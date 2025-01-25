{ config, pkgs, inputs, lib, ... }:

{

    ## My custom modules
    # lab = {
    #  amdgpu.enable = true;
    #  jellyfin = {
    #    enable = true;
    #    enableCaddy = true;
    #  };
    #};

    environment.systemPackages = with pkgs; [
        zfs
        tailscale
    ];


    services.nfs.server.enable = true;
    services.nfs.server.exports = ''
      /mnt/storage-ssd/editing-workspace	*(rw,async,insecure,no_root_squash,no_subtree_check)
      /mnt/storage-ssd/editing-finished	        *(rw,async,insecure,no_root_squash,no_subtree_check)
      /mnt/storage-ssd/games	                *(rw,async,insecure,no_root_squash,no_subtree_check)
    ''
    ;

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };

    networking.nat = {
        enable = true;
        internalInterfaces = [ "ve-+" ];
        externalInterface = "enp1s0";
        enableIPv6 = false;
    };

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

    hardware.graphics.enable = true;

    imports = [
        ./services
        #../../modules/homelab/jellyfin.nix
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
        "tailscaleSaeko".file = ../../secrets/tailscaleSaeko.age;
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
                "/cvol"
            ];
            timerConfig = {
                OnCalendar = "weekly";
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
