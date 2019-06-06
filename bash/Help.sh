remindme() {
    touch ~/.REMINDERS
    echo "$@" >> ~/.REMINDERS
}

iforgot() {
    echo
    echo "+-----------+"
    echo "| Reminders |"
    echo "+-----------+"
    echo
    cat ~/.REMINDERS
    echo
}