#!/bin/bash
set -euo pipefail

DEVICE="$1"

umount -R /mnt || true
umount -R /mnt/nix || true
umount -R /mnt/boot || true
umount -R /mnt/home || true
umount -R /mnt/nix || true

zpool export zroot || true


echo "Wiping $DEVICE using sgdisk..."
sgdisk --zap-all "$DEVICE"

# Reload the partition table to ensure changes are applied
echo "Forcing partition table reload..."
partprobe "$DEVICE" 

# Verify the new partition table is in use
sleep 5  # Allow some time for the kernel to process the changes

echo "Partitioning $DEVICE..."
parted --script "$DEVICE" \
    mklabel gpt \
    mkpart ESP fat32 1MiB 512MiB \
    set 1 boot on \
    set 1 esp on \
    mkpart primary 512MiB 100%

# Reload the partition table to ensure changes are applied
echo "Forcing partition table reload..."
partprobe "$DEVICE" 
# Verify the new partition table is in use
sleep 5  # Allow some time for the kernel to process the changes

echo "Formatting ESP partition..."
ESP_PART="${DEVICE}-part1"
mkfs.vfat -F 32 -n NIXESP "$ESP_PART"

echo "Creating ZFS pool on $DEVICE..."
ZFS_PART="${DEVICE}-part2"
zpool create -f \
    -O compression=zstd \
    -O com.sun:auto-snapshot=false \
    -o cachefile=none \
    zroot "$ZFS_PART"

echo "Creating ZFS datasets..."
zfs create -o com.sun:auto-snapshot=false -o mountpoint=legacy zroot/nix
zfs create -o com.sun:auto-snapshot=true  -o mountpoint=legacy zroot/home
zfs create -o com.sun:auto-snapshot=false -o mountpoint=legacy zroot/lab

echo "Mounting filesystems..."
mount -t zfs zroot /mnt
mkdir -p /mnt/{boot,nix,home,lab}
mount -t zfs zroot/nix /mnt/nix
mount -t zfs zroot/home /mnt/home
mount -t zfs zroot/lab /mnt/lab
mount "$ESP_PART" /mnt/boot -o umask=0077

echo "Disk and ZFS setup complete!"
zpool export zroot || true