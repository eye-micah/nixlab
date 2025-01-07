{ config, pkgs, lib, ... }:

let
  zfsSolidStatePool = "storage-ssd";
in
{
  options = {
    zfsSolidStatePool = lib.mkOption {
      type = lib.types.str;
      default = zfsSolidStatePool;
      description = "The name of the ZFS pool.";
    };

    dockerPersist = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/persist/docker";
      description = "Directory for persistent Docker data.";
    };

    moviesDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/${zfsSolidStatePool}/movies";
      description = "Directory where movies are stored.";
    };

    tvDir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/${zfsSolidStatePool}/tv";
      description = "Directory where TV shows are stored.";
    };
  };

  config = {
    # If you want to use these options directly in the config
    # e.g., `config.moviesDir`, etc.
  };
}
