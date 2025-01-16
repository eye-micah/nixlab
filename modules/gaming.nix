{ config, pkgs, lib, ... }:
{

  # needed for udev rules for various controllers like my 8BitDo
  services = {
    udev = {
      packages = with pkgs; [
        game-devices-udev-rules
      ];
    };
  };

  boot.kernelModules = [ "xpad" ]; # Needed for my 8BitDo controller.

  hardware.uinput.enable = true;

  environment.systemPackages = with pkgs; [
    # monitoring
    mangohud
    gamemode

    # emulation
    pcsx2-bin
    rpcs3
    dolphin-emu
    duckstation
    bsnes-hd
    ppsspp
    xemu

    # streaming/social crap
    vesktop
    obs-studio
  ];

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  hardware.xone.enable = true;

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
