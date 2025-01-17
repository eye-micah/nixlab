{ config, ... }: {

    sops.defaultSopsFile = ./secrets/secrets.json;
    sops.defaultSopsFormat = "json";
    sops.age.keyFile = "./secrets/age/keys.txt";

    sops.secrets.tailscaleAuthKey = { };

}
