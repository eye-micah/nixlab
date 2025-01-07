{
  config,
  pkgs,
  lib,
  ...
}:

let
  envVars = import ../env-vars.nix;
  jellyfinImageVersion = "10.10.3";

in {
  config.virtualisation.oci-containers.containers = {
    jellyfin = {
      image = "docker.io/linuxserver/jellyfin:${jellyfinImageVersion}";
      ports = [
        "0.0.0.0:8096:8096"
        "0.0.0.0:7359:7359/udp"
        "0.0.0.0:1900:1900/udp"
      ];
      volumes = [
        "${dockerPersist}/jellyfin:/config"
        "${moviesDir}:/movies"
        "${tvDir}:/tv"
      ];
      environment = { 
        PGID = "1000";
        PUID = "1000";
        TZ = "Etc/UTC";
      };
    };  
  };
}  

