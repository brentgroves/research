# **[What is the relationship or difference among iptables, xtables, iptables-nft, xtables-nft, nf_tables, nftables](https://unix.stackexchange.com/questions/687857/what-is-the-relationship-or-difference-among-iptables-xtables-iptables-nft-xt)**

## What I understood is

- **nftables** is the modern Linux kernel packet classification framework. nftables is the successor to iptables. It replaces the existing iptables, ip6tables, arptables, and ebtables framework.
- **x_tables** is the name of the kernel module carrying the shared code portion used by iptables, ip6tables, arptables and ebtables thus, Xtables is more or less used to refer to the entire firewall (v4, v6, arp, and eb) architecture. As a system admin, I should not worry about xtables / x_tables (some people use the underscore, so not sure whether xtables is same as x_tables or not) which is actually some code in the kernel.
- **nftables uses nf_tables**, where nf_tables is the name of the kernel module. As a system admin, I should not worry about nf_tables which is actually some code in the kernel.
- **iptables-nft** is something that looks like iptables but acts like nftables. Its whole purpose is to migrate from iptables to nftables.
- **iptables-nft** uses xtables-nft, where xtables-nft is the name of the kernel module. As a system admin, I should not worry about xtables-nft.

**Ebtables** is a Linux kernel module that allows for the filtering of Ethernet bridging frames. It operates at layer 2 of the OSI model, which allows for filtering rules to be applied to Ethernet frames that pass through a Linux bridging firewall. Ebtables is used to set up, maintain, and inspect the tables of Ethernet frame rules in the Linux kernel.

## other guy's view

My view is that iptables, ip6tables, ebtables and arptable is a frontend tool-set to Netfilter.

They are a user-space tool-set that format and compile the rules to load them in the core Netfilter that runs in the kernel. You can find all the kernel parts of Netfilter in your modules directory ls /lib/modules/$(uname -r)/kernel/net/netfilter/ they have the form of yours nf_*, nft_*, xt_* kernel modules.

The problems with these tools is that they operate with rule granularity, so every adjust of rules implies to download ALL the kernel rules, make your modification on a binary blob, then upload it back to the kernel. This process become very intensive in CPU load when the rules becomes too numerous.

nftables is a rewrite of this tool series inside one unique tool (to rule them all ... ahemm), which make it simpler to use and more performant, but it is still a frontend to Netfilter, however the main differences is that it has a smooth syntax that is able to address every part of Netfilter, and it has the ability to modify the binary set of rules as a whole, directly inside Netfilter without having to download then and upload them one by one, which represent a big gain in performance.

This explain also that you can use both iptables and nftables to modify the rules but it is not recommended because you can't see precedence between different rules, or this precedence may not be what you wanted.

Now, depending on distribution policy one can find different set of packages to works with the new Netfilter core kernel set modules. you mentioned xtables-nft : it is just a shortcut to designate an intermediary set (or package) of userspace tools made of {ip|ip6,eb,arp}tables with the ability to work on the new Netfilter core, the same way the olders tools were used to, so it helps and ease the migration from the old way to nftables (the new way).

There is also a package named iptables-legacy to keep ip{,6}tables set of traditional tools working the same way with the new Netfilter core without the ability to translate the rules directly to nftables, so Firewall scripting tools like ferm can keep working on new installation of modern kernel.

bridging the two, one can for example iptables-legacy-save |iptables-nft-restore to directly translate an old set of iptables rules to a new nftables ruleset.

xtables-nft is just a shortcut to designate an intermediary set (or package) of userspace tools made of {ip,eb,arp}tables with the ability to work on the new Netfilter core, the same way the olders tools were used to, so it helps and ease the migration from the old way to nftables (the new way)
