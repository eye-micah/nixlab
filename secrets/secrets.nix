let
  haruka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC";
  nanba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILU5dkBeErUxK+KyjIrlzUiSqIimz9q7Oz7RV8JZjIru";
in
{
  "tailscaleNanba.age".publicKeys = [ haruka nanba ];
  "tailscaleSaeko.age".publicKeys = [ haruka ];
  "rsyncKaitoKeyId.age".publicKeys = [ haruka ];
  "rsyncKaitoAppKey.age".publicKeys = [ haruka ];
  "resticEnv.age".publicKeys = [ haruka ];
  "resticRepo.age".publicKeys = [ haruka ];
  "resticPassword.age".publicKeys = [ haruka ];
}
