{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    auto-aspm = {
      url = "github:notthebee/AutoASPM";
      flake = false;
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs"; };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, 
              nixpkgs, 
              nix-darwin, 
              home-manager, 
              sops-nix, 
              disko, 
              nixvim, 
              ... } @inputs: let
    modules = import ./modules/default.nix { inherit (nixpkgs) lib; };

    # Define persistentModules
    persistentModules = [
      ./modules/zfs.nix
      ./modules/zfs-fs-config.nix
      ./modules/qemu.nix
      sops-nix.nixosModules.sops
      ./configuration.nix  # Shared configuration for all hosts
      disko.nixosModules.default
      ./disko/root
    ];

    desktopModules = [
      ./modules/pipewire.nix
      ./modules/firefox.nix
      ./modules/gnome.nix
      ./modules/flatpak.nix
      nixvim.nixosModules.nixvim
      ./modules/nixvim.nix
    ];

    # Define impermanentModules
    impermanentModules = [
      inputs.impermanence.nixosModules.impermanence
      ./configuration.nix
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
        modules = persistentModules ++ [
            ./hosts/saeko
        ];
      };

      saejima = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = persistentModules ++ desktopModules ++ [
          ./modules/gaming.nix
          ./modules/nvidia.nix
          ./hosts/saejima
        ] ++ [
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
            ./hosts/nanba
        ];
      };

      oracleArm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [ ./configuration.nix ./hosts/oracleArm ];
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
          ./modules/darwin.nix
          ./modules/nixvim.nix
          nixvim.nixDarwinModules.nixvim
          home-manager.darwinModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.micah = import ./home-manager/clients/home.nix;
          }
        ];
      };
    };
  };
}
