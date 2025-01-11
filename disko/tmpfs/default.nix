{
  disko.devices = {
    disk = {
      NIXROOT = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "500M";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
                extraArgs = [ "-nNIXESP" ] ;
              };
            };
            persist = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-LNIXROOT" ] ;
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "nix_persist" = {
                    mountpoint = "/nix/persist";
                  };
                  # Parent is not mounted so the mountpoint must be set
                  "nix" = {
                    mountOptions = [ "compress=zstd" "noatime" ];
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = [ "size=2G" ];
      };
    };
  };
}