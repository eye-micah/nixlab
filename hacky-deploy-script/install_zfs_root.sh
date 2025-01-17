#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <device> <host@ip> <flake host>"
    echo "Example: $0 /dev/disk/by-id/usb-Example_Device_ID root@192.2.1.3 gamingpc"
    exit 1
fi

DEVICE="$1"
HOST="$2"
FLAKE="$3"

# Ensure the device is valid
if [[ ! "$DEVICE" =~ ^/dev/disk/by-id/ ]]; then
    echo "ERROR: The device must be a /dev/disk/by-id/* path."
    exit 1
fi

# Confirm before proceeding
read -rp "WARNING: This will erase all data on $DEVICE. Continue? (y/N): " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Copy the partitioning script and run it on the target
echo "Sending partitioning script to $HOST..."
scp partition_zfs_root.sh "$HOST:/tmp/partition_zfs_root.sh"

echo "Running partitioning script on $HOST..."
ssh "$HOST" "sudo bash /tmp/partition_zfs_root.sh $DEVICE"

# Copy the NixOS configuration to the target
echo "Copying NixOS configuration to $HOST..."
nix run nixpkgs#rsync -- -avz --delete "$(dirname "$0")/.." "$HOST:/mnt/lab"

# Deploy NixOS configuration
echo "Deploying NixOS configuration..."
ssh "$HOST" "cd /mnt/lab && chown -R root:root /mnt/lab && sudo nixos-install --flake .#$FLAKE"


echo "Disk partitioning and NixOS installation complete!"

echo "Be sure to export the pool before rebooting."