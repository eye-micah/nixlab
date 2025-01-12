# linux.nix
{ config, pkgs, lib, ... }:

{
  home.homeDirectory = "/home/micah";  # Set Linux home directory

  # Other Linux-specific configurations can go here
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
      };
    };
  };
}
