let
  haruka = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHFQy6Jw3QC3ADSbNdRZZSTZMOwB7o/+SQatG4Er2gtC";
  users = [ haruka ];

in
{
  "cloudflare.age".publicKeys = [ haruka ];
  "tailscale.age".publicKeys = users;
}
