{ config, ... }: {

  services.dnsmasq = {
    enable = true;
    extraConfig = ''
      interface=wg0
    '';
  };

  networking = {

    nat = {
      enable = true;
      enableIPv6 = false;
      externalInterface "enp1s0";
      internalInterfaces = [ "wg0" ];
    };

    wg-quick.interfaces = {

      wg0 = {

        address = [ "10.0.0.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/root/wireguard-keys/privatekey";

        postUp = ''
          ${pkgs.iptables}/bin/iptables -A FORWARD -i wg0 -j ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.1/24 -o enp1s0 -j MASQUERADE
        '';

        preDown = ''
          ${pkgs.iptables}/bin/iptables -D FORWARD -i wg0 -J ACCEPT
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.1/24 -o enp1s0 -j MASQUERADE
        '';

        peers = [
          { # haruka
            publicKey = "${config.age.secrets.harukaPubKey}";
            presharedKeyFile = "/root/wireguard-keys/preshared_from_peer0.key";
            allowedIPs = [ "0.0.0.0/0" ];
          };
        ];

      };
    };
  };
}
