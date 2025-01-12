{
    inputs = {
        # I like living on the edge, and going with unstable just means less headaches with out of date software
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        # Used for partitioning
        disko.url = "github:nix-community/disko";
        disko.inputs.nixpkgs.follows = "nixpkgs";
        # Used for deploying to nodes
        deploy-rs.url = "github:serokell/deploy-rs";
        deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
        # Script from Wolfgang's Channel for forcing ASPM.
        auto-aspm = {
            url = "github:notthebee/AutoASPM";
            flake = false;
        };
        # For secrets management.
        #agenix = {
        #    url = "github:ryantm/agenix";
        #    inputs.nixpkgs.follows = "nixpkgs";
        #};
        # For Macs.
        nix-darwin = {
            url = "github:LnL7/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # For all home users on client devices.
        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        impermanence = {
            url = "github:nix-community/impermanence";
            #inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = 
        {
            self,
            nixpkgs,
            nix-darwin,
            home-manager,
            #agenix,
            ...
        } @inputs: 
        let
            modules = import ./modules/default.nix { inherit (nixpkgs) lib; };
        in 
        {
            # darwinConfigurations {};
            nixosConfigurations = {
                generic = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [
                        inputs.disko.nixosModules.disko
                        (import ./disko/zfs-root { device = "insert device here"; })
                        ./modules/zfs.nix
                        ./hosts/configuration.nix
                        #agenix.nixosModules.default
                        ./hosts/generic
                    ];
                };
                saeko = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [
                        inputs.disko.nixosModules.disko
                        (import ./disko/zfs-root { device = "insert device here"; })
                        ./modules/zfs.nix
                        ./hosts/configuration.nix
                        #agenix.nixosModules.default
                        ./hosts/saeko
                    ];
                };

                saejima = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [
                        inputs.disko.nixosModules.disko
                        (import ./disko/zfs-root { device = "insert device here"; })
                        ./modules/zfs.nix
                        ./modules/pipewire.nix
                        ./modules/gnome.nix
                        ./modules/gaming.nix
                        ./modules/nvidia.nix
                        # Jesus Christ. There's gotta be a cleaner way to do this.
                        ./hosts/configuration.nix
                        ./hosts/saejima
                        home-manager.nixosModules.home-manager
                        {
                            # NixOS with Home Manager integration
                            home-manager.useGlobalPkgs = true;
                            home-manager.useUserPackages = true;
                            home-manager.users.micah = import ./home-manager/clients/home.nix;

                        }
              
                    ];
                };

                nanba = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [
                        inputs.disko.nixosModules.disko
                        (import ./disko/zfs-root { device = "insert device here"; })
                        ./hosts/configuration.nix
                        ./hosts/nanba
                    ];
                };
            };

            homeConfigurations = {
                micah = home-manager.lib.homeManagerConfiguration {
                    pkgs = import nixpkgs { system = "x86_64-linux"; };
                    modules = [
                        ./home-manager/clients/linux.nix
                        ./home-manager/clients/home.nix
                    ];
                };
            };

            darwinConfigurations = {
                haruka = nix-darwin.lib.darwinSystem {
                        system = "aarch64-darwin";
                            modules = [
                                ./home-manager/clients/darwin.nix
                                home-manager.darwinModules.home-manager
                                {
                                    # nix-darwin with Home Manager integration
                                    home-manager.useGlobalPkgs = true;
                                    home-manager.useUserPackages = true;
                                    home-manager.users.micah = import ./home-manager/clients/home.nix;
                                }
                        ];
                };
            };
            
            deploy = {
                nodes = {
                    generic = {
                        hostname = "nixos";
                        profiles.system = {
                            user = "root";
                            ssh_user = "root";
                            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.generic;
                        };
                    };

                    saeko = {
                        hostname = "saeko-1"; # Replace with "saeko" during deployment. This is for my main Ryzen home server.
                        profiles.system = { 
                            user = "root";
                            sshUser = "root";
                            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.saeko;
                        };
                    };

                    nanba = {
                        hostname = "192.168.1.177"; # Was "nanba". This is for a low-power thin client or Pi.
                        profiles.system = { 
                            user = "root";
                            sshUser = "root";
                            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nanba;
                        };
                    };

                    haruka = {
                        hostname = "haruka"; # This is my Mac.
                        profiles.system = {
                            user = "micah";
                            sshUser = "micah";
                            path = inputs.deploy-rs.lib.aarch64-darwin.activate.darwin self.darwinConfigurations.haruka;
                        };
                    };

                    lxc = {
                        hostname = "lxc";
                        profiles.system = {
                            user = "root";
                            sshUser = "root";
                            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.lxc;
                        };
                    };
                };
            };

            checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

        };
}
