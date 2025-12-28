# **[storage volumes](https://documentation.ubuntu.com/lxd/stable-5.21/explanation/storage/#storage-volumes)**

Storage volumes

LXD stores its data in storage pools, divided into storage volumes of different content types (like images or instances). You could think of a storage pool as the disk that is used to store data, while storage volumes are different partitions on this disk that are used for specific purposes.

In addition to storage volumes, there are storage buckets, which use the Amazon S3 protocol. Like storage volumes, storage buckets are part of a storage pool.

Watch on YouTube
When you create an instance, LXD automatically creates the required storage volumes for it. You can create additional storage volumes.

See the following how-to guides for additional information:

**[How to manage storage volumes](https://documentation.ubuntu.com/lxd/stable-5.21/howto/storage_volumes/#howto-storage-volumes)**

**[How to move or copy storage volumes](https://documentation.ubuntu.com/lxd/stable-5.21/howto/storage_move_volume/#howto-storage-move-volume)**

**[How to back up custom storage volumes](https://documentation.ubuntu.com/lxd/stable-5.21/howto/storage_backup_volume/#howto-storage-backup-volume)**

Storage volume types
Storage volumes can be of the following types:

container/virtual-machine
LXD automatically creates one of these storage volumes when you **[launch](https://documentation.ubuntu.com/lxd/stable-5.21/reference/manpages/lxc/launch/#lxc-launch-md)** an instance. It is used as the root disk for the instance and is destroyed when the instance is deleted.

The storage pool can be explicitly specified by providing the --storage flag to the launch command. If no pool or profile is specified, LXD uses the storage pool of the default profile’s root disk device.

image
LXD automatically creates one of these storage volumes when it unpacks an image to launch one or more instances from it. You can delete it after the instance has been created. If you do not delete it manually, it is deleted automatically ten days after it was last used to launch an instance.

The image storage volume is created in the same storage pool as the instance storage volume, and only for storage pools that use a storage driver that supports optimized image storage.

custom
You can add one or more custom storage volumes to hold data that you want to store separately from your instances. Custom storage volumes of content type filesystem or iso can be shared between instances, and they are retained until you delete them.

You can also use custom storage volumes to hold your backups or images.

You must specify the storage pool for the custom volume when you create it.

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

Storage buckets
▶
Watch on YouTube
Storage buckets provide object storage functionality via the S3 protocol.

They can be used in a way that is similar to custom storage volumes. However, unlike storage volumes, storage buckets are not attached to an instance. Instead, applications can access a storage bucket directly using its URL.

Each storage bucket is assigned one or more access keys, which the applications must use to access it.

Storage buckets can be located on local storage (with dir, btrfs, lvm or zfs pools) or on remote storage (with cephobject pools).

To enable storage buckets for local storage pool drivers and allow applications to access the buckets via the S3 protocol, you must configure the core.storage_buckets_address server setting.

See the following how-to guide for additional information:

**[How to manage storage buckets and keys](https://documentation.ubuntu.com/lxd/stable-5.21/howto/storage_buckets/#howto-storage-buckets)**

Related topics
How-to guides:

Storage

Reference:

Storage drivers
