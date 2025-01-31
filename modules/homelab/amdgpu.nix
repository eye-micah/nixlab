{ lib, config, ... }: 
let cfg = config.homelab.amdgpu; in {

    options = {
      homelab.amdgpu.enable = lib.mkEnableOption "Enable amdgpu config";
    };

    config = lib.mkIf cfg.enable {
      boot.initrd.kernelModules = [ "amdgpu" ];
      hardware.graphics.enable = true;
    };
}
