{ config, lib, pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  environment.systemPackages = with pkgs; [
    #cudaPackages_12_2.cudatoolkit
    gwe
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; # nixos says these two settings are experimental -- we'll see?
    powerManagement.finegrained = false;
    open = true; 
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    #package = config.boot.kernelPackages.nvidiaPackages.legacy_470; # Maybe this will fix suspend?
  };

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
}
