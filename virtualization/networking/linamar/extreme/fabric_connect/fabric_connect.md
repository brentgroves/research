# **[Fabric Connect](https://en.wikipedia.org/wiki/Fabric_Connect)**

**[Back to Research List](../../../../`research_list.md)**\
**[Back to Current Status](../../../../../a_status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

Fabric Connect, in computer networking usage, is the name used by Extreme Networks to market an extended implementation of the IEEE 802.1aq and IEEE 802.1ah-2008 standards.

The Fabric Connect technology was originally developed by the Enterprise Solutions R&D department within Nortel Networks. In 2009, Avaya, Inc acquired Nortel Networks Enterprise Business Solutions; this transaction included the Fabric Connect intellectual property together with all of the Ethernet Switching platforms that supported it.[1] Subsequently, the Fabric Connect technology became part of the Extreme Networks portfolio by virtue of their 2017 purchase of the Avaya Networking business and assets.[2] It was during the Avaya era that this technology was promoted as the lead element of the Virtual Enterprise Network Architecture (VENA).[3]

For their part, Extreme Networks stated that acquiring the Avaya Networking assets and more specifically the "Award-Winning Fabric Technology...strengthens extreme's position as a leader across the education, healthcare and government markets".[4]

## Fabric Connect
Fabric Connect's aim is to provide network-wide, end-to-end, multi-layer virtualization. A network virtualization capability, based on an enhanced implementation of the IEEE 802.1aq Shortest Path Bridging (SPB) standard, Fabric Connect offers the ability to create a simplified network that can dynamically virtualize elements to efficiently provision and utilize resources, thus reducing the strain on the network and personnel. Extreme Networks base the Fabric Connect technology on the SPB standard, including support for RFC 6329,[5] and have integrated IP Routing and IP Multicast[6] support; this unified technology allows for the replacement of multiple conventional protocols such as Spanning Tree, RIP and/or OSPF, ECMP, and PIM.

## Fabric Attach
An adjunct to the Fabric Connect technology, Fabric Attach allows network operators to extend network virtualization directly into conventional wiring closets (using existing non-Fabric Ethernet switches) and automate the provisioning of devices to their appropriate virtual network. This is particularly relevant for the mass of unattended network end-point that are now appearing, such as IP Phones, Wireless Access Points, and IP Cameras. Fabric Attach standardized protocols such as 802.1AB LLDP to exchange credentials and obtain provisioning information that allows "Client" Switches to be automatically re-configured on the fly with parameters that let Traffic Flows Map through to Fabric Connect Edge Switches (aka "Backbone Edge Bridge" in SPB definition) functioning as a Fabric Attach "Server" Switch. This method is described by an IETF "Internet Draft",[7] pending further standardization activity. Fabric Attach is typically used to automate Wiring Closet connectivity, but has the potential to be extensible for use in the Data Center, with Virtual Machines being able to dynamically request VLAN/VSN (Virtual Service Network) assignment based upon application requirements.[8]


