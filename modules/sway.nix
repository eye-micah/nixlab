{ config, pkgs, lib, ... }: {
  environment.systemPackages = with pkgs; [
    grim
    slurp
    wl-clipboard
    mako
    alacritty
  ];

  services.gnome.gnome-keyring.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

}
