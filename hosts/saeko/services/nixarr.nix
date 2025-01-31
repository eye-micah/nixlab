{ config, ... }: let envVars = import ../env-vars.nix; in {

  networking.firewall.allowedUDPPorts = [ "51820" ];


  nixarr = {
    enable = true;
    vpn = {
      enable = true;
      wgConf = config.age.secrets.wgConf.path;
      vpnTestService = {
        enable = true;
       port = 12345;
      };
    };
    transmission = {
      enable = true;
      vpn.enable = true;
      extraAllowedIps = [ 
        "0.0.0.0" 
        "192.168.*"
        "100*"
        "100.85.135.55"
      ];
    };
    sonarr.enable = true;
    radarr.enable = true;
    bazarr.enable = true;
    prowlarr.enable = true;
    jellyseerr.enable = true;
  };

  services.caddy.virtualHosts."trans.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverse_proxy http://127.0.0.1:9091
    ''
    ;
  };

  services.caddy.virtualHosts."sonarr.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverse_proxy http://127.0.0.1:8989
    ''
    ;
  };

  services.caddy.virtualHosts."jellyseerr.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverse_proxy http://127.0.0.1:5055
    ''
    ;
  };

  services.caddy.virtualHosts."prowlarr.${envVars.localDomain}" = {
    useACMEHost = "${envVars.localDomain}";
    extraConfig = ''
      reverse_proxy http://127.0.0.1:9696
    ''
    ;
  };

}
