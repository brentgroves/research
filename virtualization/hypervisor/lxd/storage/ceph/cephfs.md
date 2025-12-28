# **[cephfs](https://documentation.ubuntu.com/lxd/stable-5.0/reference/storage_cephfs/#storage-cephfs)**

CephFS - cephfs
▶
Watch on YouTube
Ceph is an open-source storage platform that stores its data in a storage cluster based on RADOS. It is highly scalable and, as a distributed system without a single point of failure, very reliable.

Tip

If you want to quickly set up a basic Ceph cluster, check out MicroCeph.

Ceph provides different components for block storage and for file systems.

CephFS is Ceph’s file system component that provides a robust, fully-featured POSIX-compliant distributed file system. Internally, it maps files to Ceph objects and stores file metadata (for example, file ownership, directory paths, access permissions) in a separate data pool.

## Terminology

Ceph uses the term object for the data that it stores. The daemon that is responsible for storing and managing data is the Ceph OSD. Ceph’s storage is divided into pools, which are logical partitions for storing objects. They are also referred to as data pools, storage pools or OSD pools.

A CephFS file system consists of two OSD storage pools, one for the actual data and one for the file metadata.

cephfs driver in LXD
Note

The cephfs driver can only be used for custom storage volumes with content type filesystem.

For other storage volumes, use the Ceph driver. That driver can also be used for custom storage volumes with content type filesystem, but it implements them through Ceph RBD images.

Unlike other storage drivers, this driver does not set up the storage system but assumes that you already have a Ceph cluster installed.

You must create the CephFS file system that you want to use beforehand and specify it through the source option.

This driver also behaves differently than other drivers in that it provides remote storage. As a result and depending on the internal network, storage access might be a bit slower than for local storage. On the other hand, using remote storage has big advantages in a cluster setup, because all cluster members have access to the same storage pools with the exact same contents, without the need to synchronize storage pools.

LXD assumes that it has full control over the OSD storage pool. Therefore, you should never maintain any file system entities that are not owned by LXD in a LXD OSD storage pool, because LXD might delete them.

The cephfs driver in LXD supports snapshots if snapshots are enabled on the server side.

## Configuration options

The following configuration options are available for storage pools that use the cephfs driver and for storage volumes in these pools.

Storage pool configuration

| Key                    | Type   | Default | Description                                                   |
|------------------------|--------|---------|---------------------------------------------------------------|
| cephfs.cluster_name    | string | ceph    | Name of the Ceph cluster that contains the CephFS file system |
| cephfs.fscache         | bool   | false   | Enable use of kernel fscache and cachefilesd                  |
| cephfs.path            | string | /       | The base path for the CephFS mount                            |
| cephfs.user.name       | string | admin   | The Ceph user to use                                          |
| source                 | string | -       | Existing CephFS file system or file system path to use        |
| volatile.pool.pristine | string | true    | Whether the CephFS file system was empty on creation time     |
