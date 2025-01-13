#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <device> <host@ip>"
    echo "Example: $0 /dev/disk/by-id/usb-Example_Device_ID root@192.2.1.3"
    exit 1
fi

DEVICE="$1"
HOST="$2"


# Ensure the device is valid
if [[ ! "$DEVICE" =~ ^/dev/disk/by-id/ ]]; then
    echo "ERROR: The device must be a /dev/disk/by-id/* path."
    exit 1
fi



# Copy the partitioning script and run it on the target
echo "Sending import/mount script to $HOST..."
scp import.sh "$HOST:/tmp/import.sh"

echo "Running import/mount script on $HOST..."
ssh "$HOST" "sudo bash /tmp/import.sh $DEVICE"

# Copy the NixOS configuration to the target
echo "Copying NixOS configuration to $HOST..."
nix run nixpkgs#rsync -- -avz --delete "$(dirname "$0")/.." "$HOST:/mnt/lab"

ssh $HOST
