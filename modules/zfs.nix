{ config, pkgs, lib, ... }:

{
    environment.systemPackages = with pkgs; [
        # needed tools 
        git 

        # containerization packages
        #podman-tui 
        #docker-compose

        # storage
        zfs
    ];

      systemd.services."custom-zfs-import" = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "/run/current-system/sw/bin/zpool import -f -a";  # Force import all pools
          RemainAfterExit = true;  # Keep the service status even after exit
        };
      };

      # Custom systemd service for scanning and importing ZFS pools
      systemd.services."custom-zfs-import-scan" = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = "/run/current-system/sw/bin/zpool import -a";  # Import pools based on scan
          RemainAfterExit = true;
        };
      };

      # Custom systemd service for mounting ZFS datasets
      systemd.services."custom-zfs-mount" = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        after = [ "custom-zfs-import.service" "custom-zfs-import-scan.service" ];  # Ensure import happens first
        serviceConfig = {
          ExecStart = "/run/current-system/sw/bin/zfs mount -a";  # Mount all ZFS datasets
          RemainAfterExit = true;
        };
      };

      # Custom service for exporting ZFS pools (optional)
      systemd.services."custom-zfs-export" = {
        enable = true;
        wantedBy = [ "shutdown.target" ];  # Run during shutdown
        serviceConfig = {
          ExecStart = "/run/current-system/sw/bin/zpool export -a";  # Export all ZFS pools during shutdown
        };
      };

      boot.zfs.forceImportAll = true;
}