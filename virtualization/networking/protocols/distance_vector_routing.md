# **[Distance Vector Routing (DVR) Protocol](https://www.geeksforgeeks.org/distance-vector-routing-dvr-protocol/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

Distance Vector Routing (DVR) Protocol is a method used by routers to find the best path for data to travel across a network. Each router keeps a table that shows the shortest distance to every other router, based on the number of hops (or steps) needed to reach them. Routers share this information with their neighbors, allowing them to update their tables and find the most efficient routes. This protocol helps ensure that data moves quickly and smoothly through the network.

## What is the Distance Vector Routing Algorithm?

The protocol requires that a router inform its neighbors of topology changes periodically. Historically known as the old **[ARPANET](https://www.geeksforgeeks.org/arpanet-full-form/)** routing algorithm (or known as the **[Bellman-Ford algorithm](https://www.geeksforgeeks.org/bellman-ford-algorithm-simple-implementation/)**).

## Bellman-Ford Basics

Each router maintains a Distance Vector table containing the distance between itself and All possible destination nodes. Distances, based on a chosen metric, are computed using information from the neighbors’ distance vectors.

## Information kept by DV router

- Each router has an ID
- Associated with each link connected to a router,
there is a link cost (static or dynamic).
- Intermediate hops

## Distance Vector Table Initialization

- Distance to itself = 0
- Distance to ALL other routers = infinity number.

covers these protocols extensively.

## How Distance Vector Algorithm works?

- A router transmits its distance vector to each of its neighbors in a routing packet.
- Each router receives and saves the most recently received distance vector from each of its neighbors.
- A router recalculates its distance vector when:
  - It receives a distance vector from a neighbor containing different information than before.
  - It discovers that a link to a neighbor has gone down.

The DV calculation is based on minimizing the cost to each destination

Dx(y) = Estimate of least cost from x to y
C(x,v) =  Node x knows cost to each neighbor v
Dx   =  [Dx(y): y ? N ] = Node x maintains distance vector
Node x also maintains its neighbors' distance vectors
– For each neighbor v, x maintains Dv = [Dv(y): y ? N ]

Note:

From time-to-time, each node sends its own distance vector estimate to neighbors.
When a node x receives new DV estimate from any neighbor v, it saves v’s distance vector and it updates its own DV using B-F equation:
Dx(y) = min { C(x,v) + Dv(y), Dx(y) } for each node y ? N

## Example

Consider 3-routers X, Y and Z as shown in figure. Each router have their routing table. Every routing table will contain distance to the destination nodes.

![rt](https://media.geeksforgeeks.org/wp-content/uploads/DVP1.jpg)

Consider router X , X will share it routing table to neighbors and neighbors will share it routing table to it to X and distance from node X to destination will be calculated using bellmen- ford equation.

Dx(y) = min { C(x,v) + Dv(y)} for each node y ? N

As we can see that distance will be less going from X to Z when Y is intermediate node(hop) so it will be update in routing table X.

![bf](https://media.geeksforgeeks.org/wp-content/uploads/dvp2.jpg)

Similarly for Z also –

![bfc](https://media.geeksforgeeks.org/wp-content/uploads/dvp3.jpg)

Finally the routing table for all –

![bfa](https://media.geeksforgeeks.org/wp-content/uploads/dvp4.jpg)

## Applications of Distance Vector Routing Algorithm

The Distance Vector Routing Algorithm has several uses:

- Computer Networking : It helps route data packets in networks.
- Telephone Systems : It’s used in some telephone switching systems.
- Military Applications : It has been used to route missiles.

## Advantages of Distance Vector routing

- Shortest Path : Distance Vector Routing finds the shortest path for data to travel in a network.
- Usage : It is used in local, metropolitan, and wide-area networks.
- Easy Implementation : The method is simple to set up and doesn’t require many resources.

## Disadvantages of Distance Vector Routing Algorithm

- It is slower to converge than link state.
- It is at risk from the count-to-infinity problem.
- It creates more traffic than link state since a hop count change must be propagated to all routers and processed on each router. Hop count updates take place on a periodic basis, even if there are no changes in thenetwork topology , so bandwidth -wasting broadcasts still occur.
- For larger networks, distance vector routing results in larger routing tables than link state since each router must know about all other routers. This can also lead to congestion onWAN links.

## Conclusion

In conclusion, Distance Vector Routing (DVR) Protocol is a simple and efficient method for finding the shortest path for data in various types of networks. Its ease of implementation and quick adjustment to network changes make it a valuable tool for ensuring data travels quickly and efficiently. DVR Protocol helps maintain smooth network operations by constantly updating and optimizing routes.
