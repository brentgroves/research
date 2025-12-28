# **[What is nftables](https://wiki.nftables.org/wiki-nftables/index.php/What_is_nftables%3F)**

## What is nftables?

nftables is the modern Linux kernel packet classification framework. New code should use it instead of the legacy {ip,ip6,arp,eb}_tables (xtables) infrastructure. For existing codebases that have not yet converted, the legacy xtables infrastructure is still maintained as of 2021. Automated tools assist the xtables to nftables conversion process.

nftables in a nutshell:

- It is available in Linux kernels >= 3.13 we are on 6.9.4
- It comes with a new command line utility nft whose syntax is different to iptables.
- It also comes with a compatibility layer that allows you to run iptables commands over the new nftables kernel framework.
- It provides a generic set infrastructure that allows you to construct maps and concatenations. - You can use these new structures to arrange your ruleset in a multidimensional tree which drastically reduces the number of rules that need to be inspected until reaching the final action on a packet.

This new framework features a new linux kernel subsystem, known as **nf_tables**. The new engine mechanism is inspired by BPF-like systems, with a set of basic expressions, which can be combined to build complex filtering rules.

## Why nftables?

We like iptables after all, this tool has been serving us (and will likely keep serving still for a while in many deployments) to filter out traffic on both per-packet and per-flow basis, log suspicious traffic activity, perform NAT and many other things. It comes with more than a hundred of extensions that have been contributed along the last 15 years!.

Nevertheless, the iptables framework suffers from limitations that cannot be easily worked around:

- Avoid code duplication and inconsistencies: Many of the iptables extensions are protocol specific, so there is no a consolidated way to match packet fields, instead we have one extension for each protocol that it supports. This bloats the codebase with very similar code to perform a similar task: payload matching.
- Faster packet classification through enhanced generic set and map infrastructure.
- Simplified dual stack IPv4/IPv6 administration, through the new inet family that allows you to register base chains that see both IPv4 and IPv6 traffic.
- Better dynamic ruleset updates support.
- Provide a Netlink API for third party applications, just as other Linux Networking and Netfilter subsystem do.
- Address syntax inconsistencies and provide nicer and more compact syntax.

These, among other things not listed here, triggered the nftables development which was originally presented to the Netfilter community in the 6th Netfilter Workshop in Paris (France).

## Main differences with iptables

Some key differences between nftables and iptables from the user point of view are:

- **nftables uses a new syntax.** The iptables command line tool uses a getopt_long()-based parser where keys are always preceded by double minus, eg. --key or one single minus, eg. -p tcp. In contrast, nftables uses a compact syntax inspired by tcpdump.
- **Tables and chains are fully configurable.** iptables has multiple pre-defined tables and base chains, all of which are registered even if you only need one of them. There have been reports of even unused base chains harming performance. With nftables there are no pre-defined tables or chains. Each table is explicitly defined, and contains only the objects (chains, sets, maps, flowtables and stateful objects) that you explicitly add to it. Now you register only the base chains that you need. You choose table and chain names and netfilter hook priorities that efficiently implement your specific packet processing pipeline.
- **A single nftables rule can take multiple actions.** Instead of the matches and single target action used in iptables, an nftables rule consists of zero or more expressions followed by one or more statements. Each expression tests whether a packet matches a specific payload field or packet/flow metadata. Multiple expressions are linearly evaluated from left to right: if the first expression matches, then the next expression is evaluated and so on. If we reach the final expression, then the packet matches all of the expressions in the rule, and the rule's statements are executed. Each statement takes an action, such as setting the netfilter mark, counting the packet, logging the packet, or rendering a verdict such as accepting or dropping the packet or jumping to another chain. As with expressions, multiple statements are linearly evaluated from left to right: a single rule can take multiple actions by using multiple statements. Do note that a verdict statement by its nature ends the rule.
- **No built-in counter per chain and rule.** In nftables counters are optional, you can enable them as needed.
- **Better support for dynamic ruleset updates.** In contrast to the monolithic blob used by iptables, nftables rulesets are represented internally in a linked list. Now adding or deleting a rule leaves the rest of the ruleset untouched, simplifying maintenance of internal state information.
- **Simplified dual stack IPv4/IPv6 administration.** The nftables inet family allows you to register base chains that see both IPv4 and IPv6 traffic. It is no longer necessary to rely on scripts to duplicate your ruleset.
- **New generic set infrastructure.** This infrastructure integrates tightly into the nftables core and allows advanced configurations such as maps, verdict maps and intervals to achieve performance-oriented packet classification. The most important thing is that you can use any supported selector to classify traffic.
- Support for **[concatenations.](https://wiki.nftables.org/wiki-nftables/index.php/Concatenations)** Since Linux kernel 4.1, you can concatenate several keys and combine them with maps and verdict maps. The idea is to build a tuple whose values are hashed to obtain the action to be performed nearly O(1).
- **Support new protocols without a kernel upgrade.** Kernel upgrades can be a time-consuming and daunting task, especially if you have to maintain more than a single firewall in your network. Distribution kernels usually lag the newest release. With the new nftables virtual machine approach, supporting a new protocol will often not require a new kernel, just a relatively simple nft userspace software update.

## Adoption

The Netfilter project and community is focused on replacing the iptables framework with nftables, adding new features and refreshing some workflows along the way.

Many upstream projects use iptables to handle filtering, NAT, mangling and other networking tasks. This page tracks nftables adoption in the wider community.

## Cases

Known cases and examples we could heard of. TODO: extend with more current data.

All major Linux distributions contains the nftables framework ready to use. Check Nftables from distributions.

## virtualization / cloud / infrastructure

<https://github.com/zevenet/nftlb> -- nftlb by Zevenet is a nftables-based loadbalancer which can outperform LVS by 10x
<https://www.docker.com/> -- Some discussion happened in the Docker community regarding a native integration with nftables, which could ease some of their use cases (link) (link) (running docker with IPv6 using nftables)
<https://kubernetes.io/> -- Kubernetes does not support nftables yes, but some discussion happened already (link). Compat tools may be used to trick kubernetes into using nftables transparently.
<http://openstack.org/> -- Openstack does not support nftables yet. Compat tools may be used to trick neutron and other components into using nftables transparently.
<https://libvirt.org/> -- there are reports of people running libvirt with nftables for bridge filtering for virtual machines
<https://saltstack.com/> -- SaltStack includes native support for nftables (link).
<https://coreos.com/> -- the CoreOS ecosystem includes native support for nftables (link)
