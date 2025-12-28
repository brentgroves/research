# **[Link aggregation](https://en.wikipedia.org/wiki/Link_aggregation#:~:text=family%20of%20standards.-,Link%20Aggregation%20Control%20Protocol,device%20that%20also%20implements%20LACP.)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

In computer networking, link aggregation is the combining (aggregating) of multiple network connections in parallel by any of several methods. Link aggregation increases total throughput beyond what a single connection could sustain, and provides redundancy where all but one of the physical links may fail without losing connectivity. A link aggregation group (LAG) is the combined collection of physical ports.

Other umbrella terms used to describe the concept include trunking,[1] bundling,[2] bonding,[1] channeling[3] or teaming.

Implementation may follow vendor-independent standards such as Link Aggregation Control Protocol (LACP) for Ethernet, defined in IEEE 802.1AX or the previous IEEE 802.3ad, but also proprietary protocols.

Link aggregation increases the bandwidth and resilience of Ethernet connections.

Bandwidth requirements do not scale linearly. Ethernet bandwidths historically have increased tenfold each generation: 10 Mbit/s, 100 Mbit/s, 1000 Mbit/s, 10000 Mbit/s. If one started to bump into bandwidth ceilings, then the only option was to move to the next generation, which could be cost prohibitive. An alternative solution, introduced by many of the network manufacturers in the early 1990s, is to use link aggregation to combine two physical Ethernet links into one logical link. Most of these early solutions required manual configuration and identical equipment on both sides of the connection.[4]

There are three single points of failure inherent to a typical port-cable-port connection, in either a computer-to-switch or a switch-to-switch configuration: the cable itself or either of the ports the cable is plugged into can fail. Multiple logical connections can be made, but many of the higher level protocols were not designed to fail over completely seamlessly. Combining multiple physical connections into one logical connection using link aggregation provides more resilient communications.
