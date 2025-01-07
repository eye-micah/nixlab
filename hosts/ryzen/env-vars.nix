{ config, pkgs, lib, ... }:

{
    zfsSolidStatePool = "storage-ssd";
    dockerPersist = lib.mkDefault "/mnt/persist/docker";
    moviesDir = lib.mkDefault "/mnt/${zfsSolidStatePool}/movies";
    tvDir = lib.mkDefault "/mnt/${zfsSolidStatePool}/tv";
}
