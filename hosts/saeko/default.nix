{ pkgs, inputs, lib, ... }:

{
    environment.systemPackages = with pkgs; [
        pkgs.zfs
    ];

    imports = [
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

    networking.hostName = "ryzen";
    networking.hostId = "41b9e6d1";

    # Containerization and VMs enablement
    virtualisation = {
        containers.enable = true;
        podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };

}