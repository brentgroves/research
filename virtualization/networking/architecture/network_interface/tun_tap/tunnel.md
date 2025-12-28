# **[Tunneling](https://wiki.linuxfoundation.org/networking/tunneling)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![lf](https://wiki.linuxfoundation.org/_media/wiki/logo.png)

Tunneling is a way to transform data frames to allow them pass networks with incompatible address spaces or even incompatible protocols. There are different kinds of tunnels: some process only IPv4 packets and some can carry any type of frame. Linux kernel supports 3 tunnel types: IPIP (IPv4 in IPv4), GRE (IPv4/IPv6 over IPv4) and SIT (IPv6 over IPv4). Tunnels are managed with ip program, part of Iproute2:

Iproute2 is usually shipped with documentation, of which you need the file ip-tunnels.ps to learn about tunnel management. In Fedora Core 4 it is /usr/share/doc/iproute-2.6.11/ip-tunnels.ps.

```bash
ls /usr/share/doc/iproute2 
changelog.Debian.gz  copyright  README.Debian
```

## IPIP tunnels

IPIP kind of tunnels is the simplest one. It has the lowest overhead, but can incapsulate only IPv4 unicast traffic, so you will not be able to setup OSPF, RIP or any other multicast-based protocol. You can setup only one tunnel for unique tunnel endpoints pair. It can work with FreeBSD and cisco IOS. Kernel module is 'ipip'. The following example demonstrates configuration of IPIP tunnel with four IPv4 routes, manually or via /etc/net.

## What is Cisco IOS (Cisco Internetwork Operating System)?

Cisco IOS (Internetwork Operating System) is a collection of proprietary operating systems (OSes) that run on Cisco Systems hardware, including routers, switches and other network devices.

Developed in the 1980s by William Yeager, an engineer at Stanford University, the core function of Cisco IOS is to enable data communications between network nodes. Cisco IOS enables the administration, operation and management of Cisco network devices.

## Unicast

Unicast is one-to-one traffic, such as a client surfing the Web. Multicast is one-to-many, and the “many” is preselected. Broadcast is one-to-all on a LAN. Multicast traffic uses “Class D” addresses when used over IPv4

## **[OSPF](https://www.geeksforgeeks.org/open-shortest-path-first-ospf-protocol-fundamentals/)**

Open Shortest Path First (OSPF) is a routing protocol that finds the most efficient path for data packets to travel between routers on an IP network. It's a key protocol in large-scale networks and is part of the Internet Protocol (IP) suite

Open shortest path first (OSPF) is a link-state routing protocol that is used to find the best path between the source and the destination router using its own shortest path first (SPF) algorithm. A link-state routing protocol is a protocol that uses the concept of triggered updates, i.e., if there is a change observed in the learned routing table then the updates are triggered only, not like the distance-vector routing protocol where the routing table is exchanged at a period of time.

Open shortest path first (OSPF) is developed by Internet Engineering Task Force (IETF) as one of the Interior Gateway Protocols (IGP), i.e., the protocol which aims at moving the packet within a large autonomous system or routing domain. It is a network layer protocol that works on protocol number 89 and uses AD value 110. OSPF uses multicast address 224.0.0.5 for normal communication and 224.0.0.6 for updating to the designated router (DR)/Backup Designated Router (BDR).
