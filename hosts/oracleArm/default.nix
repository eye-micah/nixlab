{ lib, ... }: 
{
  imports = [
    ./services
	./generated/configuration.nix
    ./generated/hardware-configuration.nix
  ];

	boot.tmp.cleanOnBoot = lib.mkDefault true;
	zramSwap.enable = lib.mkDefault true;
	networking.hostName = lib.mkDefault "oracleArmInstance";
	networking.domain = lib.mkDefault "";
	services.openssh.enable = lib.mkDefault true;
	users.users.root.openssh.authorizedKeys.keys = lib.mkDefault [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC micah@haruka.tail8d76a.ts.net'' ];
	system.stateVersion = "23.11";
	networking.hostId = lib.mkDefault "7f4a3c1d";
	boot.loader.grub.configurationLimit = lib.mkDefault 1;
	boot.loader.grub.zfsSupport = lib.mkDefault false;
    boot.loader.efi.canTouchEfiVariables = false;
    fileSystems."/boot" = lib.mkDefault { device = "/dev/disk/by-uuid/A552-E981"; fsType = "vfat"; };
    boot.initrd.availableKernelModules = lib.mkDefault [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
    boot.initrd.kernelModules = lib.mkDefault [ "nvme" ];
    fileSystems."/" = lib.mkDefault { device = "/dev/sda1"; fsType = "ext4"; };
	nix.settings.max-jobs = 2;
	nix.settings.cores = 1;
}
