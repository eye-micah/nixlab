{ lib, ... }:

{
  
  networking.hostName = "shinada";
  networking.hostId = "deadb33f";
  networking.useDHCP = lib.mkDefault true;
  services.xserver.displayManager.gdm.enable = lib.mkForce false;

  services.tailscale.enable = true;



}
