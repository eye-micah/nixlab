{ pkgs, inputs, lib, ... }:

{

  networking = {
    useDHCP = false; # NM handles this for us.
    networkmanager = {
      enable = true;
      dns = "none"; # NixOS handles this.
    };
    hostId = "41b9e6d4";
    hostName = "saejima";
    nameservers = [
      "192.168.1.206"
    ];
  };

  fileSystems."/" = {
      device = "zroot";
      fsType = "zfs";
      neededForBoot = true;
  };

  fileSystems."/nix" = {
      device = lib.mkForce "zroot/nix";
      fsType = lib.mkForce "zfs";
      neededForBoot = true;
  };

  fileSystems."/home" = {
      device = lib.mkForce "zroot/home";
      fsType = lib.mkForce "zfs";
      neededForBoot = true;
  };

  fileSystems."/boot" = {
      device = lib.mkForce "/dev/disk/by-label/NIXESP";
      fsType = "vfat";
  };



  networking.firewall.enable = false;
 
  environment.systemPackages = with pkgs; [ zed-editor ];
}
