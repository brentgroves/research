# **[Ethernet Bridging](https://openvpn.net/community-resources/ethernet-bridging/)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

Ethernet Bridging
Ethernet bridging essentially involves combining an ethernet interface with one or more virtual TAP interfaces and bridging them together under the umbrella of a single bridge interface. Ethernet bridges represent the software analog to a physical ethernet switch. The ethernet bridge can be thought of as a kind of software switch which can be used to connect multiple ethernet interfaces (either physical or virtual) on a single machine while sharing a single IP subnet.

By bridging a physical ethernet NIC with an OpenVPN-driven TAP interface at two separate locations, it is possible to logically merge both ethernet networks, as if they were a single ethernet subnet.
