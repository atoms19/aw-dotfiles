

qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -m 4G \
  -drive file=cachy.img,format=qcow2 \
  -boot c \
  -audio pa \
  -device ich9-intel-hda \
  -device hda-output \
  -vga none \
  -device virtio-gpu-gl-pci \
  -display gtk,gl=on
