{ pkgs, inputs, lib, ... }:

{

    imports = [
        #./hardware-configuration.nix
#        ./default.nix # Separating parts of configuration that are unique to this system.
        #./services
    ];

    system.stateVersion = "25.05";

    boot.initrd.systemd.enable = true;

    boot.supportedFilesystems = [ "zfs" "vfat" "btrfs" ];

    services.zfs.trim.enable = true;
    services.zfs.autoScrub.enable = true;

    boot.loader = {
        systemd-boot = {
            enable = true;
            configurationLimit = 5;
        };
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/dev/disk/by-label/NIXESP";
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
        password = "micah";  # This will use a hashed password in the system
        shell = pkgs.bash;    # Set the shell to Zsh or another shell of your choice
        group = "micah";
        extraGroups = [ "wheel" "podman" "video" "input" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC micah@haruka.tail8d76a.ts.net"
        ];
      };

      users.users.root = { password = "micah"; };

      users.groups.micah = {};

}
