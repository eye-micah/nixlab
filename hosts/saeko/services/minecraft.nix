{ ... }: {

    systemd.tmpfiles.rules = [
        "f /cvol/minecraft/quade - minecraft minecraft --"
    ];
    # For Quade. I don't trust Minecraft stuff enough to run this outside of a VM or container.
    containers.minecraft-quade = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.100.12";
        localAddress = "192.168.100.13";

        bindMounts = {
            "/var/lib/minecraft" = { hostPath = "/cvol/minecraft/quade"; isReadOnly = false;};
        };

        config = { ... }: {
            system.stateVersion = "24.11";
            networking = {
                firewall = {
                    enable = true;
                    allowedTCPPorts = [ 25565 ];
                };
                useHostResolvConf = lib.mkForce false;
            };

            services.resolved.enable = true;

            services.minecraft = {
                enable = true;
                eula = true;
                declarative = true;

                serverProperties = {
                    gamemode = "survival";
                    difficulty = "hard";
                    simulation-distance = 10;
                    level-seed = "4";
                };

                whitelist = {
                    # username = id;
                };

                jvmOpts = "-Xms4096M -Xmx4096M -XX:+UseG1GC";
            };
        };
    };    

}
