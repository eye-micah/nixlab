## Backups!!

This system is planned to be a simple low power 1u backup server.
2x2.5 inch HDDs configured for spindown in a mirror. Tarballs are pushed out to it and it pushes them out to Backblaze B2 via restic.

I would like this to work with my "dirty" Linux systems like the Proxmox node I have and the Alpine version of my main home server, so an rsync script that hooks into the PVE Debian host should be enough.