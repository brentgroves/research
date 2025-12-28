# **[How to Set Up A Firewall Using Iptables on Ubuntu 22.04](https://www.liquidweb.com/kb/set-firewall-using-iptables-ubuntu-16-04/)**

This guide will walk you through the steps for setting up a firewall using iptables in an Ubuntu **[VPS server](https://www.liquidweb.com/products/vps)**. We’ll show you some common commands for manipulating the firewall, and teach you how to create your own rules.

## What are Iptables in Ubuntu?

The utility iptables is a Linux based firewall that comes pre-installed on many Linux distributions. It is a leading solution for software-based firewalls. It’s a critical tool for Linux system administrators to learn and understand. Any publicly facing server on the Internet should have some form of firewall enabled for security reasons. In a typical configuration, you would only open ports for the services that you wish to be accessible via the Internet. All other ports would remain closed and inaccessible via the Internet. For example, in a typical server, you may want to open ports for your web services, but you probably would not want to make your database accessible to the public!

## Pre-flight

Working with iptables requires root privileges on your Linux box. The rest of this guide assumes you have logged in as root. Please exercise caution, as commands issued to iptables take effect immediately. You will be manipulating how your server is accessible to the outside world, so it’s possible to lock yourself out from your own server!

## How Do Iptables Work?

Iptables works by inspecting predefined firewall rules. Incoming server traffic is compared against these rules, and if iptables finds a match, it takes action. If iptables is unable to find a match, it will apply a default policy action. Typical usage is to set iptables to allow matched rules, and deny all others.

## How Can I See Firewall Rules in Ubuntu?

Before making any changes to your firewall, it is best practice to view the existing rule set and understand what ports are already open or closed. To list all firewall rules, run the following command.

```bash
iptables -L

# If this is a brand new Ubuntu 16.04 installation, you may see there are no rules defined! Here is an example “empty” output with no rules set:

Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
```

If you’re running Ubuntu 16.04 on a Liquid Web VPS, you’ll see we’ve already configured a basic firewall for you. There are usually three essential sections to look at in the iptables ruleset. When dealing with iptables rulesets, they are called “chains”, particularly “Chain INPUT”, “Chain FORWARD”, and “Chain OUTPUT”. The input chain handles traffic coming into your server while the output chain handles the traffic leaving your server. The forwarding chain handles server traffic that is not destined for local delivery. As you can surmise, the traffic is forwarded by our server  to its intended destination.

## Common Firewall Configurations

The default action is listed in “policy”. If traffic doesn’t match any of the chain rules, iptables will perform this default policy action. You can see that with an empty iptables configuration, the firewall is accepting all connections and not blocking anything! This is not ideal, so let’s change this. Here is an example firewall configuration allowing some common ports, and denying all other traffic.

```bash
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
iptables -A INPUT -s 192.168.0.100 -j ACCEPT
iptables -A INPUT -s 192.168.0.200 -j DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT
```

## We will break down these rules one at a time

```bash
iptables -A INPUT -i lo -j ACCEPT
```

This first command tells the INPUT chain to accept all traffic on your loopback interface. We specify the loopback interface with -i lo. The -j ACCEPT portion is telling iptables to take this action if traffic matches our rule.

```bash
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
```

Next, we’ll allow connections that are already established or related. This can be especially helpful for traffic like SSH, where you may initiate an outbound connection and wish to accept incoming traffic of the connection you intentionally established.

```bash
iptables -A INPUT -p icmp -j ACCEPT
```

This command tells your server not to block ICMP (ping) packets. This can be helpful for network troubleshooting and monitoring purposes. Note that the -p icmp portion is telling iptables the protocol for this rule is ICMP.

## How Do I Allow a Port in Ubuntu?

```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

TCP port 22 is commonly used for SSH. This command allows TCP connections on port 22. Change this if you are running SSH on a different port. Notice since SSH uses TCP, we’ve specified the protocol using -p tcp in this rule.

```bash
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

These two commands allow web traffic. Regular HTTP uses TCP port 80, and encrypted HTTPS traffic uses TCP port 443.

```bash
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
```

This is a less commonly used port, but here is an example of how to open port 1194 utilizing the UDP protocol instead of TCP. Note that in this example we’ve specified UDP by using -p udp.

## How Do I Allow an IP Address in Ubuntu?

```bash
iptables -A INPUT -s 192.168.0.100 -j ACCEPT
```

You can configure iptables to always accept connections from an IP address, regardless of what port the connections arrive on. This is commonly referred to as “whitelisting”, and can be helpful in certain circumstances. We’re whitelisting 192.168.0.100 in this example. Typically you would want to be very restrictive with this action and only allow trusted sources.

## How Do I Block an IP Address in Ubuntu?

```bash
iptables -A INPUT -s 192.168.0.200 -j DROP
```

You can also use iptables to block all connections from an IP address or IP range, regardless of what port they arrive on. This can be helpful if you need to block specific known malicious IPs. We’re using 192.168.0.200 as our IP to block in this example.

## How Do I Block All Other inputs?

```bash
iptables -P INPUT DROP
```

Next, we tell iptables to block all other inputs. We’re only allowing a few specific ports in our example, but if you had other ports needed, be sure to insert them before issuing the DROP command.

## How Do I Forward Traffic in Ubuntu?

```bash
iptables -P FORWARD DROP
```

Likewise, we’re going to drop forwarded packets. Iptables is very powerful, and you can use it to configure your server as a network router. Our example server isn’t acting as a router, so we won’t be using the FORWARD chain.

## How Do I Allow All Outbound Traffic?

```bash
iptables -P OUTPUT ACCEPT
```

Finally, we want to allow all outgoing traffic originating from our server. We’re mostly worried about outside traffic hitting our server, and not blocking our own box from accessing the outside world.

## How Do I Permanently Save IP Rules?

To make your firewall rules persist after a reboot, we need to save them. The following command will save the current ruleset:

```bash
/sbin/iptables-save
```

## How Do I Reset My Iptable?

To wipe out all existing firewall rules and return to a blank slate, you can issue the following command. Remember that an empty iptables configuration allows all traffic to your server, so you typically would not want to leave your server unprotected in this state for very long. Nevertheless, this can be very helpful when configuring new firewall rulesets and you need to revert to a blank slate.

```bash
iptables -F
```

We’ve covered a lot of ground in this article! Configuring iptables can seem like a daunting process when first looking at an extensive firewall ruleset, but if you break down the rules one at a time, it becomes much easier to understand the process. When used correctly, iptables is an indispensable tool for hardening your server’s security. Liquid Web customers enjoy our highly trained support staff, standing by 24×7, if you have questions on iptables configurations. Have fun configuring your firewall!
