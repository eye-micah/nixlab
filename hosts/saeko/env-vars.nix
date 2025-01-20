let
    zfsSolidStatePool = "storage-ssd";
in
{
    dockerPersist =  "/var/lib/docker/volumes";
    moviesDir =  lib.mkDefault "/mnt/${zfsSolidStatePool}/movies";
    tvDir =  lib.mkDefault "/mnt/${zfsSolidStatePool}/tv";
}
