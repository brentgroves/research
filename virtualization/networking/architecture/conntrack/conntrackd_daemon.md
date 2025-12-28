# **[Chapter 6. Setting up conntrackd: the daemon](https://conntrack-tools.netfilter.org/manual.html#:~:text=conntrack%20provides%20a%20full%20featured,also%20listen%20to%20flow%20events.)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../README.md)**

The conntrackd daemon supports three modes:

- State table synchronization, to synchronize the connection tracking state table between several firewalls in High Availability (HA) scenarios.
- Userspace connection tracking helpers, for layer 7 Application Layer Gateway (ALG) such as DHCPv6, MDNS, RPC, SLP and Oracle TNS. As an alternative to the in-kernel connection tracking helpers that are available in the Linux kernel.
- Flow-based statistics collection, to collect flow-based statistics as an alternative to **[ulogd2](http://www.netfilter.org/projects/ulogd/)**, although ulogd2 allows for more flexible statistics collection.
