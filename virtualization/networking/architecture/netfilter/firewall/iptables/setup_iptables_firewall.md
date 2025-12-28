# **[How To Set Up a Firewall Using Iptables on Ubuntu 14.04](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-iptables-on-ubuntu-14-04)**


**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

Setting up a good firewall is an essential step to take in securing any modern operating system. Most Linux distributions ship with a few different firewall tools that we can use to configure our firewalls. In this guide, we’ll be covering the iptables firewall.

Iptables is a standard firewall included in most Linux distributions by default (a modern variant called nftables will begin to replace it). It is actually a front end to the kernel-level netfilter hooks that can manipulate the Linux network stack. It works by matching each packet that crosses the networking interface against a set of rules to decide what to do.

In the previous guide, we learned **[how iptables rules work to block unwanted traffic](https://www.digitalocean.com/community/articles/how-the-iptables-firewall-works)**. In this guide, we’ll move on to a practical example to demonstrate how to create a basic rule set for an Ubuntu 14.04 server. The resulting firewall will allow SSH and HTTP traffic.

Note: This tutorial covers IPv4 security. In Linux, IPv6 security is maintained separately from IPv4. For example, “iptables” only maintains firewall rules for IPv4 addresses but it has an IPv6 counterpart called “ip6tables”, which can be used to maintain firewall rules for IPv6 network addresses.

If your VPS is configured for IPv6, please remember to secure both your IPv4 and IPv6 network interfaces with the appropriate tools. For more information about IPv6 tools, refer to this guide: **[How To Configure Tools to Use IPv6 on a Linux VPS](https://www.digitalocean.com/community/tutorials/how-to-configure-tools-to-use-ipv6-on-a-linux-vps)**

## Prerequisites

Before you start using this tutorial, you should have a separate, non-root superuser account—a user with sudo privileges—set up on your server. If you need to set this up, follow this guide: Initial Server Setup with Ubuntu 14.04.

## Basic iptables Commands

Now that you have a good understanding of iptables concepts, we should cover the basic commands that will be used to form complex rule sets and to manage the iptables interface in general.

First, you should be aware that iptables commands must be run with root privileges. This means you need to log in as root, use su or sudo -i to gain a root shell, or precede all commands with sudo. We are going to use sudo in this guide since that is the preferred method on an Ubuntu system.

A good starting point is to list the current rules that are configured for iptables. You can do that with the -L flag:

```bash
sudo iptables -L
Output:
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
```


As you can see, we have our three default chains (INPUT,OUTPUT, and FORWARD). We also can see each chain’s default policy (each chain has ACCEPT as its default policy). We also see some column headers, but we don’t see any actual rules. This is because Ubuntu doesn’t ship with a default rule set.

We can see the output in a format that reflects the commands necessary to enable each rule and policy by instead using the -S flag:

```bash
sudo iptables -S
Output:
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
```

To replicate the configuration, we’d just need to type sudo iptables followed by each of the lines in the output. (Depending on the configuration, it may actually slightly more complicated if we are connected remotely so that we don’t institute a default drop policy before the rules are in place to catch and allow our current connection.)

If you do have rules in place and wish to scrap them and start over, you can flush the current rules by typing:

```bash
sudo iptables -F
```

Once again, the default policy is important here, because, while all of the rules are deleted from your chains, the default policy will not change with this command. That means that if you are connected remotely, you should ensure that the default policy on your INPUT and OUTPUT chains are set to ACCEPT prior to flushing your rules. You can do this by typing:

```bash
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F
```

You can then change the default drop policy back to DROP after you’ve established rules that explicitly allow your connection. We’ll go over how to do that in a moment.


## Make your First Rule

We’re going to start to build our firewall policies. As we said above, we’re going to be working with the INPUT chain since that is the funnel that incoming traffic will be sent through. We are going to start with the rule that we’ve talked about a bit above: the rule that explicitly accepts your current SSH connection.

The full rule we need is this:

```bash
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

This may look incredibly complicated, but most of it will make sense when we go over the components:

-A INPUT: The -A flag appends a rule to the end of a chain. This is the portion of the command that tells iptables that we wish to add a new rule, that we want that rule added to the end of the chain, and that the chain we want to operate on is the INPUT chain.

-m conntrack: iptables has a set of core functionality, but also has a set of extensions or modules that provide extra capabilities.

In this portion of the command, we’re stating that we wish to have access to the functionality provided by the conntrack module. This module gives access to commands that can be used to make decisions based on the packet’s relationship to previous connections.

–ctstate: This is one of the commands made available by calling the conntrack module. This command allows us to match packets based on how they are related to packets we’ve seen before.

We pass it the value of ESTABLISHED to allow packets that are part of an existing connection. We pass it the value of RELATED to allow packets that are associated with an established connection. This is the portion of the rule that matches our current SSH session.

-j ACCEPT: This specifies the target of matching packets. Here, we tell iptables that packets that match the preceding criteria should be accepted and allowed through.


