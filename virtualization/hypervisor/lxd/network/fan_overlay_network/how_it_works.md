# AI Overview

The FAN (Field Area Network) overlay is a networking solution from Ubuntu that addresses IP address limitations for containers on hosts, primarily using IP-in-IP (IPIP) or Virtual Extensible LAN (VXLAN) tunneling. Instead of a lookup-based system, the FAN uses a stateless, deterministic calculation to route traffic, making it simpler and more scalable than other overlay network approaches.

## How the FAN overlay network works

The FAN is a form of "address expansion" that maps a smaller IPv4 underlay network to a much larger overlay network, effectively multiplying the number of available IP addresses per host.

- **Mathematical mapping:** The FAN uses a formula to create a deterministic, one-to-one mapping between the host's underlay IP address and a specific subnet in the overlay network.
- **Container IP assignment:** The host assigns IP addresses from its designated overlay subnet to the containers it hosts. Because the container's IP address is mathematically derived from the host's IP, the Linux kernel can automatically route traffic.
- **Tunneling for communication:** When a container needs to communicate with another container on a different host, the host machine encapsulates the container's traffic inside an IP tunnel.
- **Decapsulation and delivery:** Upon reaching the destination host, the traffic is decapsulated and delivered to the correct container.

## The tunneling protocols used by the FAN

The FAN specifically utilizes standard IP tunneling protocols for its encapsulation and routing. The type of tunnel can be specified during configuration.

- **IP-in-IP (IPIP):** This simple and efficient protocol encapsulates one IP packet inside another. The outer header carries the host's IP addresses, allowing it to be routed across the underlying network, while the inner header contains the container's overlay IP address.
- **Virtual Extensible LAN (VXLAN):** For more complex or advanced deployments, VXLAN can also be used. VXLAN creates logical Layer 2 networks over a Layer 3 infrastructure, allowing containers to be on the same Layer 2 segment even when physically separated.

Benefits and use cases
The FAN is particularly useful for containerized environments where a host may need to run hundreds or even thousands of containers.
Massive address space: A single host can gain 253 additional usable IP addresses for every IP address it has on the underlay network.
Simplified management: The stateless nature of the FAN network eliminates the need for complex distributed databases or consensus protocols for route management, which are typically required for other overlay networks.
Efficient routing: Because routes are calculated mathematically instead of through lookups, there is very little overhead to the routed traffic.
LXD integration: The FAN was integrated into the Ubuntu kernel and works seamlessly with the LXD container hypervisor.

## reference

**[The Fan overlay network for container addresses](https://ubuntu.com/blog/fan-networking#:~:text=Today%2C%20Canonical%20introduces%20the%20Fan,to%20in%20a%20cloud%20environment.)** ... - Ubuntu
Jun 21, 2015 — Both feature incredible density – Canonical has demonstrated thousands of full Ubuntu machines hosted on a single s...
favicon
Ubuntu
**[Ubuntu Fan Aims to Simply Container Networking](https://www.enterprisenetworkingplanet.com/os/ubuntu-fan-aims-to-simply-container-networking/#:~:text=container%20networking%20project.-,There%20are%20multiple%20open%20source%20software%2Ddefined%20networking%20(SDN),of%20areas%2C%20including%20LXD%20clustering.)**
Oct 28, 2018 — “What you trade is the ability to live migrate an IP address for simplicity.” Fan takes an overlay network address ...
favicon
Enterprise Networking Planet

FanNetworking - Ubuntu Wiki
Jun 21, 2015 — Typically, the number of extra addresses needed is roughly constant across each container host. A new solution to t...
favicon
Ubuntu
Show all
