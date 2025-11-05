#!/usr/bin/env bash

KEYBOARD="/dev/input/event2"
STATE_FILE="/tmp/keyb_state"

if [ -f "$STATE_FILE" ] && grep -q "disabled" "$STATE_FILE"; then
    pkill -f "evtest --grab $KEYBOARD"
    echo "enabled" > "$STATE_FILE"
    notify-send "Keyboard Enabled"
    echo "Built-in keyboard enabled"
else
    sudo evtest --grab "$KEYBOARD" >/dev/null 2>&1 &
    echo $! > /tmp/keyb_grab.pid
    echo "disabled" > "$STATE_FILE"
    notify-send "Keyboard Disabled"
    echo "Built-in keyboard disabled"
fi
