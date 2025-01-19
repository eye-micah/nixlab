{ pkgs, ... }: {

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

  environment.systemPackages = [

	pkgs.gutenprint # — Drivers for many different printers from many different vendors.
	pkgs.gutenprintBin # — Additional, binary-only drivers for some printers.
	pkgs.hplip # — Drivers for HP printers.
	pkgs.hplipWithPlugin # — Drivers for HP printers, with the proprietary plugin. Use NIXPKGS_ALLOW_UNFREE=1 nix-shell -p hplipWithPlugin --run 'sudo -E hp-setup' to add the printer, regular CUPS UI doesn't seem to work.
	pkgs.postscript-lexmark # — Postscript drivers for Lexmark
	pkgs.samsung-unified-linux-driver # — Proprietary Samsung Drivers
	pkgs.splix # — Drivers for printers supporting SPL (Samsung Printer Language).
	pkgs.brlaser # — Drivers for some Brother printers
	pkgs.brgenml1lpr #  — Generic drivers for more Brother printers [1]
	pkgs.brgenml1cupswrapper  # — Generic drivers for more Brother printers [1]
	pkgs.cnijfilter2 # — Drivers for some Canon Pixma devices (Proprietary driver)

  ];

  
  systemd.services.cups-browsed.enable = true;

  services.printing = {
    listenAddresses = [ "*:631" ];
    browsed.enable = true;
    allowFrom = [ "all" ];
    browsing = true;
    defaultShared = true;
    openFirewall = true;
    
    browsedConf = ''
      BrowseDNSSDSubTypes _cups,_print
      BrowseLocalProtocols all
      BrowseRemoteProtocols all
      CreateIPPPrinterQueues All
      BrowseProtocols all
    '';
  };


}
