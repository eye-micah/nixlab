# linux.nix
{ config, pkgs, lib, ... }:

{
  home-manager.homeDirectory = "/home/micah";  # Set Linux home directory

  # Other Linux-specific configurations can go here
  home-manager.dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
      };
    };
  };
}
