# **[VM on local network](https://www.reddit.com/r/qemu_kvm/comments/13uc290/vm_on_the_local_network/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## How to use bridged networking with libvirt and KVM

Libvirt is a free and open source software which provides API to manage various aspects of virtual machines. On Linux it is commonly used in conjunction with KVM and Qemu. Among other things, libvirt is used to create and manage virtual networks. The default network created when libvirt is used is called “default” and uses NAT (Network Address Translation) and packet forwarding to connect the emulated systems with the “outside” world (both the host system and the internet). In this tutorial we will see how to create a different setup using Bridged

In this tutorial you will learn:

- How to create a virtual bridge
- How to add a physical interface to a bridge
- How to make the bridge configuration persistent
- How to modify firmware rules to allow traffic to the virtual machine
- How to create a new virtual network and use it in a virtual machine
