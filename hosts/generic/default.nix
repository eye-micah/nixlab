{ ... }:

{
  
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];

  networking.hostName = "nixos";
  networking.hostId = "41b9e6d9";
  networking.useDHCP = true;

}
