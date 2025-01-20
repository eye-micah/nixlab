let zfsSolidStatePool = "storage-ssd";
in {
    dockerPersist =  "/cvol";
    moviesDir =  "/mnt/${zfsSolidStatePool}/movies";
    tvDir =  "/mnt/${zfsSolidStatePool}/tv";
}
