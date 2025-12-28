# **[](https://discourse.ubuntu.com/t/update-2025-on-docker-inside-lxd-container-with-zfs-storage-with-gpu-passthrough/53609/5)**

Update [2025] on Docker inside LXD container with ZFS storage with GPU passthrough

Hey everyone

I realize that there has been some issues with docker on ZFS in the past. I just wanted to post a thread here incase anyone is searching the web for information on this.

It seems that with time ZFS now supports overlay2. I launched a container with the following profile settings

```bash
config:
  security.nesting: "true"
  security.syscalls.intercept.mknod: "true"
  security.syscalls.intercept.setxattr: "true"
```

There is also a FUSE implementation of ZFS on the Linux platform. This is not recommended. The native ZFS driver (ZoL) is more tested, has better performance, and is more widely used. The remainder of this document refers to the native ZoL port.

## Prerequisites

ZFS requires one or more dedicated block devices, preferably solid-state drives (SSDs).
The /var/lib/docker/ directory must be mounted on a ZFS-formatted filesystem.
Changing the storage driver makes any containers you have already created inaccessible on the local system. Use docker save to save containers, and push existing images to Docker Hub or a private repository, so that you do not need to re-create them later.
