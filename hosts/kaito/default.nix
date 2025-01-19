{ config, ... }: {

    age.secrets = {
        "resticEnv".file = ../../secrets/resticEnv.age;
        "resticRepo".file = ../../secrets/resticRepo.age;
        "resticPassword".file = ../../secrets/resticPassword.age;
    };
    
    networking.hostId = "41b9e6d8";



}