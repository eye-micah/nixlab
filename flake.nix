{
  inputs = { 
    nixpkgs = { 
      url = "github:nixos/nixpkgs/nixos-24.11"; 
    }; 

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixarr = {
      url = "github:rasmus-kirk/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    auto-aspm = {
      url = "github:notthebee/AutoASPM";
      flake = false;
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    agenix = {
      url = "github:ryantm/agenix";
    };

    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixarr, deploy-rs, jovian-nixos, nix-darwin, home-manager, home-manager-unstable, agenix, impermanence, nixvim, microvm, nix-minecraft, auto-aspm, ... } @inputs:
    let
      baseModules = [
        ./modules/zfs.nix
        ./modules/zfs-fs-config.nix
        ./modules/qemu.nix
        agenix.nixosModules.default
        ./configuration.nix
      ];

      persistentModules = baseModules ++ [
      ];

      impermanentModules = baseModules ++ [
        inputs.impermanence.nixosModules.impermanence
      ];

      desktopModules = [
        ./modules/pipewire.nix
        ./modules/firefox.nix
        #./modules/printing.nix
        #./modules/plymouth.nix
        #./modules/gnome.nix
        ./modules/sway.nix
        ./modules/fonts.nix
        ./modules/flatpak.nix
        nixvim.nixosModules.nixvim
        ./modules/nixvim.nix
      ];

      deckModules = [
        agenix.nixosModules.default
        ./configuration.nix
        ./modules/ext4-config.nix
        ./modules/gnome.nix
        ./modules/flatpak.nix
      ];

    in {
      nixosConfigurations = {
        generic = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = persistentModules ++ [
            ./hosts/generic
          ];
        };

        saeko = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = persistentModules ++ [
            ./modules/auto-aspm.nix
            ./hosts/saeko
            nixarr.nixosModules.default
          ] ++ [
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.micah = import ./home-manager/home.nix;
            }
          ];
        };

        saejima = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = persistentModules ++ desktopModules ++ [
            ./modules/gaming.nix
            ./modules/nvidia.nix
            ./modules/resolve.nix
            ./modules/saekoMounts.nix
            ./hosts/saejima
          ] ++ [
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-bak";
              home-manager.users.micah = import ./home-manager/home.nix;
            }
          ];
        };

        nanba = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = impermanentModules ++ [
            ./hosts/nanba
          ];
        };

        kaito = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = impermanentModules ++ [
            ./hosts/kaito
          ];
        };

        shinada = nixpkgs-unstable.lib.nixosSystem {
          system = "x86_64-linux";
          modules = deckModules ++ [
            ./hosts/shinada
            home-manager-unstable.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.micah = import ./home-manager/home.nix;
              home-manager.backupFileExtension = "hm.bak";
            }
            jovian-nixos.nixosModules.default {
              jovian = {
                decky-loader.enable = true;
                devices.steamdeck = {
                  enable = true;
                  autoUpdate = true;
                };
                steam = {
                  enable = true;
                  autoStart = true;
                  desktopSession = "gnome";
                  user = "micah";
                };
              };
            }
          ];
        };

        oracleArm = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [ ./configuration.nix ./hosts/oracleArm ];
        };
      };

      homeConfigurations = {
        micah = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = "x86_64-linux"; };
          modules = [
            nixvim.homeManagerModules.nixvim
            ./modules/nixvim.nix
            ./home-manager/home.nix
          ];
        };
      };

      darwinConfigurations = {
        haruka = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./modules/darwin.nix
            ./modules/nixvim.nix
            nixvim.nixDarwinModules.nixvim
            home-manager.darwinModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.micah = import ./home-manager/home.nix;
            }
          ];
        };
      };

      deploy = {
        nodes = {
          saeko = {
            fastConnection = true;
            interactiveSudo = true;
            remoteBuild = true;
            hostname = "saeko";
            profiles.system = {
              sshUser = "micah";
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.saeko;
            };
          };
          saejima = {
            fastConnection = true;
            interactiveSudo = true;
            remoteBuild = true;
            hostname = "saejima.local";
            profiles.system = {
              sshUser = "micah";
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.saejima;
            };
          };
        };
      };

      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    };
}

