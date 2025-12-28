# **[](https://docs.docker.com/engine/storage/drivers/btrfs-driver/)**

BTRFS storage driver
Page options
Important
In most cases you should use the overlay2 storage driver - it's not required to use the btrfs storage driver simply because your system uses Btrfs as its root filesystem.

Btrfs driver has known issues. See Moby issue #27653 for more information.

Btrfs is a copy-on-write filesystem that supports many advanced storage technologies, making it a good fit for Docker. Btrfs is included in the mainline Linux kernel.

Docker's btrfs storage driver leverages many Btrfs features for image and container management. Among these features are block-level operations, thin provisioning, copy-on-write snapshots, and ease of administration. You can combine multiple physical block devices into a single Btrfs filesystem.

This page refers to Docker's Btrfs storage driver as btrfs and the overall Btrfs Filesystem as Btrfs.

Note
The btrfs storage driver is only supported with Docker Engine CE on SLES, Ubuntu, and Debian systems.
