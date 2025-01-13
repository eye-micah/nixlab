{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Helper to follow nixpkgs
    followNixpkgs = input: { url = input; inputs.nixpkgs.follows = "nixpkgs"; };

    disko = followNixpkgs "github:nix-community/disko";
    deploy-rs = followNixpkgs "github:serokell/deploy-rs";
    nix-darwin = followNixpkgs "github:LnL7/nix-darwin/master";
    home-manager = followNixpkgs "github:nix-community/home-manager/master";
    impermanence.url = "github:nix-community/impermanence";
    auto-aspm = { url = "github:notthebee/AutoASPM"; flake = false; };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... } @ inputs:
    let
      # Common definitions
      defaultSystem = "x86_64-linux";

      diskoImport = path: import path { device = "IDK"; };

      micahHomeConfig = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.micah = import ./home-manager/clients/home.nix;
      };

      commonModules = [
        ./modules/zfs.nix
        ./hosts/configuration.nix
        ./modules/zfs-fs-config.nix
      ];

      hosts = {
        generic = {
          modules = [
            diskoImport ./disko/root
            ./hosts/generic
          ];
        };

        saeko = {
          modules = [
            diskoImport ./disko/root
            ./hosts/saeko
          ];
        };

        saejima = {
          modules = [
            diskoImport ./disko/root
            ./modules/pipewire.nix
            ./modules/gnome.nix
            ./modules/gaming.nix
            ./modules/nvidia.nix
            ./hosts/saejima
            home-manager.nixosModules.home-manager micahHomeConfig
          ];
        };

        nanba = {
          modules = [
            diskoImport ./disko/root
            ./hosts/nanba
          ];
        };

        kaito = {
          modules = [
            diskoImport ./disko/imperm-root
            inputs.impermanence.nixosModules.impermanence
            ./hosts/configuration.nix
            ./hosts/kaito
          ];
        };
      };

      nixosSystemConfig = name: cfg: nixpkgs.lib.nixosSystem {
        system = defaultSystem;
        modules = (if name == "kaito" then [] else commonModules) ++ cfg.modules;
      };
    in {
      nixosConfigurations =
        lib.mapAttrs (host: cfg: nixosSystemConfig host cfg) hosts;

      homeConfigurations = {
        micah = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs { system = defaultSystem; };
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
            home-manager.darwinModules.home-manager micahHomeConfig
          ];
        };
      };
    };
}

