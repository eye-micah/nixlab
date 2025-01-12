{
  description = "Darwin and Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    agenix.url = "github:ryantm/agenix";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, agenix, ... }: {
    # Home Manager configuration for Linux
    homeConfigurations = {
      micah = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./linux.nix
          ./home.nix
        ];
      };
    };

    # nix-darwin configuration for macOS
    darwinConfigurations = {
      haruka = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin.nix
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.aarch64-darwin.default ];
          }
          home-manager.darwinModules.home-manager
          {
            # nix-darwin with Home Manager integration
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.micah = import ./home.nix;
          }
        ];
      };
    };
  };
}
