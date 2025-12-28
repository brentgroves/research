# **[How the Iptables Firewall Works](https://www.digitalocean.com/community/tutorials/how-the-iptables-firewall-works)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

Setting up a firewall is an essential step to take in securing any modern operating system. Most Linux distributions ship with a few different firewall tools that you can use to configure a firewall. In this guide, we’ll be covering the iptables firewall.

Iptables is a standard firewall included in most Linux distributions by default. It is a command-line interface to the kernel-level netfilter hooks that can manipulate the Linux network stack. It works by matching each packet that crosses the networking interface against a set of rules to decide what to do.

In this guide, you will review how Iptables works. For a more in-depth approach, you can read **[A Deep Dive into Iptables and Netfilter Architecture](https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture)**.

How Iptables Works
First, let’s review some terminology and discuss how iptables works.

The iptables firewall operates by comparing network traffic against a set of rules. The rules define the characteristics that a network packet needs to have to match, and the action that should be taken for matching packets.

There are many options to establish which packets match a specific rule. You can match the packet protocol type, the source or destination address or port, the interface that is being used, its relation to previous packets, and so on.

When the defined pattern matches, the action that takes place is called a target. A target can be a final policy decision for the packet, such as ACCEPT or DROP. It can also move the packet to a different chain for processing, or log the encounter. There are many options.

These rules are organized into groups called chains. A chain is a set of rules that a packet is checked against sequentially. When the packet matches one of the rules, it executes the associated action and skips the remaining rules in the chain.

A user can create chains as needed. There are three chains defined by default. They are:

- **INPUT:** This chain handles all packets that are addressed to your server.
- **OUTPUT:** This chain contains rules for traffic created by your server.
- **FORWARD:** This chain is used to deal with traffic destined for other servers that are not created on your server. This chain is a way to configure your server to route requests to other machines.

Each chain can contain zero or more rules, and has a default policy. The policy determines what happens when a packet drops through all of the rules in the chain and does not match any rule. You can either drop the packet or accept the packet if no rules match.

Iptables can also track connections. This means you can create rules that define what happens to a packet based on its relationship to previous packets. The capability is “state tracking”, “connection tracking”, or configuring the “state machine”.

IPv4 Versus IPv6
The netfilter firewall that is included in the Linux kernel keeps IPv4 and IPv6 traffic completely separate. The Iptables tools used to manipulate the tables that contain the firewall rulesets are distinct as well. If you have IPv6 enabled on your server, you will have to configure both tables to address the traffic on your server.

Note: Nftables, a successor to Iptables, integrates handling of IPv4 and IPv6 more closely. The iptables-translate command can be used to migrate Iptables rules to Nftables.

The regular iptables command is used to manipulate the table containing rules that govern IPv4 traffic. For IPv6 traffic, a companion command called ip6tables is used. Any rules that you set with iptables will only affect packets using IPv4 addressing, but the syntax between these commands is the same. The iptables command will make the rules that apply to IPv4 traffic, and the ip6tables command will make the rules that apply to IPv6 traffic. Don’t forget to use the IPv6 addresses of your server to craft the ip6tables rules.

## Things to Keep in Mind

Now that you know how iptables directs packets that come through its interface – direct the packet to the appropriate chain, check it against each rule until one matches, issue the default policy of the chain if no match is found – you can begin to create rules.

First, you need to make sure that you have rules to keep current connections active if you implement a default drop policy. This is especially important if you are connected to your server through SSH. If you accidentally implement a rule or policy that drops your current connection, you may need to log into your server using a browser-based recovery console.

Another thing to keep in mind is that the order of the rules in each chain matter. A packet must not come across a more general rule that it matches if it is meant to match a more specific rule.

Because of this, rules near the top of a chain should have a higher level of specificity than rules at the bottom. You should match specific cases first, and then provide more general rules to match broader patterns. If a packet falls through the entire chain (if it doesn’t match any rules), it will follow the most general rule, i.e., the default policy.

For this reason, a chain’s default policy strongly dictates the types of rules that will be included in the chain. A chain with the default policy of ACCEPT will contain rules that explicitly drop packets. A chain that defaults to DROP will contain exceptions for packets that should be specifically accepted.
