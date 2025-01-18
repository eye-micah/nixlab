{ ... }: {
  age.identityPaths = [
    "/nix/persist/etc/ssh/ssh_host_ed25519_key"
    "/nix/persist/etc/ssh/ssh_host_rsa_key"
  ];

  environment.persistence."/nix/persist" = {
    enable = true;
    hideMounts = false;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [ 
      "/etc/machine-id" 
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/etc/ssl/certs/ca-certificates.crt"
    ];
  };
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };
}