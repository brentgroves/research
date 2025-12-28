# **[](https://docs.docker.com/engine/storage/drivers/zfs-driver/)**

ZFS storage driver
Page options
ZFS is a next generation filesystem that supports many advanced storage technologies such as volume management, snapshots, checksumming, compression and deduplication, replication and more.

It was created by Sun Microsystems (now Oracle Corporation) and is open sourced under the CDDL license. Due to licensing incompatibilities between the CDDL and GPL, ZFS cannot be shipped as part of the mainline Linux kernel. However, the ZFS On Linux (ZoL) project provides an out-of-tree kernel module and userspace tools which can be installed separately.

The ZFS on Linux (ZoL) port is healthy and maturing. However, at this point in time it is not recommended to use the zfs Docker storage driver for production use unless you have substantial experience with ZFS on Linux.
