# **[Adaption of iptables Tutorial: A Beginner's Guide to the Linux Firewall](https://phoenixnap.com/kb/iptables-linux)**


**[Back to Research List](../../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../../README.md)**

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

## Replace iptables commands

Replace all iptables commands in this iptables tutorial with their xtables-nft counterparts.

The xtables-nft set is composed of several commands:

- iptables-nft
- iptables-nft-save
- iptables-nft-restore
- ip6tables-nft
- ip6tables-nft-save
- ip6tables-nft-restore
- arptables-nft
- ebtables-nft

These tools use the libxtables framework extensions and hook to the nf_tables kernel subsystem using the nft_compat module.

USAGE
The xtables-nft tools allow you to manage the nf_tables backend using the native syntax of iptables(8), ip6tables(8), arptables(8), and ebtables(8).
You should use the xtables-nft tools exactly the same way as you would use the corresponding original tools.

Adding a rule will result in that rule being added to the nf_tables kernel subsystem instead. Listing the ruleset will use the nf_tables backend as well.

## Start of iptables tutorial

All modern operating systems come with a firewall, an application that regulates network traffic to and from a computer. Firewalls use rules to control incoming and outgoing traffic, creating a network security layer.

iptables is the primary firewall utility program developed for Linux systems. The program enables system administrators to define rules and policies for filtering network traffic.

In this tutorial, learn how to install, configure, and use iptables in Linux.

## Prerequisites

- A user account with sudo privileges.
- Access to a terminal window/command line.


## What Is iptables?

iptables is a command-line utility for configuring the built-in Linux kernel firewall. It enables administrators to define chained rules that control incoming and outgoing network traffic.

The rules provide a robust security mechanism, defining which network packets can pass through and which should be blocked. iptables protects Linux systems from data breaches, unauthorized access, and other network security threats.

Administrators use iptables to enforce network security policies and protect a Linux system from various network-based attacks.

## How Does iptables Work?

iptables uses rules to determine what to do with a network packet. The utility consists of the following components:

- Tables. Tables are files that group similar rules. A table consists of several rule chains.
- Chains. A chain is a string of rules. When a packet is received, iptables finds the appropriate table and filters it through the rule chain until it finds a match.
- Rules. A rule is a statement that defines the conditions for matching a packet, which is then sent to a target.
- Targets. A target is a decision of what to do with a packet. The packet is either accepted, dropped, or rejected.

The sections below cover each of these components in greater depth.

## Tables

Linux firewall iptables have four default tables that manage different rule chains:

- **Filter** The default packet filtering table. It acts as a gatekeeper that decides which packets enter and leave a network.
- **Network Address Translation (NAT)**. Contains NAT rules for routing packets to remote networks. It is used for packets that require alterations.
- **Mangle**. Adjusts the IP header properties of packets.
- **Raw**. Exempts packets from connection tracking.
- Some Linux distributions include a **security table** that implements **[mandatory access control (MAC)](https://phoenixnap.com/glossary/mandatory-access-control-mac)** rules for stricter access management.

## Chains

Chains are rule lists within tables. The lists control how to handle packets at different processing stages. There are different chains, each with a specific purpose:

- **INPUT**. Handles incoming packets whose destination is a local application or service. The chain is in the filter and mangle tables.
- **OUTPUT**. Manages outgoing packets generated on a local application or service. All tables contain this chain.
FORWARD. Works with packets that pass through the system from one network interface to another. The chain is in the filter, mangle, and security tables.
PREROUTING. Alters packets before they are routed. The alteration happens before a routing decision. The NAT, mangle, and raw tables contain this chain.
POSTROUTING. Alters packets after they are routed. The alteration happens after a routing decision. The NAT and mangle tables contain this chain.

![c](https://phoenixnap.com/kb/wp-content/uploads/2024/05/iptables-tables-and-chains.png)

Iptable chains correspond to a netfilter subsystem hook.