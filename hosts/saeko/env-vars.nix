let
    zfsSolidStatePool = "storage-ssd";
in
{
    dockerPersist =  "/var/lib/docker/volumes";
    moviesDir =  "/mnt/${zfsSolidStatePool}/movies";
    tvDir =  "/mnt/${zfsSolidStatePool}/tv";
}
