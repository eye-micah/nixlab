let
  haruka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC";
  nanba = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJxtdbmFvZUWxlJ2Wezvr3t8rFvAGIWtfHJcScgmOQGp";
in
{
  "tailscaleNanba.age".publicKeys = [ haruka nanba ];
  "tailscaleSaeko.age".publicKeys = [ haruka ];
}
