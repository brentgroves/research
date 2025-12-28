# **[](https://docs.ovn.org/en/latest/tutorials/ovn-interconnection.html)**

OVN Interconnection
This document provides a guide for interconnecting multiple OVN deployements with OVN managed tunneling. More details about the OVN Interconnectiong design can be found in ovn-architecture(7) manpage.

This document assumes two or more OVN deployments are setup and runs normally, possibly at different data-centers, and the gateway chassises of each OVN are with IP addresses that are reachable between each other.

Setup Interconnection Databases
To interconnect different OVNs, you need to create global OVSDB databases that store interconnection data. The databases can be setup on any nodes that are accessible from all the central nodes of each OVN deployment. It is recommended that the global databases are setup with HA, with nodes in different avaialbility zones, to avoid single point of failure.
