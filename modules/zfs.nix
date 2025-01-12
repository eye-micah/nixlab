{ config, pkgs, lib, ... }:

{
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