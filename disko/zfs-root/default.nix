{
  device ? throw "Set this to your disk device, e.g. /dev/nvme0n1",
  ...
}: {
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
              extraArgs = [ "-nNIXESP" ] ;
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
      };
    };
  };
  zpool = {
    zroot = {
      type = "zpool";
      options.cachefile = "none";
      rootFsOptions = {
        compression = "zstd";
        "com.sun:auto-snapshot" = "false";
      };
      mountpoint = "/";
      postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
      datasets = {
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options."com.sun:auto-snapshot" = "false";
        };
        home = {
          type = "zfs_fs";
          mountpoint = "/home";
          options."com.sun:auto-snapshot" = "true";
        };
      };
    };
  };
  };
}
