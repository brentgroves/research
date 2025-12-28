# **[CephFS Client Capabilities](https://docs.ceph.com/en/reef/cephfs/client-auth/)**

Ceph authentication capabilities are used to restrict CephFS clients to the lowest level of authority necessary.

Note

Path restriction and layout-modification restriction were introduced in the Jewel release of Ceph.

Note

Using Erasure Coded (EC) pools with CephFS is supported only with BlueStore. Erasure-coded pools cannot be used as metadata pools. Overwrites must be enabled on erasure-coded data pools.

## Path restriction

By default, clients are not restricted in the paths that they are allowed to mount. When clients mount a subdirectory (for example /home/user), the MDS does not by default verify that subsequent operations are “locked” within that directory.

To restrict clients so that they mount and work only within a certain directory, use path-based MDS authentication capabilities.

This restriction impacts only the filesystem hierarchy, or, in other words, the metadata tree that is managed by the MDS. Clients will still be able to access the underlying file data in RADOS directly. To segregate clients fully, isolate untrusted clients in their own RADOS namespace. You can place a client’s filesystem subtree in a particular namespace using file layouts and then restrict their RADOS access to that namespace using OSD capabilities.

## Syntax

To grant rw access to the specified directory only, mention the specified directory while creating key for a client. Use a command of the following form:

```bash
ceph fs authorize <fs_name> client.<client_id> <path-in-cephfs> rw
```

For example, to restrict a client named foo so that it can write only in the bar directory of file system cephfs_a, run the following command:

```bash
ceph fs authorize cephfs_a client.foo / r /bar rw
```

This results in:

```bash
client.foo
  key: *key*
  caps: [mds] allow r, allow rw path=/bar
  caps: [mon] allow r
  caps: [osd] allow rw tag cephfs data=cephfs_a
```

To completely restrict the client to the bar directory, omit the root directory :

```bash
ceph fs authorize cephfs_a client.foo /bar rw
```

If a client’s read access is restricted to a path, the client will be able to mount the file system only by specifying a readable path in the mount command (see below).

Supplying all or *as the file system name grants access to every file system. It is usually necessary to quote* to protect it from the shell.

See **[User Management - Add a User to a Keyring](https://docs.ceph.com/en/reef/rados/operations/user-management/#add-a-user-to-a-keyring)** for more on user management.

To restrict a client to only the specified sub-directory, mention the specified directory while mounting. Use a command of the following form:

`ceph-fuse -n client.<client_id> <mount-path> -r *directory_to_be_mounted*`

For example, to restrict client foo to mnt/bar directory, use the following command:

`ceph-fuse -n client.foo mnt -r /bar`
