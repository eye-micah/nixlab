{ inputs, config, pkgs, lib, ... }:
let
  auto-aspm = pkgs.writeScriptBin "auto-aspm" (builtins.readFile "${inputs.auto-aspm}/autoaspm.py");
in
{
  environment.systemPackages = [
    auto-aspm
    pkgs.python312Full
  ];

  systemd.services.auto-aspm = {
    description ="activate ASPM on supported devices - thank you wolfgang's channel";
    wantedBy = [ "multi-user.target" ];
    path = [
      pkgs.python312Full
      pkgs.which
      pkgs.pciutils
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe pkgs.python312Full} ${lib.getExe auto-aspm}";
    };
  };

}
