{ pkgs, inputs, lib, ... }:

{

    #boot.zfs.devNodes = "/dev/disk/by-id";

    #boot.zfs.forceImportRoot = true;

    imports = [
        #./hardware-configuration.nix
#        ./default.nix # Separating parts of configuration that are unique to this system.
        #./services
    ];

    

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };


    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnsupportedSystem = true;

    system.stateVersion = lib.mkDefault "25.05";

    boot.initrd.systemd.enable = false;

    boot.supportedFilesystems = [ "zfs" "vfat" ];

    services.zfs.trim.enable = true;
    services.zfs.autoScrub.enable = true;

    boot.loader = {
        grub = {
            efiSupport = true;
            zfsSupport = true;
            device = "nodev";
        };
        efi = {
            canTouchEfiVariables = lib.mkDefault true;
            efiSysMountPoint = "/boot";
        };
    };

    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };

    services.openssh.enable = true;

    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
        };

        optimise.automatic = true;
    };



    environment.systemPackages = with pkgs; [
        # needed tools 
        git 

        # containerization packages
        #podman-tui 
        #docker-compose

        # storage
        #zfs
    ];



      users.users.micah = {
        isSystemUser = true;
        home = "/home/micah";
        createHome = true;
        hashedPassword = "$6$RnJeIDSyPLqDOHGu$u/oHbJyOeBu0uss9DY2VBYLD7BZmCNoc7456iP4LBEy8a5tjlu5GzDEX1FKte/7rFxolXXNkZS5UacQdz5Row0";  # This will use a hashed password in the system
        shell = pkgs.bash;    # Set the shell to Zsh or another shell of your choice
        group = "micah";
        extraGroups = [ "wheel" "podman" "video" "input" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC micah@haruka.tail8d76a.ts.net"
        ];
      };

      users.groups.micah = {};

}
