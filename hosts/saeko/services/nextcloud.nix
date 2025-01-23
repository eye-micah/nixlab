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

    bindMounts = {
      "/var/lib/nextcloud" = { hostPath = "/cvol/nextcloud"; isReadOnly = false; };
      "/var/lib/nextcloud/data" = { hostPath = "/mnt/storage-ssd/nextcloud"; isReadOnly = false; };
      "/var/lib/postgresql" = { hostPath = "/cvol/nextcloud-db"; isReadOnly = false; };
      #"/db" = { hostPath = "/mnt/storage-ssd/nextcloud/db"; isReadOnly = false; };
    };

    config = { config, pkgs, lib, ... }: {

      systemd.tmpfiles.rules = [
        "f /var/lib/nextcloud/CAN_INSTALL - nextcloud nextcloud --"
      ];

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
        config = {
          dbtype = "pgsql";
          dbuser = "nextcloud";
          dbhost = "/run/postgresql";
          dbname = "nextcloud";
          adminpassFile = "${pkgs.writeText "adminpass" "whitewomen"}";
          adminuser = "root";
        };
        extraApps = {
          inherit (config.services.nextcloud.package.packages.apps) onlyoffice polls notes calendar tasks;
        };
        extraAppsEnable = true;
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [{ 
          name = "nextcloud";
          ensureDBOwnership = true;
        }];
      };

      systemd.services."nextcloud-setup" = {
        requires = [ "postgresql.service" ];
        after = [ "postgresql.service" ];
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

