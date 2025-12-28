# **[iptables Processing Flowchart](https://stuffphilwrites.com/2014/09/iptables-processing-flowchart/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

In networking, a **packet** is the basic unit of data transmitted over a network, typically at the network layer (Layer 3 of the OSI model). A **frame**, on the other hand, encapsulates a packet and other information for transmission across a specific network technology at the data link layer (Layer 2 of the OSI model). Think of **it like putting a letter (the packet) into an envelope (the frame)** for mailing.

![iptfc1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*OIoNQkH4RTSm-eY2lUMBcQ.jpeg)**

| Tables↓/Chains→               | PREROUTING | INPUT | FORWARD | OUTPUT | POSTROUTING |
|-------------------------------|------------|-------|---------|--------|-------------|
| (routing decision)            |            |       |         | ✓      |             |
| raw                           | ✓          |       |         | ✓      |             |
| (connection tracking enabled) | ✓          |       |         | ✓      |             |
| mangle                        | ✓          | ✓     | ✓       | ✓      | ✓           |
| nat (DNAT)                    | ✓          |       |         | ✓      |             |
| (routing decision)            | ✓          |       |         | ✓      |             |
| filter                        |            | ✓     | ✓       | ✓      |             |
| security                      |            | ✓     | ✓       | ✓      |             |
| nat (SNAT)                    |            | ✓     |         |        | ✓           |

- Incoming packets destined for the local system: PREROUTING -> INPUT
- Incoming packets destined to another host: PREROUTING -> FORWARD -> POSTROUTING
- Locally generated packets: OUTPUT -> POSTROUTING

