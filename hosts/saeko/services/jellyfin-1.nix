{ config, pkgs, lib, ... }: let envVars = import ../env-vars.nix; in {
  services.jellyfin = {
    enable = true;
  };

  services.caddy.virtualHosts."jellyfin.${envVars.localDomain}" = {
    #useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      tls /var/lib/acme/lan.zandyne.xyz/cert.pem /var/lib/acme/lan.zandyne.xyz/key.pem {
        resolvers 1.1.1.1
      }
      reverse_proxy http://127.0.0.1:8096
    ''
    ;
  };
}

