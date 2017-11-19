# Preferred editor, ie "VS Code" or TextEdit
__EDITOR__="VS Code"

### Bash helpers ###
# Aliases for common commands and useful flags
alias rc="open -a "$__EDITOR__" ~/.bashrc"
alias profile="open -a "$__EDITOR__" ~/.bash_profile"
alias history="open -a "$__EDITOR__" ~/.bash_history"
alias path="open -a "$__EDITOR__" ~/.PATH"
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
for file in `/bin/ls ~/bash | grep \.sh`; do
    include ~/bash/"$file"
done

# Open included file
re() {
    if [[ "$1" ]]; then
        open -a "$__EDITOR__" ~/bash/"$1".sh
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
