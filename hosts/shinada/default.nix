{ config, pkgs, lib, ... }:

{


  
  networking.hostName = "shinada";
  networking.hostId = "deadb33f";
  networking.useDHCP = lib.mkDefault true;
  services.xserver.displayManager.gdm.enable = lib.mkForce false; # Needed for Jovian-NixOS to work correctly

  environment.systemPackages = with pkgs; [ trayscale gnome-software ];

  boot.kernelModules = [ "xpad" ]; # Needed for my 8BitDo controller.
  systemd.services.load-xpad = {
    description = "Load xpad module on boot and after waking from suspend";

    # Enable the service on boot and hook it into suspend/resume
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.kmod}/bin/modprobe xpad";
    };
  };

  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_rsa_key"
  ];

  age.secrets = {
    "tailscaleShinada".file = ../../secrets/tailscaleShinada.age;
  };

  services.tailscale = {
      enable = true;
  };

  #networking.firewall.allowedUDPPorts = [ ${services.tailscale.port} ];

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
      ${tailscale}/bin/tailscale up -authkey $( cat ${config.age.secrets.tailscaleShinada.path} ) --ssh --operator=micah 
      '';
  };


}
