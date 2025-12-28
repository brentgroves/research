# **[conntrack_tools user manaual](https://conntrack-tools.netfilter.org/manual.html#:~:text=conntrack%20provides%20a%20full%20featured,also%20listen%20to%20flow%20events.)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../README.md)**

## Chapter 1. Introduction

This documentation provides a description on how to install and to configure the conntrack-tools.

This documentation assumes that the reader is familiar with basic firewalling and Netfilter concepts. You also must understand the difference between stateless and stateful firewalls. Otherwise, please read Netfilter's Connection Tracking System published in :login; the **[USENIX magazine](http://people.netfilter.org/pablo/docs/login.pdf)** for a quick reference.

## AI Overview

In Linux firewalls, a stateless firewall filters packets based on predefined rules without tracking connection state, while a stateful firewall keeps track of connections to ensure legitimate traffic flow and provides more robust security.

## Chapter 2. What are the conntrack-tools?

The conntrack-tools package contains two programs:

conntrack provides a full featured command line utility to interact with the connection tracking system. The conntrack utility provides a replacement for the limited /proc/net/nf_conntrack interface. With conntrack, you can list, update and delete the existing flow entries; you can also listen to flow events.

conntrackd is the user-space connection tracking daemon. This daemon can be used to deploy fault-tolerant GNU/Linux firewalls but you can also use it to collect flow-based statistics of the firewall use.

Mind the trailing d that refers to either the command line utility or the daemon.
