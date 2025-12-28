# **[What is a router](https://www.cloudflare.com/learning/network-layer/what-is-a-router/)**

## What is a router?

A router is a device that connects two or more packet-switched networks or subnetworks. It serves two primary functions: managing traffic between these networks by forwarding **[data packets](https://www.cloudflare.com/learning/network-layer/what-is-a-packet/)** to their intended IP addresses, and allowing multiple devices to use the same Internet connection.

Packet switching is the transfer of small pieces of data across various networks. These data chunks or “packets” allow for faster, more efficient data transfer. Often, when a user sends a file across a network, it gets transferred in smaller data packets, not in one piece.

There are several types of routers, but most routers pass data between LANs (local area networks) and WANs (wide area networks). A LAN is a group of connected devices restricted to a specific geographic area. A LAN usually requires a single router.

A WAN, by contrast, is a large network spread out over a vast geographic area. Large organizations and companies that operate in multiple locations across the country, for instance, will need separate LANs for each location, which then connect to the other LANs to form a WAN. Because a WAN is distributed over a large area, it often necessitates multiple routers and switches*.

*A **[network switch](https://www.cloudflare.com/learning/network-layer/what-is-a-network-switch/)** forwards data packets between groups of devices in the same network, whereas a router forwards data between different networks.

## How does a router work?

Think of a router as an air traffic controller and data packets as aircraft headed to different airports (or networks). Just as each plane has a unique destination and follows a unique route, each packet needs to be guided to its destination as efficiently as possible. In the same way that an air traffic controller ensures that planes reach their destinations without getting lost or suffering a major disruption along the way, a router helps direct data packets to their destination IP address.

In order to direct packets effectively, a router uses an internal routing table — a list of paths to various network destinations. The router reads a packet's header to determine where it is going, then consults the routing table to figure out the most efficient path to that destination. It then forwards the packet to the next network in the path.

To learn more about IP routing and the protocols that are used during this process, read **[What is routing](https://www.cloudflare.com/learning/network-layer/what-is-routing/)**?
