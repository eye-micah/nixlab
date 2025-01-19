{ ... }: {
# Set up with msmtp. ZFS Events are sent to my GMail, as well as backups
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      port = 465;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = "login";
      tls_starttls = "off";
    };
    accounts = {
      default = {
        host = "mail.gmail.com";
        passwordeval = config.age.secrets."gmailPassword".path;
        user = config.age.secrets."gmailAddress".path;
        from = config.age.secrets."gmailAddress".path;
      };
    };
  };
}
