# **[Full Mesh Network for Ceph Server](https://pve.proxmox.com/wiki/Full_Mesh_Network_for_Ceph_Server)**

## **[mesh network](https://en.wikipedia.org/wiki/Mesh_networking)**

A mesh network is a local area network topology in which the infrastructure nodes (i.e. bridges, switches, and other infrastructure devices) connect directly, dynamically and non-hierarchically to as many other nodes as possible and cooperate with one another to efficiently route data to and from clients.

Basic principles
Mesh networks can relay messages using either a flooding or a routing technique, which makes them different from non-mesh networks.[3] A routed message is propagated along a path by hopping from node to node until it reaches its destination. To ensure that all its paths are available, the network must allow for continuous connections and must reconfigure itself around broken paths, using self-healing algorithms such as Shortest Path Bridging and TRILL (Transparent Interconnection of Lots of Links). Self-healing allows a routing-based network to operate when a node breaks down or when a connection becomes unreliable. The network is typically quite reliable, as there is often more than one path between a source and a destination in the network. Although mostly used in wireless situations, this concept can also apply to wired networks and to software interaction.

A mesh network whose nodes are all connected to each other is a fully connected network. Fully connected wired networks are more secure and reliable: problems in a cable affect only the two nodes attached to it. In such networks, however, the number of cables, and therefore the cost, goes up rapidly as the number of nodes increases.

Types
Wired mesh
Shortest path bridging and TRILL each allow Ethernet switches to be connected in a mesh topology and allow for all paths to be active.[4][5] IP routing supports multiple paths from source to destination.

Wireless mesh
Main article: Wireless mesh network
A wireless mesh network (WMN) is a network made up of radio nodes organized in a mesh topology. It can also be a form of wireless ad hoc network.[6]

## Introduction

This wiki page describes how to configure a three node "Meshed Network" Proxmox VE (or any other Debian based Linux distribution), which can be, for example, used for connecting Ceph Servers or nodes in a Proxmox VE Cluster with the maximum possible bandwidth and without using a switch. We recommend to use switches for clusters larger than 3 nodes or if a 3 node cluster should be expanded in the future.

The big advantage of this setup is that you can achieve a fast network connection between the nodes (10, 25, 40 or 100Gbit/s) WITHOUT buying expensive switches which can handle these fast speeds.

You need at least two available NICs in each server which each connect to one of the other servers.

            ┌───────┐
       ┌────┤ Node1 ├────┐
       │    └───────┘    │
   ┌───┴───┐         ┌───┴───┐
   │ Node2 ├─────────┤ Node3 │
   └───────┘         └───────┘

There are a few possible ways to set up such a network:

- Routed (with fallback): Each packet is sent to the addressed node only. If the direct connection is down, the packets will be routed via the node in between.
- Routed (simple): Each packet is sent to the addressed node only
- RSTP: A loop with the rapid spanning tree protocol enabled
Broadcast: Each packet is sent to both other nodes

Each setup has benefits and caveats. The simple routed one does not need any additional software and delivers the best performance. The routed with fallback approach delivers similar performance but can handle the loss of one connection in the mesh by routing the traffic via the middle node. Because of this, performance could be impacted in such a scenario.

The RSTP setup gives you similar fault tolerance as the routed setup with fallback. If the loop is complete, RSTP will create an artificial cut-off between two nodes, e.g. between Node 1 and Node 3. This means, Node 2 is in between Node 1 and 3 and the traffic between Node 1 and Node 3 is going via Node 2. Should a cable or NIC fail somewhere else, for example between Node 1 and Node 2, RSTP will remove the cut-off within a few seconds. Node 3 is now in between Node 1 and 2 and has to handle that traffic as well. Once the broken part has been replaced and the loop if complete again, RSTP will introduce another artificial cut-off.

The advantage of the broadcast method is an easier setup process, but it will send all data to both other nodes, using up more bandwidth.

