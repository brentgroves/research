# **[Multicasting Addressing](https://www.dqnetworks.ie/toolsinfo.d/multicastaddressing.html)**

IP Addressing
Multicast IP addresses fall within the range 224.0.0.0 - 239.255.255.255. In the pre-CIDR world, they would have been called Class D addresses (although nowadays it is not considered polite to use such vulgar terminology !). For the honours students, they are distinguished by the most significant four bits being "1110".

If you are looking for something to test IP multicast on your network you might like to check out our free (but very unfinished !) **[IP Multicast Tester](https://www.dqnetworks.ie/toolsinfo/mcasttest/)**

## Ethernet Addressing

In the Ethernet world, a multicast MAC address is distinguished by a binary '1' in the least significant bit of the first byte. For IP multicast specifically, the Ethernet prefix "01-00-5e" is reserved.

## Mapping from IP to Ethernet

If you aren't interested and reading this but just need to do a conversion you can skip ahead to the Address Converter Tool. We won't mind!

Since it is obviously infeasible to have an equivalent of ARP when transmitting multicast traffic, we would ideally like a one-to-one mapping between multicast IP addresses and multicast MAC addresses. If we ignore the four most significant bits of the multicast IP address (which, as noted earlier, will always be "1110"), that leaves 28 bits of IP address information which needs to be mapped to a MAC address.

The astute reader may have noticed a problem by now: There are only 24 bits (the least significant three bytes of the MAC address) available into which to encode the IP address. Actually, it is even worse than this...only the lower 23 bits are available for use (for non-technical reasons which need not detain us here). To get around this, the most significant 9 bits of the multicast IP address are quite simply ignored and the remaining 23 bits are copied into the lowest 23 bits of the MAC address.

![ma](https://www.dqnetworks.ie/toolsinfo.d/multicastaddressmapping.gif)

As a consequence of this, 5 bits of "useful" IP address information being scrapped, there is not a one-to-one mapping between multicast IP address and multicast MAC addresses. Rather, each multicast MAC address will be shared by 32 IP addresses.

| 224.0.0.1 224.128.0.1 225.0.0.1 225.128.0.1 226.0.0.1 : :238.128.0.1 239.0.0.1 239.128.0.1 | 01-00-5e-00-00-01 |
|--------------------------------------------------------------------------------------------|-------------------|

This has implications for multicast application design. Typically, modern LAN switches have the intelligence to "filter" multicasts. Users will only "see" multicast traffic they have actually asked for, so that (for example) a high-bandwidth software download (using Ghost or something similar) will not affect network performance for all users. However, LAN switches are not IP-aware and will do their multicast filtering based on MAC addresses. This means that if the high-bandwidth software download is being transmitted on multicast IP address 224.1.2.3 and you are subscribed to a streaming video feed on multicast IP address 237.129.2.3 (which maps to the same MAC address), you are going to be swamped with the download traffic as well as your video feed.
