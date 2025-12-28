# **[ovn networks](https://documentation.ubuntu.com/microcloud/latest/lxd/reference/network_ovn/#network-ovn)**

OVN network
OVN is a software-defined networking system that supports virtual network abstraction. You can use it to build your own private cloud. See <www.ovn.org> for more information.

The ovn network type allows to create logical networks using the OVN SDN. This kind of network can be useful for labs and multi-tenant environments where the same logical subnets are used in multiple discrete networks.

A LXD OVN network can be connected to an existing managed Bridge network or Physical network to gain access to the wider network. By default, all connections from the OVN logical networks are NATed to an IP allocated from the uplink network.

See How to set up OVN with LXD for basic instructions for setting up an OVN network.

Note

Static DHCP assignments depend on the client using its MAC address as the DHCP identifier. This method prevents conflicting leases when copying an instance, and thus makes statically assigned leases work properly.

OVN networking architecture
The following figure shows the OVN network traffic flow in a LXD cluster:

![i1](https://documentation.ubuntu.com/microcloud/latest/lxd/_images/ovn_networking_1.svg)

OVN networking (one network)

The OVN network connects the different cluster members. Network traffic between the cluster members passes through the NIC for inter-cluster traffic (eth1 in the figure) and is transmitted through an OVN tunnel. This traffic between cluster members is referred to as OVN east/west traffic.

For outside connectivity, the OVN network requires an uplink network (a **[Bridge network](https://documentation.ubuntu.com/microcloud/latest/lxd/reference/network_bridge/#network-bridge)** or a **[Physical network](https://documentation.ubuntu.com/microcloud/latest/lxd/reference/network_physical/#network-physical)**). The OVN network uses a virtual router to connect to the uplink network through the NIC for uplink traffic (eth0 in the figure). The virtual router is active on only one of the cluster members, and can move to a different member at any time. Independent of where the router resides, the OVN network is available on all cluster members.

Every instance on any cluster member can connect to the OVN network through its virtual NIC (usually eth0 for containers and enp5s0 for virtual machines). The traffic between the instances and the uplink network is referred to as OVN north/south traffic.

The strengths of using OVN become apparent when looking at a networking architecture with more than one OVN network:

![i2](https://documentation.ubuntu.com/microcloud/latest/lxd/_images/ovn_networking_2.svg)

OVN networking (two networks)

In this case, both depicted OVN networks are completely independent. Both networks are available on all cluster members (with each virtual router being active on one random cluster member). Each instance can use either of the networks, and the traffic on either network is completely isolated from the other network.

## Configuration options

The following configuration key namespaces are currently supported for the ovn network type:

- bridge (L2 interface configuration)
- dns (DNS server and resolution configuration)
- ipv4 (L3 IPv4 configuration)
- ipv6 (L3 IPv6 configuration)
- security (network ACL configuration)
- user (free-form key/value for user metadata)

Note

LXD uses the CIDR notation where network subnet information is required, for example, 192.0.2.0/24 or 2001:db8::/32. This does not apply to cases where a single address is required, for example, local/remote addresses of tunnels, NAT addresses or specific addresses to apply to an instance.

The following configuration options are available for the ovn network type:
