# **[](https://documentation.ubuntu.com/lxd/stable-5.21/howto/storage_pools/#howto-storage-pools)**

How to manage storage pools
See the following sections for instructions on how to create, configure, view and resize Storage pools.

## Create a storage pool

LXD creates a storage pool during initialization. You can add more storage pools later, using the same driver or different drivers.

To create a storage pool, use the following command:

`lxc storage create <pool_name> <driver> [configuration_options...]`

See the **[Storage drivers](https://documentation.ubuntu.com/lxd/stable-5.21/reference/storage_drivers/#storage-drivers)** documentation for a list of available configuration options for each driver.

By default, LXD sets up loop-based storage with a sensible default size/quota: 20% of the free disk space, with a minimum of 5 GiB and a maximum of 30 GiB.

## Create a storage pool in a cluster

If you are running a LXD cluster and want to add a storage pool, you must create the storage pool for each cluster member separately. The reason for this is that the configuration, for example, the storage location or the size of the pool, might be different between cluster members.

To create a storage pool via the CLI, start by creating a pending storage pool on each member with the --target=<cluster_member> flag and the appropriate configuration for the member.

Make sure to use the same storage pool name for all members. Then create the storage pool without specifying the --target flag to actually set it up.

Also see **[How to configure storage for a cluster](https://documentation.ubuntu.com/lxd/stable-5.21/howto/cluster_config_storage/#cluster-config-storage)**.

Note

For most storage drivers, the storage pools exist locally on each cluster member. That means that if you create a storage volume in a storage pool on one member, it will not be available on other cluster members.

This behavior is different for Ceph-based storage pools (ceph, cephfs and cephobject) where each storage pool exists in one central location and therefore, all cluster members access the same storage pool with the same storage volumes.

Examples

See the following examples for different storage drivers for instructions on how to create local or remote storage pools in a cluster.

## Create a local storage pool

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

## Create a remote storage pool

Create a storage pool named my-remote-pool using the Ceph RBD driver and the on-disk name my-osd on three cluster members. Because the ceph.osd.pool_name configuration setting isn’t member-specific, it must be set when creating the actual storage pool:

```bash
~$lxc storage create my-remote-pool ceph --target=vm01
Storage pool my-remote-pool pending on member vm01
~$lxc storage create my-remote-pool ceph --target=vm02
Storage pool my-remote-pool pending on member vm02
~$lxc storage create my-remote-pool ceph --target=vm03
Storage pool my-remote-pool pending on member vm03
~$lxc storage create my-remote-pool ceph ceph.osd.pool_name=my-osd
Storage pool my-remote-pool created
```

## Configure storage pool settings

See the Storage drivers documentation for the available configuration options for each storage driver.

General keys for a storage pool (like source) are top-level. Driver-specific keys are namespaced by the driver name.

CLIUI
Use the following command to set configuration options for a storage pool:

lxc storage set <pool_name> <key> <value>
For example, to turn off compression during storage pool migration for a dir storage pool, use the following command:

`lxc storage set my-dir-pool rsync.compression false`

## You can also edit the storage pool configuration by using the following command

`lxc storage edit <pool_name>`

## View storage pools

You can display a list of all available storage pools and check their configuration.

Use the following command to list all available storage pools:

`lxc storage list`

```bash
lxc storage list
To start your first container, try: lxc launch ubuntu:24.04
Or for a virtual machine: lxc launch ubuntu:24.04 --vm

+-----------+--------+----------------------------------------------+---------+---------+
|   NAME    | DRIVER |                 DESCRIPTION                  | USED BY |  STATE  |
+-----------+--------+----------------------------------------------+---------+---------+
| local     | zfs    | Local storage on ZFS                         | 6       | CREATED |
+-----------+--------+----------------------------------------------+---------+---------+
| remote    | ceph   | Distributed storage on Ceph                  | 3       | CREATED |
+-----------+--------+----------------------------------------------+---------+---------+
| remote-fs | cephfs | Distributed file-system storage using CephFS | 0       | CREATED |
+-----------+--------+----------------------------------------------+---------+---------+
```

The resulting table contains the storage pool that you created during initialization (usually called default or local) and any storage pools that you added.

To show detailed information about a specific pool, use the following command:

lxc storage show <pool_name>

```bash
lxc storage show remote
name: remote
description: Distributed storage on Ceph
driver: ceph
status: Created
config:
  ceph.cluster_name: ceph
  ceph.osd.pg_num: "32"
  ceph.osd.pool_name: lxd_remote
  ceph.rbd.du: "false"
  ceph.rbd.features: layering,striping,exclusive-lock,object-map,fast-diff,deep-flatten
  ceph.user.name: admin
  volatile.pool.pristine: "true"
used_by:

- /1.0/images/c89a5fe8efa0a12a59ec3234c17c1bb5524688c66f48b0d7fd616b4c126aba8d
- /1.0/instances/open-osprey
- /1.0/profiles/default
locations:
- micro11
- micro12
- micro13

# fs
lxc storage show remote-fs
name: remote-fs
description: Distributed file-system storage using CephFS
driver: cephfs
status: Created
config:
  cephfs.cluster_name: ceph
  cephfs.create_missing: "true"
  cephfs.data_pool: lxd_cephfs_data
  cephfs.meta_pool: lxd_cephfs_meta
  cephfs.osd_pg_num: "32"
  cephfs.path: lxd_cephfs
  cephfs.user.name: admin
used_by: []
locations:
- micro11
- micro12
- micro13
```

To see usage information for a specific pool, run the following command:

lxc storage info <pool_name>

```bash
lxc storage info remote
info:
  description: Distributed storage on Ceph
  driver: ceph
  name: remote
  space used: 6.64GiB
  total space: 1.73TiB
used by:
  images:
  - c89a5fe8efa0a12a59ec3234c17c1bb5524688c66f48b0d7fd616b4c126aba8d
  instances:
  - open-osprey
  profiles:
  - default
  ```

## Resize a storage pool

If you need more storage, you can increase the size (quota) of your storage pool. You can only grow the pool (increase its size), not shrink it.

CLIUI
In the CLI, resize a storage pool by changing the size configuration key:

`lxc storage set <pool_name> size=<new_size>`

This will only work for loop-backed storage pools that are managed by LXD.  
