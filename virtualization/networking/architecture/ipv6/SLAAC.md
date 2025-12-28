# SLAAC

## references

<https://www.networkacademy.io/ccna/ipv6/stateless-address-autoconfiguration-slaac>

## IPv6 Stateless Address Auto-configuration (SLAAC)

Each IPv6 node on the network needs a globally unique address to communicate outside its local segment. But where a node get such an address from? There are a few options:

- Manual assignment - Every node can be configured with an IPv6 address manually by an administrator. It is not a scalable approach and is prone to human error.  
- DHCPv6 (The Dynamic Host Configuration Protocol version 6) - The most widely adopted protocol for dynamically assigning addresses to hosts. Requires a DHCP server on the network and additional configuration.
- SLAAC (Stateless Address Autoconfiguration) -  It was designed to be a simpler and more straight-forward approach to IPv6 auto-addressing. In its current implementation as defined in RFC 4862, SLAAC does not provide DNS server addresses to hosts and that is why it is not widely adopted at the moment.

In this lesson, we are going to learn how SLAAC works and what are the pros and cons of using it in comparison to DHCPv6.

## What is SLAAC?

SLAAC stands for Stateless Address Autoconfiguration and the name pretty much explains what it does. It is a mechanism that enables each host on the network to auto-configure a unique IPv6 address without any device keeping track of which address is assigned to which node.

Stateless and Stateful in the context of address assignment mean the following:

A stateful address assignment involves a server or other device that keeps track of the state of each assignment. It tracks the address pool availability and resolves duplicated address conflicts. It also logs every assignment and keeps track of the expiration times.
Stateless address assignment means that no server keeps track of what addresses have been assigned and what addresses are still available for an assignment. Also in the stateless assignment scenario, nodes are responsible to resolve any duplicated address conflicts following the logic: Generate an IPv6 address, run the Duplicate Address Detection (DAD), if the address happens to be in use, generate another one and run DAD again, etc.

## How does SLAAC work?

To fully understand how the IPv6 auto-addressing work, let's follow the steps an IPv6 node takes from the moment it gets connect to the network to the moment it has a unique global unicast address.
