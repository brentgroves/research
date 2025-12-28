# **[network segments](https://en.wikipedia.org/wiki/Network_segment)**

## Ethernet

According to the defining IEEE 802.3 standards for Ethernet, a network segment is an electrical connection between networked devices using a shared medium.[2] In the original 10BASE5 and 10BASE2 Ethernet varieties, a segment would therefore correspond to a single coax cable and all devices tapped into it. At this point in the evolution of Ethernet, multiple network segments could be connected with repeaters (in accordance with the 5-4-3 rule for 10 Mbit Ethernet) to form a larger collision domain.

With twisted-pair Ethernet, electrical segments can be joined together using repeaters or repeater hubs as can other varieties of Ethernet. This corresponds to the extent of an OSI layer 1 network and is equivalent to the collision domain.[3][4] The 5-4-3 rule applies to this collision domain.

Using switches or bridges, multiple layer-1 segments can be combined to a common layer-2 segment, i.e. all nodes can communicate with each other through MAC addressing or broadcasts. A layer-2 segment is equivalent to a broadcast domain. Traffic within a layer-2 segment can be separated into virtually distinct partitions by using VLANs. Each VLAN forms its own logical layer-2 segment.

## IP

A layer-3 segment in an IP network is called a subnetwork, formed by all nodes sharing the same network prefix as defined by their IP addresses and the network mask.[5] Communication between layer-3 subnets requires a router. Hosts on a subnet communicate directly using the layer-2 segment that connects them. Most often a subnetwork corresponds exactly with the underlying layer-2 segment but it is also possible to run multiple subnets on a single layer-2 segment.
