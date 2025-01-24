#!/bin/bash

# Set the path to your hosts file
HOSTS_FILE="./hosts"

# Function to check if the SSH host key is in the known_hosts file
checkSshHostKey() {
    local host="$1"
    # Use ssh-keyscan to get the host key and compare it with known_hosts
    if ! ssh-keygen -F "$host" > /dev/null; then
        echo "SSH host key for $host not found. Adding it to known_hosts."
        # Add the host key to known_hosts
        ssh-keyscan "$host" >> ~/.ssh/known_hosts
    else
        echo "SSH host key for $host is already in known_hosts."
    fi
}

# Loop through the sections in the hosts file
while IFS= read -r line; do
    # Ignore empty lines or comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # If the line starts with '[', it's a section header (group)
    if [[ "$line" =~ ^\[.*\]$ ]]; then
        # Extract the section name
        section_name="${line//[\[\]]/}"
        flake_name=".#$section_name"
        echo "Processing group: $flake_name"
    else
        # Otherwise, it's a hostname or IP
        host="$line"
        echo "Running nixos-rebuild for $flake_name on host: $host"
        
        # Check SSH host key before running the rebuild
        checkSshHostKey "$host"
        nixos-rebuild --fast switch --use-remote-sudo --target-host "$host" --flake "$flake_name"
    fi
done < "$HOSTS_FILE"
