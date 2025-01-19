{ config, ... }: {

    sops.defaultSopsFile = ../secrets/secrets.json;
    sops.defaultSopsFormat = "json";
    sops.age.keyFile = "~/.config/age/keys.txt";

    sops.secrets.tailscaleAuthKey = { };

}
