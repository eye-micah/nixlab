{ config, pkgs, lib, ... }:

{
    fileSystems."/" = {
        device = "zroot/root";
        fsType = "zfs";
        neededForBoot = true;
    };

    fileSystems."/nix" = {
        device = "zroot/nix";
        fsType = "zfs";
        neededForBoot = true;
    };

    fileSystems."/home" = {
        device = "zroot/home";
        fsType = "zfs";
        neededForBoot = true;
    };

    fileSystems."/boot" = {
        device = lib.mkForce "/dev/disk/by-label/NIXESP";
        fsType = "vfat";
    };

    swapDevices = [];

    systemd.services.zfs-mount.enable = true; # I hope this fixes this shit bro

}
