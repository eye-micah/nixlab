{
  config,
  pkgs,
  lib,
  ...
}:

let
  envVars = import ../env-vars.nix;
  traefikImageVersion = "3.3.2";
  # For the sake of local testing in a VM.

in {

  systemd.tmpfiles.settings = {
    "${dockerPersist}/traefik" = {
      d = { group = "root"; mode = "0755"; user = "root"; };
    };
  };

  config.virtualisation.oci-containers.backend = "podman";
  config.virtualisation.oci-containers.containers = {
    traefik = {
      image = "docker.io/library/traefik:${traefikImageVersion}";
      ports = [
        "0.0.0.0:80:80"
        "0.0.0.0:443:443"
        "0.0.0.0:8080:8080"
      ];
      volumes = [
#        "${envVars.dockerPersist}/jellyfin:/config"
        "/etc/localtime:/etc/localtime:ro"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
        "${dockerPersist}/traefik.yml:/traefik.yml:ro"
      ];
      environment = { 
        PGID = "1000";
        PUID = "1000";
        TZ = "Etc/UTC";
      };
      autoStart = true;
      extraOptions = [ 
        --security-opt=no-new-privileges=true 
      ];
      labels = [
        "traefik.http.routers.traefik.rule" = "Host( `traefik-dashboard.lan.zandyne.xyz` )"
      ];
    };  
  };
}  

