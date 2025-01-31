{ lib, config, pkgs, ... }: 

with lib;

let

  configOptions = {
    # Define the homelab.jellyfin submodule options
    homelab.jellyfin = mkOption {
      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Enable the Jellyfin service";
          };

          enableCaddy = mkOption {
            type = types.bool;
            default = true;
            description = "Enable the Caddy virtual host for Jellyfin.";
          };
        };
      };
      default = { enable = false; enableCaddy = false; };
      description = "Options for enabling Jellyfin and Caddy configuration.";
    };

    # You can add other configurations here, e.g., for other homelab services
  };

in

# Define the configuration block that applies the options
{
  options = configOptions;

  # Apply configuration conditionally
  config = rec {
    # Enable Jellyfin service if 'enable' is true
    services.jellyfin = mkIf config.homelab.jellyfin.enable {
      enable = true;
    };

    # If 'enableCaddy' is true, configure Caddy virtual host for Jellyfin
    services.caddy.virtualHosts = optionalAttrs config.homelab.jellyfin.enableCaddy {
      "jellyfin.lan.zandyne.xyz" = {
        useACMEHost = "lan.zandyne.xyz";
        extraConfig = ''
          reverse_proxy http://127.0.0.1:8096
        '';
      };
    };
  };
}

