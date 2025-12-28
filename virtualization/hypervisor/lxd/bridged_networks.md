# **[Bridged Network](https://documentation.ubuntu.com/lxd/en/latest/reference/network_bridge/)**

As one of the possible network configuration types under LXD, LXD supports creating and managing network bridges.

A network bridge creates a virtual L2 Ethernet switch that instance NICs can connect to, making it possible for them to communicate with each other and the host. LXD bridges can leverage underlying native Linux bridges and Open vSwitch.

The bridge network type allows to create an L2 bridge that connects the instances that use it together into a single network L2 segment. Bridges created by LXD are managed, which means that in addition to creating the bridge interface itself, LXD also sets up a local dnsmasq process to provide DHCP, IPv6 route announcements and DNS services to the network. By default, it also performs NAT for the bridge.

See **[How to configure your firewall](https://documentation.ubuntu.com/lxd/en/latest/howto/network_bridge_firewalld/#network-bridge-firewall)** for instructions on how to configure your firewall to work with LXD bridge networks.

## IPv6 prefix size

If you’re using IPv6 for your bridge network, you should use a prefix size of 64.

Larger subnets (i.e., using a prefix smaller than 64) should work properly too, but they aren’t typically that useful for SLAAC.

Smaller subnets are in theory possible (when using stateful DHCPv6 for IPv6 allocation), but they aren’t properly supported by dnsmasq and might cause problems. If you must create a smaller subnet, use static allocation or another standalone router advertisement daemon.

An IPv6 prefix is the part of an IPv6 address that identifies the network, similar to a subnet ID in IPv4. It's written in the format prefix/length in bits, using classless inter-domain routing (CIDR) notation. The prefix length is a decimal number that indicates how many of the leftmost bits of the IPv6 address are in the prefix. For example, in the IPv6 prefix 2001:1111:2222:3333::/64, the number 64 indicates that the prefix is 64 bits long.

## Configuration options

The following configuration key namespaces are currently supported for the bridge network type:

- bgp (BGP peer configuration)
- bridge (L2 interface configuration)
- dns (DNS server and resolution configuration)
- fan (configuration specific to the Ubuntu FAN overlay)
- ipv4 (L3 IPv4 configuration)
- ipv6 (L3 IPv6 configuration)
- maas (MAAS network identification)
- security (network ACL configuration)
- raw (raw configuration file content)
- tunnel (cross-host tunneling configuration)
- user (free-form key/value for user metadata)
