# **[Routing Information Protocol (RIP)](https://www.geeksforgeeks.org/routing-information-protocol-rip/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

Routing Information Protocol (RIP) is a routing protocol that uses hop count as a routing metric to find the best path between the source and the destination network. In this article, we will discuss Routing Information Protocol in detail.

## What is Routing Information Protocol?

The Routing Information Protocol is a distance vector routing protocol that helps routers determine the best path to transfer data packets across the network. RIP works on the Network layer of the OSI model. It uses hop count as its metric for determining the best path, but the maximum hop count allowed in the RIP is 15. Routing Information Protocol is mostly used in small to medium-sized networks.

## What is Hop Count?

Hop count is the number of routers occurring between the source and destination network. The path with the lowest hop count is considered the best route to reach a network and therefore placed in the routing table. RIP prevents routing loops by limiting the hops allowed in a path from source to destination. The maximum hop count allowed for RIP is 15 and a hop count of 16 is considered as network unreachable.

## Features of RIP

- Updates of the network are exchanged periodically.
- Updates (routing information) are always broadcast.
- Full routing tables are sent in updates.
- Routers always trust routing information received from neighbor routers. This is also known as Routing on rumors.

## How Routing Information Protocol Works?

Routing Information Protocol uses **[Distance Vector Routing](https://www.geeksforgeeks.org/distance-vector-routing-dvr-protocol/)** to put the packets to its destination. In RIP, Each router maintains a routing table where the distance to each destination is mentioned. RIP sharesits routing tables to neighbouring routers at an interval of 30 seconds through broadcasting. Upon receiving the data, each router updates the table according to that. If an router receives a route and it is shorter than the previous one, then router simply updates the data in the table.

RIP has a limit of 15 hops, that is, if some route requires more than 15 hops, then that path in unreachable. It helps in limiting the size of network that a router can handle. In case, if a route is not updated in six successful cycles ( 180 seconds) in the routing table, the RIP will drop that route and inform rest of the network about the same.

Routing Information Protocol is simple to implement, but it is more efficient for smaller networks, for larger networks, protocols like **[OSPF](https://www.geeksforgeeks.org/open-shortest-path-first-ospf-protocol-states/)** or **[EIGRP](https://www.geeksforgeeks.org/eigrp-fundamentals/)** are preferred.
