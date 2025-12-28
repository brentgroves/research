# AI: how does ceph filesytem relate to lxd storage

How CephFS and LXD storage relate
CephFS (Ceph File System) and LXD storage are related because LXD can leverage CephFS as a storage backend for containers and virtual machines. This allows LXD instances to benefit from CephFS's distributed and highly available nature.
Here's how they connect:
LXD storage drivers: LXD has a cephfs storage driver that allows it to interact with and utilize a CephFS cluster.
Remote storage advantage: Using CephFS as a remote storage solution for LXD in a cluster provides several benefits:
Shared access: All LXD cluster members can access the same storage pools and volumes, eliminating the need for data synchronization between nodes.
High availability: Ceph's distributed nature ensures that data remains available even if some nodes fail.
Scalability: CephFS can scale to accommodate growing storage needs.
CephFS functionality: When configured with the cephfs driver, LXD utilizes CephFS for features like:
Filesystem-based volumes: Providing persistent storage for LXD containers and virtual machines through a POSIX-compliant distributed filesystem.
Snapshots: LXD can create snapshots of CephFS volumes if snapshots are enabled on the Ceph cluster.
CephFS vs. Ceph RBD for LXD: While both can be used for LXD storage, CephFS and Ceph RBD (block device) have different use cases and characteristics within LXD:
CephFS (Driver cephfs): Provides a shared filesystem that can be mounted across multiple LXD instances, allowing multiple containers or VMs to access the same data simultaneously.
Ceph RBD (Driver ceph): Provides block-level storage (like a virtual disk) that is typically mapped to a single LXD instance at a time. LXD uses RBD images with a filesystem on top for images, instances and snapshots.
Important considerations:
Existing Ceph cluster: The LXD cephfs driver requires an existing Ceph cluster to be already set up.
LXD control over CephFS pool: LXD assumes full control over the CephFS OSD storage pool it's configured to use, and it's recommended to avoid managing non-LXD owned filesystem entities within that pool to prevent unintended data loss.
In essence, LXD can integrate with CephFS to provide a powerful and flexible storage solution, especially beneficial for clustered LXD environments where shared and highly available storage is essential.

```bash
ceph osd lspools
1 lxd_remote
2 .mgr
3 lxd_cephfs_meta
4 lxd_cephfs_data

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

```bash
lxc storage info remote-fs
info:
  description: Distributed file-system storage using CephFS
  driver: cephfs
  name: remote-fs
  space used: 0B
  total space: 1.72TiB
used by: {}
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
- micro13
- micro11
- micro12

lxc storage show remote

lxc storage info remote
info:
  description: Distributed storage on Ceph
  driver: ceph
  name: remote
  space used: 8.41GiB
  total space: 1.73TiB
used by:
  images:
  - c89a5fe8efa0a12a59ec3234c17c1bb5524688c66f48b0d7fd616b4c126aba8d
  instances:
  - open-osprey
  profiles:
  - default
```

```bash
ceph -s
  cluster:
    id:     d2a9147c-e5b7-4848-822b-b10927455163
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum micro11,micro12,micro13 (age 2d)
    mgr: micro11(active, since 2d), standbys: micro12, micro13
    mds: 1/1 daemons up, 2 standby
    osd: 3 osds: 3 up (since 2d), 3 in (since 2d)
 
  data:
    volumes: 1/1 healthy
    pools:   4 pools, 97 pgs
    objects: 1.26k objects, 3.2 GiB
    usage:   13 GiB used, 5.4 TiB / 5.5 TiB avail
    pgs:     97 active+clean
```

Check Ceph Status: The most direct way to get an overview of your Ceph cluster (including pools and OSDs) is by running sudo ceph -s. This provides a summary of the cluster health, services running (like monitors, managers, OSDs), and data pools, objects, and usage.
List Ceph Pools: You can list the pools within your Ceph cluster (which MicroCeph manages) using the command: ceph osd pool ls. For example, a newly initialized MicroCeph cluster might have the pool .mgr.
To see more detail, including the pool number, use: ceph osd lspools.

```bash
ceph osd lspools
ceph osd lspools
1 lxd_remote
2 .mgr
3 lxd_cephfs_meta
4 lxd_cephfs_data
```

For even more detailed information about the pools, you can use: ceph osd pool ls detail.

```bash
ceph osd pool ls detail
pool 1 'lxd_remote' replicated size 3 min_size 2 crush_rule 2 object_hash rjenkins pg_num 32 pgp_num 32 autoscale_mode on last_change 45 flags hashpspool,selfmanaged_snaps stripe_width 0 application rbd read_balance_score 1.31
pool 2 '.mgr' replicated size 3 min_size 2 crush_rule 2 object_hash rjenkins pg_num 1 pgp_num 1 autoscale_mode on last_change 37 flags hashpspool stripe_width 0 pg_num_max 32 pg_num_min 1 application mgr read_balance_score 3.00
pool 3 'lxd_cephfs_meta' replicated size 3 min_size 2 crush_rule 2 object_hash rjenkins pg_num 32 pgp_num 32 autoscale_mode on last_change 39 flags hashpspool stripe_width 0 pg_autoscale_bias 4 pg_num_min 16 recovery_priority 5 application cephfs read_balance_score 1.31
pool 4 'lxd_cephfs_data' replicated size 3 min_size 2 crush_rule 2 object_hash rjenkins pg_num 32 pgp_num 32 autoscale_mode on last_change 40 flags hashpspool stripe_width 0 application cephfs read_balance_score 1.03
```
