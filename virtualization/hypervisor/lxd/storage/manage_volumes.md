# **[](https://documentation.ubuntu.com/lxd/stable-5.21/howto/storage_volumes/)**

How to manage **[storage volumes](https://documentation.ubuntu.com/lxd/stable-5.21/explanation/storage/#storage-volumes)**
▶
Watch on YouTube
See the following sections for instructions on how to create, configure, view and resize Storage volumes.

View storage volumes
You can display a list of all available storage volumes and check their configuration.

To list all available storage volumes, use the following command:

`lxc storage volume list`

To display the storage volumes for all projects (not only the default project), add the --all-projects flag.

You can also display the storage volumes in a specific storage pool:

`lxc storage volume list my-pool`

The resulting table contains, among other information, the storage volume type and the content type for each storage volume.

Note

Custom storage volumes can use the same name as instance volumes. For example, you might have a container named c1 with a container storage volume named c1 and a custom storage volume named c1. Therefore, to distinguish between instance storage volumes and custom storage volumes, all instance storage volumes must be referred to as <volume_type>/<volume_name> (for example, container/c1 or virtual-machine/vm) in commands.

To show detailed configuration information about a specific volume, use the following command:

`lxc storage volume show my-pool custom/my-volume`
To show state information about a specific volume, use the following command:

lxc storage volume info my-pool virtual-machine/my-vm
In both commands, the default storage volume type is custom, so you can leave out the custom/ when displaying information about a custom storage volume.

```bash
lxc storage volume show remote virtual-machine/open-osprey
name: open-osprey
description: ""
type: virtual-machine
pool: remote
content_type: block
project: default
location: ""
created_at: 2025-07-15T23:05:12.156025373Z
config:
  block.filesystem: ext4
  block.mount_options: discard
  volatile.uuid: f412b6b1-998f-44c5-8755-5c30d83a0507
used_by:
- /1.0/instances/open-osprey
```

## can anyone see this

`https://app.powerbi.com/groups/me/rdlreports/2e04b6ce-ae3e-46a7-a254-5504f3b8a544?ctid=ceadc058-fad7-4b6b-830b-00ac739654f0&experience=power-bi`
