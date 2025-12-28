# **[connection tracking system](https://wiki.nftables.org/wiki-nftables/index.php/Connection_Tracking_System)**

## references

<https://wiki.nftables.org/wiki-nftables/index.php/Connection_Tracking_System>
<https://conntrack-tools.netfilter.org/conntrack.html>
<https://conntrack-tools.netfilter.org/support.html>

## Connection Tracking System

nftables uses netfilter's Connection Tracking system (often referred to as conntrack or ct) to associate network packets with connections and the states of those connections. An nftables ruleset performs **[stateful firewalling](https://en.wikipedia.org/wiki/Stateful_firewall)** by applying policy based on whether or not packets are valid parts of tracked connections.

nftables also frequently performs network address translation using Netfilter's NAT engine, which is itself built on top of conntrack. You can use nft to configure NAT.

conntrack and nftables (and NAT) are technically distinct components of netfilter. Even so, conntrack is so often used together with nftables that it's worth including an overview and references to further documentation about it here.

- **[Conntrack sysfs variables](https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/tree/Documentation/networking/nf_conntrack-sysctl.rst)**.
