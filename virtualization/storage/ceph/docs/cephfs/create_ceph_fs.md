# **[Create a Ceph file system](https://docs.ceph.com/en/latest/cephfs/createfs/)**

## Creating pools

A Ceph file system requires at least two RADOS pools, one for data and one for metadata. There are important considerations when planning these pools:

- We recommend configuring at least 3 replicas for the metadata pool, as data loss in this pool can render the entire file system inaccessible. Configuring 4 would not be extreme, especially since the metadata pool’s capacity requirements are quite modest.
- We recommend the fastest feasible low-latency storage devices (NVMe, Optane, or at the very least SAS/SATA SSD) for the metadata pool, as this will directly affect the latency of client file system operations.
- We strongly suggest that the CephFS metadata pool be provisioned on dedicated SSD / NVMe OSDs. This ensures that high client workload does not adversely impact metadata operations. See **[Device classes](https://docs.ceph.com/en/latest/rados/operations/crush-map/#device-classes)** to configure pools this way.
- The data pool used to create the file system is the “default” data pool and the location for storing all inode backtrace information, which is used for hard link management and disaster recovery. For this reason, all CephFS inodes have at least one object in the default data pool. If erasure-coded pools are planned for file system data, it is best to configure the default as a replicated pool to improve small-object write and read performance when updating backtraces. Separately, another erasure-coded data pool can be added (see also Erasure code) that can be used on an entire hierarchy of directories and files (see also File layouts).

An inode (short for index node) is a data structure used in Unix-like file systems to store metadata about a file or directory, excluding the file's name and content. It acts as a unique identifier for each file, storing details like file type, permissions, ownership, timestamps, and pointers to where the file's data is stored on disk.

Refer to **[Pools](https://docs.ceph.com/en/latest/rados/operations/pools/)** to learn more about managing pools. For example, to create two pools with default settings for use with a file system, you might run the following commands:

```bash
ceph osd pool create cephfs_data
ceph osd pool create cephfs_metadata
```

The metadata pool will typically hold at most a few gigabytes of data. For this reason, a smaller PG count is usually recommended. 64 or 128 is commonly used in practice for large clusters.

In Ceph, a placement group (PG) is a subset of a pool that holds data objects. The number of PGs (pg_num) in a pool significantly impacts data distribution, rebalancing, and overall cluster performance. A general recommendation is to have between 50 and 100 PGs per Object Storage Daemon (OSD), but this can vary based on cluster size and other factors.

Note

The names of the file systems, metadata pools, and data pools can only have characters in the set [a-zA-Z0-9_-.].

## Creating a file system

Once the pools are created, you may enable the file system using the fs new command:

```bash
# ceph fs new <fs_name> <metadata> <data> [--force] [--allow-dangerous-metadata-overlay] [<fscid:int>] [--recover] [--yes-i-really-really-mean-it] [<set>...]
# ceph fs new newFs cephfs_meta cephfs_data
ceph fs new indFs ind_cephfs_meta ind_cephfs_data

ceph fs ls
name: lxd_cephfs, metadata pool: lxd_cephfs_meta, data pools: [lxd_cephfs_data ]
name: indFs, metadata pool: ind_cephfs_meta, data pools: [ind_cephfs_data ]
```
