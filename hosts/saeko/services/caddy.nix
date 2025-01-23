{ config, ... }: {

  security.acme = {
    acceptTerms = true;
    defaults.email = "micahdc@mailbox.org";
    certs."lan.zandyne.xyz" = {
      domain = "*.lan.zandyne.xyz";
      dnsProvider = "cloudflare";
      environmentFile = "${config.age.secrets.cloudflareToken.path}";
    };
  };

  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  #services.caddy.virtualHosts."test.lan.zandyne.xyz" = {
  #  extraConfig = ''
  #    reverse_proxy 127.0.0.1:8080
  #    ''
  #  useACMEHost = "lan.zandyne.xyz";
  #};

  services.caddy = {
    enable = true;
    globalConfig = ''
      tls internal {
        resolvers 1.1.1.1
      }
    ''
    ;
  };
}
