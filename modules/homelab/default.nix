{ lib, config, ... }: with lib; 

  let
    configOptions = {
      localDomain = mkOption {
        type = types.str;
        default = "lan.zandyne.xyz";
        description = "The local domain used for internal reverse proxies";
      };
    };

  in
    {
      options = configOptions;
      imports = [
        ./amdgpu.nix
        ./jellyfin.nix
      ];
    }





  

