{
    device ? throw "Set this to your disk device, e.g. /dev/sda" ,
    ...
}:

{
    disko.devices = {
        disk.main = {
            inherit device;
            type = "disk";
            content = {
                type = "gpt";
                partitions = {
                    ESP = {
                        name = "ESP";
                        size = "512M";
                        type = "EF00";
                        content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = [ "umask=0077" ];
                            extraArgs = [ "-nNIXESP" ];
                        };
                    };
                    nix = {
                        size = "100%";
                        content = {
                            type = "filesystem";
                            format = "ext4";
                            mountpoint = "/nix";
                            mountOptions = [ "noatime" ];
                            extraArgs = [ "-LNIX" ];
                        };
                    };
                };
            };
        };
        nodev."/" = {
            fsType = "tmpfs";
            mountOptions = [
                "size=2G"
                "defaults"
                "mode=755"
            ];
        };
    };

}