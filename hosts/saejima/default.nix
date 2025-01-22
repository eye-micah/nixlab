{ pkgs, config, inputs, lib, ... }:

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
      "192.168.1.244"
      "192.168.1.206"
    ];
  };

  fileSystems."/" = {
      device = lib.mkForce "zroot";
      fsType = lib.mkForce "zfs";
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

  boot.kernelModules = [ "xpad" ];

  systemd.services = {
    "xpad-modprobe" = {
      after = [ "graphical.target" ];
      serviceConfig = {
        ExecStart = "modprobe xpad";
      };
    };
  };

  networking.firewall.enable = false;
 
  environment.systemPackages = with pkgs; [ # put shit here ];
}
