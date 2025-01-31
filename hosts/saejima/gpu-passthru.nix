let
  # RTX 4070 Super
  gpuIDs = [
    "10de:18ca" # gfx
    #"" # audio
  ];

in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "configure machine for vfio";

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        "vfio_virqfd"

        "nvidia"
        "nvidia-modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      kernelParams = [
        "intel_iommu=on"
      ] ++ lib.optional cfg.enable
        # isolate GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
    };

    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "micah" ];
    virtualisation.libvirtd.enable = true;
    
    hardware.opengl.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };

}
