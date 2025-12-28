# **[42.1.1. Basics of nftables tables](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/getting-started-with-nftables_configuring-and-managing-networking#con_basics-of-nftables-tables_assembly_creating-and-managing-nftables-tables-chains-and-rules)**

**[Back to Research List](../../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../../README.md)**

A table in nftables is a namespace that contains a collection of chains, rules, sets, and other objects.

Each table must have an address family assigned. The address family defines the packet types that this table processes. You can set one of the following address families when you create a table:

- ip: Matches only IPv4 packets. This is the default if you do not specify an address family.
- ip6: Matches only IPv6 packets.
- inet: Matches both IPv4 and IPv6 packets.
- arp: Matches IPv4 address resolution protocol (ARP) packets.
- bridge: Matches packets that pass through a bridge device.
- netdev: Matches packets from ingress.
