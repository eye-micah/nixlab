let
    zfsSolidStatePool = "storage-ssd";
in
{
    localDomain = "local.zandyne.xyz";
    dockerPersist =  "/var/lib/docker/volumes";
    moviesDir =  "/mnt/${zfsSolidStatePool}/movies";
    tvDir =  "/mnt/${zfsSolidStatePool}/tv";
}
