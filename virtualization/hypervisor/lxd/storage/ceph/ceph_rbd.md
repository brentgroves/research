# **[Ceph RBD - ceph](https://documentation.ubuntu.com/lxd/stable-5.0/reference/storage_ceph/)

▶
Watch on YouTube
Ceph is an open-source storage platform that stores its data in a storage cluster based on RADOS. It is highly scalable and, as a distributed system without a single point of failure, very reliable.

Tip

If you want to quickly set up a basic Ceph cluster, check out MicroCeph.

Ceph provides different components for block storage and for file systems.

Ceph RBD is Ceph’s block storage component that distributes data and workload across the Ceph cluster. It uses thin provisioning, which means that it is possible to over-commit resources.

## Terminology

Ceph uses the term object for the data that it stores. The daemon that is responsible for storing and managing data is the Ceph OSD. Ceph’s storage is divided into pools, which are logical partitions for storing objects. They are also referred to as data pools, storage pools or OSD pools.

Ceph block devices are also called RBD images, and you can create snapshots and clones of these RBD images.

## ceph driver in LXD

Note

To use the Ceph RBD driver, you must specify it as ceph. This is slightly misleading, because it uses only Ceph RBD (block storage) functionality, not full Ceph functionality. For storage volumes with content type filesystem (images, containers and custom file-system volumes), the ceph driver uses Ceph RBD images with a file system on top (see **[block.filesystem](https://documentation.ubuntu.com/lxd/stable-5.0/reference/storage_ceph/#storage-ceph-vol-config)**).

Alternatively, you can use the CephFS driver to create storage volumes with content type **[filesystem](https://documentation.ubuntu.com/lxd/stable-5.0/reference/storage_cephfs/#storage-cephfs)**.

Unlike other storage drivers, this driver does not set up the storage system but assumes that you already have a Ceph cluster installed.

This driver also behaves differently than other drivers in that it provides remote storage. As a result and depending on the internal network, storage access might be a bit slower than for local storage. On the other hand, using remote storage has big advantages in a cluster setup, because all cluster members have access to the same storage pools with the exact same contents, without the need to synchronize storage pools.

The ceph driver in LXD uses RBD images for images, and snapshots and clones to create instances and snapshots.

LXD assumes that it has full control over the OSD storage pool. Therefore, you should never maintain any file system entities that are not owned by LXD in a LXD OSD storage pool, because LXD might delete them.

Due to the way copy-on-write works in Ceph RBD, parent RBD images can’t be removed until all children are gone. As a result, LXD automatically renames any objects that are removed but still referenced. Such objects are kept with a zombie_ prefix until all references are gone and the object can safely be removed.

Limitations
The ceph driver has the following limitations:

Sharing custom volumes between instances
Custom storage volumes with **[content type](https://documentation.ubuntu.com/lxd/stable-5.0/explanation/storage/#storage-content-types)** filesystem can usually be shared between multiple instances different cluster members. However, because the Ceph RBD driver “simulates” volumes with content type filesystem by putting a file system on top of an RBD image, custom storage volumes can only be assigned to a single instance at a time. If you need to share a custom volume with content type filesystem, use the **[CephFS](https://documentation.ubuntu.com/lxd/stable-5.0/reference/storage_cephfs/#storage-cephfs)** driver instead.
