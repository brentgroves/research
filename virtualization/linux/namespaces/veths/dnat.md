# **["Destination NAT"](http://linux-ip.net/html/nat-dnat.html)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\
**[Main](../../../../../../README.md)**

## AI Overview: what is RFC 1918 network

RFC 1918 defines the private IP address ranges (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16) that are reserved for use within private networks and are not routable on the public internet.

## 5.5. Destination NAT with netfilter (DNAT)

Destination NAT with netfilter is commonly used to publish a service from an internal RFC 1918 network to a publicly accessible IP. To enable DNAT, at least one iptables command is required. The connection tracking mechanism of netfilter will ensure that subsequent packets exchanged in either direction (which can be identified as part of the existing DNAT connection) are also transformed.

In a devilishly subtle difference, netfilter DNAT does not cause the kernel to answer ARP requests for the NAT IP, where iproute2 NAT automatically begins answering ARP requests for the NAT IP.

Example 5.5. Using DNAT for all protocols (and ports) on one IP

```bash
iptables -t nat -A PREROUTING -d 10.10.20.99 -j DNAT --to-destination 10.10.14.2
```

In this example, all packets arriving on the router with a destination of 10.10.20.99 will depart from the router with a destination of 10.10.14.2.

Example 5.6. Using DNAT for a single port

```bash
iptables -t nat -A PREROUTING -p tcp -d 10.10.20.99 --dport 80 -j DNAT --to-destination 10.10.14.2
```

Full network address translation, as performed with iproute2 can be simulated with both netfilter SNAT and DNAT, with the potential benefit (and attendent resource consumption) of connection tracking.

Example 5.7. Simulating full NAT with SNAT and DNAT

```bash
iptables -t nat -A PREROUTING -d 205.254.211.17 -j DNAT --to-destination 192.168.100.17
iptables -t nat -A POSTROUTING -s 192.168.100.17 -j SNAT --to-destination 205.254.211.17
```
