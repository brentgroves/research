# **[Install Custom Linux Desktop Distributions Remotely on LXD Servers | DevOps | Virtualization](https://m.youtube.com/watch?v=dfh_9aGQ9rE)**

## **[Create a VM that boots from an ISO](https://documentation.ubuntu.com/lxd/stable-5.21/howto/instances_create/#create-a-vm-that-boots-from-an-iso)**

```bash
lxc init iso-vm --empty --vm --config limits.cpu=2 --config limits.memory=4GiB --device root,size=30GiB
```

Adapt the limits.cpu, limits.memory, and root size based on the hardware recommendations for the ISO image used.

The second step is to import an ISO image that can later be attached to the VM as a storage volume:

```bash
lxc storage volume import <pool> <path-to-image.iso> iso-volume --type=iso
```

Lastly, attach the custom ISO volume to the VM using the following command:

```bash
lxc config device add iso-vm iso-volume disk pool=<pool> source=iso-volume boot.priority=10
```
