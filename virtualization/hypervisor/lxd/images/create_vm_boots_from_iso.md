# **[Create a VM that boots from an ISO](https://documentation.ubuntu.com/lxd/latest/howto/instances_create/#create-a-vm-that-boots-from-an-iso)**

To create a VM that boots from an ISO:

First, create an empty VM that we can later install from the ISO image:

```bash
lxc init iso-vm --empty --vm --config limits.cpu=2 --config limits.memory=4GiB --device root,size=30GiB
```

Note

Adapt the limits.cpu, limits.memory, and root size based on the hardware recommendations for the ISO image used.

The second step is to import an ISO image that can later be attached to the VM as a storage volume:

```bash
lxc storage volume import <pool> <path-to-image.iso> iso-volume --type=iso
```

Lastly, attach the custom ISO volume to the VM using the following command:

```bash
lxc config device add iso-vm iso-volume disk pool=<pool> source=iso-volume boot.priority=10
```

The **[boot.priority](https://documentation.ubuntu.com/lxd/latest/reference/devices_disk/#device-disk-device-conf:boot.priority)** configuration key ensures that the VM will boot from the ISO first. Start the VM and **[connect to the console](https://documentation.ubuntu.com/lxd/latest/howto/instances_console/#instances-console)** as there might be a menu you need to interact with:

```bash
lxc start iso-vm --console
```

Once you’re done in the serial console, disconnect from the console using Ctrl+a q and connect to the VGA console using the following command:

```bash
lxc console iso-vm --type=vga
```

You should now see the installer. After the installation is done, detach the custom ISO volume:

```bash
lxc storage volume detach <pool> iso-volume iso-vm
```

Now the VM can be rebooted, and it will boot from disk.

Note

On Linux virtual machines, the **[LXD agent](https://documentation.ubuntu.com/lxd/latest/howto/instances_create/#lxd-agent-manual-install)** can be manually installed.

## Install the LXD agent into virtual machine instances

In order for features like direct command execution (lxc exec & lxc shell), file transfers (lxc file) and detailed usage metrics (lxc info) to work properly with virtual machines, an agent software is provided by LXD.

The virtual machine images from the official remote image servers are pre-configured to load that agent on startup.

For other virtual machines, you may want to manually install the agent.

Note

The LXD agent is currently available only on Linux virtual machines using systemd.

LXD provides the agent through a remote 9p file system and a virtiofs one that are both available under the mount name config. To install the agent, you’ll need to get access to the virtual machine and run the following commands as root:

```bash
modprobe 9pnet_virtio
mount -t 9p config /mnt -o access=0,transport=virtio || mount -t virtiofs config /mnt
cd /mnt
./install.sh
cd /
umount /mnt
reboot
```

You need to perform this task once.
