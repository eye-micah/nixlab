{ pkgs, inputs, lib, ... }:

{

  imports = [
    ./services
  ];


  networking.hostName = "nanba";
  networking.hostId = "41b9e6d2";

  networking.useDHCP = true;

}
