# **[nftables wiki](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)**

What is nftables?
nftables is the modern Linux kernel **packet classification framework**. New code should use it instead of the legacy {ip,ip6,arp,eb}_tables (xtables) infrastructure. For existing codebases that have not yet converted, the legacy xtables infrastructure is still maintained as of 2021. Automated tools assist the xtables to nftables conversion process.

nftables in a nutshell:

It is available in Linux kernels >= 3.13.
It comes with a new command line utility nft whose syntax is different to iptables.
It also comes with a compatibility layer that allows you to run iptables commands over the new nftables kernel framework.
It provides a generic set infrastructure that allows you to construct maps and concatenations. You can use these new structures to arrange your ruleset in a multidimensional tree which drastically reduces the number of rules that need to be inspected until reaching the final action on a packet.

## **[netfilter hooks](https://wiki.nftables.org/wiki-nftables/index.php/Netfilter_hooks)**

nftables uses mostly the same Netfilter infrastructure as legacy iptables. The hook infrastructure, Connection Tracking System, NAT engine, logging infrastructure, and userspace queueing remain the same. Only the packet classification framework is new.

## Netfilter hooks into Linux networking packet flows

The following schematic shows packet flows through Linux networking:

![hooks](https://people.netfilter.org/pablo/nf-hooks.png)

## Why do you have to add a chain family since we already have a table family?

I believe this is because if the table family is inet which includes both ip and ip6 families the chain can be specifically for either ip or ip6 packets if desired.

- **[table family/chain type/hook](./netfilter_hooks.md)**
- **[configure tables](./configure_tables.md)**
- **[configure chains](./configure_chains.md)**
- **[ruleset backup/restore](./ruleset_backup_restore.md)**
- **[simple rule management](./simple_rule_management.md)**
- **[port forwarding](../port_forwarding.md)**
