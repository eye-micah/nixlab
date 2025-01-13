{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    auto-aspm = {
      url = "github:notthebee/AutoASPM";
      flake = false;
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, impermanence, ... } @inputs: let
    modules = import ./modules/default.nix { inherit (nixpkgs) lib; };
    persistentModules = [
      inputs.disko.nixosModules.disko
      (import ./disko/root { device = "IDK"; })
      ./modules/zfs.nix
      ./modules/zfs-fs-config.nix
    ];
    impermanentModules = [
      inputs.disko.nixosModules.disko
      inputs.impermanence.nixosModules.impermanence
      (import ./disko/imperm-root { device = "IDK"; })
    ];
  in {
    nixosConfigurations = {
      generic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = persistentModules ++ [
          ./hosts/configuration.nix
          ./hosts/generic
        ];
      };

      saeko = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = persistentModules ++ [
          ./hosts/configuration.nix
          ./hosts/saeko
        ];
      };

      saejima = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = persistentModules ++ [
          ./modules/pipewire.nix
          ./modules/gnome.nix
          ./modules/gaming.nix
          ./modules/nvidia.nix
          ./hosts/configuration.nix
          ./hosts/saejima
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.micah = import ./home-manager/clients/home.nix;
          }
        ];
      };

      nanba = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = persistentModules ++ [
          ./hosts/configuration.nix
          ./hosts/nanba
        ];
      };

      kaito = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = impermanentModules ++ [
          ./hosts/configuration.nix
          ./hosts/kaito
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
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.micah = import ./home-manager/clients/home.nix;
          }
        ];
      };
    };
  };
}
