let
  haruka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC";
  nanba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIRcmH2DmzMa8eYswUll6q9SJRGU2fDY32hG6yW71v6C";
in
{
  "tailscaleNanba.age".publicKeys = [ haruka nanba ];
  "tailscaleSaeko.age".publicKeys = [ haruka ];
}
