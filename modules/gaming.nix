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
  systemd.services.load-xpad = {
    description = "Load xpad module on boot and after waking from suspend";

    # Enable the service on boot and hook it into suspend/resume
    wantedBy = [ "multi-user.target" "sleep.target" ];
    before = [ "suspend.target" "hibernate.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe xpad";
    };
  };




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

  #services.displayManager = {
  #  autoLogin.enable = true;
  #  autoLogin.user = "micah";
  #};

  #services.xserver.displayManager.defaultSession = "steam";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "tuigreet --time --remember --cmd gamescope -r 165 --adaptive-sync -e -- steam -tenfoot"
        user = "micah";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal"; # Without this errors will spam on screen
    # Without these bootlogs will spam on screen
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };


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
