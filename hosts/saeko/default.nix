{ config, pkgs, inputs, lib, ... }:

{
    environment.systemPackages = with pkgs; [
        pkgs.zfs
    ];

    fileSystem."/cvol" = {
        device = "zroot/cvol";
        fsType = "zfs";
        neededForBoot = true;
    }

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
