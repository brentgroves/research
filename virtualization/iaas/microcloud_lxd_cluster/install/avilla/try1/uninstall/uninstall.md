Summary of issues and solutions:

If while executing “microclound init” it failed with Timed out waiting for a response from all cluster members and one or more of the nodes failed to handle and/or parse the join token (see the errors I got in the previous comment), cancel the current execution, wipe out all snaps on all nodes, and run again, eventually it will succeed.
To wipe out, I executed what nkrapf suggested:
snap stop microcloud microceph lxd && snap disable microcloud && snap disable microceph && snap disable lxd && snap remove --purge microcloud && snap remove --purge microceph && snap remove --purge lxd
If you are using qemu-kvm VMs, and the additional disks attached to the VMs has a disk bus of virtio, then during adding the disks to ceph, there will be an issue that the path to the disks will be unknown or there is some issue there, so there is no path to the disks appearing
/dev/disk/by-id/
to overcome this issue, wipe out all snaps on all nodes as mentioned in point 1, re-add the disks to the VMs but choose SCSI as the bus type and run microclound again, eventually it should succeed.

```bash
sudo snap stop microcloud microceph microovn lxd && sudo snap disable microcloud && sudo snap disable microceph && sudo snap disable lxd && sudo snap disable microovn && sudo snap remove --purge microcloud && sudo snap remove --purge microceph && sudo snap remove --purge lxd && sudo snap remove --purge microovn
```
