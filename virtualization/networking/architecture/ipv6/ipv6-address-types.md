# ipv6-address-types

## references

<https://www.networkacademy.io/ccna/ipv6/ipv6-address-types>

## Types of IPv6 addresses

There are different types and formats of IPv6 addresses, of which, it's notable to mention that there are no broadcast addresses in IPv6. Some examples of IPv6 formats include:

- **Global unicast**. These addresses are routable on the internet and start with "2001:" as the prefix group. Global unicast addresses are the equivalent of IPv4 public addresses.
- **Unicast address**: Used to identify the interface of an individual node.
- **Anycast address**: Used to identify a group of interfaces on different nodes.
- **Multicast address**: An address used to define Multicast Multicasts are used to send a single packet to multiple destinations at one time.
- **Link local addresses**: One of the two internal address types that are not routed on the internet. Link local addresses are used inside an internal network, are self-assigned and start with "fe80:" as the prefix group.
- **Unique local addresses**: This is the other type of internal address that is not routed on the internet. Unique local addresses are equivalent to the IPv4 addresses 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16.

## IPv6 Address Types

The IPv6 Address Space
As we already learned, IPv6 addresses are 128-bit long, which means that there are 340 undecillion possible addresses (the exact number is shown below).

340,282,366,920,938,463,463,374,607,431,768,211,456

For reference, in IPv4 with its 32-bit address space, there are 4.29 billion possible addresses.

**undecillion:** 10^66

|        Name       | Number of Zeros |   Groups of 3 Zeros   |
|:-----------------:|:---------------:|:---------------------:|
| Ten               | 1               | 0                     |
| Hundred           | 2               | 0                     |
| Thousand          | 3               | 1 (1,000)             |
| Ten thousand      | 4               | 1 (10,000)            |
| Hundred thousand  | 5               | 1 (100,000)           |
| Million           | 6               | 2 (1,000,000)         |
| Billion           | 9               | 3(1,000,000,000)      |
| Trillion          | 12              | 4 (1,000,000,000,000) |
| Quadrillion       | 15              | 5                     |
| Quintillion       | 18              | 6                     |
| Sextillion        | 21              | 7                     |
| Septillion        | 24              | 8                     |
| Octillion         | 27              | 9                     |
| Nonillion         | 30              | 10                    |
| Decillion         | 33              | 11                    |
| Undecillion       | 36              | 12                    |
| Duodecillion      | 39              | 13                    |
| Tredecillion      | 42              | 14                    |
| Quattuordecillion | 45              | 15                    |
| Quindecillion     | 48              | 16                    |
| Sexdecillion      | 51              | 17                    |
| Septen-decillion  | 54              | 18                    |
| Octodecillion     | 57              | 19                    |
| Novemdecillion    | 60              | 20                    |
| Vigintillion      | 63              | 21                    |
| Centillion        | 303             | 101                   |

The Internet Assigned Numbers Authority (IANA) allocates only a small portion of the whole IPv6 space. IANA provides global unicast addresses that start with leading leftmost bits 001. A small portion of the addresses starting with 000 and 111 are allocated for special types. All other possible addresses are reserved for future use and are currently not being allocated.

![Figure-1](https://www.networkacademy.io/sites/default/files/inline-images/iana-allocation-of-ipv6-address-space.png)

Figure 1 visualizes the allocation logic. Note the following examples of Global Unicast Addresses:

2001:4::aac4:13a2
2001:0db6:87a3::2114:8f2e:0f70:1a11
2c0f:c20a:12::1

At present, in the Internet IPv6 routing table, all prefixes start with the hexadecimal digit 2 or 3, because IANA allocates only addresses that start with the first 3 bits 001.

## The IPv6 Address Types

An IPv6 address is a 128-bit network layer identifier for a single interface of IPv6 enabled node.  There are three main types of addresses as shown in Figure 2:

- Unicast - A network layer identifier for a single interface of IPv6 enabled node. Packets sent to a unicast address are delivered to the interface configured with that IPv6 address. Therefore, it is one-to-one communication.
- Multicast - A network layer identifier for a set of interfaces, belonging to different IPv6 enabled nodes. Packets sent to a multicast address are delivered to all interfaces identified by that address. Therefore, it is one-to-many communication.
- Anycast - A network layer identifier for a set of interfaces, belonging to different IPv6 enabled nodes.  Packets sent to an anycast address are delivered to the "closest" interface identified by that address. "Closest" typically means the one with the best routing metric according to the IPv6 routing protocol. Therefore, it is one-to-closest communication.
- Broadcast - There are no broadcast addresses in IPv6. Broadcast functionality is implemented using multicast addresses.

![Figure 2](https://www.networkacademy.io/sites/default/files/inline-images/ipv6_address_types.png)

## Unicast Addresses

Aggregatable Global Unicast Address
Aggregatable global unicast addresses are part of the global routing prefix. The structure of these addresses enables for aggregation of routing entries to achieve a smaller global IPv6 routing table. At present, all global unicast addresses start with binary value 001 (2000::/3). Their structure consists of a 48-bit global routing prefix and a 16-bit subnet ID also referred to as Site-Level Aggregator (SLA).

![](https://cdn.ttgtmedia.com/rms/onlineimages/whatis-ipv6_address-h.png)

![Figure 3](https://www.networkacademy.io/sites/default/files/inline-images/aggregatable-global-ipv6-address-format.png)

Figure 3. Aggregatable Global IPv6 Address Format

Let's take a look at the following example of allocating global unicast addresses.

- IANA currently allocates addresses from the prefix 2000::/3 to the regional providers.
- For example, part of this address space is allocated to ARIN.
- ARIN then allocates sub-parts of this address space 2001:18::/23 to ISPs and large customers.

Note that the prefix was given to Customer 1 2001:18B1:1::/48 is part of the bigger prefix 2001:18B1::/32 owned by the ISP, which itself is part of the bigger prefix 2001:18::/23 of ARIN and so on. That's is why these global IPv6 unicast addresses are called aggregatable.
