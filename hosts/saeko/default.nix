{ pkgs, inputs, lib, ... }:

{
    environment.systemPackages = with pkgs; [
        pkgs.zfs
    ];

    imports = [
        ./services
    ];

    networking.hostName = "saeko";
    networking.hostId = "41b9e6d1";

    # Containerization and VMs enablement
    virtualisation = {
        containers.enable = true;
        podman = {
            enable = true;
            dockerCompat = true;
            defaultNetwork.settings.dns_enabled = true;
        };
    };

}