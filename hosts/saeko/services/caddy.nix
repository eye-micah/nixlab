{ config, ... }: {

  security.acme = {
    acceptTerms = true;
    defaults.email = "micahdc@mailbox.org";
    certs."lan.zandyne.xyz" = {
      group = config.services.caddy.group;
      domain = "lan.zandyne.xyz";
      extraDomainNames = [ "*.lan.zandyne.xyz" ];
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      dnsPropagationCheck = true;
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
    virtualHosts."example.lan.zandyne.xyz".extraConfig = ''
      respond "Hello, world!"
      tls {
        resolvers 1.1.1.1
      }
    '';
  };

  services.caddy.virtualHosts."git.lan.zandyne.xyz".extraConfig = ''
    reverse_proxy http://192.168.1.173:3000/gitea/nixlab.git
  '';
  
}
