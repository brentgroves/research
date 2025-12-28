# **[Spanning Tree Protocol (STP)](https://www.techtarget.com/searchnetworking/definition/spanning-tree-protocol)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

Spanning Tree Protocol (STP), standardized as IEEE 802.1D, is a networking protocol used to prevent loops in Ethernet networks, ensuring a stable and reliable network by blocking redundant paths and ensuring a loop-free logical topology.

Loop Prevention:
The primary function of STP is to identify and prevent loops in a network topology, which can lead to broadcast storms and network instability.

Network Redundancy:
STP allows for redundant links in a network, providing fault tolerance and increased resilience, while still ensuring a loop-free topology.

## Layer 2 Protocol

STP operates at Layer 2 of the OSI model, focusing on the physical network topology and switch behavior.

## Root Bridge Election

STP selects a single switch as the "root bridge" for the network, which acts as the central point for determining the shortest paths.
