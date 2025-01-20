{ ... }: {

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

}
