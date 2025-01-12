{ pkgs, inputs, lib, config, ... }:

{
  
  networking.hostName = lib.mkDefault "nixos";
  networking.hostId = builtins.substring 0 8 (builtins.hashString "sha256" config.networking.hostName);

  networking.useDHCP = true;

}