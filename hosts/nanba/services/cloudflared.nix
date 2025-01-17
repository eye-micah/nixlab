{ config, pkgs, lib, ... }:

age.secrets.cloudflare = {
  file = ../../../secrets/cloudflare.age;
  owner = "root";
  group = "root";
};

let
  cloudflaredToken = config.age.secrets.cloudflare.file; # Replace with your actual token
in
{
  # Ensure the cloudflared package is available
  environment.systemPackages = [ pkgs.cloudflared ];

  # Configure cloudflared as a systemd service
  services.cloudflared = {
    enable = true;
  };

  # Write the cloudflared systemd service directly with the token as argument
  systemd.services.cloudflared = {
    serviceConfig.ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token ${cloudflaredToken}";
    wantedBy = [ "multi-user.target" ];
  };
}
