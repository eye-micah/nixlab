{ ... }: {
# Containerizing Nixarr for separation's sake.
containers.nixarr = {

  bindMounts."/etc/ssh/ssh_host_ed25519_key".isReadOnly = true;
  bindMounts."${zfsSolidStatePool}/movies".isReadOnly = false;
  bindMounts."${zfsSolidStatePool}/tv".isReadOnly = false;

  autoStart = true;
  privateNetwork = true;

  config = { config, pkgs, lib, ... }: {

    imports = [ agenix.nixosModules.default ];

    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.secrets."wireGuard" = file ../../secrets/wireGuard.age;

    system.stateVersion = "24.11";

    networking = {
      firewall = {
        enable = false;
      };
    };

    nixarr = {
      enable = true;
      vpn = {
        enable = true;
        wgConf = config.age.secrets.wireGuard.path;
      };
      transmission = {
        enable = true;
        vpn.enable = true;
      };
      sonarr.enable = true;
      radarr.enable = true;
    };

  };

}

