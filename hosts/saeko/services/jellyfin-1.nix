{ config, pkgs, lib, ... }: let envVars = import ../env-vars.nix; in {
  services.jellyfin = {
    enable = true;
  };

  services.caddy.virtualHosts."jellyfin.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverse_proxy http://192.168.1.234:8096
    ''
    ;
  };
}

