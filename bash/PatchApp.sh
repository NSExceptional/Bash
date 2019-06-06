
# Usage:
patchapp() {
    # Args and temp directory location
    IPA=$1
    DYLIB_FOLDER=$2
    TMPDIR=/tmp/.patchapp.cache
    
    # Must have first arg
	if [[ ! "$IPA" ]]; then
		_patchapp_usage
		return
	fi
    # IP must exist
	if [[ ! -r "$IPA" ]]; then
		echo "$IPA not found or not readable"
		return
	fi

    setup_environment
    copy_dylib_and_load

    cd "$TMPDIR"

    repack_ipa

    cd - >/dev/null 2>&1
}

# Usage / syntax
_patchapp_usage() {
	if [[ ! "$2" ]] || [[ ! "$1" ]]; then
		cat <<USAGE
usage: patchapp [app.ipa]
USAGE
	fi
}

copy_dylib_and_load() {
	# copy the files into the .app folder
	echo '[+] Copying .dylib dependences into "'$TMPDIR/Payload/$APP'"'
	cp -rf $DYLIB_FOLDER $TMPDIR/Payload/$APP/Dylibs

	# re-sign Frameworks
	echo "APPDIR=$APPDIR"
	for file in `ls -1 $APPDIR/Dylibs`; do
		echo -n '     '
		echo "Install Load: $file -> @executable_path/Dylibs/$file"
		optool install -c load -p "@executable_path/Dylibs/$file" -t "$APPDIR/$APP_BINARY" >& /dev/null
	done
    
	if [[ "$?" != "0" ]]; then
		echo "Failed to inject "${DYLIB##*/}" into $APPDIR/${APP_BINARY}"
		exit 0
	fi
	chmod +x "$APPDIR/$APP_BINARY"
}

# Unzips IPA into temporary directory
setup_environment() {

	# Remove old temp directory
	rm -rf "$TMPDIR" >/dev/null 2>&1
	mkdir "$TMPDIR"
	SAVED_PATH=`pwd`

	# uncompress the IPA into tmpdir
	echo '[+] Unpacking the .ipa file: ('"`pwd`/$IPA"')...'
	unzip -o -d "$TMPDIR" "$IPA" >/dev/null 2>&1
	if [[ "$?" != "0" ]]; then
		echo "Couldn't unzip the IPA file"
		exit 1
	fi

	cd "$TMPDIR"
	cd Payload/*.app
	if [[ "$?" != "0" ]]; then
		echo "Payload/*.app not found after unzipping IPA"
		exit 1
	fi
    
    # APP = current directory name
	APP=`pwd`
	APP=${APP##*/}
    
	APPDIR="$TMPDIR/Payload/$APP"
	cd "$SAVED_PATH"
	BUNDLE_ID=`plutil -convert xml1 -o - $APPDIR/Info.plist|grep -A1 CFBundleIdentifier|tail -n1|cut -f2 -d\>|cut -f1 -d\<`-patched
	APP_BINARY=`plutil -convert xml1 -o - $APPDIR/Info.plist|grep -A1 Exec|tail -n1|cut -f2 -d\>|cut -f1 -d\<`
}

# Zip folder back into IPA
repack_ipa() {
	echo '[+] Repacking the .ipa'
	rm -f "${IPA%*.ipa}-patched.ipa" >/dev/null 2>&1
	zip -9r "${IPA%*.ipa}-patched.ipa" Payload/ >/dev/null 2>&1
	if [ "$?" != "0" ]; then
		echo "Failed to compress the app into an .ipa file."
		exit 1
	fi
	IPA=${IPA#../*}
	mv "${IPA%*.ipa}-patched.ipa" ..
	echo "[+] Wrote \"${IPA%*.ipa}-patched.ipa\""
}
