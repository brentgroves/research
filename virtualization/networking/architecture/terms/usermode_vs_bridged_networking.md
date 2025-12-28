# **[KVM Networking](https://help.ubuntu.com/community/KVM/Networking)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

There are a few different ways to allow a virtual machine access to the external network.

1. The default virtual network configuration is known as Usermode Networking. NAT is performed on traffic through the host interface to the outside network.

2. Alternatively, you can configure Bridged Networking to enable external hosts to directly access services on the guest operating system.

If you are confused, the **[libvirt Networking Handbook](https://jamielinux.com/docs/libvirt-networking-handbook/)** provides a good outline.

## Usermode Networking

In the default configuration, the guest operating system will have access to network services, but will not be visible to other machines on the network. The guest will be able, for example, to browse the web, but will not be able to host an accessible web server.

By default, the guest OS will get an IP address in the 192.168.122.0/24 address space and the host OS will be reachable at 192.168.122.1.

You should be able to ssh into the host OS (at 192.168.122.1) from inside the guest OS and use scp to copy files back and forth.

If this configuration is suitable for your purposes, no other configuration is required.

If your guests do not have connectivity "out-of-the-box" see **[Troubleshooting](https://help.ubuntu.com/community/KVM/Networking#Troubleshooting)**, below.

## Bridged Networking

Bridged networking allows the virtual interfaces to connect to the outside network through the physical interface, making them appear as normal hosts to the rest of the network.

Warning: Network bridging will not work when the physical network device (e.g., eth1, ath0) used for bridging is a wireless device (e.g., ipw3945), as most wireless device drivers do not support bridging!

NOTE: Bridging is popular, and so it has reference material in several places that may not all be updated at once. These are the links I know of;

- **[KVM Networking](https://help.ubuntu.com/community/KVM/Networking)** - This page.
- **[Network Connection Bridge](https://help.ubuntu.com/community/NetworkConnectionBridge)** - An in depth page on bridging.
- **[Installing bridge utilities](https://help.ubuntu.com/community/BridgingNetworkInterfaces)** - A similar page from a Bridge-Utils point of view.
- **[Network Monitoring Bridge](https://help.ubuntu.com/community/NetworkMonitoringBridge)** - An in-line sniffer page.

## Generating a KVM MAC

If you are managing your guests via command line, the following script might be helpful to generate a randomized MAC using QEMU's registered OUI (52:54:00):

```bash
MACADDR="52:54:00:$(dd if=/dev/urandom bs=512 count=1 2>/dev/null | md5sum | sed 's/^\(..\)\(..\)\(..\).*$/\1:\2:\3/')"; echo $MACADDR
```

If you're paranoid about assigning an in-use MAC then check for a match in the output of "ip neigh". However, using this random method is relatively safe, giving you an approximately n in 16.8 million chance of a collision (where n is the number of existing QEMU/KVM guests on the LAN).

## Converting an existing guest

If you have already created VMs before, you can make them use bridged networking if you change the XML definition (in /etc/libvirt/qemu/) for the network interface, adjusting the mac address as desired from:

```xml
    <interface type='network'>
      <mac address='00:11:22:33:44:55'/>
      <source network='default'/>
    </interface>
to:

    <interface type='bridge'>
      <mac address='00:11:22:33:44:55'/>
      <source bridge='br0'/>
    </interface>
```
