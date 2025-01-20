{ ... }: {
  
  # Jovian Steam Deck Modules
  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "micah";
      desktopSession = "gnome";
    };
    devices.steamdeck = {
      enable = true;
      autoUpdate = false;
      enableGyroDsuService = true;
    };
  };

  # GNOME
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # ZFS tweaks
  boot.kernelParams = [
    "zfs_arc_min=64M"
    "zfs_arc_max=2G"
  ];

  # Home directory, where games are stored
  fileSystems."/home" = {
    mountPoint = "/home";
    fsType = "zfs";
    options = [
      "compression=zstd"
      "recordsize=1M"
      "casesensitivity=insensitive"
    ];
  };

  networking.hostId = "41b9e6d9";

}
