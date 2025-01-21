{ config, pkgs, inputs, lib, ... }:

{

    hardware.opengl.enable = true;

    imports = [
        ./services
    ];

    networking.hostName = "saeko";
    networking.hostId = "41b9e6d1";

    networking.nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "ens3"; # change
      enableIPv6 = true;
    };

    age.secrets = {
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
