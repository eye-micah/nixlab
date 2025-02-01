{ ... }: let envVars = import ../env-vars.nix; in {
    services.navidrome = {
        enable = true;
        openFirewall = true;
        settings = {
            MusicFolder = "/mnt/storage-ssd/music";
        };
    };

    services.caddy.virtualHosts."navidrome.${envVars.localDomain}" = {
        useACMEHost = "${envVars.localDomain}";
        extraConfig = ''
            reverse_proxy http://127.0.0.1:4533
        ''
        ;
    };
}


{ lib, config, pkgs, ... }:

with lib;

let

  configOptions = {
    homelab.navidrome = mkOption {
      type = types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Enable the Navidrome service";
          };

          enableCaddy = mkOption {
            type = types.bool;
            default = true;
            description = "Enable the Caddy virtual host for Navidrome.";
          };
        };
      };
      default = { enable = false; enableCaddy = false; };
      description = "Options for enabling Navidrome and Caddy configuration.";
    };
    
