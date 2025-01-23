{ config, pkgs, lib, ... }: let envVars = import ../env-vars.nix; in {
  services.nextcloud = {
    enable = true;
    configureRedis = true;
    package = pkgs.nextcloud30; # why
    hostName = "nextcloud.${envVars.localDomain}";
    config.adminpassFile = "${config.age.secrets.nextcloudPass.path}";
    config.dbtype = "pgsql";
  };

  # WHY IS THERE A HARD DEPENDENCY ON NGINX???
  services.nginx.enable = true;
  services.nginx.virtualHosts."localhost".listen = [ { addr = "127.0.0.1"; port = 8080; } ];

  services.caddy.virtualHosts."nextcloud.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverseProxy http://127.0.0.1:8080
    ''
    ;
  };
}

