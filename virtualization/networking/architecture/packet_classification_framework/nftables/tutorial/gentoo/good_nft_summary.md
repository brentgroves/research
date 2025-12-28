# **[nftable chains](https://wiki.gentoo.org/wiki/Nftables#:~:text=Chains%20are%20grouped%20in%20base,see%20any%20traffic%20by%20default.)**

## Introduction

As with the iptables framework, nftables is built upon rules which specify actions. These rules are attached to chains. A chain can contain a collection of rules and is registered in the netfilter hooks. Chains are stored inside tables. A table is specific for one of the layer 3 protocols. One of the main differences with iptables is that there are no predefined tables and chains anymore.

Both iptables and nftables use the Netfilter framework. Because iptables does not allow for the manual configuration of hooks - the default tables are used for tapping into the Netfilter framework, while nftables requires the hooks to be defined inside of user-defined chains. Iptables also does not support dual stack (inet) configurations or netdev. Other than these differences, they are functionally identical, acting as interfaces for Netfilter.

## Tables

A table is a container for chains. Unlike iptables, nftables has no predefined tables (filter, raw, mangle...). An iptables-like structure can be used, but this is not required. Tables must be defined with an address family and name, which can be anything.

The address families used by nftables are documented under man nft 8:

| Address family | Description                                                         |
|----------------|---------------------------------------------------------------------|
| ip             | Used for IPv4 related chains.                                       |
| ip6            | Used for IPv6 related chains.                                       |
| inet           | Mixed IPv4/IPv6 chains (kernel 3.14 and up).                        |
| arp            | Used for ARP related chains.                                        |
| bridge         | Used for bridging related chains.                                   |
| netdev         | Used for chains that filter early in the stack (kernel 4.2 and up). |

If a family is not specified, ip is used.

## Chains

Chains are used to group rules. As with the tables, nftables does not have any predefined chains. Chains are grouped in base and non-base types. Base chains are registered in one of the netfilter hooks, non-base chains are not. base chains must be defined with a hook type, and priority. In contrast, non-base chains are not attached to a hook and they don't see any traffic by default. They can be used as jump targets to arrange a rule-set in a tree of chains.

The chains used by nftables are documented under man nft 8:

| Chain  | Families     | Hooks                                  | Description                                                                                                          |
|--------|--------------|----------------------------------------|----------------------------------------------------------------------------------------------------------------------|
| filter | all          | all                                    | Standard chain, generally used for filtering.                                                                        |
| nat    | ip, ip6, nat | prerouting, input, output, postrouting | Used to perform Native Address Translation using conntrack. Only the first packet of a connection uses this chain.   |
| route  | ip, ip6      | output                                 | Packets that traverse this chain type, if about to be accepted, trigger a route lookup if the IP header has changed. |
