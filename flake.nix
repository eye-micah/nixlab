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

    # Define persistentModules
    persistentModules = [
      inputs.disko.nixosModules.disko
      (import ./disko/root { device = "IDK"; })
      ./modules/zfs.nix
      ./modules/zfs-fs-config.nix
      ./configuration.nix  # Shared configuration for all hosts
    ];

    # Define impermanentModules
    impermanentModules = [
      inputs.disko.nixosModules.disko
      inputs.impermanence.nixosModules.impermanence
      (import ./disko/imperm-root { device = "IDK"; })
      ./configuration.nix
    ];

    # Automatically import all host configuration files from ./hosts/
    hostConfigs = builtins.map (host: import ./hosts/${host}) (builtins.attrNames (builtins.readDir ./hosts));
  in {
    nixosConfigurations = {
      generic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = persistentModules ++ hostConfigs;
      };

      saeko = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = persistentModules ++ hostConfigs;
      };

      saejima = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = persistentModules ++ [
          ./modules/pipewire.nix
          ./modules/gnome.nix
          ./modules/gaming.nix
          ./modules/nvidia.nix
        ] ++ hostConfigs ++ [
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
        modules = persistentModules ++ hostConfigs;
      };

      #kaito = nixpkgs.lib.nixosSystem {
      #  system = "x86_64-linux";
      #  modules = impermanentModules ++ hostConfigs;
      #};
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

