# **[Adding an LXC container with/to virt-manager (Virtual Machine Manager)
](https://www.kentoseth.com/posts/2023/mar/20/adding-an-lxc-container-withto-virt-manager-virtual-machine-manager/)**
 

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

## references

- **[redhat vlan tutorial](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#vlan)**
- **[extreme swtiches](https://emc.extremenetworks.com/content/oneview/docs/network/devices/docs/l_ov_cf_vlan.html#:~:text=Port%20VLAN%20ID's.-,VLAN%20ID%20(VID),(VIDs)%20and%20VLAN%20names.&text=A%20unique%20number%20between%201,reserved%20for%20the%20Default%20VLAN.)**

Virtual Machine Manager (or virt-manager) is a desktop GUI tool meant to simplify the process of dealing with VMs or containers on Linux desktop machines.

Before I begin this tutorial I will give my verdict on Virtual Machine Manager regarding LXC containers. This software is terrible at what it is supposed to do for 2 main reasons:

It has some of the worst documentation of any Open Source project (essentially none on their website)
It doesn't actually help create an LXC container at all. This tutorial demonstrates how to 'connect' an existing LXC container (which we will create on the command-line) to the GUI software via the most arduous processes possible
I would urge people to consider alternative GUI options for LXC containers. But if you went through the effort of installing virt-manager (I will use this name to refer to the software in the rest of this tutorial), this guide is for you.

The source references for my tutorial are: Linux Containers via LXC and Libvirt

Accessing remote KVM/QEMU vms with virt-manager

Unprivileged LXC container with libvirt

Make sure LXC, virt-manager and all the packages needed for virt-manager to work with LXC are installed.

Create the LXC container
