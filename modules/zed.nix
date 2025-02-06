{ config, pkgs, lib, ... }: 
  let

    age.secrets."gmailPassword" = ../secrets/gmailPassword.age;

    hostName = "${config.networking.hostName}";

    emailAddr = "pdbrohan@gmail.com";

    msmtpAccount = {
      auth = "login";
      tls = "on";
      tls_starttls = "off";
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      host = "smtp.gmail.com";
      port = "465";
      user = "pdbrohan@gmail.com";
      passwordeval = "cat ${config.age.secrets.gmailPassword.path}";
      from = emailAddr;
    };

    sendEmailEvent = { event }: ''
        printf "Subject: ${hostName} ${event} ''$(${pkgs.coreutils}/bin/date --iso-8601=seconds)\n\nzpool status:\n\n''$(${pkgs.zfs}/bin/zpool status)" | ${pkgs.msmtp}/bin/msmtp -a default ${emailAddr}
      '';

    customizeZfs = zfs:
        (zfs.override { enableMail = true; }).overrideAttrs (oldAttrs: {
          patches = oldAttrs.patches ++
            [ (pkgs.fetchpatch {
                name = "notify-on-unavail-events.patch";
                url = "https://github.com/openzfs/zfs/commit/f74604f2f0d76ee55b59f7ed332409fb128ec7e5.patch";
                sha256 = "1v25ydkxxx704j0gdxzrxvw07gfhi7865grcm8b0zgz9kq0w8i8i";
              })
            ];
        });
in {

  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = builtins.toFile "aliases" ''
        default: ${emailAddr}
      '';
    };
    accounts.default = msmtpAccount;
  };

  nixpkgs.config.packageOverrides = pkgs: {
    zfsStable = customizeZfs pkgs.zfsStable;
  };

  boot.supportedFilesystems = [ "zfs" ];

  services.zfs.zed.enableMail = true;
  services.zfs.zed.settings = {
    ZED_EMAIL_ADDR = [ emailAddr ];
    ZED_EMAIL_OPTS = "-a 'FROM:${emailAddr} -s '@SUBJECT@' @ADDRESS@";
    ZED_EMAIL_PROG="${pkgs.msmtp}/bin/msmtp";
    ZED_NOTIFY_VERBOSE = true;
  };

}
