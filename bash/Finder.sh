### Finder-like utilities ###

alias bk="cd - > /dev/null"

# Make a shortcut to the current path in my shortcuts folder
scut() {
    cur=`pwd`
    dir=~/Shortcuts/$@
    ln -vs "$cur" "$dir"
}

# Search for the given text in files in the current directory
search() {
    find . -type f -not -iwholename '*.git*' -exec grep -H $1 {} \;
    # for var in `find . -type f`
    # do
    #     grep -H $1 "$var"
    # done
}

# Set optiont to show full path in the Finder window
alias finderfullpath="defaults write com.apple.finder _FXShowPosixPathInTitle -bool true; killall Finder"

# Creates a macOS installer drive
# Usage: createinstaller <volume name> [appPath]
createinstaller() {
    drive="/Volumes/$1"
    appPath="$2"
    
    if [[ ! "$1" ]]; then
        echo "Missing volume name"
    else
        if [[ ! "$appPath" ]]; then
            appPath="/Applications/Install macOS Sierra.app"
        fi
    
        binary="$appPath/Contents/Resources/createinstallmedia"
    
        echo "Volume: $drive"
        echo "App:    $appPath"
        echo "Binary: $binary"
        echo
        echo sudo \"$binary\" --volume \"$drive\" --applicationpath \"$appPath\" --nointeraction
        sudo "$binary" --volume "$drive" --applicationpath "$appPath" --nointeraction
    fi
}
