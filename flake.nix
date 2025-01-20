{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };

    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS/development";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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

  };

  outputs = { ... }@inputs:
      let
          helpers = import ./flakeHelpers.nix inputs;
          inherit (helpers) mkMerge mkNixos mkDarwin;
      in
      mkMerge [

          # Steam Deck
          (mkNixos "shinada" inputs.nixpkgs-unstable [
            ./hosts/shinada
            inputs.jovian-nixos.nixosModules.default
          ])

          # Gaming PC
          (mkNixos "saejima" inputs.nixpkgs [
            ./hosts/saejima
            ./modules/gaming.nix
            ./modules/nvidia.nix
            ./modules/resolve.nix
            ./modules/saekoMounts.nix
          ])

          # T620 Thin Client
          (mkNixos "nanba" inputs.nixpkgs [
            ./hosts/nanba
            inputs.impermanence.nixosModules.impermanence
          ])

          # Home server
          (mkNixos "saeko" inputs.nixpkgs [
            ./hosts/saeko
          ])

          # Backup NAS
          (mkNixos "kaito" inputs.nixpkgs [
            ./hosts/kaito
            inputs.impermanence.nixosModules.impermanence
          ])
      ];
}