# **[](https://documentation.ubuntu.com/lxd/latest/reference/devices_disk/)**

Type: disk
▶
Watch on YouTube
Note

The disk device type is supported for both containers and VMs. It supports hotplugging for both containers and VMs.

Disk devices supply additional storage to instances.

For containers, they are essentially mount points inside the instance (either as a bind-mount of an existing file or directory on the host, or, if the source is a block device, a regular mount). Virtual machines share host-side mounts or directories through 9p or virtiofs (if available), or as VirtIO disks for block-based disks.
