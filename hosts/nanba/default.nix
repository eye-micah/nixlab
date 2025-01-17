{ pkgs, inputs, lib, ... }:

{

  imports = [
    ./services
  ];

  fileSystems."/" = {
      device = "zroot";
      fsType = "zfs";
  };

  fileSystems."/nix" = {
      device = "zroot/nix";
      fsType = "zfs";
  };

  fileSystems."/home" = {
      device = "zroot/home";
      fsType = "zfs";
  };

  fileSystems."/boot" = {
      device = lib.mkForce "/dev/disk/by-label/NIXESP";
      fsType = "vfat";
  };

  swapDevices = [];


  networking.hostName = "nanba";
  networking.hostId = "41b9e6d2";

  networking.useDHCP = true;

}
