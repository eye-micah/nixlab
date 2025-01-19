{ config, pkgs, lib, ... }:
{
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "gnome";
  };

  environment.systemPackages = with pkgs; [ gettext cinnamon-common mint-y-icons mint-themes ];

  services.xserver = {
    enable = true;
    libinput.enable = true;
    displayManager.lightdm.enable = true;
    desktopManager = {
      cinnamon.enable = true;
    };
    displayManager.defaultSession = "cinnamon";
  };

  #services.udev.packages = [ pkgs.gnome-settings-daemon ]; # Needed for appindicator icons

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
