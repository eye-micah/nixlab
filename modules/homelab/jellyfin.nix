{ lib, config, pkgs, ... }: 

with lib;

let
  configOptions = {
    lab.jellyfin = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable the Jellyfin service
            '';
          };

          enableCaddy = mkOption {
            type = types.bool;
            default = true;
            description = ''
              Enable the Caddy virtual host for Jellyfin.
            '';
          };
        };
      });
    };
    default = { enable = false; enableCaddy = true; };
    description = ''
      Options for enabling Jellyfin and Caddy configuration.
    '';
  };

in
  options = configOptions;

  config = mkIf config.lab.jellyfin.enable {
    services.jellyfin.enable = true;

    config = mkIf config.lab.jellyfin.enableCaddy {
      services.caddy.virtualHosts = {
        "jellyfin.${config.lab.localDomain}" = {
          useACMEHost = config.lab.localDomain;
          extraConfig = ''
            reverse_proxy http://127.0.0.1:8096
          '';
        };
      };
    };
  };
}


