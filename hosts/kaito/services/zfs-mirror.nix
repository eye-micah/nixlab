{ pkgs, lib, ... }:
{

    boot.kernelParams = [ "zfs.zfs_arc_max=536870912" ];

    fileSystems."/mirror" = {
        device = "zpool/mirror";
        fsType = "zfs";
    };

}