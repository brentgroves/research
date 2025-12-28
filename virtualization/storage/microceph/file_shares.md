# **[](https://canonical-microceph.readthedocs-hosted.com/stable/how-to/mount-cephfs-share/)**

## references

- **[Windows File Sharing and Ceph Clustering - Both Made Simple with Cockpit (Houston) File Explorer and File Sharing Modules](https://www.reddit.com/r/DataHoarder/comments/oyhlb4/windows_file_sharing_and_ceph_clustering_both/)**
- **[Tuesday Tech Tip - Ceph Clustering Simplified Using Houston's Navigator & File Sharing Modules](https://www.youtube.com/watch?v=Z6rtOyaJZD4)**
- **[File System Shares Over SMB](https://docs.ceph.com/en/latest/mgr/smb/)**

## Mount MicroCeph backed CephFs shares

CephFs (Ceph Filesystem) are filesystem shares backed by the Ceph storage cluster. This tutorial will guide you with mounting CephFs shares using MicroCeph.

The above will be achieved by creating an fs on the MicroCeph deployed Ceph cluster, and then mounting it using the kernel driver.

## MicroCeph Operations

Check Ceph cluster’s status:

```bash

$ sudo ceph -s
  cluster:
    id:     d2a9147c-e5b7-4848-822b-b10927455163
    health: HEALTH_WARN
            clock skew detected on mon.micro12
 
  services:
    mon: 3 daemons, quorum micro11,micro12,micro13 (age 46h)
    mgr: micro11(active, since 47h), standbys: micro12, micro13
    mds: 1/1 daemons up, 2 standby
    osd: 3 osds: 3 up (since 46h), 3 in (since 46h)
 
  data:
    volumes: 1/1 healthy
    pools:   4 pools, 97 pgs
    objects: 1.06k objects, 2.9 GiB
    usage:   11 GiB used, 5.4 TiB / 5.5 TiB avail
    pgs:     97 active+clean
 
  io:
    client:   0 B/s rd, 20 KiB/s wr, 4 op/s rd, 4 op/s wr
```

## configured timesyncd

ceph still says micro2 time is skewed for a few minutes.

```bash
ceph -s
  cluster:
    id:     d2a9147c-e5b7-4848-822b-b10927455163
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum micro11,micro12,micro13 (age 47h)
    mgr: micro11(active, since 47h), standbys: micro12, micro13
    mds: 1/1 daemons up, 2 standby
    osd: 3 osds: 3 up (since 47h), 3 in (since 47h)
 
  data:
    volumes: 1/1 healthy
    pools:   4 pools, 97 pgs
    objects: 1.06k objects, 2.9 GiB
    usage:   11 GiB used, 5.4 TiB / 5.5 TiB avail
    pgs:     97 active+clean
```

Create data/metadata pools for CephFs:

```bash
# microcloud init created the metadata and data pools for me.
sudo ceph fs ls
name: lxd_cephfs, metadata pool: lxd_cephfs_meta, data pools: [lxd_cephfs_data ]
# didn't need to do this.
$ sudo ceph osd pool create cephfs_meta
$ sudo ceph osd pool create cephfs_data
```

Create CephFs share:

```bash
# micrcloud init created a cephfs filesystem.
sudo ceph fs ls
name: lxd_cephfs, metadata pool: lxd_cephfs_meta, data pools: [lxd_cephfs_data ]
# did not need to do this step
$ sudo ceph fs new newFs cephfs_meta cephfs_data
new fs with metadata pool 4 and data pool 3
$ sudo ceph fs ls
name: newFs, metadata pool: cephfs_meta, data pools: [cephfs_data ]
```

## Client Operations

Download ‘ceph-common’ package:

`sudo apt install ceph-common`
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  ibverbs-providers libbabeltrace1 libboost-context1.83.0 libboost-filesystem1.83.0 libboost-iostreams1.83.0 libboost-program-options1.83.0 libboost-thread1.83.0 libboost-url1.83.0
  libcephfs2 libdaxctl1 libgoogle-perftools4t64 libibverbs1 liblua5.4-0 libndctl6 liboath0t64 libpmem1 libpmemobj1 librabbitmq4 librados2 libradosstriper1 librbd1 librdmacm1t64
  libtcmalloc-minimal4t64 python3-ceph-argparse python3-ceph-common python3-cephfs python3-prettytable python3-rados python3-rbd python3-wcwidth
Suggested packages:
  ceph ceph-mds
The following NEW packages will be installed:
  ceph-common libbabeltrace1 libboost-context1.83.0 libboost-filesystem1.83.0 libboost-iostreams1.83.0 libboost-program-options1.83.0 libboost-thread1.83.0 libboost-url1.83.0 libcephfs2
  libdaxctl1 libgoogle-perftools4t64 liblua5.4-0 libndctl6 liboath0t64 libpmem1 libpmemobj1 librabbitmq4 librados2 libradosstriper1 librbd1 librdmacm1t64 libtcmalloc-minimal4t64
  python3-ceph-argparse python3-ceph-common python3-cephfs python3-prettytable python3-rados python3-rbd python3-wcwidth
The following packages will be upgraded:
  ibverbs-providers libibverbs1
2 upgraded, 29 newly installed, 0 to remove and 86 not upgraded.
Need to get 38.2 MB of archives.
After this operation, 155 MB of additional disk space will be used.
Do you want to continue? [Y/n]

This step is required for mount.ceph i.e. making mount aware of ceph device type.

Fetch the ceph.conf and ceph.keyring file :

Ideally, a keyring file for any Cephx user which has access to CephFs will work. For the sake of simplicity, we are using admin keys in this example.

```bash
ls /var/snap/microceph/current/conf
ceph.client.admin.keyring  ceph.conf  ceph.keyring  metadata.yaml
```

The files are located at the paths shown above on any MicroCeph node. The kernel driver, by-default looks into /etc/ceph so we will create symbolic links to that folder.

## AI: can we create a file symbolic link to a file in a folder that does not exist

```bash
ln -s /var/snap/microceph/current/conf/ceph.keyring /etc/ceph/ceph.keyring
ln: failed to create symbolic link '/etc/ceph/ceph.keyring': No such file or directory
mkdir /etc/ceph
```

```bash
sudo ln -s /var/snap/microceph/current/conf/ceph.keyring /etc/ceph/ceph.keyring
sudo ln -s /var/snap/microceph/current/conf/ceph.conf /etc/ceph/ceph.conf
ll /etc/ceph/
```

Mount the filesystem:

```bash
$ sudo mkdir /mnt/mycephfs
# $ sudo mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=newFs
sudo mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=lxd_cephfs
# or
sudo mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=indFs
ls /mnt/mycephfs/
custom  custom-snapshots
```

Here, we provide the Cephx user (admin in our example) and the fs created earlier (newFs).

With this, you now have a CephFs mounted at /mnt/mycephfs on your client machine that you can perform IO to.

## Perform IO and observe the ceph cluster

Write a file:

```bash
ls /mnt/mycephfs
custom  custom-snapshots
$ cd /mnt/mycephfs
$ sudo dd if=/dev/zero of=random.img count=1 bs=50M
52428800 bytes (52 MB, 50 MiB) copied, 0.0491968 s, 1.1 GB/s

$ ll
...
-rw-r--r-- 1 root root 52428800 Jun 25 16:04 random.img
```

## AI: can i use ceph cli from host that is not in the ceph cluster

Yes, you can use the Ceph CLI from a host that is not part of the Ceph cluster. You'll need to install the ceph-common package and configure it with the necessary credentials (keyring) and configuration file to interact with the cluster

Here's a breakdown:

1. Install ceph-common:
On the non-cluster host, install the ceph-common package, which includes the Ceph CLI tools (like ceph, rbd, etc.).
For example, on Debian/Ubuntu: sudo apt update && sudo apt install ceph-common
And on Red Hat/CentOS: sudo yum install ceph-common
