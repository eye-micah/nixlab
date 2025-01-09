{ config, pkgs, lib, ... }:

let
  cloudflaredToken = "eyJhIjoiNDNjNTg0MGYyYWNjM2Q1ZmNjNjU4NjQ3MGU3ZTRiZGMiLCJ0IjoiYzY5YzAzODQtY2VkMi00ZGU0LWI3ZDUtOGM1ZTA4YzI2MDk5IiwicyI6Ik1EVmtZVFF6T1RVdE5EVXpNUzAwTjJNMUxUbGhZalV0TWpoa05USXpZamsxTUdVMiJ9"; # Replace with your actual token
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
