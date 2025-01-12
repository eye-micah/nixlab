{ config, lib, pkgs, ... }:

{
    imports = [
        ./services
    ];

    fileSystems."/" = {
        device = "none";
        fsType = "tmpfs";
        options = [ "defaults" "size=2G" "mode=755" ];
    };

    fileSystems."/boot" = {
        device = lib.mkForce "/dev/disk/by-label/NIXESP";
        fsType = "vfat";
    };

    fileSystems."/nix" = {
        device = lib.mkForce "/dev/disk/by-label/NIX";
        fsType = "ext4";
    };

    swapDevices = [];

    environment.persistence."/nix/persist" = {
        enable = true;
        hideMounts = true;
        directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/etc/exports"
            "/etc/smb"
            "/etc/samba"
            # "/etc/rclone" 
        ];
    };

}