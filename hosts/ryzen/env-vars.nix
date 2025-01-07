{ config, pkgs, lib, ... }:

{
    dockerPersist = lib.mkDefault "/mnt/persist/docker";
    moviesDir = lib.mkDefault "/mnt/${zfsSolidStatePool}/movies";
    tvDir = lib.mkDefault "/mnt/${zfsSolidStatePool}/tv";
}
