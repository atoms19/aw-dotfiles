#!/bin/bash

selected=$(ls "$HOME/VM" | fzf --prompt="Select a VM image: ")

[[ -z "$selected" ]] && echo "No VM selected." && exit 1


read -p "Enter RAM in GB (default 4): " ramount
[[ -z "$ramount" ]] && ramount=4

read -p "Enter number of CPU cores (default 4): " cpucores
[[ -z "$cpucores" ]] && cpucores=4

read -p "Debug mode? (y/N): " debugmode
[[ "$debugmode" =~ ^[Yy]$ ]] && debug=true || debug=false


common_args=(
  -enable-kvm
  -cpu host
  -smp "${cpucores}"
  -m "${ramount}G"
  -drive file="$HOME/VM/$selected",format=qcow2
  -boot c
  -audio driver=pa
  -device ich9-intel-hda
  -device hda-output
  -vga none
  -device virtio-gpu-gl-pci
  -display gtk,gl=on
)

if $debug; then
  echo "Starting VM in debug mode..."
  qemu-system-x86_64 "${common_args[@]}"
else
  echo "Starting VM in background..."
  setsid qemu-system-x86_64 "${common_args[@]}" >/dev/null 2>&1 & 
  sleep 5
fi
