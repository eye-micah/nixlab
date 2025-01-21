{ ... }: {

  # Mount points for NFS shares
  fileSystems."/mnt/workspace" = {
    device = "192.168.1.246:/mnt/storage-ssd/editing-workspace";
    fsType = "nfs";
    options = [
      "rw"  # Read-Write mount
      "hard"  # Retries on failure
      "intr"  # Allow interrupts in case of failure
      "noatime"  # Skip updating access times, optimizing sequential reads
      "rsize=1048576"  # Larger read buffer size for improved sequential read performance
      "wsize=1048576"  # Larger write buffer size
      "timeo=14"  # Timeout value for NFS requests
      "retrans=2"  # Retransmissions on failure
    ];
  };

  fileSystems."/mnt/finished" = {
    device = "192.168.1.246:/mnt/storage-ssd/editing-finished";
    fsType = "nfs";
    options = [
      "rw"  # Read-Write mount
      "hard"  # Retries on failure
      "intr"  # Allow interrupts in case of failure
      "noatime"  # Skip updating access times, optimizing sequential reads
      "rsize=1048576"  # Larger read buffer size for improved sequential read performance
      "wsize=1048576"  # Larger write buffer size
      "timeo=14"  # Timeout value for NFS requests
      "retrans=2"  # Retransmissions on failure
    ];
  };
  
  fileSystems."/mnt/games" = {
    device = "192.168.1.246:/mnt/storage-ssd/games";
    fsType = "nfs";
    options = [
      "rw"  # Read-Write mount
      "hard"  # Retries on failure
      "intr"  # Allow interrupts in case of failure
      "noatime"  # Skip updating access times, optimizing sequential reads
      "rsize=1048576"  # Larger read buffer size for improved sequential read performance
      "wsize=1048576"  # Larger write buffer size
      "timeo=14"  # Timeout value for NFS requests
      "retrans=2"  # Retransmissions on failure
    ];
  };

}
