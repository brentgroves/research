# **[nftable families](https://wiki.nftables.org/wiki-nftables/index.php/Nftables_families)**

family refers to a one of the following table types: ip, arp, ip6, bridge, inet, netdev. It defaults to ip.

Netfilter enables filtering at multiple networking levels. With iptables there is a separate tool for each level: iptables, ip6tables, arptables, ebtables. With nftables the multiple networking levels are abstracted into families, all of which are served by the single tool nft.

Please note that what traffic/packets you see and at which point in the network stack depends on the hook you are using.

Following are descriptions of current nftables families. Additional families may be added in the future.

**ip**\
Tables of this family see IPv4 traffic/packets. The iptables tool is the legacy x_tables equivalent.

**ip6**\
Tables of this family see IPv6 traffic/packets. The ip6tables tool is the legacy x_tables equivalent.

**inet**\
Tables of this family see both IPv4 and IPv6 traffic/packets, simplifying dual stack support.

Within a table of inet family, both IPv4 and IPv6 packets traverse the same rules. Rules for IPv4 packets don't affect IPv6 packets and vice-versa. Rules for both layer 3 protocols affect both. Use meta l4proto l4proto to match on the layer 4 protocol, regardless of whether the packet is IPv4 or IPv6.

## Examples

```bash
# This rule affects only IPv4 packets:
add rule inet filter input ip saddr 1.1.1.1 counter accept

# This rule affects only IPv6 packets:
add rule inet filter input ip6 daddr fe00::2 counter accept

# These rules affect both IPv4 and IPv6 packets:
add rule inet filter input ct state established,related counter accept
add rule inet filter input udp dport 53 accept
```

New in nftables 0.9.7 and Linux kernel 5.10 is the inet family ingress hook, which filters at the same location as the netdev ingress hook.

## arp

Tables of this family see ARP-level (i.e, L2) traffic, before any L3 handling is done by the kernel. The arptables tool is the legacy x_tables equivalent.

## bridge

Tables of this family see traffic/packets traversing bridges (i.e. switching). No assumptions are made about L3 protocols.

The ebtables tool is the legacy x_tables equivalent. Some old x_tables modules such as physdev will also eventually be served from the nftables bridge family.

Note that there is no nf_conntrack integration for the nftables bridge family.

## netdev

The netdev family is different from the others in that it is used to create base chains attached to a single network interface. Such base chains see all network traffic on the specified interface, with no assumptions about L2 or L3 protocols. Therefore you can filter ARP traffic from here. There is no legacy x_tables equivalent to the netdev family.

The principal (only?) use for this family is for base chains using the ingress hook, new in Linux kernel 4.2. Such ingress chains see network packets just after the NIC driver passes them up to the networking stack. This very early location in the packet path is ideal for dropping packets associated with DDoS attacks. Dropping packets from an ingress chain is twice as efficient as doing so from a prerouting chain. (Do note that in an ingress chain, fragmented datagrams have not yet been reassembled. So, for example, matching ip saddr and daddr works for all ip packets, but matching L4 headers like udp dport works only for unfragmented packets, or the first fragment.)

The ingress hook provides an alternative to tc ingress filtering. You still need tc for traffic shaping/queue management.

You can also use the ingress hook for load balancing, including Direct Server Return (DSR), that has been reported to be 10x faster.
