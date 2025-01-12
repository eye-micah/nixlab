{ config, pkgs, lib, ... }:

{
    boot.initrd.supportedFilesystems = ["zfs"];
    boot.supportedFilesystems = [ "zfs" ];

    environment.systemPackages = with pkgs; [
        # needed tools 
        git 

        # containerization packages
        #podman-tui 
        #docker-compose

        # storage
        zfs
    ];

}