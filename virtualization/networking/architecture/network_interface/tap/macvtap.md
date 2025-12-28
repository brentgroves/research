# **[macvtap](https://en.wikipedia.org/wiki/MacVTap)

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

<https://gist.github.com/lukasnellen/d597f52441d6ca65ea0f0c79c9c170e7>

MacVTap is a Linux kernel device driver that facilitates virtualized bridged networking. Typically, it is used in virtualized environments to make both the guest and the host show up directly on the network switch the host is connected to, and to improve throughput and latencies to external systems

Connect host and VM when using a MACVTAP interface
NB: The following is only of interest if you want to share the host network with your virtual machine. The most common way this gets implemented is by setting up a bridge which includes the physical interface. Using a MACVTAP inerface is suposed to be more efficient, since it avoids the additional bridge in the network setup.

In this gist, we extend the information provided in the documenation on linux virtual interfaces.

In the following, we assume you host interface is eth0. IP addresses used:

host: 198.51.100.50/24
virtual machine: 198.51.100.198/24
default gateway: 198.51.100.254

Normal setup
In the normal setup, the host will use eth0 to comunicate with the outside and will have the IP addresses assigned to that interface.

ip addr add dev eth0 198.51.100.50/24
ip route add default via 198.51.100.254

When you look at the docummentation of linux virtual interfaces you notice that, normally, you cannot communicate between the host and a virtual machine using MACVTAP (or direct attachment) instead of a bridged network to connect to the host network. Unless you have support by external hardware, you should use bridge mode.

Here is a snippet used to set up a domain in libvirt with direct attachment to the physical interface:

```xml
<interface type='direct' trustGuestRxFilters='yes'>
  <source dev='eth0' mode='bridge'/>
  <target dev='macvtap0'/>
  <model type='virtio'/>
  <alias name='net0'/>
  <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
</interface>
```

This will create a MACVTAP interface connected to eth0. If you have several virtual machines set up this way, they will be able to communicate. It is not possible, though, for packages to get bridged from eth0 to one of the MACVTAP interfaces.

![](https://user-images.githubusercontent.com/115917/139610947-69035c03-d1ff-4e4d-8fa3-52460ef33f4a.png)

On-host MACVLAN
To work around this, you can add an additional, virtual, interface for the host and use that for outgoing connections. This will be a MACVLAN interface, which is more often used for containers. Here, we will create the MACVLAN inerface in the host's main network namespace and not in the namespace of a container, so it is accessible as an additional interface on the host. Briding works also between MACVTAP and MACVLAN interfaces, so the host can communicate from veth0 to the VMs and to the outside.

We will create the interface veth0 in the main network namespace and assign the IP addresses to that interface.

```bash
ip link set eth0 up
ip link add veth0 link eth0 type macvlan mode bridge
ip addr add dev veth0 198.51.100.50/24
ip route add default via 198.51.100.254
```

Note that eth0 is activated, but does not have any IP address assigned. The host can now communicate to both to external host and to internal VMs on the 198.51.100.0/24 network.

![](https://user-images.githubusercontent.com/115917/139611130-a85b6288-f90b-45a3-a044-71cf94412703.png)
