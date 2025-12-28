# **[](https://documentation.ubuntu.com/lxd/latest/explanation/storage/#content-types)**

Content types
Each storage volume uses one of the following content types:

filesystem
This content type is used for containers and container images. It is the default content type for custom storage volumes.

Custom storage volumes of content type filesystem can be attached to both containers and virtual machines, and they can be shared between instances.

block
This content type is used for virtual machines and virtual machine images. You can create a custom storage volume of type block by using the --type=block flag.

Custom storage volumes of content type block can only be attached to virtual machines. By default, they can only be attached to one instance at a time, because simultaneous access can lead to data corruption. Sharing custom storage volumes of content type block is made possible through the usage of the security.shared configuration key.

iso
This content type is used for custom ISO volumes. A custom storage volume of type iso can only be created by importing an ISO file using lxc storage volume import or by copying another volume.

Custom storage volumes of content type iso can only be attached to virtual machines. They can be attached to multiple machines simultaneously as they are always read-only.

After creating a custom storage volume, you can add it to one or more instances as a disk device.

The following restrictions apply:

- Storage volumes of **[content type](https://documentation.ubuntu.com/lxd/latest/explanation/storage/#storage-content-types)** block or iso cannot be attached to containers, only to virtual machines.
- Storage volumes of content type block that don’t have security.shared enabled cannot be attached to more than one instance at the same time. Attaching a block volume to more than one instance at a time risks data corruption.
- Storage volumes of content type iso are always read-only, and can therefore be attached to more than one virtual machine at a time without corrupting data.
- Storage volumes of content type filesystem can’t be attached to virtual machines while they’re running.
- You cannot attach a storage volume from a local storage pool (a pool that uses the Directory, Btrfs, ZFS, or LVM driver) to an instance that has `migration.stateful` set to true. You must set migration.stateful to false on the instance. Note that doing so makes the instance ineligible for live migration.
