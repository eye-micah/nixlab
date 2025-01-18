{ config, modulesPath, pkgs, inputs, lib, ... }:

{

  age.secrets.tailscaleNanba.file = ../secrets/tailscaleNanba.age;

  imports = [
    ./services
  ];

  networking.hostName = "nanba";
  networking.hostId = "41b9e6d2";

  networking.useDHCP = true;

  environment.systemPackages = with pkgs; [ tailscale adguardhome ];

  # tailscale
  services.tailscale = {
    # Should already be enabled.
    enable = true;
    extraUpFlags = [ "--ssh" "--advertise-exit-node" "--accept-dns=true" "--advertise-routes=192.168.0.0/24,192.168.1.0/24" ];
    authKeyFile = "${config.age.secrets.tailscaleNanba.path}";
    authKeyParameters.preauthorized = true;
  };

  # adguard home
  services.adguardhome = {
    enable = true;
    settings = {
        http = {
          address = "localhost:3003";
        };
        dns = {
          upstream_dns = [
            "9.9.9.9#dns.quad9.net"
            "149.112.112.112#dns.quad9.net"
          ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
        };
        filters = map(url: { enabled = true; url = url; }) [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
        ];
      };
    };


}
