{ pkgs, inputs, lib, ... }:

{

    imports = [
        #./hardware-configuration.nix
        ./services
    ];

    fileSystems = {
        # NOTE: root and home are on tmpfs
        # root partition, exists only as a fallback, actual root is a tmpfs
        "/" = {
          device = lib.mkForce "/dev/disk/by-label/NIXROOT";
          fsType = "ext4";
          neededForBoot = true;
        };

        # boot partition
        "/boot/efi" = {
          device = lib.mkForce "/dev/disk/by-label/NIXESP";
          fsType = "vfat";
        };

    };

    system.stateVersion = "25.05";

    boot.initrd.systemd.enable = true;

    boot.supportedFilesystems = [ "zfs" "vfat" ];

    services.zfs.trim.enable = true;
    services.zfs.autoScrub.enable = true;

    boot.loader = {
        systemd-boot = {
            enable = true;
            configurationLimit = 5;
        };
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
        };
    };

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    networking.hostName = "ryzen";
    networking.hostId = "41b9e6d1";

    services.openssh.enable = true;

    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
        };

        optimise.automatic = true;
    };

    # Containerization and VMs enablement
    virtualisation = {
        containers.enable = true;
        podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };

    environment.systemPackages = with pkgs; [
        # needed tools 
        git 

        # containerization packages
        podman-tui 
        docker-compose

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

      users.users.micah = {
        isSystemUser = true;
        home = "/home/micah";
        password = "micah";  # This will use a hashed password in the system
        shell = pkgs.bash;    # Set the shell to Zsh or another shell of your choice
        extraGroups = [ "wheel" "podman" "video" "input" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC micah@haruka.tail8d76a.ts.net"
        ];
      };

}
