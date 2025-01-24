#!/bin/bash
set -euo pipefail

DEVICE="$1"

# Unmount any existing mounts to start fresh
echo "Unmounting existing partitions..."
umount -R /mnt || true
umount -R /mnt/nix || true
umount -R /mnt/boot || true
umount -R /mnt/home || true
umount -R /mnt/lab || true

# Import the ZFS pool if it's not already imported
echo "Importing ZFS pool 'zroot'..."
zpool import -N zroot || true

# Mount the existing ZFS datasets
echo "Mounting existing ZFS datasets..."
mount -t zfs zroot/root /mnt
mkdir -p /mnt/{boot,nix,home,lab}
mount -t zfs zroot/nix /mnt/nix
mount -t zfs zroot/home /mnt/home

# Identify the ESP partition (assuming it's the first partition on the device)
ESP_PART="${DEVICE}-part1"
echo "Mounting ESP partition..."
mount "$ESP_PART" /mnt/boot -o umask=0077

echo "ZFS pool imported and datasets mounted!"
