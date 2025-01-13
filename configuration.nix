{ pkgs, inputs, lib, ... }:

{

  # Set boot-related options
  boot.zfs.devNodes = "/dev/disk/by-id";

  imports = [
    # Uncomment if needed for system-specific configurations
    # ./hardware-configuration.nix
    # ./default.nix
    # ./services
  ];

  # Default nixpkgs settings
  nixpkgs.config.allowUnfree = lib.mkDefault false;
  nixpkgs.config.allowUnsupportedSystem = lib.mkDefault false;

  # Set the default state version
  system.stateVersion = lib.mkDefault "23.05";

  # Disable initrd systemd by default (can be overwritten if needed)
  boot.initrd.systemd.enable = lib.mkDefault false;

  # Define the supported file systems
  boot.supportedFilesystems = lib.mkDefault [ "zfs" "vfat" ];

  # Set up ZFS-related services
  services.zfs.trim.enable = lib.mkDefault true;
  services.zfs.autoScrub.enable = lib.mkDefault true;

  # Configure the boot loader
  boot.loader = {
    grub = {
      efiSupport = lib.mkDefault true;
      zfsSupport = lib.mkDefault true;
      device = lib.mkDefault "nodev";
    };
    efi = {
      canTouchEfiVariables = lib.mkDefault true;
      efiSysMountPoint = lib.mkDefault "/boot";
    };
  };

  # Enable Nix experimental features (flakes, nix-command)
  nix.settings = {
    experimental-features = lib.mkDefault [ "nix-command" "flakes" ];
  };

  # Enable SSH by default
  services.openssh.enable = lib.mkDefault true;

  # Configure garbage collection and optimization for Nix
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 30d";
  };

  nix.optimise.automatic = lib.mkDefault true;

  # Default system packages
  environment.systemPackages = with pkgs; lib.mkDefault [
    git
    # podman-tui
    # docker-compose
    # zfs
  ];

  # User configuration for micah
  users.users.micah = {
    isSystemUser = lib.mkDefault true;
    home = lib.mkDefault "/home/micah";
    createHome = lib.mkDefault true;
    hashedPassword = lib.mkDefault "$6$RnJeIDSyPLqDOHGu$u/oHbJyOeBu0uss9DY2VBYLD7BZmCNoc7456iP4LBEy8a5tjlu5GzDEX1FKte/7rFxolXXNkZS5UacQdz5Row0";
    shell = pkgs.bash; # Default shell
    group = lib.mkDefault "micah";
    extraGroups = lib.mkDefault [ "wheel" "podman" "video" "input" ];
    openssh.authorizedKeys.keys = lib.mkDefault [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC micah@haruka.tail8d76a.ts.net"
    ];
  };

  # Define user group configuration for micah
  users.groups.micah = {};

}
