#!/bin/bash


selected=$(ls "$HOME/Downloads" | grep -E '\.iso$' | fzf --prompt="Select an ISO image: ")

[[ -z "$selected" ]] && echo "No ISO selected." && exit 1

read -p "Enter VM name: " vmname
[[ -z "$vmname" ]] && echo "VM name cannot be empty." && exit 1

read -p "Enter disk size in GB (default 20): " dsize
[[ -z "$dsize" ]] && dsize=20

qemu-img create -f qcow2 "$HOME/VM/$vmname.img" "${dsize}G"
echo "Created disk image at $HOME/VM/$vmname.img with size ${dsize}G"
sleep 1

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
  -cdrom "$HOME/Downloads/$selected"
  -drive file="$HOME/VM/$vmname.img",format=qcow2
  -boot d
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
  sleep 40
else
  echo "Starting VM in background..."
  setsid qemu-system-x86_64 "${common_args[@]}" >/dev/null 2>&1 & 
  sleep 5
fi
