{ ... }: {
  services.tailscale.enable = true;
  environment.systemPackages = with pkgs; [ tailscale ];
  networking.firewall.allowedUDPPorts = [ ${services.tailscale.port} ];
}
