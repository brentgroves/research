Complete the following steps to create the required disks in a LXD storage pool:

Create a ZFS storage pool called disks:

lxc storage create disks zfs size=100GiB
Configure the default volume size for the disks pool:

lxc storage set disks volume.size 10GiB
Create four disks to use for local storage:

lxc storage volume create disks local1 --type block
lxc storage volume create disks local2 --type block
lxc storage volume create disks local3 --type block
lxc storage volume create disks local4 --type block
