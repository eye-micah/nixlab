{ config, pkgs, inputs, lib, ... }:

{
    environment.systemPackages = with pkgs; [
        zfs
        tailscale
    ];

    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

    services.tailscale = {
        enable = true;
    };

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
        ${tailscale}/bin/tailscale up -authkey $( cat ${config.age.secrets.tailscaleSaeko.path} ) --ssh 
        '';
    };

    fileSystems."/cvol" = {
        device = "zroot/cvol";
        fsType = "zfs";
        neededForBoot = true;
    };

    boot.zfs.extraPools = [ "storage-ssd" ];

    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_rsa_key"
    ];

    hardware.opengl.enable = true;

    imports = [
        ./services
    ];

    networking.hostName = "saeko";
    networking.hostId = "41b9e6d1";
    networking.nameservers = [ "1.1.1.1" ];

    age.secrets = {
        "cloudflareToken".file = ../../secrets/cloudflareToken.age;
        "nextcloudPass".file = ../../secrets/nextcloudPass.age;
        #"nextcloudPass".owner = "nextcloud";
        #"nextcloudPass".group = "nextcloud";
        #"nextcloudPass".mode = "660";
        "resticEnv".file = ../../secrets/resticEnv.age;
        "resticRepo".file = ../../secrets/resticRepo.age;
        "resticPassword".file = ../../secrets/resticPassword.age;
    };
    
    services.restic.backups = {
        backblaze = {
            initialize = true;
            environmentFile = config.age.secrets."resticEnv".path;
            repositoryFile = config.age.secrets."resticRepo".path;
            passwordFile = config.age.secrets."resticPassword".path;

            paths = [
                "/mnt/storage-ssd/editing-finished" ## Uses way too much disk space! Can't afford that!
                "/mnt/storage-ssd/docs"
            ];
            timerConfig = {
                OnCalendar = "05:00";
                RandomizedDelaySec = "5h";
            };
        };
#        kaito = {
#            initialize = true;

#            paths = [
#                "/cvol"
#                "/mnt/storage-ssd/editing-finished"
#                "/mnt/storage-ssd/docs"
#            ];
#            repository = "ssh:backup@kaito:/mnt/mirror";
#        };
    };

}
