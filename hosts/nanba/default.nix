{ config, modulesPath, pkgs, inputs, lib, ... }:

{

  imports = [
    ./services
  ];

  networking.hostName = "nanba";
  networking.hostId = "41b9e6d2";

  networking.useDHCP = true;

  # tailscale
  services.tailscale = {
    # Should already be enabled.
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

    boot.loader.grub.device = lib.mkForce "/dev/sda";
    boot.loader.grub.efiSupport = false;
    boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
    boot.initrd.kernelModules = [ "nvme" ];
    fileSystems."/" = { device = lib.mkForce "/dev/sda1"; fsType = lib.mkForce "ext4"; };
    swapDevices = [ { device = lib.mkForce "/dev/sda5"; } ];

    boot.tmp.cleanOnBoot = true;
    zramSwap.enable = false;
    networking.domain = "";
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC micah@haruka.tail8d76a.ts.net'' ];

}
