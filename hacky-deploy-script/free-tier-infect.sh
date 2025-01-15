#!/usr/bin/env bash

## This script just migrates the generated hardware-configuration.nix file from nixos-infect and copies it over to the Git repo.

# Exit immediately if a command exits with a non-zero status
set -euo pipefail

# Define source files and target directory
SOURCE_FILES=(
  "/etc/nixos/configuration.nix"
  "/etc/nixos/hardware-configuration.nix"
)
TARGET_DIR="../hosts/oracleArm/generated"

# Create the target directory if it doesn't exist
mkdir -p "$TARGET_DIR"

# Copy files to the target directory
for file in "${SOURCE_FILES[@]}"; do
  if [[ -f "$file" ]]; then
    cp --preserve=timestamps "$file" "$TARGET_DIR"
    echo "Copied $file to $TARGET_DIR"
  else
    echo "Warning: $file does not exist or is not a regular file."
  fi
done

echo "All files processed."
