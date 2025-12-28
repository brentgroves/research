# **[Netfilter and iptables homepage](http://www.netfilter.org/)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

## references

- **[Introduction to Netfilter](https://blogs.oracle.com/linux/post/introduction-to-netfilter)**

## What is the netfilter.org project?
The netfilter project is a community-driven collaborative FOSS project that provides packet filtering software for the Linux 2.4.x and later kernel series. The netfilter project is commonly associated with **[iptables](https://www.netfilter.org/projects/iptables/index.html)** and its successor **[nftables](https://www.netfilter.org/projects/nftables/index.html)**.

The netfilter project enables packet filtering, network address [and port] translation (NA[P]T), packet logging, userspace packet queueing and other packet mangling.

The netfilter hooks are a framework inside the Linux kernel that allows kernel modules to register callback functions at different locations of the Linux network stack. The registered callback function is then called back for every packet that traverses the respective hook within the Linux network stack.

iptables is a generic firewalling software that allows you to define rulesets. Each rule within an IP table consists of a number of classifiers (iptables matches) and one connected action (iptables target).

nftables is the successor of iptables, it allows for much more flexible, scalable and performance packet classification. This is where all the fancy new features are developed.

