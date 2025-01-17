{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  ...
}:

# Using legacy mountpoints because ZFS is weird by default and decides it wants to opaquely handle its own mounts?

{
  disko.devices = {
    disk.main = {
      type = "disk";
      inherit device;
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
      postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";
      datasets = {
        nix = {
          type = "zfs_fs";
          options."com.sun:auto-snapshot" = "false";
        };
        home = {
          type = "zfs_fs";
          options."com.sun:auto-snapshot" = "true";
        };
      };
    };
  };
  };
}
