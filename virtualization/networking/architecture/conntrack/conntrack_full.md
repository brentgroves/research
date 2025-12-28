# **[How to fix conntrack: table full, dropping packets in Kubernetes?](https://adil.medium.com/how-to-fix-conntrack-table-full-dropping-packets-in-kubernetes-07f561a432aa#:~:text=full%2C%20dropping%20packets-,What%20is%20conntrack?,and%20NAT%20rules%20in%20Kubernetes.)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../README.md)**

## reference

- **[ubuntu man page](https://manpages.ubuntu.com/manpages/noble/man8/conntrack.8.html)**

The Kubernetes network stack has many levels.

One of the most important layers is conntrack.

You may have seen this error log on your system:

`nf_conntrack: table full, dropping packets`

## What is conntrack?

conntrack stands for “Connection Tracking”. conntrack is a component of the Netfilter framework in Linux Kernel. conntrack functions as a database for network connections that travel through a Linux server. It tracks the state of each network connection (TCP, UDP, ICMP, etc).

The state of a network connection is critical for packet filtering and NAT rules in Kubernetes.

## What is the conntrack limit?

Conntrack has a maximum limit to maintain active network traffic. The Linux Kernel automatically sets the maximum value depending on the Linux Server’s RAM **[(source code)](https://github.com/torvalds/linux/blob/v6.8/net/netfilter/nf_conntrack_core.c#L2673-L2694)**.

However, each Linux distribution or cloud provider may assign a different value.

Enter your Kubernetes node and get your k8s node’s limit:

```bash
ssh ubuntu@10.188.50.214
cat /proc/sys/net/netfilter/nf_conntrack_max
131072
```

Get the current number of entries in conntrack:

```bash
cat /proc/sys/net/netfilter/nf_conntrack_count
78
```

In your monitoring system, you may create an alarm like this:

(<nf_conntrack_count>/<nf_conntrack_max>) * 100 >= 95
Alert: 95% of the maximum conntrack limit is reached.
