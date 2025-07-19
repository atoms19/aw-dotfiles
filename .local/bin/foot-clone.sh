#!/bin/bash

pid=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | .pid')
echo "found focused terminal " $pid 

subprocess=$(ps --ppid "$pid" -o pid=| awk 'NR==1 {gsub(/[^0-9]/, "", $1); print $1}')
echo "found subprocess " $subprocess
wd=$(readlink -e "/proc/$subprocess/cwd")
echo "found dir" $wd
foot -D "$wd"
