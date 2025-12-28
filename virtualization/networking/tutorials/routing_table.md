# **[Routing Table](https://notes.networklessons.com/routing-table)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

![lf](https://wiki.linuxfoundation.org/_media/wiki/logo.png)

The routing table is a construct within as Layer 3 network device that is used to determine the egress interface of a received packet during the process of routing. The routing table is created using one or more of the following methods:

- Directly connected routes
- Statically configured routes
- Dynamically learned routes via routing protocols such as **[EIGRP](https://notes.networklessons.com/eigrp)**, RIP, OSPF, IS-IS, and BGP.

The routing table entries consist of prefixes that correspond to next-hop IPs, exit interfaces, or both.

An example of an IPv4 routing table found within a Cisco router is the following:

```bash
PE1#show ip route
Codes: L - local, C - connected, S - static, R - RIP, M - mobile, B - BGP
       D - EIGRP, EX - EIGRP external, O - OSPF, IA - OSPF inter area
       N1 - OSPF NSSA external type 1, N2 - OSPF NSSA external type 2
       E1 - OSPF external type 1, E2 - OSPF external type 2, m - OMP
       n - NAT, Ni - NAT inside, No - NAT outside, Nd - NAT DIA
       i - IS-IS, su - IS-IS summary, L1 - IS-IS level-1, L2 - IS-IS level-2
       ia - IS-IS inter area, * - candidate default, U - per-user static route
       H - NHRP, G - NHRP registered, g - NHRP registration summary
       o - ODR, P - periodic downloaded static route, l - LISP
       a - application route
       + - replicated route, % - next hop override, p - overrides from PfR
       & - replicated local route overrides by connected

Gateway of last resort is not set

      1.0.0.0/32 is subnetted, 1 subnets
i L2     1.1.1.1 [115/20] via 192.168.12.1, 19:48:33, GigabitEthernet1
      2.0.0.0/32 is subnetted, 1 subnets
C        2.2.2.2 is directly connected, Loopback0
      3.0.0.0/32 is subnetted, 1 subnets
i L2     3.3.3.3 [115/20] via 192.168.23.3, 19:48:33, GigabitEthernet2
      4.0.0.0/32 is subnetted, 1 subnets
i L2     4.4.4.4 [115/20] via 192.168.24.4, 19:48:33, GigabitEthernet3
      5.0.0.0/32 is subnetted, 1 subnets
i L2     5.5.5.5 [115/30] via 192.168.24.4, 19:48:33, GigabitEthernet3
      6.0.0.0/32 is subnetted, 1 subnets
S        6.6.6.6 is directly connected, Tunnel1
      7.0.0.0/32 is subnetted, 1 subnets
i L2     7.7.7.7 [115/40] via 192.168.23.3, 19:48:33, GigabitEthernet2
      192.168.12.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.12.0/24 is directly connected, GigabitEthernet1
L        192.168.12.2/32 is directly connected, GigabitEthernet1
      192.168.23.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.23.0/24 is directly connected, GigabitEthernet2
L        192.168.23.2/32 is directly connected, GigabitEthernet2
      192.168.24.0/24 is variably subnetted, 2 subnets, 2 masks
C        192.168.24.0/24 is directly connected, GigabitEthernet3
L        192.168.24.2/32 is directly connected, GigabitEthernet3
i L2  192.168.36.0/24 [115/20] via 192.168.23.3, 19:48:33, GigabitEthernet2
i L2  192.168.45.0/24 [115/20] via 192.168.24.4, 19:48:33, GigabitEthernet3
i L2  192.168.56.0/24 [115/30] via 192.168.24.4, 19:48:33, GigabitEthernet3
                      [115/30] via 192.168.23.3, 19:48:33, GigabitEthernet2
i L2  192.168.67.0/24 [115/30] via 192.168.23.3, 19:48:33, GigabitEthernet2

```
