{
  config,
  pkgs,
  lib,
  ...
}:

let
  envVars = import ../env-vars.nix;
  jellyfinImageVersion = "10.10.3";
  # For the sake of local testing in a VM.
  moviesDir = /mnt/movies;
  tvDir = /mnt/tv;

in {
  config.virtualisation.oci-containers.backend = "podman";
  config.virtualisation.oci-containers.containers = {
    jellyfin = {
      image = "docker.io/linuxserver/jellyfin:${jellyfinImageVersion}";
      ports = [
        "0.0.0.0:8096:8096"
        "0.0.0.0:7359:7359/udp"
        "0.0.0.0:1900:1900/udp"
      ];
      volumes = [
        "${envVars.dockerPersist}/jellyfin:/config"
        "${envVars.moviesDir}:/movies"
        "${envVars.tvDir}:/tv"
      ];
      environment = { 
        PGID = "1000";
        PUID = "1000";
        TZ = "Etc/UTC";
      };
      autoStart = true;
      extraOptions = [ --device="/dev/dri:/dev/dri" ];
    };  
  };
}  

