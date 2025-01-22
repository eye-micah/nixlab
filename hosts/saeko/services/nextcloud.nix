{ config, pkgs, lib, ... }: let envVars = import ../env-vars.nix; in {
  services.nextcloud = {
    enable = true;
    configureRedis = true;
    package = pkgs.nextcloud28;
    hostname = "nextcloud.${envVars.localDomain}";
    config.adminPassfile = "${config.age.secrets.nextcloudPass.path}";
    config.dbtype = "pgsql";
  };

  services.caddy.virtualHosts."nextcloud.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverseProxy http://127.0.0.1:8096
    ''
    ;
  };
}

