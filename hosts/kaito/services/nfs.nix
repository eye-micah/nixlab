{ config, pkgs, lib, ... }:

{

    fileSystems."/backup" = {
        device = "/mnt/mirror";
        options = [ "bind" ];
    };

    services.nfs.server.enable = true;
    services.nfs.server.exports = ''
        /backup     haruka(ro,no_subtree_check) saeko(rw,fsid=0,no_subtree_check)
    '';

    networking.firewall.allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ]; 
    networking.firewall.allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
}