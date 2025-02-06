{ pkgs, config, inputs, lib, ... }:

{


  imports = [
    #./gpu-passthru.nix
  ];

  networking = {
    useDHCP = false; # NM handles this for us.
    networkmanager = {
      enable = true;
      dns = "systemd-resolved"; # resolved is necessary for Mullvad to work properly.
    };
    hostId = "41b9e6d4";
    hostName = "saejima"; # massivefire.mp4
    nameservers = [
      "192.168.1.244"
      "192.168.1.206"
    ];
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "micah" ];
  virtualisation.virtualbox.host.enableExtensionPack = true;


  services.resolved = {
    enable = true; 
  };

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  fileSystems."/" = {
      device = lib.mkForce "zroot"; # I partitioned this system this way a while back. Normally I use a dataset inside the pool.
      fsType = lib.mkForce "zfs";
      neededForBoot = true;
  };

  fileSystems."/nix" = {
      device = lib.mkForce "zroot/nix";
      fsType = lib.mkForce "zfs";
      neededForBoot = true;
  };

  fileSystems."/home" = {
      device = lib.mkForce "zroot/home"; # Make sure casefolding is enabled here for video games.
      fsType = lib.mkForce "zfs";
      neededForBoot = true;
  };

  fileSystems."/boot" = {
      device = lib.mkForce "/dev/disk/by-label/NIXESP";
      fsType = "vfat";
  };

  fileSystems."/mnt/steam-games" = {
      device = "zroot/games";
      fsType = "zfs";
  };

  boot.kernelModules = [ "xpad" ]; # I need this for my 8BitDo controller.

  networking.firewall.enable = false; # This is a desktop that sits at home behind my router's firewall. It's not necessary and hurts printer discovery
 
  environment.systemPackages = with pkgs; [ ];
}
