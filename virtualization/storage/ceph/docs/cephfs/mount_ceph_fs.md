# **[Mount CephFS using Kernel Driver](https://docs.ceph.com/en/latest/cephfs/mount-using-kernel-driver/#mount-cephfs-using-kernel-driver)**

The CephFS kernel driver is part of the Linux kernel. It makes possible the mounting of CephFS as a regular file system with native kernel performance. It is the client of choice for most use-cases.

Note

The CephFS mount device string now uses a new syntax (“v2”). The mount helper is backward compatible with the old syntax. The kernel is backward-compatible with the old syntax. This means that the old syntax can still be used for mounting with newer mount helpers and with the kernel.

## Prerequisites

Complete General Prerequisites
Go through the prerequisites required by both kernel and FUSE mounts, as described on the **[Mount CephFS](https://docs.ceph.com/en/latest/cephfs/mount-prerequisites)**: Prerequisites page.

## Is mount helper present?

The mount.ceph helper is installed by Ceph packages. The helper passes the monitor address(es) and CephX user keyrings, saving the Ceph admin the effort of passing these details explicitly while mounting CephFS. If the helper is not present on the client machine, CephFS can still be mounted using the kernel driver but only by passing these details explicitly to the mount command. To check whether mount.ceph is present on your system, run the following command:

```bash
sudo apt install ceph-common
Setting system user ceph properties..usermod: unlocking the user's password would result in a passwordless account.
You should set a password with usermod -p to unlock this user's password.
..done
chown: cannot access '/var/log/ceph/*.log*': No such file or directory
Created symlink /etc/systemd/system/multi-user.target.wants/ceph.target → /usr/lib/systemd/system/ceph.target.
Created symlink /etc/systemd/system/multi-user.target.wants/rbdmap.service → /usr/lib/systemd/system/rbdmap.service.
Processing triggers for man-db (2.12.0-4build2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.5) ...

This step is required for mount.ceph i.e. making mount aware of ceph device type.

Fetch the ceph.conf and ceph.keyring file :

Ideally, a keyring file for any Cephx user which has access to CephFs will work. For the sake of simplicity, we are using admin keys in this example.

# is it there
stat /sbin/mount.ceph
stat /sbin/mount.ceph
  File: /sbin/mount.ceph
  Size: 285864     Blocks: 560        IO Block: 4096   regular file
Device: 8,2 Inode: 1062302     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2025-07-17 19:08:00.624470754 -0400
Modify: 2025-06-23 22:03:08.000000000 -0400
Change: 2025-07-17 19:04:46.668942025 -0400
 Birth: 2025-07-17 19:04:46.078928210 -0400

ls /etc/ceph/
ceph.client.admin.keyring  ceph.conf  ceph.keyring  metadata.yaml

```

## Which Kernel Version?

Because the kernel client is distributed as part of the Linux kernel (and not as part of the packaged Ceph releases), you will need to consider which kernel version to use on your client nodes. Older kernels are known to include buggy Ceph clients and may not support features that more recent Ceph clusters support.

Remember that the “latest” kernel in a stable Linux distribution is likely to be years behind the latest upstream Linux kernel where Ceph development takes place (including bug fixes).

As a rough guide, as of Ceph 10.x (Jewel), you should be using a least a 4.x kernel. If you absolutely have to use an older kernel, you should use the fuse client instead of the kernel client.

This advice does not apply if you are using a Linux distribution that includes CephFS support. In that case, the distributor is responsible for backporting fixes to their stable kernel. Check with your vendor.

Synopsis
This is the general form of the command for mounting CephFS via the kernel driver:

```bash
ceph fs ls
name: lxd_cephfs, metadata pool: lxd_cephfs_meta, data pools: [lxd_cephfs_data ]
name: indFs, metadata pool: ind_cephfs_meta, data pools: [ind_cephfs_data ]

# mount -t ceph {device-string}={path-to-mounted} {mount-point} -o {key-value-args} {other-args}

mkdir /mnt/mycephfs
# $ sudo mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=newFs
mount -t ceph :/ /mnt/mycephfs/ -o name=admin,fs=indFs
ls /mnt/mycephfs/

