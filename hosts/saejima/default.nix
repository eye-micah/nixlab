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


  networking.firewallEnable = false;
 
  environment.systemPackages = with pkgs; [ zed-editor ];
}
