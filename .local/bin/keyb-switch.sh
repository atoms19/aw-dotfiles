#!/bin/bash

DEVICE="1:1:AT_Translated_Set_2_keyboard"

STATE=$(swaymsg -t get_inputs | jq -r '.[] | select(.identifier=="'"$DEVICE"'") | .libinput.send_events')
if [ "$1" = "info" ] ; then
		echo "$STATE"
		exit 0
fi


if [ "$STATE" = "enabled" ]; then
    swaymsg input "$DEVICE" events disabled
	 notify-send "keyb-switch : disabled" "system keyboard disabled" -t 2000
	 echo "system keyboard disabled"
else
    swaymsg input "$DEVICE" events enabled
	 notify-send "keyb-switch : enabled " "system keyboard enabled" -t 2000
	 echo "system keyboard enabled"
fi
