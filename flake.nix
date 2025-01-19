{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    auto-aspm = {
      url = "github:notthebee/AutoASPM";
      flake = false;
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs"; };
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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self,
              nixpkgs, nixpkgs-unstable,
              nix-darwin,
              home-manager,
              agenix,
              disko,
              impermanence,
              nixvim,
              ... } @inputs: let
    modules = import ./modules/default.nix { inherit (nixpkgs) lib; };

    # Define persistentModules
    persistentModules = [
      ./modules/zfs.nix
      ./modules/zfs-fs-config.nix
      ./modules/qemu.nix
      agenix.nixosModules.default
      ./configuration.nix  # Shared configuration for all hosts
      disko.nixosModules.default
      ./disko/root
    ];

    desktopModules = [
      ./modules/pipewire.nix
      ./modules/firefox.nix
      #./modules/cinnamon.nix
      ./modules/printing.nix
      ./modules/plymouth.nix
      ./modules/gnome.nix
      ./modules/flatpak.nix
      nixvim.nixosModules.nixvim
      ./modules/nixvim.nix
    ];

    # Define impermanentModules
    impermanentModules = [
      ./modules/zfs.nix
      ./modules/zfs-fs-config.nix
      ./modules/qemu.nix
      agenix.nixosModules.default
      disko.nixosModules.default
      inputs.impermanence.nixosModules.impermanence
      ./configuration.nix
      ./disko/imperm-root
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

      nanba = nixpkgs.lib.nixosSystem { # HP T620 thin client -- AdGuard Home, Tailscale, Cloudflare Tunnel
        system = "x86_64-linux";
        modules = impermanentModules ++ [
            ./hosts/nanba
        ];
      };

      kaito = nixpkgs.lib.nixosSystem { # 
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
          ./modules/nixvim.nix
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
