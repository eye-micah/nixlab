{ config, lib, pkgs, ... }:
{

  imports = [
    ./nvidia.nix
  ];

  environment.systemPackages = with pkgs; [
    davinci-resolve
    cudatoolkit
  ];

  fileSystems."/mnt/workspace" = {
    device = "192.168.1.246:/mnt/storage-ssd/editing-workspace";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "async" ];
  };
}
