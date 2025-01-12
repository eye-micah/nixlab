{ pkgs, lib, ... }:
{

    boot.kernelParams = [ "zfs.zfs_arc_max=536870912" ];

    fileSystems."/backup" = {
        device = "zpool/backup";
        fsType = "zfs";
    };

}