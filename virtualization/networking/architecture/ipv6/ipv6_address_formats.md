# ipv6

## references

<https://www.ibm.com/docs/en/i/7.5?topic=concepts-ipv6-address-formats>

## IPv6 address formats

The size and format of the IPv6 address expand addressing capability.

The IPv6 address size is 128 bits. The preferred IPv6 address representation is: x:x:x:x:x:x:x:x, where each x is the hexadecimal values of the eight 16-bit pieces of the address. IPv6 addresses range from 0000:0000:0000:0000:0000:0000:0000:0000 to ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff.

In addition to this preferred format, IPv6 addresses might be specified in two other shortened formats:

## Omit leading zeros

Specify IPv6 addresses by omitting leading zeros. For example, IPv6 address 1050:0000:0000:0000:0005:0600:300c:326b can be written as 1050:0:0:0:5:600:300c:326b.

## Double colon

Specify IPv6 addresses by using double colons (::) in place of a series of zeros. For example, IPv6 address ff06:0:0:0:0:0:0:c3 can be written as ff06::c3. Double colons can be used only once in an IP address.

An alternative format for IPv6 addresses combines the colon and dotted notation, so the IPv4 address can be embedded in the IPv6 address. Hexadecimal values are specified for the left-most 96 bits, and decimal values are specified for the right-most 32 bits indicating the embedded IPv4 address. This format ensures compatibility between IPv6 nodes and IPv4 nodes when you are working in a mixed network environment.

IPv4-mapped IPv6 address uses this alternative format. This type of address is used to represent IPv4 nodes as IPv6 addresses. It allows IPv6 applications to communicate directly with IPv4 applications. For example, 0:0:0:0:0:ffff:192.1.56.10 and ::ffff:192.1.56.10/96 (shortened format).

All of these formats are valid IPv6 address formats. You can specify these IPv6 address formats in IBM® Navigator for i except for the IPv4-mapped IPv6 address.

IPv6 address types
Last Updated: 2023-10-10
This information shows the categories of different IPv6 address types, and explains the uses for each of them.

## IPv6 addresses are categorized into these basic types

### Unicast address

The unicast address specifies a single interface. A packet sent to a unicast address destination travels from one host to the destination host.
The two regular types of unicast addresses include:

#### Link-local address

Link-local addresses are designed for use on a single local link (local network). Link-local addresses are automatically configured on all interfaces. The prefix used for a link-local address is fe80::/10. Routers do not forward packets with a destination or source address containing a link-local address.

#### Global address

Global addresses are designed for use on any network. The prefix used for a global address begins with binary 001.
There are two special unicast addresses defined:
Unspecified address
The unspecified address is 0:0:0:0:0:0:0:0. You can abbreviate the address with two colons (::). The unspecified address indicates the absence of an address, and it can never be assigned to a host. It can be used by an IPv6 host that does not yet have an address assigned to it. For example, when the host sends a packet to discover if an address is used by another node, the host uses the unspecified address as its source address.
Loopback address
The loopback address is 0:0:0:0:0:0:0:1. You can abbreviate the address as ::1. The loopback address is used by a node to send a packet to itself.
Anycast address
An anycast address specifies a set of interfaces, possibly at different locations, that all share a single address. A packet sent to an anycast address goes only to the nearest member of the anycast group. IBM® i can send to anycast addresses, but cannot be a member of an anycast group.
Multicast address
The multicast address specifies a set of interfaces, possibly at multiple locations. The prefix used for a multicast address is ff. If a packet is sent to a multicast address, one copy of the packet is delivered to each member of the group. The IBM i operating system currently provides basic support for multicast addressing.
