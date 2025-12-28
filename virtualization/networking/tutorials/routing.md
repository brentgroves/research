# **[Routing](https://notes.networklessons.com/routing)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../README.md)**

![lf](https://wiki.linuxfoundation.org/_media/wiki/logo.png)

Routing is a process that takes place at the Network Layer (Layer 3) of the **[OSI model](https://notes.networklessons.com/osi-model)**. It is the process by which a router will decide out of which interface it will send a packet based on its destination address.

- Application Layer: Applications create the data.
- Presentation Layer: Data is formatted and encrypted.
- Session Layer: Connections are established and managed.
- Transport Layer: Data is broken into segments for reliable delivery.
- Network Layer : Segments are packaged into packets and routed.
- Data Link Layer: Packets are framed and sent to the next device.
- Physical Layer: Frames are converted into bits and transmitted physically.

In the OSI model, a "network packet" refers to a data unit at the network layer (Layer 3), containing information like source and destination IP addresses, while a "frame" is a data unit at the data link layer (Layer 2), which includes additional information like source and destination MAC addresses, used for transmission between devices on the same network; essentially, a frame encapsulates a packet with extra data needed for local network communication.

When a router receives a packet, it will examine the destination IP address and compare it with the entries it has in the **[Routing Table](https://notes.networklessons.com/routing-table)**. Based on those entries, it will forward the packet out of the appropriate egress interface.

Routing is a fundamental operation of the IPv4 and IPv6 protocols and enables end to end (host to host) communication.
