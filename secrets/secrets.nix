let
  haruka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC";
  nanba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU5dkBeErUxK+KyjIrlzUiSqIimz9q7Oz7RV8JZjIru";
  saeko = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEL80C82PvpfW8Ocj6Rn9vQhOnJZ6X3aZDxXwm1PYlgy";
  shinada = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA9Ws20xFLbgiHH9ZQPOPD4ioefE28BfYfXBDWcuNa82";
in
{
  "tailscaleNanba.age".publicKeys = [ haruka nanba ];
  "tailscaleSaeko.age".publicKeys = [ haruka saeko ];
  "tailscaleShinada.age".publicKeys = [ haruka shinada ];
  "gmailPassword.age".publicKeys = [ haruka saeko nanba ];
  "gmailAddress.age".publicKeys = [ haruka saeko nanba ];
  "rsyncKaitoKeyId.age".publicKeys = [ haruka ];
  "rsyncKaitoAppKey.age".publicKeys = [ haruka ];
  "resticEnv.age".publicKeys = [ haruka saeko ];
  "resticRepo.age".publicKeys = [ haruka saeko ];
  "resticPassword.age".publicKeys = [ haruka saeko ];
  "cloudflareToken.age".publicKeys = [ haruka saeko ];
  "nextcloudPass.age".publicKeys = [ haruka saeko ];
  "wgConf.age".publicKeys = [ haruka saeko ];
}
