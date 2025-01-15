{ ... }: 
{
  imports = [
    ./services
    ./hardware-configuration.nix
  ];

	boot.tmp.cleanOnBoot = true;
	zramSwap.enable = true;
	networking.hostName = "instance-20250115-1216";
	networking.domain = "";
	services.openssh.enable = true;
	users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC micah@haruka.tail8d76a.ts.net'' ];
	system.stateVersion = "23.11";

}
