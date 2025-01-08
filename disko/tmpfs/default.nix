{
  disko.devices = {
    disk = {
      my-disk = {
        device = "ADD DEVICE HERE";
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
                mountpoint = "/boot/efi";
                mountOptions = [ "umask=0077" ];
                extraArgs = [ "-L NIXESP" ] ;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "btrfs";
                extraArgs = [ "-L NIXROOT" ] ;
                subvolumes = {
                  # Subvolume name is different from mountpoint
                  "persist" = {
                    mountpoint = "/persist";
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
};}