# **[An introduction to Linux virtual interfaces: Tunnels](https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

## references


- **[Linux Networking](https://www.youtube.com/@routerologyblog1111/playlists)**
## netfilter subsystem hooks
![pf](https://people.netfilter.org/pablo/nf-hooks.png)

The following hooks represent these well-defined points in the networking stack:

- **NF_IP_PRE_ROUTING:** This hook will be triggered by any incoming traffic very soon after entering the network stack. This hook is processed before any routing decisions have been made regarding where to send the packet.
- **NF_IP_LOCAL_IN:** This hook is triggered after an incoming packet has been routed if the packet is destined for the local system.
- **NF_IP_FORWARD:** This hook is triggered after an incoming packet has been routed if the packet is to be forwarded to another host.
- **NF_IP_LOCAL_OUT:** This hook is triggered by any locally created outbound traffic as soon as it hits the network stack.
- **NF_IP_POST_ROUTING:** This hook is triggered by any outgoing or forwarded traffic after routing has taken place and just before being sent out on the wire.

| Tables↓/Chains→               | PREROUTING | INPUT | FORWARD | OUTPUT | POSTROUTING |
|-------------------------------|------------|-------|---------|--------|-------------|
| (routing decision)            |            |       |         | ✓      |             |
| raw                           | ✓          |       |         | ✓      |             |
| (connection tracking enabled) | ✓          |       |         | ✓      |             |
| mangle                        | ✓          | ✓     | ✓       | ✓      | ✓           |
| nat (DNAT)                    | ✓          |       |         | ✓      |             |
| (routing decision)            | ✓          |       |         | ✓      |             |
| filter                        |            | ✓     | ✓       | ✓      |             |
| security                      |            | ✓     | ✓       | ✓      |             |
| nat (SNAT)                    |            | ✓     |         |        | ✓           |


Linux has supported many kinds of tunnels, but new users may be confused by their differences and unsure which one is best suited for a given use case. In this article, I will give a brief introduction for commonly used tunnel interfaces in the Linux kernel. There is no code analysis, only a brief introduction to the interfaces and their usage on Linux. Anyone with a network background might be interested in this information. A list of tunnel interfaces, as well as help on specific tunnel configuration, can be obtained by issuing the iproute2 command ip link help.

This post covers the following frequently used interfaces:

- IPIP Tunnel
- SIT Tunnel
- ip6tnl Tunnel
- VTI and VTI6
- GRE and GRETAP
- IP6GRE and IP6GRETAP
- FOU
- GUE
- GENEVE
- ERSPAN and IP6ERSPAN

After reading this article, you will know what these interfaces are, the differences between them, when to use them, and how to create them.

## IPIP Tunnel
IPIP tunnel, just as the name suggests, is an IP over IP tunnel, defined in RFC 2003. The IPIP tunnel header looks like:

![i](https://developers.redhat.com/blog/wp-content/uploads/2019/03/ipip.png)

It's typically used to connect two internal IPv4 subnets through public IPv4 internet. It has the lowest overhead but can only transmit IPv4 unicast traffic. That means you cannot send multicast via IPIP tunnel.

IPIP tunnel supports both IP over IP and MPLS over IP.

Note: When the ipip module is loaded, or an IPIP device is created for the first time, the Linux kernel will create a tunl0 default device in each namespace, with attributes local=any and remote=any. When receiving IPIP protocol packets, the kernel will forward them to tunl0 as a fallback device if it can't find another device whose local/remote attributes match their source or destination address more closely.

Here is how to create an IPIP tunnel:

On Server A:

```bash
# ip link add name ipip0 type ipip local LOCAL_IPv4_ADDR remote REMOTE_IPv4_ADDR
# ip link set ipip0 up
# ip addr add INTERNAL_IPV4_ADDR/24 dev ipip0
```

Add a remote internal subnet route if the endpoints don't belong to the same subnet
```bash
# ip route add REMOTE_INTERNAL_SUBNET/24 dev ipip0
```

On Server B:

```bash
# ip link add name ipip0 type ipip local LOCAL_IPv4_ADDR remote REMOTE_IPv4_ADDR
# ip link set ipip0 up
# ip addr add INTERNAL_IPV4_ADDR/24 dev ipip0
# ip route add REMOTE_INTERNAL_SUBNET/24 dev ipip0
```

Note: Please replace LOCAL_IPv4_ADDR, REMOTE_IPv4_ADDR, INTERNAL_IPV4_ADDR, REMOTE_INTERNAL_SUBNET to the addresses based on your testing environment. The same with following example configs.

...

