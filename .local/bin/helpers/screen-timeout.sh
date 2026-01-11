
#!/bin/bash

# Check if swayidle is running
if pgrep -x swayidle >/dev/null; then
    pkill swayidle
    notify-send "swayidle" "Disabled"
    exit 0
fi

# Ask for timeout using fzf
TIMEOUT=$(printf "30 sec\n1 min\n5 min\n10 min\n15 min\n30 min\nNever" \
    | fzf --prompt="Select screen timeout: ")

# Exit if user cancels
[ -z "$TIMEOUT" ] && exit 0

# Convert selection to seconds
case "$TIMEOUT" in
    "30 sec")  SECONDS=30 ;;
    "1 min")   SECONDS=60 ;;
    "5 min")   SECONDS=300 ;;
    "10 min")  SECONDS=600 ;;
    "15 min")  SECONDS=900 ;;
    "30 min")  SECONDS=1800 ;;
    "Never")
        notify-send "swayidle" "Disabled"
        exit 0
        ;;
esac

# Start swayidle
swayidle -w \
    timeout "$SECONDS" 'swaylock -f -c 000000' \
    before-sleep 'swaylock -f -c 000000' &

notify-send "swayidle" "Enabled (${TIMEOUT})"
