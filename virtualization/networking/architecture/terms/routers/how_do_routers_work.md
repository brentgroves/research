# **[Routers](https://www.cisco.com/c/en/us/solutions/small-business/resource-center/networking/how-does-a-router-work.html#~what-does-a-router-do)**

## What are the different types of routers?

### Wired routers

Wired routers usually connect directly to modems or wide-area networks (WANs) via network cables. They typically come with a port that connects to modems to communicate with the Internet.

### Wireless routers

Routers can also connect wirelessly to devices that support the same wireless standards. Wireless routers can receive information from and send information to the Internet.

## How routers route data

**Routing, defined**\
Routing is the ability to forward IP packets—a package of data with an Internet protocol (IP) address—from one network to another. The router's job is to connect the networks in your business and manage traffic within these networks. Routers typically have at least two network interface cards, or NICs, that allow the router to connect to other networks.

**Speeding data across networks**\
Routers figure out the fastest data path between devices connected on a network, and then send data along these paths. To do this, routers use what's called a "metric value," or preference number. If a router has the choice of two routes to the same location, it will choose the path with the lowest metric. The metrics are stored in a routing table.

**Creating a routing table**\
A routing table, which is stored on your router, is a list of all possible paths in your network. When routers receive IP packets that need to be forwarded somewhere else in the network, the router looks at the packet's destination IP address and then searches for the routing information in the routing table.

If you are managing a network, you need to become familiar with routing tables since they'll help you troubleshoot networking issues. For example, if you understand the structure and lookup process of routing tables, you should be able to diagnose any routing table issue, regardless of your level of familiarity with a particular routing protocol.

As an example, you might notice that the routing table has all the routes you expect to see, yet packet forwarding is not working as well as expected. By knowing how to look up a packet's destination IP address, you can determine if the packet is being forwarded, why the packet is being sent elsewhere, or whether the packet has been discarded.

## Managing routers

When you need to make changes to your network's routing options, you log in to your router to access its software. For example, you can log in to the router to change login passwords, encrypt the network, create port forwarding rules, or update the router's firmware.
