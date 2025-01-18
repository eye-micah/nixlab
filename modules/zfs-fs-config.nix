{ config, pkgs, lib, ... }:

{
    fileSystems."/" = {
        device = lib.mkDefault "zroot/root";
        fsType = lib.mkDefault "zfs";
        neededForBoot = true;
    };

    fileSystems."/nix" = {
        device = lib.mkForce "zroot/nix";
        fsType = lib.mkForce "zfs";
        neededForBoot = true;
    };

    fileSystems."/home" = {
        device = lib.mkForce "zroot/home";
        fsType = lib.mkForce "zfs";
        neededForBoot = true;
    };

    fileSystems."/boot" = {
        device = lib.mkForce "/dev/disk/by-label/NIXESP";
        fsType = "vfat";
    };

    swapDevices = [];

    #systemd.services.zfs-mount.enable = true; # I hope this fixes this shit bro

}
