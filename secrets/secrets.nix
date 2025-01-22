let
  haruka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC";
  nanba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU5dkBeErUxK+KyjIrlzUiSqIimz9q7Oz7RV8JZjIru";
  saeko = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEL80C82PvpfW8Ocj6Rn9vQhOnJZ6X3aZDxXwm1PYlgy";
in
{
  "tailscaleNanba.age".publicKeys = [ haruka nanba ];
  "tailscaleSaeko.age".publicKeys = [ haruka saeko ];
  "rsyncKaitoKeyId.age".publicKeys = [ haruka ];
  "rsyncKaitoAppKey.age".publicKeys = [ haruka ];
  "resticEnv.age".publicKeys = [ haruka saeko ];
  "resticRepo.age".publicKeys = [ haruka saeko ];
  "resticPassword.age".publicKeys = [ haruka saeko ];
  "cloudflareToken.age".publicKeys = [ haruka saeko ];
}
