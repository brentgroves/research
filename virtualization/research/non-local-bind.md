# **[non-local bind](https://www.cyberciti.biz/faq/linux-bind-ip-that-doesnt-exist-with-net-ipv4-ip_nonlocal_bind/)**

## Linux bind IP that doesn’t exist with net.ipv4.ip_nonlocal_bind

How do I allow Linux processes to bind to IP address that doesn’t exist yet on my Linux systems or server?

You need to set up net.ipv4.ip_nonlocal_bind and net.ipv6.ip_nonlocal_bind, which allows processes to bind() to non-local IP addresses, which can be quite useful for application such as load balancer such as Nginx, HAProxy, keepalived, WireGuard, OpenVPN and others. This page explains how to bind IP address that doesn’t exist with net.ipv4.ip_nonlocal_bind and net.ipv6.ip_nonlocal_bind Linux kernel option.

## Why use net.ipv4.ip_nonlocal_bind under Linux operating systems?

HAProxy acts as a load balancer (LB) and a proxy server for TCP and HTTP-based applications. Similarly, Keepalived software provides High-Availability (HA) and Load Balancing features for Linux using VRRP protocol. It acts as an IP failover (Virtual IP) software to route traffic to the correct backend. We can combine HAProxy (or Nginx) along with Keepalived to build a two-node high availability cluster for our applications.

**HAProxy** is a free and open source software that provides a high availability load balancer and Proxy for TCP and HTTP-based applications that spreads requests across multiple servers. It is written in C and has a reputation for being fast and efficient.

The **Virtual Router Redundancy Protocol (VRRP)** is a computer networking protocol that provides for automatic assignment of available Internet Protocol (IP) routers to participating hosts. This increases the availability and reliability of routing paths via automatic default gateway selections on an IP subnetwork.

The protocol achieves this by the creation of virtual routers, which are an abstract representation of multiple routers, i.e. primary/active and secondary/Standby routers, acting as a group. The virtual router is assigned to act as a default gateway of participating hosts, instead of a physical router. If the physical router that is routing packets on behalf of the virtual router fails, another physical router is selected to automatically replace it. The physical router that is forwarding packets at any given time is called the primary/active router.

VRRP provides information on the state of a router, not the routes processed and exchanged by that router. Each VRRP instance is limited, in scope, to a single subnet. It does not advertise IP routes beyond that subnet or affect the routing table in any way. VRRP can be used in Ethernet, MPLS and Token Ring networks with Internet Protocol Version 4 (IPv4), as well as IPv6.
