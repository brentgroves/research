# **[Setup network bridge to vm](https://www.redhat.com/sysadmin/setup-network-bridge-VM)**

## Summary

Did not quite get this to work but almost. I wanted to use iproute2 to create the bridge and enslave eno3 but could not get that to work.

## How to set up a network bridge for virtual machine communication

If you're using virtual machines (VMs) with a hypervisor like KVM or QEMU, you may need to configure a network bridge to facilitate systems communicating on the same subnet.

Skip to the bottom of list
Linux containers
A practical introduction to container terminology
Containers primer
Download now: Red Hat OpenShift trial
eBook: Podman in Action
Why choose Red Hat for containers
One of my favorite ways to configure my network is nmtui, a user-friendly console tool for the NetworkManager utility.

I'll begin with an example setup. This is a common base-level deployment for virtual hosts, and the same principles apply to this configuration as they would to a structure for hundreds of hosts.

## The setup

I'm using these components for this tutorial:

- KVM host (an on-premises physical server): Red Hat Enterprise Linux (RHEL) (IP address: 10.0.1.254)
- Virtualization: KVM or QEMU
- Virtual machines (guests): Ubuntu Server 20.04 (IP: 10.0.1.253) and Windows 10 Professional (IP assigned by DHCP)

## The target network topology

A network bridge is a virtual switch that funnels the virtual guests through to the physical network interface card (NIC) of the RHEL host. The physical NIC of the host server is attached to an actual router with access to the rest of your LAN.

![](https://www.redhat.com/sysadmin/sites/default/files/styles/embed_small/public/2022-02/nettopology.png?itok=KBO5vMYM)

## Create a bridge

First, launch the nmtui application. It runs in your terminal using an ncurses interface and is primarily menu-driven. Launch it with:

```bash
sudo nmtui
```

Using the arrow keys, navigate to Edit a Connection. This displays your existing connections.

If you see a Bridge device listed, you know that some software (GNOME Boxes, Vagrant, VirtualBox, or similar) has already generated a virtual switch for you. If you only need one virtual switch, then your work is technically done; however, you may want to create an additional bridge for a more complex network or just for your own edification.

Use the Tab key to select Add. In the New Connection window that appears, use the arrow keys to scroll through the list of connection types and select Bridge.

Place an Ethernet connection as an agent ("slaves" in the nmtui interface) to this new bridge connection.

![](https://www.redhat.com/sysadmin/sites/default/files/styles/embed_medium/public/2022-02/nmtui_ethernet.png?itok=3LYlG9Dy)

You can specify the network settings for this new Bridge (IP address, subnet mask, gateway, and DNS) if your wired connection requires manual setup.

![](https://www.redhat.com/sysadmin/sites/default/files/styles/embed_medium/public/2022-02/nmtui_edit-connection.png?itok=ld1LxiH-)
