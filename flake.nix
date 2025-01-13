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

  outputs = { 
    self, 
    nixpkgs, 
    nix-darwin, 
    home-manager, 
    impermanence, 
    ... 
  } @inputs: let
    sharedConfig = import ./modules/shared.nix { inherit (nixpkgs) lib; };
    lib = nixpkgs.lib;
    generateHostConfig = name: let
        hostConfig = import ./hosts/${name}/default.nix;

        # Define persistentModules (the future is to have impersistModules)
        persistentConfig = [
            inputs.disko.nixosModules.disko
            (import ./disko/root { device = "IDK"; })
            ./modules/zfs.nix
            ./modules/fsLayout.nix
            ./configuration.nix  # Shared configuration for all hosts
        ];

        # Host-specific modules
        hostModules = if hostConfig.homeManagerEnabled then
            persistentConfig ++ [
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.micah = import ./home-manager/clients/home.nix;
                }
            ]
        else
            persistentConfig;

    in {
        nixosConfigurations.${name} = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                sharedConfig
                hostConfig
                hostModules
            ];
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

    hostNames = builtins.attrNames (builtins.readDir ./hosts);
    mergedHostConfigs = lib.mergeAttrs (map (name: generateHostConfig name) hostNames);

  in
    mergedHostConfigs;


}