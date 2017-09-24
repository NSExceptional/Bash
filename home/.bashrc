# Preferred editor
local EDITOR=Code

### Bash helpers ###
# Aliases for common commands and useful flags
alias rc="open -a $EDITOR ~/.bashrc"
alias profile="open -a $EDITOR ~/.bash_profile"
alias history="open -a $EDITOR ~/.bash_history"
alias path="open -a $EDITOR ~/.PATH"
alias refresh=". ~/.bash_profile"
alias cls="clear; clear"
alias ls="ls -FG"
alias lsl="ls -1"
alias mkdir="mkdir -p"
alias wget="wget -q --show-progress"

### Includes ###
include() {
    if [[ "$1" ]]; then
        . "$1"
    fi
}

# Include files
for file in `ls ~/bash | grep \.sh`; do
    include ~/bash/"$file"
done

# Open included file
re() {
    if [[ "$1" ]]; then
        open -a Code ~/bash/"$1".sh
    else
        lsl ~/bash
    fi
}

### Variables ###

# ls colors
LSCOLORS='gxfxcxdxbxegedabagacad'
export LSCOLORS

### Workflow ###

# Like `vim`
tim() {
    touch $1; open $1
}








