{
  nixConfig = {
      extra-substituters = [ "https://microvm.cachix.org" ];
      extra-trusted-public-keys = [ "microvm.cachix.org-1:oXnBc6hRE3eX5rSYdRyMYXnfzcCxC7yKPTbZXALsqys=" ];
  };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, nix-darwin, home-manager, agenix, impermanence, nixvim, microvm, nix-minecraft, auto-aspm, ... } @inputs:
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
        ./modules/printing.nix
        #./modules/plymouth.nix
        ./modules/gnome.nix
        ./modules/fonts.nix
        ./modules/flatpak.nix
        nixvim.nixosModules.nixvim
        ./modules/nixvim.nix
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
    };
}

