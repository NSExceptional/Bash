# This file sets up commands for adding
# stuff to $PATH easily, and executes ~/.bashrc

# For adding stuff to the PATH variable temporarily
addpath() {
    if [[ "$1" ]]
    then
        export PATH="$PATH":"$1"
    fi
}

# For adding stuff to the PATH variable permenantly
addtopath() {
    if [[ "$1" ]] && [[ "$2" ]]; then
        echo Comment: "# $1"
        echo Path: "$2"
        
        addpath "$2"
        
        echo "" >> ~/.PATH
        echo "# $1" >> ~/.PATH
        echo "$2" >> ~/.PATH
    else
        echo Must give a comment and a path, each quoted
    fi
}

export SHORTCUTS=~/Shortcuts

# No duplicate commands in bash history
export HISTCONTROL=ignoreboth:erasedups

. ~/.PATH
. ~/.bashrc
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

export NVM_DIR="$HOME/.nvm"

initnvm() {
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

