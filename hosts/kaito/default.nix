{ ... }: {

    age.secrets = {
        "resticEnv".file = ../secrets/resticEnv.age;
        "resticRepo".file = ../secrets/resticRepo.age;
        "resticPassword".file = ../secrets/resticPassword.age;
    };
    
    services.restic.backups = {
        weekly = {
            initialize = true;
            environmentFile = config.age.secrets."resticEnv".path;
            repositoryFile = config.age.secrets."resticRepo".path;
            passwordFile = config.age.secrets."resticPassword".path;

            paths = [
                /mnt/mirror/vms
                /mnt/mirror/cvol
                /mnt/mirror/editing-finished ## Uses way too much disk space! Can't afford that!
                /mnt/mirror/gitea
            ];
        };
    };

}