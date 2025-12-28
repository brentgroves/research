# **[Manage KVM virtual machines with virsh](https://ostechnix.com/manage-kvm-virtual-machines-with-virsh-program/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

Virsh, short for Virtual Shell, is a command line user interface for managing virtual guest machines. Virsh allows you to create, list, edit, start, restart, stop, suspend, resume, shutdown and delete VMs. It currently supports KVM, LXC, Xen, QEMU, OpenVZ, VirtualBox and VMware ESX. In this guide, we will be discussing how to manage KVM virtual machines with Virsh management user interface in Linux.

## List virtual machines

To view list of guest virtual machines in run or suspend mode, execute the following command:

```bash
$ virsh list
error: failed to connect to the hypervisor
error: Failed to connect socket to '/run/user/1000/libvirt/libvirt-sock': No such file or directory

```

## Start Virtual machines

To start a virtual machine, for example "centos8-uefi", run:

```bash
virsh start centos8-uefi
```
