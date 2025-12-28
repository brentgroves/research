# **[Create a VM that boots from an ISO](https://documentation.ubuntu.com/lxd/stable-5.21/howto/instances_create/#create-a-vm-that-boots-from-an-iso)**

To create a VM that boots from an ISO:

First, create an empty VM that we can later install from the ISO image:

```bash
lxc init iso-vm --empty --vm --config limits.cpu=2 --config limits.memory=4GiB --device root,size=30GiB
lxc config show iso-vm --expanded
# lxc config device override iso-vm root size=30GiB
# lxc config device override iso-vm eth0 type=none // does not work
lxc config edit iso-vm // this manually override eth0 to type=none
restore nic config later

```

Adapt the limits.cpu, limits.memory, and root size based on the hardware recommendations for the ISO image used.

The second step is to import an ISO image that can later be attached to the VM as a storage volume:

```bash
lxc storage volume import <pool> <path-to-image.iso> iso-volume --type=iso
```

Lastly, attach the custom ISO volume to the VM using the following command:

```bash
# lxc config device add iso-vm iso-volume disk pool=<pool> source=iso-volume boot.priority=10
lxc config device add iso-vm iso-volume disk source=/home/brent/Downloads/ubuntu.iso
lxc config show iso-vm --expanded
```

## if lxd system is desktop

The boot.priority configuration key ensures that the VM will boot from the ISO first. Start the VM and connect to the console as there might be a menu you need to interact with:

`lxc start iso-vm --console`

Once you’re done in the serial console, disconnect from the console using Ctrl+a q and connect to the VGA console using the following command:

`lxc console iso-vm --type=vga`

## if lxd system is server use virt-viewer

uses **[spice](https://spice-space.org)** protocol for remotely controlling systems. It is like vnc or rdp but it is implemented by lxd. Since lxd implements spice you can see vm as it boots.

Basically this means that a process has full privileges for operations inside its current user namespace, but is unprivileged outside of it.