![ipt](https://stuffphilwrites.com/wp-content/uploads/2024/05/FW-IDS-iptables-Flowchart-v2024-05-22-768x978.png)**

## **[Architecture](https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture)**

## What Are IPTables and Netfilter?

For many years, the firewall software most commonly used in Linux was called iptables. In some distributions, it has been replaced by a new tool called nftables, but iptables syntax is still commonly used as a baseline. The iptables firewall works by interacting with the packet filtering hooks in the Linux kernel’s networking stack. These kernel hooks are known as the netfilter framework.

Every packet that passes through the networking layer (incoming or outgoing) will trigger these hooks, allowing programs to interact with the traffic at key points. The kernel modules associated with iptables register with these hooks in order to ensure that the traffic conforms to the conditions laid out by the firewall rules.

## Netfilter Hooks

There are five netfilter hooks that programs can register with. As packets progress through the stack, they will trigger the kernel modules that have registered with these hooks. The hooks that a packet will trigger depends on whether the packet is incoming or outgoing, the packet’s destination, and whether the packet was dropped or rejected at a previous point.

The following hooks represent these well-defined points in the networking stack:

- NF_IP_PRE_ROUTING: This hook will be triggered by any incoming traffic very soon after entering the network stack. This hook is processed before any routing decisions have been made regarding where to send the packet.
- NF_IP_LOCAL_IN: This hook is triggered after an incoming packet has been routed if the packet is destined for the local system.
- NF_IP_FORWARD: This hook is triggered after an incoming packet has been routed if the packet is to be forwarded to another host.
- NF_IP_LOCAL_OUT: This hook is triggered by any locally created outbound traffic as soon as it hits the network stack.
- NF_IP_POST_ROUTING: This hook is triggered by any outgoing or forwarded traffic after routing has taken place and just before being sent out on the wire.

Kernel modules that need to register at these hooks must also provide a priority number to help determine the order in which they will be called when the hook is triggered. This provides the means for multiple modules (or multiple instances of the same module) to be connected to each of the hooks with deterministic ordering. Each module will be called in turn and will return a decision to the netfilter framework after processing that indicates what should be done with the packet.

## IPTables Tables and Chains

The iptables firewall uses tables to organize its rules. These tables classify rules according to the type of decisions they are used to make. For instance, if a rule deals with network address translation, it will be put into the nat table. If the rule is used to decide whether to allow the packet to continue to its destination, it would probably be added to the filter table.

Within each iptables table, rules are further organized within separate “chains”. While tables are defined by the general aim of the rules they hold, the built-in chains represent the netfilter hooks which trigger them. Chains determine when rules will be evaluated.

The names of the built-in chains mirror the names of the netfilter hooks they are associated with:

- PREROUTING: Triggered by the NF_IP_PRE_ROUTING hook.
- INPUT: Triggered by the NF_IP_LOCAL_IN hook.
- FORWARD: Triggered by the NF_IP_FORWARD hook.
- OUTPUT: Triggered by the NF_IP_LOCAL_OUT hook.
- POSTROUTING: Triggered by the NF_IP_POST_ROUTING hook.

Chains allow the administrator to control where in a packet’s delivery path a rule will be evaluated. Since each table has multiple chains, a table’s influence can be exerted at multiple points in processing. Because certain types of decisions only make sense at certain points in the network stack, every table will not have a chain registered with each kernel hook.

There are only five netfilter kernel hooks, so chains from multiple tables are registered at each of the hooks. For instance, three tables have PREROUTING chains. When these chains register at the associated NF_IP_PRE_ROUTING hook, they specify a priority that dictates what order each table’s PREROUTING chain is called. Each of the rules inside the highest priority PREROUTING chain is evaluated sequentially before moving onto the next PREROUTING chain. We will take a look at the specific order of each chain in a moment.

## Which Tables are Available?

Let’s step back for a moment and take a look at the different tables that iptables provides. These represent distinct sets of rules, organized by area of concern, for evaluating packets.

### The Filter Table

The filter table is one of the most widely used tables in iptables. The filter table is used to make decisions about whether to let a packet continue to its intended destination or to deny its request. In firewall parlance, this is known as “filtering” packets. This table provides the bulk of functionality that people think of when discussing firewalls.

### The NAT Table

The nat table is used to implement network address translation rules. As packets enter the network stack, rules in this table will determine whether and how to modify the packet’s source or destination addresses in order to impact the way that the packet and any response traffic are routed. This is often used to route packets to networks when direct access is not possible.

### The Mangle Table

The mangle table is used to alter the IP headers of the packet in various ways. For instance, you can adjust the TTL (Time to Live) value of a packet, either lengthening or shortening the number of valid network hops the packet can sustain. Other IP headers can be altered in similar ways.

This table can also place an internal kernel “mark” on the packet for further processing in other tables and by other networking tools. This mark does not touch the actual packet, but adds the mark to the kernel’s representation of the packet.

### The Raw Table

The iptables firewall is stateful, meaning that packets are evaluated in regards to their relation to previous packets. The connection tracking features built on top of the netfilter framework allow iptables to view packets as part of an ongoing connection or session instead of as a stream of discrete, unrelated packets. The connection tracking logic is usually applied very soon after the packet hits the network interface.

The raw table has a very narrowly defined function. Its only purpose is to provide a mechanism for marking packets in order to opt-out of connection tracking.

### The Security Table

The security table is used to set internal SELinux security context marks on packets, which will affect how SELinux or other systems that can interpret SELinux security contexts handle the packets. These marks can be applied on a per-packet or per-connection basis.

## Relationships Between Chains and Tables

If three tables have PREROUTING chains, in which order are they evaluated?

The following table indicates the chains that are available within each iptables table when read from left-to-right. For instance, we can tell that the raw table has both PREROUTING and OUTPUT chains. When read from top-to-bottom, it also displays the order in which each chain is called when the associated netfilter hook is triggered.

A few things should be noted. In the representation below, the nat table has been split between DNAT operations (those that alter the destination address of a packet) and SNAT operations (those that alter the source address) in order to display their ordering more clearly. We have also include rows that represent points where routing decisions are made and where connection tracking is enabled in order to give a more holistic view of the processes taking place:

| Tables↓/Chains→               | PREROUTING | INPUT | FORWARD | OUTPUT | POSTROUTING |
|-------------------------------|------------|-------|---------|--------|-------------|
| (routing decision)            |            |       |         | ✓      |             |
| raw                           | ✓          |       |         | ✓      |             |
| (connection tracking enabled) | ✓          |       |         | ✓      |             |
| mangle                        | ✓          | ✓     | ✓       | ✓      | ✓           |
| nat (DNAT)                    | ✓          |       |         | ✓      |             |
| (routing decision)            | ✓          |       |         | ✓      |             |
| filter                        |            | ✓     | ✓       | ✓      |             |
| security                      |            | ✓     | ✓       | ✓      |             |
| nat (SNAT)                    |            | ✓     |         |        | ✓           |

As a packet triggers a netfilter hook, the associated chains will be processed as they are listed in the table above from top-to-bottom. The hooks (columns) that a packet will trigger depend on whether it is an incoming or outgoing packet, the routing decisions that are made, and whether the packet passes filtering criteria.

Certain events will cause a table’s chain to be skipped during processing. For instance, only the first packet in a connection will be evaluated against the NAT rules. Any nat decisions made for the first packet will be applied to all subsequent packets in the connection without additional evaluation. Responses to NAT’ed connections will automatically have the reverse NAT rules applied to route correctly.

## Chain Traversal Order

Assuming that the server knows how to route a packet and that the firewall rules permit its transmission, the following flows represent the paths that will be traversed in different situations:

- Incoming packets destined for the local system: PREROUTING -> INPUT
- Incoming packets destined to another host: PREROUTING -> FORWARD -> POSTROUTING
- Locally generated packets: OUTPUT -> POSTROUTING

If we combine the above information with the ordering laid out in the previous table, we can see that an incoming packet destined for the local system will first be evaluated against the PREROUTING chains of the raw, mangle, and nat tables. It will then traverse the INPUT chains of the mangle, filter, security, and nat tables before finally being delivered to the local socket.
