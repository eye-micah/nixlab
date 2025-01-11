{ pkgs, inputs, lib, ... }:

{
  
  imports = [
    ./services
  ];

  fileSystems."/" = {
    device = "none";
    fsType = lib.mkForce "tmpfs";
    options = [ "defaults" "size=25%" "mode=755" ];
  };

  fileSystems."/persist" = {
    device = lib.mkForce "/dev/disk/by-label/NIXROOT";
    neededForBoot = true;
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };

  fileSystems."/nix" = {
    device = lib.mkForce "/dev/disk/by-label/NIXROOT";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/boot" = {
    device = lib.mkForce "/dev/disk/by-label/NIXESP";
    fsType = "vfat";
  };

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/cache"
        "/etc/NetworkManager/system-connections"
    ];
    files = [
        "/etc/machine-id"
    ];
    users.micah = {
      directories = [ "git" { directory = ".ssh"; mode = "0700"; } ];
    };
  };

  networking.hostName = "nanba";
  networking.hostId = "41b9e6d2";

  networking.useDHCP = true;

}