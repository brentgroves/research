# **[Introduction to Linux interfaces for virtual networking](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#:~:text=VETH-,VETH,VCAN)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

## references


- **[Linux Networking](https://www.youtube.com/@routerologyblog1111/playlists)**
## netfilter subsystem hooks
![pf](https://people.netfilter.org/pablo/nf-hooks.png)

The following hooks represent these well-defined points in the networking stack:

- **NF_IP_PRE_ROUTING:** This hook will be triggered by any incoming traffic very soon after entering the network stack. This hook is processed before any routing decisions have been made regarding where to send the packet.
- **NF_IP_LOCAL_IN:** This hook is triggered after an incoming packet has been routed if the packet is destined for the local system.
- **NF_IP_FORWARD:** This hook is triggered after an incoming packet has been routed if the packet is to be forwarded to another host.
- **NF_IP_LOCAL_OUT:** This hook is triggered by any locally created outbound traffic as soon as it hits the network stack.
- **NF_IP_POST_ROUTING:** This hook is triggered by any outgoing or forwarded traffic after routing has taken place and just before being sent out on the wire.

| Tables↓/Chains→               | PREROUTING | INPUT | FORWARD | OUTPUT | POSTROUTING |
|-------------------------------|------------|-------|---------|--------|-------------|
| (routing decision)            |            |       |         | ✓      |             |
| raw                           | ✓          |       |         | ✓      |             |
| (connection tracking enabled) | ✓          |       |         | ✓      |             |
| mangle                        | ✓          | ✓     | ✓       | ✓      | ✓           |
| nat (DNAT)                    | ✓          |       |         | ✓      |             |
| (routing decision)            | ✓          |       |         | ✓      |             |
| filter                        |            | ✓     | ✓       | ✓      |             |
| security                      |            | ✓     | ✓       | ✓      |             |
| nat (SNAT)                    |            | ✓     |         |        | ✓           |


Linux has rich virtual networking capabilities that are used as basis for hosting VMs and containers, as well as cloud environments. In this post, I will give a brief introduction to all commonly used virtual network interface types. There is no code analysis, only a brief introduction to the interfaces and their usage on Linux. Anyone with a network background might be interested in this blog post. A list of interfaces can be obtained using the command ip link help.

This post covers the following frequently used interfaces and some interfaces that can be easily confused with one another:

- Bridge
- Bonded interface
- Team device
- VLAN (Virtual LAN) 
- VXLAN (Virtual eXtensible Local Area Network)
- MACVLAN
- IPVLAN
- MACVTAP/IPVTAP
- MACsec (Media Access Control Security)
- VETH (Virtual Ethernet)
- VCAN (Virtual CAN)
- VXCAN (Virtual CAN tunnel)
- IPOIB (IP-over-InfiniBand)
- NLMON (NetLink MONitor)
- Dummy interface
- IFB (Intermediate Functional Block)
- netdevsim

After reading this article, you will know what these interfaces are, what's the difference between them, when to use them, and how to create them. For other interfaces like tunnel, please see **[An introduction to Linux virtual interfaces: Tunnels](https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels/)**

## Bridge
A Linux bridge behaves like a network switch. It forwards packets between interfaces that are connected to it. It's usually used for forwarding packets on routers, on gateways, or between VMs and network namespaces on a host. It also supports STP, VLAN filter, and multicast snooping.

![b](https://developers.redhat.com/blog/wp-content/uploads/2018/10/bridge.png)

Use a bridge when you want to establish communication channels between VMs, containers, and your hosts.

Here's how to create a bridge:

```bash
# ip link add br0 type bridge
# ip link set eth0 master br0
# ip link set tap1 master br0
# ip link set tap2 master br0
# ip link set veth1 master br0
```

This creates a bridge device named br0 and sets two TAP devices (tap1, tap2), a VETH device (veth1), and a physical device (eth0) as its slaves, as shown in the diagram above.

## VLAN

A VLAN, aka virtual LAN, separates broadcast domains by adding tags to network packets. VLANs allow network administrators to group hosts under the same switch or between different switches.

The VLAN header looks like:

![v](https://developers.redhat.com/blog/wp-content/uploads/2018/10/vlan_01.png)

Use a VLAN when you want to separate subnet in VMs, namespaces, or hosts.

Here's how to create a VLAN:

```bash
# ip link add link eth0 name eth0.2 type vlan id 2
# ip link add link eth0 name eth0.3 type vlan id 3
```

This adds VLAN 2 with name eth0.2 and VLAN 3 with name eth0.3. The topology looks like this:

![vl](https://developers.redhat.com/blog/wp-content/uploads/2018/10/vlan.png)

Note: When configuring a VLAN, you need to make sure the switch connected to the host is able to handle VLAN tags, for example, by setting the switch port to trunk mode.

"Switch trunk mode" refers to a configuration on a network switch where a specific port can carry traffic from multiple VLANs (Virtual Local Area Networks) simultaneously, allowing data from different VLANs to be transmitted over a single physical link, essentially acting like a "trunk" to carry multiple data streams at once; this is in contrast to an access port which is dedicated to only one VLAN. 

## MACVLAN
With VLAN, you can create multiple interfaces on top of a single one and filter packages based on a VLAN tag. With MACVLAN, you can create multiple interfaces with different Layer 2 (that is, Ethernet MAC) addresses on top of a single one.

Before MACVLAN, if you wanted to connect to physical network from a VM or namespace, you would have needed to create TAP/VETH devices and attach one side to a bridge and attach a physical interface to the bridge on the host at the same time, as shown below.

![mv](https://developers.redhat.com/blog/wp-content/uploads/2018/10/br_ns.png)

Now, with MACVLAN, you can bind a physical interface that is associated with a MACVLAN directly to namespaces, without the need for a bridge.

![mvl](https://developers.redhat.com/blog/wp-content/uploads/2018/10/macvlan.png)

## There are five MACVLAN types:

1. Private: doesn't allow communication between MACVLAN instances on the same physical interface, even if the external switch supports hairpin mode.

![mvl1](https://developers.redhat.com/blog/wp-content/uploads/2018/10/macvlan_01.png)

2. VEPA: data from one MACVLAN instance to the other on the same physical interface is transmitted over the physical interface. Either the attached switch needs to support hairpin mode or there must be a TCP/IP router forwarding the packets in order to allow communication.

![mvl2](https://developers.redhat.com/blog/wp-content/uploads/2018/10/macvlan_02.png)

3. Bridge: all endpoints are directly connected to each other with a simple bridge via the physical interface.

![mvl3](https://developers.redhat.com/blog/wp-content/uploads/2018/10/macvlan_03.png)

4. Passthru: allows a single VM to be connected directly to the physical interface.

![mvl4](https://developers.redhat.com/blog/wp-content/uploads/2018/10/macvlan_04.png)

5. Source: the source mode is used to filter traffic based on a list of allowed source MAC addresses to create MAC-based VLAN associations. Please see the commit message.

The type is chosen according to different needs. Bridge mode is the most commonly used.

Use a MACVLAN when you want to connect directly to a physical network from containers.

Here's how to set up a MACVLAN:

```bash
# ip link add macvlan1 link eth0 type macvlan mode bridge
# ip link add macvlan2 link eth0 type macvlan mode bridge
# ip netns add net1
# ip netns add net2
# ip link set macvlan1 netns net1
# ip link set macvlan2 netns net2
```
This creates two new MACVLAN devices in bridge mode and assigns these two devices to two different namespaces.

## IPVLAN

IPVLAN is similar to MACVLAN with the difference being that the endpoints have the same MAC address.

![ipv](https://developers.redhat.com/blog/wp-content/uploads/2018/10/ipvlan.png)

IPVLAN supports L2 and L3 mode. IPVLAN L2 mode acts like a MACVLAN in bridge mode. The parent interface looks like a bridge or switch.

![ipv2](https://developers.redhat.com/blog/wp-content/uploads/2018/10/ipvlan_01.png)

In IPVLAN L3 mode, the parent interface acts like a router and packets are routed between endpoints, which gives better scalability.

![ipvlan3](https://developers.redhat.com/blog/wp-content/uploads/2018/10/ipvlan_02.png)

Regarding when to use an IPVLAN, the **[IPVLAN kernel documentation](https://www.kernel.org/doc/Documentation/networking/ipvlan.txt)** says that MACVLAN and IPVLAN "are very similar in many regards and the specific use case could very well define which device to choose. if one of the following situations defines your use case then you can choose to use ipvlan -

- (a) The Linux host that is connected to the external switch / router has policy configured that allows only one mac per port.
- (b) No of virtual devices created on a master exceed the mac capacity and puts the NIC in promiscuous mode and degraded performance is a concern.
- (c) If the slave device is to be put into the hostile / untrusted network namespace where L2 on the slave could be changed / misused."

Here's how to set up an IPVLAN instance:

```bash
# ip netns add ns0
# ip link add name ipvl0 link eth0 type ipvlan mode l2
# ip link set dev ipvl0 netns ns0
```

This creates an IPVLAN device named ipvl0 with mode L2, assigned to namespace ns0.

## MACVTAP/IPVTAP

MACVTAP/IPVTAP is a new device driver meant to simplify virtualized bridged networking. When a MACVTAP/IPVTAP instance is created on top of a physical interface, the kernel also creates a character device/dev/tapX to be used just like a TUN/TAP device, which can be directly used by KVM/QEMU.

With MACVTAP/IPVTAP, you can replace the combination of TUN/TAP and bridge drivers with a single module:

![mvti](https://developers.redhat.com/blog/wp-content/uploads/2018/10/macvtap.png)

Typically, MACVLAN/IPVLAN is used to make both the guest and the host show up directly on the switch to which the host is connected. The difference between MACVTAP and IPVTAP is same as with MACVLAN/IPVLAN.

Here's how to create a MACVTAP instance:

```bash
# ip link add link eth0 name macvtap0 type macvtap
```

## MACsec

MACsec (Media Access Control Security) is an IEEE standard for security in wired Ethernet LANs. Similar to IPsec, as a layer 2 specification, MACsec can protect not only IP traffic but also ARP, neighbor discovery, and DHCP. The MACsec headers look like this:

![macs](https://developers.redhat.com/blog/wp-content/uploads/2018/10/macsec_01.png)

The main use case for MACsec is to secure all messages on a standard LAN including ARP, NS, and DHCP messages.

![macsec](https://developers.redhat.com/blog/wp-content/uploads/2018/10/macsec.png)

Here's how to set up a MACsec configuration:

# ip link add macsec0 link eth1 type macsec
Note: This only adds a MACsec device called macsec0 on interface eth1. For more detailed configurations, please see the "Configuration example" section in this **[MACsec introduction by Sabrina Dubroca](https://developers.redhat.com/blog/2016/10/14/macsec-a-different-solution-to-encrypt-network-traffic/)**.

## VETH

The VETH (virtual Ethernet) device is a local Ethernet tunnel. Devices are created in pairs, as shown in the diagram below.

Packets transmitted on one device in the pair are immediately received on the other device. When either device is down, the link state of the pair is down.

![veth](https://developers.redhat.com/blog/wp-content/uploads/2018/10/veth.png)

Use a VETH configuration when namespaces need to communicate to the main host namespace or between each other.

Here's how to set up a VETH configuration:

```bash
# ip netns add net1
# ip netns add net2
# ip link add veth1 netns net1 type veth peer name veth2 netns net2
```

This creates two namespaces, net1 and net2, and a pair of VETH devices, and it assigns veth1 to namespace net1 and veth2 to namespace net2. These two namespaces are connected with this VETH pair. Assign a pair of IP addresses, and you can ping and communicate between the two namespaces.


