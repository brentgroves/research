# **[Introduction to Routers and routing](https://networklessons.com/cisco/ccna-200-301/introduction-to-routers-and-routing)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

![lf](https://wiki.linuxfoundation.org/_media/wiki/logo.png)

In this lesson, we will take a look at the difference between switches and routers and I’ll explain to you the basics of routing.

First of all…what is a router or what is routing exactly? A switch “switches” and a router “routes,” but what does this exactly mean?

We have seen switches and you have learned that they “switch” based on MAC address information. The only concern for our switch is to know when an Ethernet frame enters one of its interfaces where it should send this Ethernet frame by looking at the destination MAC address. Switches make decisions based on Data Link layer information (layer 2).

Routers have a similar task but this time we are going to look at IP packets and as you might recall IP is on the Network layer (layer 3). Routers look at the destination IP address in an IP packet and send it out to the correct interface.

Maybe you are thinking…what is the big difference here? Why don’t we use MAC addresses everywhere and switch? Why do we need to look at IP addresses and route them? Both MAC addresses and IP addresses are unique per network device. Good question, and I’m going to show you a picture to answer this:

![mvi](https://networklessons.com/wp-content/uploads/2013/02/400-computers-2-switches.png)

We have two switches and to each switch are 200 computers connected. Now, if all 400 computers want to communicate with each switch, has to learn 400 MAC addresses. They need to know the MAC addresses of the computers on the left and right sides.

Now think about a really large network…for example, the Internet. There are millions of devices! Would it be possible to have millions of entries in your MAC-address table? For each device on the Internet? No way! The problem with switching is that it’s not scalable; we don’t have any hierarchy, just flat 48-bit MAC addresses. Let’s look at the same example, but now we are using routers.

![rt](https://networklessons.com/wp-content/uploads/2013/02/400-computers-2-routers.png)

What we have here is our 200 computers on the left are connected to R1 and in the 192.168.1.0 /24 network. R2 has 200 computers behind it, and the network we use over there is 192.168.2.0 /24. Routers “route” based on IP information. In our example, R1 only has to know that network 192.168.2.0 /24 is behind R2. R2 only needs to know that the 192.168.1.0 /24 network is behind R1. Are you following me here?

Instead of having a MAC address table with 400 MAC addresses we now only need a single entry on each router for each other’s networks. Switches use mac address tables to forward Ethernet frames, and routers use a routing table to learn where to forward IP packets to. As soon as you take a brand new router out of the box, It will build a routing table, but the only information you’ll find is the directly connected interfaces. Let’s start with a simple example:

![nrt](https://networklessons.com/wp-content/uploads/2013/02/routing-table-1.png)

Above we have one router and two computers:

- H1 has IP address 192.168.1.1 and has configured IP address 192.168.1.254 as its default gateway.
- H2 has IP address 192.168.2.2 and has configured IP address 192.168.2.254 as its default gateway.
- On our router, we have configured IP address 192.168.1.254 on interface FastEthernet 0/0 and IP address 192.168.2.254 on interface FastEthernet 1/0.
- Since we also configured a subnet mask with the IP addresses, our router knows the network addresses and will store these in its routing table.
