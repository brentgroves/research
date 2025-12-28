# **[](https://www.auvik.com/franklyit/blog/multicast-networking/)**

What is multicast?
Multicast networking, often referred to simply as “multicast,” is a network traffic distribution mode that enables one-to-many and many-to-many communication from data sources to multiple destinations simultaneously. It establishes point-to-multipoint connections over **[Layer 3 networks](https://www.auvik.com/franklyit/blog/layer-3-switches-layer-2/)** utilizing IP addressing.

Layer 2 of the OSI model is known as the data link layer. The Layer 2 protocol you’re likely most familiar with is Ethernet. Devices in an Ethernet network are identified by a MAC (media access control) address, which is generally hardcoded to a particular device and doesn’t normally change.

Layer 3 is the network layer and its protocol is the Internet Protocol or IP. Devices in an IP network are identified by an IP address, which can be dynamically assigned and may change over time. Traditionally, the network device most associated with Layer 3 has been the router, which allows you to connect devices to different IP networks.

Instead of sending copies of packets individually to each intended recipient (unicast) or transmitting packets indiscriminately to all nodes on the local network segment (broadcast), multicast sends traffic only to registered end-points that comprise a specific multicast group. This avoids flooding the entire network while still reaching numerous subscribers.

In multicast communications, sources send packets just once to the multicast network, labeled with special reserved IP addresses indicating the multicast group. Network routers then utilize specific multicast protocols to replicate packets and forward them along optimized distribution paths to reach all group members.

Multicast traffic forwarding is accomplished through the construction of a multicast distribution tree, which spreads through all nodes containing receivers belonging to the applicable group. This tree creation, group registration, and packet replication functionality necessitates specific multicast protocols and network configuration to work properly.

Key multicast terms
**Multicast group:** A set of receivers registered to receive traffic sent to a specific multicast IP address. Group members join through IGMP signaling.
