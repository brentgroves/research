# **[configure the uplink network](https://documentation.ubuntu.com/lxd/latest/howto/network_ovn_setup/)**

```bash
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_1>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_2>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_3>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_4>
lxc network create UPLINK --type=physical \
   ipv4.ovn.ranges=<IP_range> \
   ipv6.ovn.ranges=<IP_range> \
   ipv4.gateway=<gateway> \
   ipv6.gateway=<gateway> \
   dns.nameservers=<name_server>

# lxc network get UPLINK ipv4.dhcp.ranges=<IP_range> ipv4.ovn.ranges=<IP_range>
lxc network get UPLINK ipv4.ovn.ranges
lxc network get UPLINK ipv4.ovn.ranges
10.188.50.206-10.188.50.212
```

In the context of LXD and Open Virtual Network (OVN), an "uplink CIDR" refers to a subnet or range of IP addresses assigned to a physical or virtual network that OVN uses as its gateway to the wider network or external resources. It's essentially the IP address space OVN uses to connect its virtual networks to the outside world.

Here's a breakdown:
OVN (Open Virtual Network):
OVN is a software-defined networking solution built on top of Open vSwitch (OVS), used to manage virtual networks in environments like LXD, Kubernetes, and others.
Uplink Network:
This is the physical or virtual network (e.g., a bridge, physical interface, or another OVN network) that OVN uses to provide connectivity to external networks or other OVN networks.
CIDR Notation:
CIDR (Classless Inter-Domain Routing) is a way to represent IP addresses and their associated network masks in a compact notation (e.g., 192.0.2.0/24).

## Uplink CIDR in OVN

When configuring an OVN network, you often need to specify an uplink network and its associated CIDR. This CIDR is used for:
NAT: OVN typically uses Network Address Translation (NAT) to connect its internal networks to the uplink. The uplink CIDR provides the IP address range for this NAT.
Routing: If you're not using NAT, the uplink CIDR can be used to configure routing rules, allowing traffic to flow between the OVN network and the uplink.
IP Allocation: The uplink CIDR provides the pool of IP addresses that OVN can use to assign to virtual routers, gateways, and other components within the OVN network.
External Access: If you want to expose services running inside the OVN network to the outside world, you can use the uplink CIDR to configure forwarding or routing rules that map external IPs to internal resources.

In essence, the uplink CIDR is a crucial configuration parameter for OVN networks, defining how they connect to and interact with the broader network environment.
