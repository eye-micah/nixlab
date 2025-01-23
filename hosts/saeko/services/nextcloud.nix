{ config, pkgs, lib, ... }: let envVars = import ../env-vars.nix; in {
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp1s0";
    enableIPv6 = false;
  };

  # Nextcloud is so fucking fat and greedy I have to slam it inside a container so it doesn't listen on 86 ports I'm already using.
  containers.nextcloud = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";
    config = { config, pkgs, lib, ... }: {
      system.stateVersion = "24.11";
      networking = {
        firewall = {
          enable = true;
          allowedTCPPorts = [ 80 ];
        };
        useHostResolvConf = lib.mkForce false;
      };

      services.resolved.enable = true;

      services.nextcloud = {
        enable = true;
        configureRedis = true;
        package = pkgs.nextcloud28;
        hostName = "nextcloud.${envVars.localDomain}";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}";
        #config.adminpassFile = "${config.age.secrets.nextcloudPass.path}";
        config.dbtype = "pgsql";
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps) onlyoffice polls notes calendar tasks;
        };
        extraAppsEnable = true;
      };
    };

  };

  services.caddy.virtualHosts."nextcloud.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverse_proxy http://192.168.100.11:80
    ''
    ;
  };
}

