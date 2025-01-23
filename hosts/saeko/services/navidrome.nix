{ ... }: {
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