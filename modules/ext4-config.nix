{ config, pkgs, lib, ... }:

{
    fileSystems."/" = {
        device = lib.mkForce "/dev/disk/by-label/NIXROOT";
        fsType = lib.mkDefault "ext4";
        neededForBoot = true;
    };

    fileSystems."/boot" = {
        device = lib.mkForce "/dev/disk/by-label/NIXESP";
        fsType = "vfat";
    };

    swapDevices = [];

    #systemd.services.zfs-mount.enable = true; # I hope this fixes this shit bro

}
