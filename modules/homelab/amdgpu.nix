{ lib, ... }: {

with lib;

let
  configOptions = {
    lab.amdgpu = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enable amdgpu config
            '';
          };
        };
      });
      default = { enable = false; };
      description = ''
        Option to enable basic amdgpu config.
      '';
    };
in

{
    options = configOptions;

    config = mkIf config.lab.amdgpu.enable {
      boot.initrd.kernelModules = [ "amdgpu" ];
      hardware.graphics.enable = true;
    };
}
