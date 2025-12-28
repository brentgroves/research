# **[The netfilter.org "ulogd" project](https://www.netfilter.org/projects/ulogd/)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../README.md)**

## What is ulogd?

ulogd is a userspace logging daemon for netfilter/iptables related logging. This includes per-packet logging of security violations, per-packet logging for accounting, per-flow logging and flexible user-defined accounting.

ulogd-1.x has been around since 2000. Since 2012, 1.x series have entered end-of-life. All production systems should migrate to the stable series ulogd-2.x as soon as possible as we do not plan to make more 1.x releases.

## Main Features

- Packet and flow-based traffic accounting
- Flexible user-defined traffic accounting via nfacct infrastructure
- SQL database back-end support: SQLite3, MySQL and PostgreSQL
- Text-based output formats: CSV, XML, Netfilter's LOG, Netfilter's conntrack

## requires

ulogd-2.x requires several libraries:

libnfnetlink that provides basic communication infrastructure via Netlink.
libmnl that provides basic communication infrastructure via Netlink, this library will supersede libnfnetlink. Still, we require both libraries as we are still in transition to entirely replace libnfnetlink by libmnl.
libnetfilter_log for stateless packet-based logging via nfnetlink_queue.
libnetfilter_conntrack for stateful flow-based via nf_conntrack_netlink.
libnetfilter_acct for flexible traffic accounting via nfnetlink_acct and iptables nfacct match (it requires Linux kernel >= 3.3.x).
This requires a Linux kernel >= 2.6.14, but Linux kernel >= 2.6.18 is strongly recommended. Note that if you need SQL database output suport, you will need the header files of the respective libraries.

Legacy ulogd-1.x requires nothing netfilter-related.
