
# Usage:
# twi <name>
twi() {
    #local PREFIX=/bootstrap
    local PREFIX=
    #local DYLIBS=/bootstrap/Library/SBInject
    local DYLIBS=/Library/MobileSubstrate/DynamicLibraries
    local PREF_BUNDLES=$PREFIX/Library/PreferenceBundles
    local PREFS=$PREFIX/Library/PreferenceLoader/Preferences
    local APP_SUP=/Library/Application\ Support

    local name=$1
    local tweak=~/tweaks/$name

    if [[ ! -d $tweak ]]; then
        echo Tweak not found
        return
    fi

    if [[ -d $tweak/MobileSubstrate ]]; then
        echo Copying dylibs...
        theoscpto $tweak/MobileSubstrate/DynamicLibraries/* $DYLIBS

        if [[ -d $tweak/PreferenceBundles ]]; then
            echo Copying PreferenceBundles...
            theoscprto $tweak/PreferenceBundles/* $PREF_BUNDLES
        fi
        if [[ -d $tweak/PreferenceLoader ]]; then
            echo Copying PreferenceLoader files...
            theoscpto $tweak/PreferenceLoader/Preferences/* $PREFS
        fi
        if [[ -d "$tweak/Application Support" ]]; then
            echo Ignoring Application Support files...
            # theoscprto "$tweak/Application\ Support/*" "$APP_SUP"
        fi
    else
        echo Copying dylibs...
        theoscpto $tweak/* $DYLIBS
    fi
}

# Usage:
# twir <name>
twir() {
    twi $@
    echo Respringing...
    ssh root@`theosip` "killall backboardd"
}

# Usage:
# apti <name of deb in ~/tweaks/deb>
apti() {
    #local PREFIX=/bootstrap
    local PREFIX=
    #local DYLIBS=/bootstrap/Library/SBInject
    local DYLIBS=/Library/MobileSubstrate/DynamicLibraries
    local PREF_BUNDLES=$PREFIX/Library/PreferenceBundles
    local PREFS=$PREFIX/Library/PreferenceLoader/Preferences

    local name=$1
    local tweak=~/tweaks/deb/$name.deb
    local tmp=/tmp/$name.deb.tmp

    if [[ ! -e $tweak ]]; then
        echo Tweak not found
        return
    fi

    # Temp dir for extraction
    mkdir $tmp

    # Extract
    #tar -xvf $1 -C $1.dir/
    cd $tmp
    ar -x $tweak
    tar -xf data.tar.*

    # Thin with lipo and sign with ldid
    for f in `find . -type f`; do
        if [[ `file $f | grep "Mach-O"` ]]; then
            # Thin
            if [[ `lipo -info $f | grep "armv7 arm64"` ]]; then
                lipo $f -thin arm64 -output $f
            fi
            # Sign (not necessary?)
            # ldid $f
        fi
    done

    if [[ -d Library/MobileSubstrate ]]; then
        echo Copying dylibs...
        theoscpto Library/MobileSubstrate/DynamicLibraries/* $DYLIBS

        if [[ -d Library/PreferenceBundles ]]; then
            echo Copying PreferenceBundles...
            theoscprto Library/PreferenceBundles/* $PREF_BUNDLES
        fi
        if [[ -d Library/PreferenceLoader ]]; then
            echo Copying PreferenceLoader files...
            theoscpto Library/PreferenceLoader/Preferences/* $PREFS
        fi
        if [[ -d "Library/Application Support" ]]; then
            echo Copying Application Support files...
            theoscprto Library/Application\ Support/* $APP_SUP
        fi
        if [[ -d usr/lib ]]; then
            echo Copying other files to /usr/lib...
            theoscpto usr/lib/* /bootstrap/usr/lib
        fi
    else
        echo Copying dylibs...
        theoscpto $tweak/* $DYLIBS
    fi

    cd -
    rm -rf $tmp
}

# Moves packaged deb to ~/tweaks/deb with a new name
# Usage: from in the project folder,
# aptpr <new name>
aptpr() {
    mv packages/*.deb ~/tweaks/deb/$1.deb
}

respr() {
    ssh root@`theosip` "killall backboardd"
}

alias iprofile="tim ~/bash/ios"
alias iprcpy="theoscpto ~/bash/ios .profile"
alias einstall="aptpr $(basename `pwd`); apti $(basename `pwd`)"
