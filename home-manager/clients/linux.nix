# linux.nix
{ config, pkgs, lib, ... }:

{
  home.homeDirectory = "/home/micah";  # Set Linux home directory

  # Other Linux-specific configurations can go here

  programs.nixvim = {
      enable = true;
      #defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;
      plugins = {
        nix.enable = true;
      };

  };

}
