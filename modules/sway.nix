{ config, pkgs, lib, ... }:
{

  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
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
  ];

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
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
