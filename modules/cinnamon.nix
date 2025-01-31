{ config, pkgs, lib, ... }:
{
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "gnome";
    EDITOR = "nvim";
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

  qt.enable = false;

}
