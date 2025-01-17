{ config, pkgs, lib, ... }:

{
    fileSystems."/" = {
        device = "zroot";
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

    systemd.services.zfs-mount.enable = false; # I hope this fixes this shit bro

}
