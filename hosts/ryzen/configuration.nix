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
        # containerization packages
        podman-tui 
        docker-compose

        # storage
        zfs
    ];

      systemd.services."zfs-import-scan" = {
        #serviceConfig = {
        #  ExecStart = "@zpool@ import -f -a"; # Forces pool import
        #  RemainAfterExit = true;
        #};
        enable = true;
      };

     systemd.services."zfs-import-cache" = {
        #serviceConfig = {
        #  ExecStart = "@zpool@ import -f -a"; # Forces pool import
        #  RemainAfterExit = true;
        #};
        enable = true;
      };
      systemd.services."zfs-mount" = {
        enable = true;
      };

}
