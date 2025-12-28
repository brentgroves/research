# **[]()**

## Data Packet

- A data packet is a unit of data at the Network Layer (Layer 3) of the OSI model.
- It is responsible for end-to-end delivery of data across different networks, using logical addressing like IP addresses (IPv4 or IPv6).
- Packets contain the source and destination IP addresses, along with the actual data payload.
- Routers examine the destination IP address within a packet to determine the optimal path for routing it across various networks.

## Data Frame

- A data frame is a unit of data at the Data Link Layer (Layer 2) of the OSI model.
- It is responsible for hop-to-hop delivery of data within a single local network segment, using physical addressing like MAC addresses.
- Frames encapsulate packets for transmission over a specific physical medium (e.g., Ethernet cable, Wi-Fi).
- Frames contain the source and destination MAC addresses, a type/length field indicating the encapsulated protocol (like an IP packet), and error-checking information (e.g., CRC).
- Switches within a local network examine the MAC addresses in frames to forward them to the correct device on that segment.

| Feature       | Data Packet                                 | Data Frame                                   |
|---------------|---------------------------------------------|----------------------------------------------|
| OSI Layer     | Network Layer (Layer 3)                     | Data Link Layer (Layer 2)                    |
| Addressing    | Logical (IP addresses)                      | Physical (MAC addresses)                     |
| Scope         | End-to-end delivery across networks         | Hop-to-hop delivery within a local network   |
| Encapsulation | May contain segments (from Transport Layer) | Encapsulates packets (from Network Layer)    |
| Purpose       | Routing across different networks           | Transmission over a specific physical medium |

In essence, a data packet provides the logical routing information for data to travel across the internet, while a data frame provides the physical mechanism for that packet to traverse individual links within a local network. A packet is encapsulated within a frame for transmission over a local network segment, and the **frame is stripped off when the packet reaches its destination on that segment**, or when it needs to be routed to another network segment.
