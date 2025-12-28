# **[wiki archlinux](https://wiki.archlinux.org/title/nftables)**

nftables is a netfilter project that aims to replace the existing {ip,ip6,arp,eb}tables framework. It provides a new packet filtering framework, a new user-space utility (nft), and a compatibility layer for {ip,ip6}tables. It uses the existing hooks, connection tracking system, user-space queueing component, and logging subsystem of netfilter.

It consists of three main components: a kernel implementation, the libnl netlink communication and the nftables user-space front-end. The kernel provides a netlink configuration interface, as well as run-time rule-set evaluation, libnl contains the low-level functions for communicating with the kernel, and the nftables front-end is what the user interacts with via nft.

You can also visit the official **[nftables wiki page](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)** for more information.
