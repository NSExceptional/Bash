### Development related utilities ###

alias cfm="clang-format -i"

# Expands a possibly relative path into an absolute path
abs() {
    local path="$1"

    # No path
    if [[ ! "$path" ]]; then
        return
    fi

    # Path = .
    if [[ "$path" = '.' ]]; then
        pwd
        return
    fi

    local wd=`pwd`

    # /absolute, ./current, ../parent
    if [[ "$path" = /* ]]; then
        echo "$path"
    elif [[ "$path" = ./* ]]; then
        echo "$wd"/`echo "$path" | cut -c 3-`
    elif [[ "$path" = ../* ]]; then
        while [[ "$path" = ../* ]]; do
            path=`echo "$path" | cut -c 4-`
            wd=`dirname "$wd"`
        done
        echo "$wd"/"$path"
    else
        echo "$wd"/"$path"
    fi
}

# Compiles input file for macOS (using Cocoa) to ./out
# Usage: occ code.m [flags]
occ() {
    _occ clang $1 $2 $3 $4 $5 $6
}

ocpp() {
    _occ clang++ $1 $2 $3 $4 $5 $6
}

_occ() {
    cls
    
    local compiler="$1"
    shift
    
    # Print supplied flags
    for var in $2 $3 $4 $5 $6; do
        echo $var
    done
    
    flags="$2 $3 $4 $5 $6"
    
    case "$1" in
        -o)
            shift
            outdir="$1"
            shift
        ;;
        *)
            file="$1"
            shift
        ;;
    esac
    
    if [[ $file ]]; then
        $compiler $file -framework Cocoa -o xout $flags
    else
        echo "Missing input file"
    fi
}

# Compile input binary for arm64 (using the latest SDK) to ./armout
# First arg must be file
# Usage: iocc file [flags]
iocc() {
    cls
    
    # Print supplied flags
    for var in $2 $3 $4 $5 $6; do
        echo $var
    done
    
    flags="$2 $3 $4 $5 $6"
    sdk=`xcrun --sdk iphoneos --show-sdk-path | tail -n 1`
    clang $1 -arch arm64 -framework Foundation -isysroot $sdk -lobjc -o armout $flags
}

# Display disassembled text segment of given binary
alias otd="otool -Vt"

# Run the Javascript REPL
alias js="/System/Library/Frameworks/JavaScriptCore.framework/Resources/jsc"
