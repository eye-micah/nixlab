{ pkgs, lib, ... }:

{

    environment.systemPackages = [ pkgs.adguardhome ];

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