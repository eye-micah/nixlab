#!/bin/bash
set -euo pipefail

DEVICE="$1"

umount -R /mnt || true
umount -R /mnt/nix || true
umount -R /mnt/boot || true
umount -R /mnt/home || true

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
    mkpart ESP fat32 1MiB 1024MiB \
    set 1 boot on \
    set 1 esp on \
    mkpart primary 1024MiB 100%

# Reload the partition table to ensure changes are applied
echo "Forcing partition table reload..."
partprobe "$DEVICE" 
# Verify the new partition table is in use
sleep 5  # Allow some time for the kernel to process the changes

echo "Formatting ESP partition..."
ESP_PART="${DEVICE}-part1"
mkfs.vfat -F 32 -n NIXESP "$ESP_PART"

echo "Creating BTRFS pool on $DEVICE..."
mkfs.btrfs -L broot "$BTRFS_PART"

mount $BTRFS_PART -o subvolid=5 /bpool

echo "Creating BTRFS subvolumes..."
btrfs sub cr /bpool/root 
btrfs sub cr --parents /bpool/nix/persist
btrfs sub cr /bpool/home
btrfs sub cr /bpool/cvol

echo "Mounting subvolumes..."
mount -o compress=zstd,subvol=root $BTRFS_PART /mnt
mkdir -p /mnt/{boot,nix/persist,home}
mount -o compress=zstd,subvol=home $BTRFS_PART /mnt/home
mount -o compress=zstd,noatime,subvol=nix $BTRFS_PART /mnt/nix
mount -o compress=zstd,noatime,subvol=nix/persist $BTRFS_PART /mnt/nix/persist
mount $ESP_PART /mnt/boot -o umask=0077

echo "Disk and BTRFS setup complete!"
#umount -R /mnt || true
#zpool export zroot || true
