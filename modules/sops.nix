{ config, ... }: {

    sops.defaultSopsFile = ../secrets/secrets.json;
    sops.defaultSopsFormat = "json";
    sops.age.keyFile = ~/.config/secrets/age/keys.txt;

    sops.secrets.tailscaleAuthKey = { };

}
