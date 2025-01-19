{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (wrapFirefox (firefox-unwrapped.override { pipewireSupport = true;}) {})
  ];

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}
