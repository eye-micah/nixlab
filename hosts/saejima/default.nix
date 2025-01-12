{ pkgs, inputs, lib, ... }:

{
  imports = [
    ./services
  ];

  fileSystems."/" = {
    device = "zpool/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zpool/nix";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/NIXESP";
    fsType = "vfat";
  };

  swapDevices = [];
}