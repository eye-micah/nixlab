import os
import subprocess
import time


def run_command(command, check=True):
    """Run a shell command."""
    try:
        result = subprocess.run(command, check=check, text=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {' '.join(command)}")
        print(f"Error message: {e.stderr.strip()}")
        if check:
            exit(1)
        return None


def is_mounted(path):
    """Check if a path is mounted."""
    mounts = run_command(["mount"], check=False)
    return path in mounts


def zpool_exists(name):
    """Check if a ZFS pool exists."""
    result = run_command(["zpool", "list", name], check=False)
    return result is not None


def zfs_dataset_exists(name):
    """Check if a ZFS dataset exists."""
    result = run_command(["zfs", "list", name], check=False)
    return result is not None


def ensure_unmounted(mount_point):
    """Ensure a mount point is unmounted."""
    if is_mounted(mount_point):
        print(f"Unmounting {mount_point}...")
        run_command(["umount", "-R", mount_point], check=False)
    else:
        print(f"{mount_point} is not mounted, skipping unmount.")


def ensure_zpool_exported(pool_name):
    """Ensure a ZFS pool is exported."""
    if zpool_exists(pool_name):
        print(f"Exporting ZFS pool {pool_name}...")
        run_command(["zpool", "export", pool_name], check=False)
    else:
        print(f"ZFS pool {pool_name} does not exist, skipping export.")


def ensure_device_wiped(device):
    """Wipe a device using sgdisk."""
    print(f"Wiping {device} using sgdisk...")
    run_command(["sgdisk", "--zap-all", device])


def ensure_partition_table(device):
    """Ensure the device has the correct partition table."""
    print(f"Partitioning {device}...")
    run_command([
        "parted", "--script", device,
        "mklabel", "gpt",
        "mkpart", "ESP", "fat32", "1MiB", "512MiB",
        "set", "1", "boot", "on",
        "set", "1", "esp", "on",
        "mkpart", "primary", "512MiB", "100%"
    ])
    print("Forcing partition table reload...")
    run_command(["partprobe", device])
    time.sleep(5)  # Allow time for kernel to process changes


def ensure_formatted_esp(device):
    """Format the ESP partition."""
    esp_part = f"{device}-part1"
    print(f"Formatting ESP partition {esp_part}...")
    run_command(["mkfs.vfat", "-F", "32", "-n", "NIXESP", esp_part])


def ensure_zpool_created(device):
    """Ensure the ZFS pool is created."""
    zfs_part = f"{device}-part2"
    if zpool_exists("zroot"):
        print("ZFS pool zroot already exists, skipping creation.")
        return
    print("Creating ZFS pool zroot...")
    run_command([
        "zpool", "create", "-f",
        "-O", "compression=zstd",
        "-O", "com.sun:auto-snapshot=false",
        "-O", "mountpoint=none",
        "-o", "cachefile=none",
        "zroot", zfs_part
    ])


def ensure_zfs_datasets():
    """Ensure the required ZFS datasets exist."""
    datasets = {
        "zroot/root": ["-o", "com.sun:auto-snapshot=false", "-o", "mountpoint=legacy"],
        "zroot/nix": ["-o", "com.sun:auto-snapshot=false", "-o", "mountpoint=legacy"],
        "zroot/home": ["-o", "com.sun:auto-snapshot=true", "-o", "mountpoint=legacy"],
        "zroot/lab": ["-o", "com.sun:auto-snapshot=false", "-o", "mountpoint=legacy"]
    }
    for name, properties in datasets.items():
        if zfs_dataset_exists(name):
            print(f"ZFS dataset {name} already exists, skipping creation.")
        else:
            print(f"Creating ZFS dataset {name}...")
            run_command(["zfs", "create"] + properties + [name])


def main(device):
    # Unmount filesystems if necessary
    mount_points = ["/mnt", "/mnt/nix", "/mnt/boot", "/mnt/home"]
    for mount_point in mount_points:
        ensure_unmounted(mount_point)

    # Export ZFS pool if it exists
    ensure_zpool_exported("zroot")

    # Ensure the device is wiped
    ensure_device_wiped(device)

    # Ensure the partition table is correct
    ensure_partition_table(device)

    # Ensure the ESP partition is formatted
    ensure_formatted_esp(device)

    # Ensure the ZFS pool is created
    ensure_zpool_created(device)

    # Ensure the ZFS datasets are created
    ensure_zfs_datasets()

    print("Disk and ZFS setup complete!")


if __name__ == "__main__":
    if len(os.sys.argv) < 2:
        print("Usage: python partition_zfs_root.py <device>")
        os.sys.exit(1)
    device = os.sys.argv[1]
    main(device)

