#!/bin/bash

BACKUP_HOSTNAME="kaito"

# Log timestamp
echo "[$(date +"%Y-%m-%d %H:%M:%S")] Starting backup..." | tee -a /var/log/proxmox_backup.log

# Ensure source directory exists
if [ ! -d "/var/lib/vz/dump" ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Source directory /var/lib/vz/dump does not exist. Exiting." | tee -a /var/log/proxmox_backup.log
    exit 1
fi

# Run rsync command
rsync -avz --delete --progress /var/lib/vz/dump/ backup@$BACKUP_HOSTNAME:/mnt/mirror/pve

# Check result
if [ $? -eq 0 ]; then
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup completed successfully." | tee -a /var/log/proxmox_backup.log
else
    echo "[$(date +"%Y-%m-%d %H:%M:%S")] Backup failed." | tee -a /var/log/proxmox_backup.log
    exit 1
fi
