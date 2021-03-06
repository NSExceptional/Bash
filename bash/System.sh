### System/OS related utilities ###

# Checks if System Integrity Protection is on
alias sip="csrutil status"

# Clears UI cache
alias uicache="sudo find /private/var/folders/ -name com.apple.dock.iconcache -exec rm {} \; sudo find /private/var/folders/ -name com.apple.iconservices -exec rm -rf {} \;"

alias bootcamp="sudo nvram InstallWindowsUEFI=1; echo You may now restart your computer."

alias rm="trash -F"
