{
  description = "Devshell for partitioning shit";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs-unstable";

  outputs = { self, nixpkgs }: {
    devShells.default = nixpkgs.lib.mkDevShell {
      packages = with nixpkgs.pkgs; [
        python3
        python3Packages.pip
        parted
        util-linux
        dosfstools
        zfs
      ];

      defaultApp = {
        type = "app"
        program = "python3";
        args = [ "./partition_zfs_root.py" ];
      };

    };
  };
}
