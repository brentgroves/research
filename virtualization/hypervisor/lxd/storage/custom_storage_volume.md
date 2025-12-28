# **[Create a custom storage volume](https://documentation.ubuntu.com/lxd/latest/howto/storage_volumes/#create-a-custom-storage-volume)**

When you create an instance, LXD automatically creates a storage volume that is used as the root disk for the instance.

You can add custom storage volumes to your instances. Such custom storage volumes are independent of the instance, which means that they can be backed up separately and are retained until you delete them. Custom storage volumes with content type filesystem can also be shared between different instances.

See **[Storage volumes](https://documentation.ubuntu.com/lxd/latest/explanation/storage/#storage-volumes)** for detailed information.

## Create the volume

Use the following command to create a custom storage volume vol1 of type filesystem in storage pool my-pool:

lxc storage volume create my-pool vol1
By default, custom storage volumes use the filesystem content type. To create a custom volume with content type block, add the --type flag:

```bash
lxc storage volume list
lxc storage volume create remote vol2 --type=block
```

## Attach the volume to an instance

After creating a custom storage volume, you can add it to one or more instances as a disk device.

The following restrictions apply:

- Storage volumes of **[content type](https://documentation.ubuntu.com/lxd/latest/explanation/storage/#storage-content-types)** block or iso cannot be attached to containers, only to virtual machines.
- Storage volumes of content type block that don’t have security.shared enabled cannot be attached to more than one instance at the same time. Attaching a block volume to more than one instance at a time risks data corruption.
- Storage volumes of content type iso are always read-only, and can therefore be attached to more than one virtual machine at a time without corrupting data.
- Storage volumes of content type filesystem can’t be attached to virtual machines while they’re running.
- You cannot attach a storage volume from a local storage pool (a pool that uses the Directory, Btrfs, ZFS, or LVM driver) to an instance that has `migration.stateful` set to true. You must set migration.stateful to false on the instance. Note that doing so makes the instance ineligible for live migration.
