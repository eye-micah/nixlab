{ config, pkgs, lib, ... }:
{
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "gnome";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    orca
    geary
    gnome-tour
    gnome-user-docs
    baobab
    epiphany
    gnome-calendar
    gnome-characters
    gnome-clocks
    gnome-maps
    gnome-music
    gnome-weather
    gnome-connections
    gnome-software
    totem
    gnome-contacts
  ];

  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-panel
    gnomeExtensions.appindicator
    gnome-terminal
    celluloid
  ];

  services.udev.packages = [ pkgs.gnome-settings-daemon ]; # Needed for appindicator icons

 # nixpkgs.overlays = [
    # GNOME 46: triple-buffering-v4-46
#    (final: prev: {
#      mutter = prev.mutter.overrideAttrs (old: {
#        src = pkgs.fetchFromGitLab  {
#          domain = "gitlab.gnome.org";
#          owner = "vanvugt";
#          repo = "mutter";
#          rev = "triple-buffering-v4-46";
#          hash = "sha256-C2VfW3ThPEZ37YkX7ejlyumLnWa9oij333d5c4yfZxc=";
#        };
#      });
#    })
#  ];

}
