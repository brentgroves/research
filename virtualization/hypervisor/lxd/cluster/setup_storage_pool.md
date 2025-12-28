# **[Create a storage pool in a cluster](https://documentation.ubuntu.com/lxd/latest/howto/storage_pools/)**

If you are running a LXD cluster and want to add a storage pool, you must create the storage pool for each cluster member separately. The reason for this is that the configuration, for example, the storage location or the size of the pool, might be different between cluster members.

To create a storage pool via the CLI, start by creating a pending storage pool on each member with the --target=<cluster_member> flag and the appropriate configuration for the member.

Make sure to use the same storage pool name for all members. Then create the storage pool without specifying the --target flag to actually set it up.

Also see How to configure storage for a cluster.

Note

For most storage drivers, the storage pools exist locally on each cluster member. That means that if you create a storage volume in a storage pool on one member, it will not be available on other cluster members.

This behavior is different for Ceph-based storage pools (ceph, cephfs and cephobject) where each storage pool exists in one central location and therefore, all cluster members access the same storage pool with the same storage volumes.

Examples

See the following examples for different storage drivers for instructions on how to create local or remote storage pools in a cluster.

Create a local storage pool

Create a storage pool named my-pool using the ZFS driver at different locations and with different sizes on three cluster members:

```bash
~$lxc storage create my-pool zfs source=/dev/sdX size=10GiB --target=vm01
Storage pool my-pool pending on member vm01
~$lxc storage create my-pool zfs source=/dev/sdX size=15GiB --target=vm02
Storage pool my-pool pending on member vm02
~$lxc storage create my-pool zfs source=/dev/sdY size=10GiB --target=vm03
Storage pool my-pool pending on member vm03
~$lxc storage create my-pool zfs
Storage pool my-pool created
```
