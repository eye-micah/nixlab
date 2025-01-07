{ config, pkgs, lib, ... }:

{
    dockerPersist = "/mnt/persist/docker";
    moviesDir = "/mnt/${zfsSolidStatePool}/movies";
    tvDir = "/mnt/${zfsSolidStatePool}/tv";
}
