{ config, pkgs, lib, ... }: let envVars = import ../env-vars.nix; in {
  services.jellyfin = {
    enable = true;
  };

  services.caddy.virtualHosts."jellyfin.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverse_proxy http://127.0.0.1:8096
    ''
    ;
  };
}

