# **[ZFS - zfs](https://documentation.ubuntu.com/lxd/stable-5.0/reference/storage_zfs/)**

▶
Watch on YouTube
ZFS combines both physical volume management and a file system. A ZFS installation can span across a series of storage devices and is very scalable, allowing you to add disks to expand the available space in the storage pool immediately.

ZFS is a block-based file system that protects against data corruption by using checksums to verify, confirm and correct every operation. To run at a sufficient speed, this mechanism requires a powerful environment with a lot of RAM.

In addition, ZFS offers snapshots and replication, RAID management, copy-on-write clones, compression and other features.

To use ZFS, make sure you have zfsutils-linux installed on your machine.

## Terminology

ZFS creates logical units based on physical storage devices. These logical units are called ZFS pools or zpools. Each zpool is then divided into a number of datasets. These datasets can be of different types:

A ZFS filesystem can be seen as a partition or a mounted file system.

A ZFS volume represents a block device.

A ZFS snapshot captures a specific state of either a ZFS filesystem or a ZFS volume. ZFS snapshots are read-only.

A ZFS clone is a writable copy of a ZFS snapshot.

zfs driver in LXD
The zfs driver in LXD uses ZFS filesystems and ZFS volumes for images and custom storage volumes, and ZFS snapshots and clones to create instances from images and for instance and custom volume snapshots. By default, LXD enables compression when creating a ZFS pool.

LXD assumes that it has full control over the ZFS pool and dataset. Therefore, you should never maintain any datasets or file system entities that are not owned by LXD in a ZFS pool or dataset, because LXD might delete them.

Due to the way copy-on-write works in ZFS, parent ZFS filesystems can’t be removed until all children are gone. As a result, LXD automatically renames any objects that are removed but still referenced. Such objects are kept at a random deleted/ path until all references are gone and the object can safely be removed. Note that this method might have ramifications for restoring snapshots. See Limitations below.

LXD automatically enables trimming support on all newly created pools on ZFS 0.8 or later. This increases the lifetime of SSDs by allowing better block re-use by the controller, and it also allows to free space on the root file system when using a loop-backed ZFS pool. If you are running a ZFS version earlier than 0.8 and want to enable trimming, upgrade to at least version 0.8. Then use the following commands to make sure that trimming is automatically enabled for the ZFS pool in the future and trim all currently unused space:

```bash
zpool upgrade ZPOOL-NAME
zpool set autotrim=on ZPOOL-NAME
zpool trim ZPOOL-NAME
```

## Limitations

The zfs driver has the following limitations:

Restoring from older snapshots
ZFS doesn’t support restoring from snapshots other than the latest one. You can, however, create new instances from older snapshots. This method makes it possible to confirm whether a specific snapshot contains what you need. After determining the correct snapshot, you can remove the newer snapshots so that the snapshot you need is the latest one and you can restore it.

Alternatively, you can configure LXD to automatically discard the newer snapshots during restore. To do so, set the zfs.remove_snapshots configuration for the volume (or the corresponding volume.zfs.remove_snapshots configuration on the storage pool for all volumes in the pool).

Note, however, that if zfs.clone_copy is set to true, instance copies use ZFS snapshots too. In that case, you cannot restore an instance to a snapshot taken before the last copy without having to also delete all its descendants. If this is not an option, you can copy the wanted snapshot into a new instance and then delete the old instance. You will, however, lose any other snapshots the instance might have had.

Observing I/O quotas
I/O quotas are unlikely to affect ZFS filesystems very much. That’s because ZFS is a port of a Solaris module (using SPL) and not a native Linux file system using the Linux VFS API, which is where I/O limits are applied.

Feature support in ZFS
Some features, like the use of idmaps or delegation of a ZFS dataset, require ZFS 2.2 or higher and are therefore not widely available yet.

## Quotas

ZFS provides two different quota properties: quota and refquota. quota restricts the total size of a dataset, including its snapshots and clones. refquota restricts only the size of the data in the dataset, not its snapshots and clones.

By default, LXD uses the quota property when you set up a quota for your storage volume. If you want to use the refquota property instead, set the zfs.use_refquota configuration for the volume (or the corresponding volume.zfs.use_refquota configuration on the storage pool for all volumes in the pool).

You can also set the zfs.use_reserve_space (or volume.zfs.use_reserve_space) configuration to use ZFS reservation or refreservation along with quota or refquota.

## Configuration options

The following configuration options are available for storage pools that use the zfs driver and for storage volumes in these pools.

Storage pool configuration

| Key            | Type   | Default                                               | Description                                                                                                                   |
|----------------|--------|-------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------|
| size           | string | auto (20% of free disk space, >= 5 GiB and <= 30 GiB) | Size of the storage pool when creating loop-based pools (in bytes, suffixes supported, can be increased to grow storage pool) |
| source         | string | -                                                     | Path to an existing block device, loop file or ZFS dataset/pool                                                               |
| source.wipe    | bool   | false                                                 | Wipe the block device specified in source prior to creating the storage pool                                                  |
| zfs.clone_copy | string | true                                                  | Whether to use ZFS lightweight clones rather than full dataset copies (Boolean), or rebase to copy based on the initial image |
| zfs.export     | bool   | true                                                  | Disable zpool export while unmount performed                                                                                  |
| zfs.pool_name  | string | name of the pool                                      | Name of the zpool                                                                                                             |
