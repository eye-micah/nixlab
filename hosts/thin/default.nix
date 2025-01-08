{ pkgs, inputs, lib, ... }:

{
  
  imports = [
    ./services
  ];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=25%" "mode=755" ];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-label/NIXROOT";
    neededForBoot = true;
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXESP";
    fsType = "vfat";
  };

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/cache"
        "/etc/NetworkManager/system-connections"
    ];
    files = [
        "/etc/machine-id"
    ];
  };

  networking.hostName = "thin";
  networking.hostId = "41b9e6d2";

  networking = {
    useDHCP = false; # Disable DHCP globally
    defaultGateway = "192.168.1.1"; # Replace with your actual gateway
    nameservers = [ "8.8.8.8" "8.8.4.4" ]; # Replace with your preferred DNS servers

    interfaces."*" = {
      ipv4.addresses = [
        {
          address = "192.168.1.245";
          prefixLength = 24;
        }
      ];
    };
  };

}