# **[](https://documentation.ubuntu.com/lxd/stable-5.21/howto/cluster_config_storage/#cluster-config-storage)**

How to configure storage for a cluster
All members of a cluster must have identical storage pools. The only configuration keys that may differ between pools on different members are source, size, zfs.pool_name, lvm.thinpool_name and lvm.vg_name. See Member configuration for more information.

LXD creates a default local storage pool for each cluster member during initialization.

Creating additional storage pools is a two-step process:

Define and configure the new storage pool across all cluster members. For example, for a cluster that has three members:

lxc storage create --target server1 data zfs source=/dev/vdb1
lxc storage create --target server2 data zfs source=/dev/vdc1
lxc storage create --target server3 data zfs source=/dev/vdb1 size=10GiB
Note

You can pass only the member-specific configuration keys source, size, zfs.pool_name, lvm.thinpool_name and lvm.vg_name. Passing other configuration keys results in an error.

These commands define the storage pool, but they don’t create it. If you run lxc storage list, you can see that the pool is marked as “pending”.

Run the following command to instantiate the storage pool on all cluster members:

lxc storage create data zfs
Note

You can add configuration keys that are not member-specific to this command.

If you missed a cluster member when defining the storage pool, or if a cluster member is down, you get an error.

Also see Create a storage pool in a cluster.

View member-specific pool configuration
Running lxc storage show <pool_name> shows the cluster-wide configuration of the storage pool.

To view the member-specific configuration, use the --target flag. For example:

lxc storage show data --target server2
