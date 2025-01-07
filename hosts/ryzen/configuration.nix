{ pkgs, inputs, ... }:

{

    imports = [
        #./hardware-configuration.nix
        ./services
    ];

    system.stateVersion = "25.05";

    boot.initrd.systemd.enable = true;

    boot.supportedFilesystems = [ "zfs" "ext4" "vfat" ];

    services.zfs.trim.enable = true;
    services.zfs.autoScrub.enable = true;

    boot.loader = {
        systemd-boot = {
            enable = true;
            configurationLimit = 5;
        };
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
        };
    };

    networking.hostName = "ryzen";
    networking.hostId = "41b9e6d1";

    nix = {
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
        };

        optimise.automatic = true;
    };

    # Containerization and VMs enablement
    virtualisation = {
        containers.enable = true;
        podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };

    environment.systemPackages = with pkgs; [
        # containerization packages
        podman-tui 
        docker-compose

        # storage
        zfs
    ];

}
