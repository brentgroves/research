# **[Firewall and network filtering in libvirt](https://libvirt.org/firewall.html)**

**[Back to Research List](../../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../../README.md)**

There are three pieces of libvirt functionality which do network filtering of some type. At a high level they are:

- The virtual network driver

This provides an isolated bridge device (ie no physical NICs attached). Guest TAP devices are attached to this bridge. Guests can talk to each other and the host, and optionally the wider world.

- The QEMU driver MAC filtering

This provides a generic filtering of MAC addresses to prevent the guest spoofing its MAC address. This is mostly obsoleted by the next item, so won't be discussed further.

- The network filter driver

This provides fully configurable, arbitrary network filtering of traffic on guest NICs. Generic rulesets are defined at the host level to control traffic in some manner. Rules sets are then associated with individual NICs of a guest. While not as expressive as directly using iptables/ebtables, this can still do nearly everything you would want to on a guest NIC filter.

## The virtual network driver

The typical configuration for guests is to use bridging of the physical NIC on the host to connect the guest directly to the LAN. In RHEL6 there is also the possibility of using macvtap/sr-iov and VEPA connectivity. None of this stuff plays nicely with wireless NICs, since they will typically silently drop any traffic with a MAC address that doesn't match that of the physical NIC.

Thus the virtual network driver in libvirt was invented. This takes the form of an isolated bridge device (ie one with no physical NICs attached). The TAP devices associated with the guest NICs are attached to the bridge device. This immediately allows guests on a single host to talk to each other and to the host OS (modulo host IPtables rules).

libvirt then uses iptables to control what further connectivity is available. There are three configurations possible for a virtual network at time of writing:

- isolated: all off-node traffic is completely blocked
- nat: outbound traffic to the LAN is allowed, but MASQUERADED
- forward: outbound traffic to the LAN is allowed

The latter 'forward' case requires the virtual network be on a separate sub-net from the main LAN, and that the LAN admin has configured routing for this subnet. In the future we intend to add support for IP subnetting and/or proxy-arp. This allows for the virtual network to use the same subnet as the main LAN and should avoid need for the LAN admin to configure special routing.

Libvirt will optionally also provide DHCP services to the virtual network using DNSMASQ. In all cases, we need to allow DNS/DHCP queries to the host OS. Since we can't predict whether the host firewall setup is already allowing this, we insert 4 rules into the head of the INPUT chain

```bash
target     prot opt in     out     source               destination
ACCEPT     udp  --  virbr0 *       0.0.0.0/0            0.0.0.0/0           udp dpt:53
ACCEPT     tcp  --  virbr0 *       0.0.0.0/0            0.0.0.0/0           tcp dpt:53
ACCEPT     udp  --  virbr0 *       0.0.0.0/0            0.0.0.0/0           udp dpt:67
ACCEPT     tcp  --  virbr0 *       0.0.0.0/0            0.0.0.0/0           tcp dpt:67
```
