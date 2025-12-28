# Network packet Journey

- Client uses name servers to determine IP address of destination service
- Client sends network packet to IP address
- Networking devices route network packet to destination network using routing protocals such as:
  - Routing Information Protocol (RIP)
  - Interior Gateway Protocol (IGRP)
  - Open Shortest Path First (OSPF)
  - Exterior Gateway Protocol (EGP)
  - Enhanced Interior Gateway Routing Protocol (EIGRP)
  - Border Gateway Protocol (BGP)
  - Intermediate System-to-Intermediate System (IS-IS)
- Once the network packet has arrived at the destination network the network routing device uses the ARP protocol/table to determine the HW address of the network interface that is assigned to the destination IP address.
- Once the HW (MAC) address is known the network routing can also use MAC tables to determine the port of layer 2 switch in which the network interface device is attached to.
- Once the network packet arrives on the destination host's kernel via the network interface device then it's firewall determines whether to accept/reject/forward the network packet to the network socket.
