inputs:
let
    homeManagerCfg = userPackages: extraImports: {
        home-manager.useGlobalPkgs = false;
        home-manager.extraSpecialArgs = {
            inherit inputs;
        };
        home-manager.users.micah.imports = [

        ] ++ extraImports;
        home-manager.useUserPackages = userPackages;
    };
in
{ 
    mkDarwin = machineHostname: nixpkgsVersion: extraHmModules: extraModules: {
        darwinConfigurations.${machineHostname} = inputs.nix-darwin.lib.darwinSystem {
            system = "aarch64-darwin";
            specialArgs = {
                inherit inputs;
            };
            modules = [
                inputs.agenix.darwinModules.default
                # ./machines/darwin # darwin specific module
                # ./machines/darwin/${machineHostname}
                inputs.home-manager.darwinModules.home-manager
                (inputs.nixpkgs.lib.attrsets.recursiveUpdate (homeManagerCfg true extraHmModules) {
                    home-manager.users.micah.home.homeDirectory = inputs.nixpkgs.lib.mkForce "/Users/micah";
                })

            ]
        };
    };
    mkNixos = machineHostname: nixpkgsVersion: extraModules: rec {
        nixosConfigurations.${machineHostname} = nixpkgsVersion.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
                inherit inputs;
                #vars = import whatever; 
            };
            modules = [
                ./modules/zfs.nix
                ./modules/zfs-fs-config.nix
                ./modules/qemu.nix
                inputs.agenix.nixosModules.default
                ./configuration.nix
            ] ++ extraModules;
        };
    };
  mkMerge = inputs.nixpkgs.lib.lists.foldl' (
    a: b: inputs.nixpkgs.lib.attrsets.recursiveUpdate a b
  ) { };
}
