# **[](https://documentation.ubuntu.com/microcloud/latest/microcloud/tutorial/get_started/#provide-storage-disks)**

2. Provide storage disks
MicroCloud supports both local and remote storage. For local storage, you need one disk per cluster member. For remote storage with high availability (HA), you need at least three disks that are located across three different cluster members.

In this tutorial, we will set up each of the four cluster members with local storage. We will also set up three of the cluster members with remote storage. In total, we will set up seven disks. It’s possible to add remote storage on the fourth cluster member, if desired. However, it is not required for HA.

Complete the following steps to create the required disks in a LXD storage pool:

## 1. Create a ZFS storage pool called disks

`lxc storage create disks zfs size=100GiB`

Configure the default volume size for the disks pool:

`lxc storage set disks volume.size 10GiB`

Create four disks to use for local storage:

```bash
lxc storage volume create disks local1 --type block
lxc storage volume create disks local2 --type block
lxc storage volume create disks local3 --type block
lxc storage volume create disks local4 --type block
```

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
```

```bash
lxc storage volume list
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
|  POOL  |      TYPE       |                               NAME                               | DESCRIPTION | CONTENT-TYPE | USED BY | LOCATION |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| local  | custom          | backups                                                          |             | filesystem   | 1       | micro11  |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| local  | custom          | backups                                                          |             | filesystem   | 1       | micro12  |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| local  | custom          | backups                                                          |             | filesystem   | 1       | micro13  |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| local  | custom          | images                                                           |             | filesystem   | 1       | micro11  |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| local  | custom          | images                                                           |             | filesystem   | 1       | micro12  |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| local  | custom          | images                                                           |             | filesystem   | 1       | micro13  |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| remote | image           | c89a5fe8efa0a12a59ec3234c17c1bb5524688c66f48b0d7fd616b4c126aba8d |             | block        | 1       |          |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| remote | virtual-machine | open-osprey                                                      |             | block        | 1       |          |
+--------+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
```

```bash
lxc storage volume list remote
+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
|      TYPE       |                               NAME                               | DESCRIPTION | CONTENT-TYPE | USED BY | LOCATION |
+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| image           | c89a5fe8efa0a12a59ec3234c17c1bb5524688c66f48b0d7fd616b4c126aba8d |             | block        | 1       |          |
+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
| virtual-machine | open-osprey                                                      |             | block        | 1       |          |
+-----------------+------------------------------------------------------------------+-------------+--------------+---------+----------+
```

```bash
lxc storage volume show remote virtual-machine/open-osprey
name: open-osprey
description: ""
type: virtual-machine
pool: remote
content_type: block
project: default
location: ""
created_at: 2025-07-15T23:05:12.156025373Z
config:
  block.filesystem: ext4
  block.mount_options: discard
  volatile.uuid: f412b6b1-998f-44c5-8755-5c30d83a0507
used_by:
- /1.0/instances/open-osprey
```
