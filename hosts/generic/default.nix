{ pkgs, inputs, lib, config, ... }:

{
  
  networking.hostName = lib.mkDefault "nixos";
  networking.hostId = "3r3r9944";
  networking.useDHCP = true;

}