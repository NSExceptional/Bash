### Bash helpers ###
alias rc="open ~/.bashrc"
alias profile="open -a Code ~/.bash_profile"
alias history="open -a Code ~/.bash_history"
alias path="open -a Code ~/.PATH"
alias refresh=". ~/.bash_profile"
alias cls="clear; clear"
alias ls="ls -FG"
alias lsl="ls -1"
alias mkdir="mkdir -p"
alias wget="wget -q --show-progress"
alias pwd="pwd -P"

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
        open -a Code ~/bash/"$1".sh
    else
        lsl ~/bash
    fi
}

### Variables ###

export MANPATH=`manpath`:/Users/tanner/man/ubuntu

# ls colors
export LSCOLORS='gxfxcxdxbxegedabagacad'

# For TextMate I think?
export EDITOR="/usr/local/bin/mate -w"

### Workflow ###

# Like `vim`
tim() {
    touch $1; open $1
}

### Misc helpers ###

alias pcopy=pbcopy
alias ppaste=pbpaste
alias highp="sudo renice -20"
rchmod() {
    stat -f "%Lp" "$1"
}

### Baylor / school ###

alias fire='cls; ssh bennettt@fire.ecs.baylor.edu'
firecp() {
    src=bennettt@wind.ecs.baylor.edu:$1
    dest=$2
    scp $src $dest
}
firecpr() {
    src=bennettt@wind.ecs.baylor.edu:$1
    dest=$2
    scp -r $src $dest
}
firecpto() {
    src=$1
    dest=bennettt@wind.ecs.baylor.edu:$2
    scp $src $dest
}
firecptor() {
    src=$1
    dest=bennettt@wind.ecs.baylor.edu:$2
    scp -r $src $dest
}
