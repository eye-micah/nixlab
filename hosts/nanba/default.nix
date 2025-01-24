{ config, modulesPath, pkgs, inputs, lib, ... }:

{

  age.secrets.tailscaleNanba.file = ../../secrets/tailscaleNanba.age;

  age.identityPaths = [
    "/nix/persist/etc/ssh/ssh_host_ed25519_key"
    "/nix/persist/etc/ssh/ssh_host_rsa_key"
  ];

  imports = [
    ./services
  ];

  services.openssh.settings.PermitRootLogin = "yes";

  networking.hostName = "nanba";
  networking.hostId = "41b9e6d2";

  networking.useDHCP = true;

  networking.firewall.enable = true;

  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;

  environment.systemPackages = with pkgs; [ tailscale adguardhome ];

  environment.persistence."/nix/persist" = {
    enable = true;
    hideMounts = false;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/tailscale"
      "/var/lib/adguardhome"
    ];
    files = [ 
      "/etc/machine-id" 
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=512M" "mode=755" ];
  };

  fileSystems."/home" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=512M" "mode=755" ];
  };

  # tailscale
  services.tailscale = {
    # Should already be enabled.
    enable = true;
    #extraUpFlags = [ "--ssh" "--advertise-exit-node" "--accept-dns=true" "--advertise-routes=192.168.0.0/24,192.168.1.0/24" ];
    #authKeyFile = "${config.age.secrets.tailscaleNanba.path}";
    #authKeyParameters.preauthorized = true;
  };

# ...

  # create a oneshot job to authenticate to Tailscale
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # make sure tailscale is running before trying to connect to tailscale
    after = [ "network-pre.target" "tailscale.service" ];
    wants = [ "network-pre.target" "tailscale.service" ];
    wantedBy = [ "multi-user.target" ];

    # set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # have the job run this shell script
    script = with pkgs; ''
      # wait for tailscaled to settle
      sleep 2

      # check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then # if so, then do nothing
        exit 0
      fi

      # otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey $( cat ${config.age.secrets.tailscaleNanba.path} ) --ssh --advertise-exit-node --accept-dns=true --advertise-routes=192.168.0.0/24,192.168.1.0/24
    '';
  };

  # adguard home
  services.adguardhome = {
    enable = true;
    settings = {
        http = {
          address = "localhost:3000";
        };
        dns = {
          upstream_dns = [
            "1.1.1.1#cloudflare-dns.net"
            "1.0.0.1#cloudflare-dns.net"
          ];
        };
        filtering = {
          protection_enabled = true;
          filtering_enabled = true;
        };
        filters = map(url: { enabled = true; url = url; }) [
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt"  # The Big List of Hacked Malware Web Sites
          "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt"  # malicious url blocklist
          "https://raw.githubusercontent.com/JackCuthbert/pihole-twitter/main/pihole-twitter.txt" # shitter
        ];
      };
    };

    networking.firewall.allowedTCPPorts = [ 3000 53 80 443 ];

}
