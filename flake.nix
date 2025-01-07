{
    inputs = {
        # I like living on the edge, and going with unstable just means less headaches with out of date software
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        # Used for deploying to nodes
        deploy-rs.url = "github:serokell/deploy-rs";
        # Script from Wolfgang's Channel for forcing ASPM.
        auto-aspm = {
            url = "github:notthebee/AutoASPM";
            flake = false;
        };
        # For secrets management.
        #agenix = {
        #    url = "github:ryantm/agenix";
        #    inputs.nixpkgs.follows = "nixpkgs";
        #};
        # For Macs.
        nix-darwin = {
            url = "github:LnL7/nix-darwin/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # For all home users on client devices.
        home-manager = {
            url = "github:nix-community/home-manager/master";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        # For my gaming system. Not used until NVIDIA + GS support improves or I move to AMD.
        #jovian = {
        #    url = "github:Jovian-Experiments/Jovian-NixOS";
        #    inputs.nixpkgs.follows = "nixpkgs";
        #};
    };

    outputs = 
        {
            self,
            nixpkgs,
            nix-darwin,
            home-manager,
            #agenix,
            ...
        } @inputs: 
        let
            modules = import ./modules/default.nix { inherit (nixpkgs) lib; };
        in 
        {
            # darwinConfigurations {};
            nixosConfigurations = {
                ryzen = nixpkgs.lib.nixosSystem {
                    system = "x86_64-linux";
                    modules = [
                        #./disko/ext4-root
                        ./hosts/ryzen/configuration.nix
                        #agenix.nixosModules.default
                    ];
                };
            };
        };
}
