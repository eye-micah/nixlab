{ ... }: {

  # For AMD GPU hosts (mainly just Saeko).

  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.opengl.driSupport = true;
  hardware.opengl.enable = true;


}
