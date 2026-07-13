#!/bin/bash
# run.sh — builds the OS, then boots it in QEMU
set -e

# kill any old QEMU window still hanging around
pkill qemu-system-i386 2>/dev/null || true

# rebuild before every run, so you never boot stale code
bash build.sh

echo "Booting in QEMU..."
qemu-system-i386 -drive format=raw,file=build/os-image.bin,if=floppy
