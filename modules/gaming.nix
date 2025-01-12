{ config, pkgs, lib, ... }:
{

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

  services.flatpak.enable = true;
}