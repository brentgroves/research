# **[](https://documentation.ubuntu.com/lxd/stable-5.21/explanation/storage/#exp-storage)**

Storage pools, volumes, and buckets
LXD stores its data in storage pools, divided into storage volumes of different content types (like images or instances). You could think of a storage pool as the disk that is used to store data, while storage volumes are different partitions on this disk that are used for specific purposes.

In addition to storage volumes, there are storage buckets, which use the Amazon S3 protocol. Like storage volumes, storage buckets are part of a storage pool.

Storage pools
During initialization, LXD prompts you to create a first storage pool. If required, you can create additional storage pools later (see Create a storage pool).

Each storage pool uses a storage driver. The following storage drivers are supported:

Directory - dir

Btrfs - btrfs

LVM - lvm

ZFS - zfs

Ceph RBD - ceph

CephFS - cephfs

Ceph Object - cephobject

Dell PowerFlex - powerflex

Pure Storage - pure

See the following how-to guides for additional information:

How to manage storage pools

How to create an instance in a specific storage pool

## Create a storage pool in a cluster

If you are running a LXD cluster and want to add a storage pool, you must create the storage pool for each cluster member separately. The reason for this is that the configuration, for example, the storage location or the size of the pool, might be different between cluster members.

To create a storage pool via the CLI, start by creating a pending storage pool on each member with the --target=<cluster_member> flag and the appropriate configuration for the member.

Make sure to use the same storage pool name for all members. Then create the storage pool without specifying the --target flag to actually set it up.

Also see How to configure storage for a cluster.

Note

For most storage drivers, the storage pools exist locally on each cluster member. That means that if you create a storage volume in a storage pool on one member, it will not be available on other cluster members.

This behavior is different for Ceph-based storage pools (ceph, cephfs and cephobject) where each storage pool exists in one central location and therefore, all cluster members access the same storage pool with the same storage volumes.
