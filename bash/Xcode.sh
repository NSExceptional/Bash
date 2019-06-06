### Xcode related utilities ###

# sudo xcode-select --switch path/to/Xcode.app
# to specify the Xcode that you wish to use for command line developer tools
#
# xcode-select --install
# to  install the standalone command line developer tools.
#
# See `man xcode-select` for more details.

# Restart simulator service
alias resim="sudo killall -9 com.apple.CoreSimulator.CoreSimulatorService"

# Clean Cocoapods pod cache
alias podclean="rm -rf ~/Library/Caches/CocoaPods/Pods/*"
# Push a pod update
alias podpush="pod trunk push"

# Reads the current Xcode.app's DVTPlugInCompatibilityUUID key
alias xcpluginuuid="defaults read /Applications/Xcode.app/Contents/Info DVTPlugInCompatibilityUUID"

# Removes Xcode code signature.
xcunsign() {
    _xcode=/Applications/Xcode.app/Contents/MacOS/Xcode
    
    # Is Xcode installed?
    if [ ! -f $_xcode ]
    then
        echo "Could not find Xcode binary at "$_xcode
        return
    fi
    
    # Is unsign installed?
    if ! sudo type unsign >/dev/null
    then
        echo "Is unsign in your PATH?"
        return
    fi

    # Does Xcode.signed exist already?
    if [ -f $_xcode.signed ]
    then
        echo "It appears you have already removed Xcode's code signature."
        return
    fi

    sudo unsign $_xcode
    sudo mv -f $_xcode $_xcode.signed
    sudo mv -f $_xcode.unsigned $_xcode

    echo "Unsigned Xcode"
    echo "$_xcode -> $_xcode.signed"
    echo "$_xcode.unsigned -> $_xcode"
    echo
    echo "You can undo this operation by running xcundounsign"
    echo "Don't forget to run xcupdateplugins!"
}

# Restores Xcode code signature removed by xcunsign.
xcundounsign() {
    _xcode=/Applications/Xcode.app/Contents/MacOS/Xcode
    
    # Does Xcode.signed exist already?
    if [ ! -f $_xcode.signed ]
    then
        echo "Nothing to undo."
        return
    fi
    
    sudo mv $_xcode.signed $_xcode
    echo "$_xcode.signed -> $_xcode"
}

# Generate separate iOS and macOS docsets.
# -s|-a, -p, -o
makedocs() {
    alias hyphen__=~/bin/hyphen/hyphen.rb
    lang=--language=objc
    platform=
    outdir=--output=.
    
    while test $# -gt 0; do
        case "$1" in
            -h|--help)
                __makedocshelp
                exit 0
            ;;
            -o)
                shift
                outdir=--output="$1"
                echo "Using output directory: ""$1"
                shift
            ;;
            -s)
                shift
                lang=--language=swift
                echo "Swift only"
                shift
            ;;
            -a)
                shift
                lang=--language=swift --language=objc
                echo "Swift and Objective-C"
                shift
            ;;
            -p)
                shift
                case "$1" in
                    [mM][aA][cC])
                    ;&
                    [mM][aA][cC][oO][sS])
                        platform=macos
                        echo "Only macOS"
                        shift
                    ;;
                    [iI][oO][sS])
                        platform=ios
                        echo "Only iOS"
                        shift
                    ;;
                esac
                shift
            ;;
            *)
                __makedocshelp
                exit 0
            ;;
        esac
    done
    
    if [[ $platform ]]; then
        hyphen__ $lang --platform=$platform $outdir
    else
        echo "Parsing iOS..."
        hyphen__ $lang --platform=ios $outdir
        echo "Done"
        echo "Parsing macOS..."
        hyphen__ $lang --platform=macos $outdir
        echo "Done"
    fi
        
}
__makedocshelp() {
    echo "Usage: makedocs [-s|-a] [-p platform] [-o output_dir]"
    echo 
    echo "      -s      Output Swift instead of Objc"
    echo "      -a      Output both Swift and Objc"
    echo "      -p      Specify a single platform (macOS, iOS, etc)"
    echo "      -o      Specify an output directory"
    echo "      -h      Show help"
    echo
}
