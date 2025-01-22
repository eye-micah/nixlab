{
  config,
  pkgs,
  lib,
  ...
}:

let
  envVars = import ../env-vars.nix;
  nextcloudImageVersion = "20250122_091948";
  # For the sake of local testing in a VM.
in {

  systemd.tmpfiles.settings = {
    "${dockerPersist}/nextcloud-aio" = {
      d = { group = "root"; mode = "0755"; user = "root"; };
    };
  };

  config.virtualisation.oci-containers.backend = "podman";
  # Nextcloud all-in-one container -- replacement for file manager and photos app from before? 
  config.virtualisation.oci-containers.containers = {
    nextcloud-aio-mastercontainer = {
      image = "docker.io/nextcloud/all-in-one:${nextcloudImageVersion}";
      ports = [
        "0.0.0.0:80:80"
        "0.0.0.0:8080:8080"
        "0.0.0.0:8443:8443"
      ];
      volumes = [
        "${envVars.dockerPersist}/nextcloud-aio:/mnt/docker-aio-config"
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
      environment = { 
        PGID = "1000";
        PUID = "1000";
        TZ = "Etc/UTC";
      };
      autoStart = true;
    };  
  };
}  

