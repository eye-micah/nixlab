let
    zfsSolidStatePool = "storage-ssd";
in
{
    dockerPersist =  "/mnt/persist/docker";
    moviesDir =  "/mnt/${zfsSolidStatePool}/movies";
    tvDir =  "/mnt/${zfsSolidStatePool}/tv";
}
