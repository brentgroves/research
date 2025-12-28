# **[NFTables Basics](https://cycle.io/learn/nftables-basics)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## reference

- **[gentoo](https://wiki.gentoo.org/wiki/Nftables/Examples)**


## **[Current status](https://wiki.debian.org/nftables)**

nftables is the default framework in use in Debian (since Debian 10 Buster)

This means:

the nft command line interface should be available.

the iptables utility may not be installed in a system by default.
if installed, the iptables utility will use by default the nf_tables backend by means of the iptables-nft layer (i.e, using iptables syntax with the nf_tables kernel subsystem).
this also affects ip6tables, arptables and ebtables

nftables is the successor to iptables, offering a more powerful, flexible, and efficient way to manage packet filtering and NAT (Network Address Translation) on Linux systems. It introduces a new framework that consolidates the functionality of iptables, ip6tables, arptables, and ebtables into a single, unified interface. This guide will introduce you to the basics of nftables, covering installation, key concepts, basic usage, and how it compares to its predecessor, iptables.

To stop nftables from doing anything, just drop all the rules:

```bash
# nft flush ruleset
```

## default configuration

On Ubuntu Server 24.04, the default nftables configuration is essentially "open" with no restrictive rules by default, meaning all traffic is allowed unless explicitly blocked by additional rules added through the UFW (Uncomplicated Firewall) interface, which is the recommended way to manage firewall settings on Ubuntu; this effectively sets the default policy to "allow" for incoming connections. 

## What is nftables?

nftables is a packet filtering framework that replaces the legacy iptables infrastructure in the Linux kernel. It's designed to provide a more consistent and unified approach to network filtering and NAT, with a simplified syntax and better performance. nftables is capable of handling both IPv4 and IPv6 traffic, as well as ARP and bridge filtering, all within a single framework.

## Key Features of nftables
Unified Interface: It consolidates the functionalities of iptables, ip6tables, arptables, and ebtables.
Simplified Syntax: Offers a more readable and maintainable syntax compared to iptables.
Better Performance: Reduces the overhead of rule processing by using a more efficient internal data structure.
Atomic Rule Changes: Allows for atomic updates to rules, minimizing the risk of inconsistencies during rule changes.
Rich Set of Expressions: Supports a wide range of expressions, making it highly flexible for advanced filtering and NAT configurations.


## Installing nftables

nftables is included in the Linux kernel starting from version 3.13, and it is available in most modern Linux distributions. Installation is pretty straightforward and usually involves installing the nftables package and ensuring the appropriate services are enabled.

Installation on Various Systems
Debian/Ubuntu:

```bash
sudo apt-get install nftables
```

After installing the package, you can enable the nftables service to ensure it starts automatically on boot:

```bash
sudo systemctl status nftables

sudo systemctl enable nftables
sudo systemctl start nftables
```

You can verify the installation by checking the nftables version:

```bash
nft --version
```

## Basic nftables Concepts

To effectively use nftables, it's important to understand its basic structure, including tables, chains, rules, and sets.

## Tables

In nftables, tables are used to organize chains and rules. A table defines a namespace and the type of filtering it supports. The most common table types are:

- inet: Handles both IPv4 and IPv6 traffic.
- ip: Handles only IPv4 traffic.
- ip6: Handles only IPv6 traffic.
- arp: Handles ARP traffic.
- bridge: Handles bridge traffic.


## Chains

Chains are lists of rules within a table. They define the points in the packet processing pipeline where rules are applied. Common chain types include:

- input: For packets destined for the local system.
- output: For packets originating from the local system.
- forward: For packets being routed through the system.
- prerouting: For packets before routing decisions are made (typically used in NAT).
- postrouting: For packets after routing decisions have been made (typically used in NAT).

## Rules

Rules define the filtering criteria and actions to be taken on packets. A rule typically consists of a match condition and a corresponding action, such as accepting or dropping the packet.

## Sets

Sets allow you to group multiple elements, like IP addresses, ports, or MAC addresses, into a single object that can be referenced in rules. This makes managing large and complex rule sets easier and more efficient.

## Basic nftables Usage

Now that we've covered the basic concepts, let's explore how to use nftables to configure simple packet filtering and NAT.

## Creating a Basic Table and Chain

To create a basic nftables configuration, you first need to create a table and then define chains within that table.

```bash
sudo nft add table inet my_filter_table
sudo nft add chain inet my_filter_table input { type filter hook input priority 0 \; }
sudo nft add chain inet my_filter_table output { type filter hook output priority 0 \; }
```

In this example:

- inet my_filter_table: Creates a new table named my_filter_table that handles both IPv4 and IPv6 traffic.
- chain inet my_filter_table input: Creates an input chain within the table for filtering incoming traffic.
- chain inet my_filter_table output: Creates an output chain within the table for filtering outgoing traffic.

## Adding Rules to Chains

Once you have created your table and chains, you can start adding rules to filter traffic.

Example: Accept Traffic on Port 22 (SSH)

```bash
sudo nft add rule inet my_filter_table input tcp dport 22 accept
```

This rule allows incoming TCP traffic on port 22 (SSH).

Example: Drop Traffic from a Specific IP Address

```bash
sudo nft add rule inet my_filter_table input ip saddr 192.168.1.100 drop
```

This rule drops all incoming traffic from the IP address 192.168.1.100.

## Example: Allow Established and Related Connections

```bash
sudo nft add rule inet my_filter_table input ct state established,related accept
```

This rule allows packets that are part of established or related connections.

## Listing Rules

You can list the rules in your nftables configuration with the following command:

```bash
sudo nft list table inet my_filter_table
```

This command displays all chains and rules within the specified table.

## Saving and Restoring Rules

To ensure that your nftables rules persist across reboots, you need to save them to a file and restore them on startup.

## Saving Rules

You can save the current nftables configuration to a file:

```bash
sudo nft list ruleset > /etc/nftables.conf
```

## Restoring Rules on Boot

To automatically restore nftables rules on boot, you can create a systemd service or modify the nftables service to load the saved configuration:

```bash
sudo systemctl status nftables.service
sudo systemctl enable nftables
sudo systemctl start nftables
```

Make sure the configuration file is specified in the nftables service configuration.

