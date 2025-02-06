{ config, pkgs, lib, ... }:
{

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };

  environment.systemPackages = with pkgs; [
    mpv
    grim
    slurp
    wl-clipboard
    waybar
    kitty
    mako
    font-awesome
    powerline-fonts
    powerline-symbols
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
  ];

  xdg.portal.enable = true;
  xdg.portal.wlr.enable = true;
  xdg.portal.wlr.settings.screencast = {
    output_name = "DP-1";
    chooser_type = "simple";
    chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
  };
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    environment = {
      WAYLAND_DISPLAY = "wayland-1";
      DISPLAY = ":0";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

  systemd.user.services.waybar = {
    description = "waybar as a systemd user service";
    environment = {
      WAYLAND_DISPLAY = "wayland-1";
      DISPLAY = ":0";
    };
    after = [ "graphical.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.waybar}/bin/waybar'';
    };
  };

  security.pam.loginLimits = [
    { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
  ];

  #programs.waybar.enable = true;

  # greetd display manager
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.sway}/bin/sway --unsupported-gpu";
        user = "micah";
      };
      default_session = initial_session;
    };
  };

}
