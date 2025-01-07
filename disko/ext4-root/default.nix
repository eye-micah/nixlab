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
                format = "ext4";
                mountpoint = "/";
                extraArgs = [ "-L NIXROOT" ] ;
              };
            };
          };
        };
      };
    };
  };
}