## Failure Scenarios

Loss of a Node
            ┌───────┐
       ┌────┤ Node1 ├────┐
       │    └───────┘    │
   ┌───┴───┐         ┌───┴───┐
   │ Node2 ├─────────┤ XXXXX │
   └───────┘         └───────┘
If a node is going down, for example Node 3, the Ceph and Proxmox VE cluster will remain functioning, though with reduced redundancy.

Loss of a Connection
            ┌───────┐
       ┌────┤ Node1 ├────┐
       │    └───────┘    X
   ┌───┴───┐         ┌───┴───┐
   │ Node2 ├─────────┤ Node3 │
   └───────┘         └───────┘
If one of the connections is failing, for example between Node 1 and Node 3, the resulting behavior depends on the chosen setup variant. For the RSTP and Routed (with fallback), everything will stay functioning. With RSTP it might take a short moment for it to remove the artificial cut-off. With a bit of luck, the artificial cut-off was exactly at the failed connection. When using the Routed (with fallback) setup, the traffic that used to go directly between Node 1 and Node 3 will now be routed via Node 2, resulting in a bit higher latency. This can have a bit of an impact on performance, but the cluster will stay fully functional.

For the Broadcast and Routed (simple) setups, such a situation is more problematic, because the nodes now have a different view, Node 2 can communicate with Node 3, while that is not possible for Node 1 anymore. You will see behavior such as Ceph showing the services on Node 3 to be down. To reduce the chances of a failed connection, you could combine the Broadcast and Routed (simple) with a bond to increase fault tolerance at the cost of more NICs and cables.

## Example

3 servers:

- Node1 with IP addresses x.x.x.50
- Node2 with IP addresses x.x.x.51
- Node3 with IP addresses x.x.x.52

3 to 4 Network ports in each server:

- ens18, ens19 will be used for the actual full mesh. Physical direct connections to the other two servers, 10.15.15.y/24
- ens20 connection to WAN (internet/router), using at vmbr0 192.168.2.y
- ens21 (optional) LAN (for Proxmox VE cluster traffic, etc.) 10.14.14.y

Direct connections between servers:

Node1/ens18 - Node2/ens19
Node2/ens18 - Node3/ens19
Node3/ens18 - Node1/ens19

Please adapt the NIC names and IP addresses according to your situation.

                    ┌───────────┐
                    │   Node1   │
                    ├─────┬─────┤
                    │ens18│ens19│
                    └──┬──┴──┬──┘
                       │     │
┌───────┬─────┐        │     │        ┌─────┬───────┐
│       │ens19├────────┘     └────────┤ens18│       │
│ Node2 ├─────┤                       ├─────┤ Node3 │
│       │ens18├───────────────────────┤ens19│       │
└───────┴─────┘                       └─────┴───────┘

Routed Setup (with Fallback)
We can make use of the OpenFabric protocoll which is a routing protocol derived from IS-IS, providing link-state routing. **[FRR](https://frrouting.org/)** has a working implementation.

Yellowpin.svg Note: This will not work in combination with the EVPN functionality from the Proxmox VE SDN as it will overwrite our FRR configuration
Yellowpin.svg Note: If you install Ceph afterwards, you will have to do the initial Ceph configuration on the command line
First install FRR:

`apt install frr`

/etc/frr/daemons
Enable the OpenFabric daemon by changing the line in /etc/frr/daemons to "yes":

[...]
fabricd=yes
[...]
/etc/frr/frr.conf
In this config file, 3 parameters need to be changed for each node:

hostname
IP address
NET
The IP addresses, in our example, are the ones in the 10.15.15.y/24 network.

The System ID in the NET (network entity title) needs to be unique. For example we can use the following ones for the three nodes:

49.0001.1111.1111.1111.00
49.0001.2222.2222.2222.00
49.0001.3333.3333.3333.00

By configuring very short interval times, we can achieve almost instantaneous failover.
