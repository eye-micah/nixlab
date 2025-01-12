#!/bin/bash

# Check for required arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <user@hostname> <flake> <target disk>"
    exit 1
fi

TARGET="$1"        # The user@hostname or IP
FLAKE="$2"         # The flake to use
TARGET_DISK="$3"
SOURCE_DIR="$(dirname "$0")/.." # Parent directory of the script

# Confirmation step if a third argument is given
if [ -n "$TARGET_DISK" ]; then
    echo "WARNING: You provided '$TARGET_DISK'. This action may wipe data."
    read -p "Do you really want to proceed? (yes/no): " CONFIRM
    if [ "$CONFIRM" != "yes" ]; then
        echo "Aborting as per user request."
        exit 1
    fi
fi

# Ensure the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist."
    exit 1
fi

# Create a tarball of the source directory
TARBALL="/tmp/nixlab.tar.gz"
echo "Creating tarball from $SOURCE_DIR..."
tar -czf "$TARBALL" -C "$SOURCE_DIR" .

if [ $? -ne 0 ]; then
    echo "Error: Failed to create tarball from $SOURCE_DIR."
    exit 1
fi

# Use scp to copy the tarball to the target system
echo "Copying tarball to $TARGET:/tmp..."
scp "$TARBALL" "$TARGET:/tmp/nixlab.tar.gz"

if [ $? -ne 0 ]; then
    echo "Error: Failed to copy tarball to $TARGET."
    rm -f "$TARBALL"
    exit 1
fi

# Clean up the local tarball
rm -f "$TARBALL"

# Use SSH to extract the tarball and run disko-install on the target system
echo "Deploying via SSH to $TARGET with flake: .#$FLAKE..."
ssh "$TARGET" bash -s <<EOF
    set -e
    echo "Extracting tarball on $TARGET..."
    if [ -d "/tmp/nixlab" ]; then
        rm -rf /tmp/nixlab
    fi
    mkdir -p /tmp/nixlab
    tar -xzf /tmp/nixlab.tar.gz -C /tmp/nixlab/lab
    rm /tmp/nixlab.tar.gz
    echo "Running disko-install on $TARGET with flake: .#$FLAKE"
    cd /tmp/nixlab/lab
    nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko/zfs-root/default.nix 
    nixos-install --flake /tmp/nixlab/lab/#$FLAKE 
EOF

# Confirm success
if [ $? -eq 0 ]; then
    echo "Deployment completed successfully to $TARGET."
else
    echo "Error: Deployment failed on $TARGET."
    exit 1
fi
