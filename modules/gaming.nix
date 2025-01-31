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
    pcsx2
    rpcs3
    dolphin-emu
    duckstation
    bsnes-hd
    ppsspp
    xemu

    # streaming/social crap
    vesktop
    discord
    obs-studio
  ];

  programs.gamescope = {
    enable = true;
    capSysNice = false;
    args = [
      "--adaptive-sync"
      "-r 165"
    ];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession.enable = true;
    gamescopeSession.args = [
      "--adaptive-sync"
      "-r 165"
    ];
  };

  services.displayManager = {
    autoLogin.enable = false;
    autoLogin.user = "micah";
  };

  #services.xserver.displayManager.defaultSession = "gnome";

  #systemd.services."getty@tty1".enable = false;
  #systemd.services."autovt@tty1".enable = false;

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
