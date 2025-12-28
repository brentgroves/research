# **[Fun with network namespaces](https://www.gilesthomas.com/2021/03/fun-with-network-namespaces)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../../README.md)**

Linux has some amazing kernel features to enable containerization. Tools like Docker are built on top of them, and at PythonAnywhere we have built our own virtualization system using them.

One part of these systems that I've not spent much time poking into is network namespaces. Namespaces are a general abstraction that allows you to separate out system resources; for example, if a process is in a mount namespace, then it has its own set of mounted disks that is separate from those seen by the other processes on a machine -- or if it's in a process namespace, then it has its own cordoned-off set of processes visible to it (so, say, ps auxwf will just show the ones in its namespace).

As you might expect from that, if you put a process into a network namespace, it will have its own restricted view of what the networking environment looks like -- it won't see the machine's main network interface,

This provides certain advantages when it comes to security, but one that I thought was interesting is that because two processes inside different namespaces would have different networking environments, they could both bind to the same port -- and then could be accessed from outside via port forwarding.

To put that in more concrete terms: my goal was to be able to start up two Flask servers on the same machine, both bound to port 8080 inside their own namespace. I wanted to be able to access one of them from outside by hitting port 6000 on the machine, and the other by hitting port 6001.

Here is a run through how I got that working; it's a lightly-edited set of my "lab notes".

Creating a network namespace and looking inside
The first thing to try is just creating a network namespace, called netns1:

```bash
sudo su
ip netns add netns1
```

Now, you can "go into" the created namespace by using ip netns exec namespace-name, so we can run Bash there and then use ip a to see what network interfaces we have available:

```bash
ip netns exec netns1 /bin/bash
ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
# exit
```

(I'll put the ip netns exec command at the start of all code blocks below if the block in question needs to be run inside the namespace, even when it's not necessary, so that it's reasonably clear which commands are to be run inside and which are not.)

So, we have a new namespace, and when we're inside it, there's only one interface available, a basic loopback interface. We can compare that with what we see with the same command outside:

```bash
# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP group default qlen 1000
    link/ether 0a:d6:01:7e:06:5b brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.173/24 brd 10.0.0.255 scope global dynamic ens5
       valid_lft 2802sec preferred_lft 2802sec
    inet6 fe80::8d6:1ff:fe7e:65b/64 scope link
       valid_lft forever preferred_lft forever
```

There we can see the actual network card attached to the machine, which has the name ens5.

## Getting the loopback interface working

You might have noticed that the details shown for the loopback interface inside the namespace were much shorter, too -- no IPv4 or IPv6 addresses, for example. That's because the interface is down by default. Let's see if we can fix that:

```bash
ip netns exec netns1 /bin/bash
ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
ping 127.0.0.1
ping: connect: Network is unreachable
ip link set dev lo up
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
ping 127.0.0.1
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.019 ms
64 bytes from 127.0.0.1: icmp_seq=2 ttl=64 time=0.027 ms
^C
--- 127.0.0.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1022ms
rtt min/avg/max/mdev = 0.019/0.023/0.027/0.004 ms

```

So, we could not ping the loopback when it was down (unsurprisingly) but once we used the ip link set dev lo up command, it showed up as configured and was pingable.

Now we have a working loopback interface, but the external network still is down:

```bash
ip netns exec netns1 /bin/bash
ping 8.8.8.8
ping: connect: Network is unreachable
```

Again, that makes sense. There's no non-loopback interface, so there's no way to send packets to anywhere but the loopback network.

Virtual network interfaces: connecting the namespace
What we need is some kind of non-loopback network interface inside the namespace. However, we can't just put the external interface ens5 inside there; an interface can only be in one namespace at a time, so if we put that one in there, the external machine would lose networking.

What we need to do is create a virtual network interface. These are created in pairs, and are essentially connected to each other. This command:

```bash
ip link add veth0 type veth peer name veth1
```

Creates interfaces called veth0 and veth1. Anything sent to veth0 will appear on veth1, and vice versa. It's as if they were two separate ethernet cards, connected to the same hub (but not to anything else). Having run that command (outside the network namespace) we can list all of our available interfaces:

```bash
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP group default qlen 1000
    link/ether 0a:d6:01:7e:06:5b brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.173/24 brd 10.0.0.255 scope global dynamic ens5
       valid_lft 2375sec preferred_lft 2375sec
    inet6 fe80::8d6:1ff:fe7e:65b/64 scope link
       valid_lft forever preferred_lft forever
5: veth1@veth0: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ce:d5:74:80:65:08 brd ff:ff:ff:ff:ff:ff
6: veth0@veth1: <BROADCAST,MULTICAST,M-DOWN> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 22:55:4e:34:ce:ba brd ff:ff:ff:ff:ff:ff
```

You can see that they're both there, and are currently down. I read the veth1@veth0 notation as meaning "virtual interface veth1, which is connected to the virtual interface veth0".

We can now move one of them -- veth1 -- into the network namespace netns1, which means that we have the interface outside connected to the one inside:

```bash
ip link set veth1 netns netns1
```

Now, from outside, we see this:

```bash
# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP group default qlen 1000
    link/ether 0a:d6:01:7e:06:5b brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.173/24 brd 10.0.0.255 scope global dynamic ens5
       valid_lft 2368sec preferred_lft 2368sec
    inet6 fe80::8d6:1ff:fe7e:65b/64 scope link
       valid_lft forever preferred_lft forever
6: veth0@if5: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 22:55:4e:34:ce:ba brd ff:ff:ff:ff:ff:ff link-netns netns1
```

veth1 has disappeared (and veth0 is now @if5, which is interesting -- not sure why, though it seems to make some kind of sense given that veth1 is now inside another namespace). But anyway, inside, we can see our moved interface:

```bash
ip netns exec netns1 /bin/bash
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
5: veth1@if6: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ce:d5:74:80:65:08 brd ff:ff:ff:ff:ff:ff link-netnsid 0
```

At this point we have a network interface outside the namespace, which is connected to an interface inside. However, in order to actually use them, we'll need to bring the interfaces up and set up routing. The first step is to bring the outside one up; we'll give it the IP address 192.168.0.1 on the 192.168.0.0/24 subnet (that is, the network covering all addresses from 192.168.0.0 to 192.168.0.255)

```bash
ip addr add 192.168.0.1/24 dev veth0
ip link set dev veth0 up
# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: ens5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP group default qlen 1000
    link/ether 0a:d6:01:7e:06:5b brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.173/24 brd 10.0.0.255 scope global dynamic ens5
       valid_lft 3567sec preferred_lft 3567sec
    inet6 fe80::8d6:1ff:fe7e:65b/64 scope link
       valid_lft forever preferred_lft forever
6: veth0@if5: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state LOWERLAYERDOWN group default qlen 1000
    link/ether 22:55:4e:34:ce:ba brd ff:ff:ff:ff:ff:ff link-netns netns1
    inet 192.168.0.1/24 scope global veth0
       valid_lft forever preferred_lft forever
```

So that's all looking good; it reports "no carrier" at the moment, of course, because there's nothing at the other end yet. Let's go into the namespace and sort that out by bringing it up on 192.168.0.2 on the same network:

```bash
ip netns exec netns1 /bin/bash
ip addr add 192.168.0.2/24 dev veth1
ip link set dev veth1 up
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
5: veth1@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether ce:d5:74:80:65:08 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.0.2/24 scope global veth1
       valid_lft forever preferred_lft forever
    inet6 fe80::ccd5:74ff:fe80:6508/64 scope link tentative
       valid_lft forever preferred_lft forever
```

Now, let's try pinging from inside the namespace to the outside interface:

```bash
ip netns exec netns1 /bin/bash
ping 192.168.0.1
PING 192.168.0.1 (192.168.0.1) 56(84) bytes of data.
64 bytes from 192.168.0.1: icmp_seq=1 ttl=64 time=0.069 ms
64 bytes from 192.168.0.1: icmp_seq=2 ttl=64 time=0.042 ms
^C
--- 192.168.0.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1024ms
rtt min/avg/max/mdev = 0.042/0.055/0.069/0.013 ms
```

And from outside to the inside:

```bash
# ping 192.168.0.2
PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
64 bytes from 192.168.0.2: icmp_seq=1 ttl=64 time=0.039 ms
64 bytes from 192.168.0.2: icmp_seq=2 ttl=64 time=0.043 ms
^C
--- 192.168.0.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1018ms
rtt min/avg/max/mdev = 0.039/0.041/0.043/0.002 ms
```

Great!

However, of course, it's still not routed -- from inside the interface, we still can't ping Google's DNS server:

```bash
ip netns exec netns1 /bin/bash
ping 8.8.8.8
ping: connect: Network is unreachable
```

Connecting the namespace to the outside world with NAT
We need to somehow connect the network defined by our pair of virtual interfaces to the one that is accessed via our real hardware network interface, either by setting up bridging or NAT. I'm running this experiment on a machine on AWS, and I'm not sure how well that would work with bridging (my guess is, really badly), so let's go with NAT.

First we tell the network stack inside the namespace to route everything via the machine at the other end of the connection defined by its internal veth1 IP address:

```bash
ip netns exec netns1 /bin/bash
ip route add default via 192.168.0.1
default via 192.168.0.1 dev veth1 
192.168.0.0/24 dev veth1 proto kernel scope link src 192.168.0.2 
ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2028ms
```

Note that the address we specify in the ip route add default command is the one for the end of the virtual interface pair that is outside the process namespace, which makes sense -- we're saying "this other machine is our router". The first time I tried this I put the address of the interface inside the namespace there, which obviously didn't work, as it was trying to send packets to itself for routing.

So now the networking stack inside the namespace knows where to route stuff, which is why it no longer says "Network is unreachable", but of course there's nothing on the other side to send it onwards, so our ping packets are getting dropped on the floor. We need to use iptables to set up that side of things outside the namespace.

The first step is to tell the host that it can route stuff:

To enable packet routing on a Linux system, you need to configure the kernel to forward packets destined for other networks. This typically involves enabling IP forwarding and setting up routing tables with appropriate routes.

Temporarily Enable IP Forwarding:

```bash
cat /proc/sys/net/ipv4/ip_forward
0

# (temporarily enables forwarding)
echo 1 > /proc/sys/net/ipv4/ip_forward
# or
sudo sysctl -w net.ipv4.ip_forward=1 

# verify
cat /proc/sys/net/ipv4/ip_forward
1

```

## AI Overview: how to sysctl to make routing permanent

Make it persistent (recommended):

Edit the /etc/sysctl.conf file and add or modify the line net.ipv4.ip_forward=1
Apply the changes with sudo sysctl -p

```bash
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p
```

## **[The iptables rules appear in the nftables rule listing](../../firewall/netfilter/iptables-nft/iptables_vs_iptables-nft.md)**

An interesting consequence of iptables-nft using nftables infrastructure is that the iptables ruleset appears in the nftables rule listing. Let's consider an example based on a simple rule:

```bash
update-alternatives --display iptables
iptables - auto mode
  link best version is /usr/sbin/iptables-nft
  link currently points to /usr/sbin/iptables-nft
  link iptables is /usr/sbin/iptables
  slave iptables-restore is /usr/sbin/iptables-restore
  slave iptables-save is /usr/sbin/iptables-save
/usr/sbin/iptables-legacy - priority 10
  slave iptables-restore: /usr/sbin/iptables-legacy-restore
  slave iptables-save: /usr/sbin/iptables-legacy-save
/usr/sbin/iptables-nft - priority 20
  slave iptables-restore: /usr/sbin/iptables-nft-restore
  slave iptables-save: /usr/sbin/iptables-nft-save

iptables -L FORWARD
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

iptables-nft -L FORWARD
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
```

Now that we're forwarding packets, we want to make sure that we're not just forwarding them willy-nilly around the network. If we check the current rules in the FORWARD chain (in the default "filter" table):

I have installed libvirt on this machine so it has modified the ruleset already.

```bash
# Only MicroK8s is using the legacy tables. It is only making rules for its RFC 1918 network.
iptables-legacy -L FORWARD
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  10.1.0.0/16          anywhere             /* generated for MicroK8s pods */
ACCEPT     all  --  anywhere             10.1.0.0/16          /* generated for MicroK8s pods */

oot@isdev:/home/brent/src/pki# iptables -L FORWARD
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         
LIBVIRT_FWX  all  --  anywhere             anywhere            
LIBVIRT_FWI  all  --  anywhere             anywhere            
LIBVIRT_FWO  all  --  anywhere             anywhere   

# Each chain is a list of rules which can match a set of packets. Each rule specifies what to do with a packet that matches. This is called a `target', which may be a jump to a user-defined chain in the same table.

# LIBVIRT_FWX target:
# This target is specifically used by libvirt, a virtualization management library, to mark packets that are being routed through a libvirt-managed network bridge. 

# Functionality:
# It allows traffic forwarded through the bridge created by libvirt.
# It enables DHCP, DNS, TFTP, and SSH traffic to the host machine.
# This is implemented via either iptables or nftables rules, depending on firewalld's backend.

```

We see that the default is ACCEPT, so we'll change that to DROP:
<!-- This may interfere with any specific rules in libvirts custom chain. -->

```bash
iptables -P FORWARD DROP
# iptables -P FORWARD ACCEPT
# iptables -L FORWARD
Chain FORWARD (policy DROP)
target     prot opt source               destination
#
```

OK, now we want to make some changes to the nat iptable so that we have routing. Let's see what we have first:

```bash
iptables -t nat -L

# The iptables NAT PREROUTING chain is an iptables chain that processes incoming packets before any routing decisions are made. It's primarily used for "Destination Network Address Translation (DNAT)", where the destination IP address or port of a packet is modified before it's sent to its intended recipient. 

Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  anywhere             anywhere             ADDRTYPE match dst-type LOCAL

# In iptables, the nat INPUT chain is part of the nat table and is specifically used for Network Address Translation (NAT) on incoming packets destined for the local machine. It processes packets after PREROUTING but before the filtering decision in the INPUT chain of the filter table. 

# INPUT Chain:
# Within the nat table, the INPUT chain focuses on NAT actions for packets directed to the local machine. This means it can modify the source IP address (SNAT) of outgoing packets related to incoming connections. 

# Processing Order:
# Incoming packets first enter the PREROUTING chain in the nat table (for Destination NAT or DNAT). Then, they flow to the INPUT chain in the nat table (for Source NAT or SNAT). Finally, if the packet is still destined for the local system, it enters the INPUT chain in the filter table. 

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

# In iptables, the nat table's OUTPUT chain applies Network Address Translation (NAT) rules to packets generated locally by the system before they are routed out. This chain allows for altering the source IP address or port of outgoing packets, primarily used for scenarios like Source NAT (SNAT) where the local IP address is masked by the router's public IP. 

# Locally Generated Packets:
# The OUTPUT chain specifically targets packets originating from applications running on the local machine. 

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
DOCKER     all  --  anywhere            !localhost/8          ADDRTYPE match dst-type LOCAL

# nat: This table is consulted when a packet that creates a new connection is encountered. It consists of three built-ins: PREROUTING (for altering packets as soon as they come in), OUTPUT (for altering locally-generated packets before routing), and POSTROUTING (for altering packets as they are about to go out)

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
MASQUERADE  all  --  ip-172-17-0-0.ec2.internal/16  anywhere

Chain DOCKER (2 references)
target     prot opt source               destination
RETURN     all  --  anywhere             anywhere
#
```

I have Docker installed on the machine already, and it's got some of its own NAT-based routing configured there. I don't think there's any harm in leaving that there; it's on a different subnet to the one I chose for my own stuff.

So, firstly, we'll enable masquerading from the 192.168.0.* network onto our main ethernet interface ens5:

In iptables, masquerading, a form of SNAT (Source Network Address Translation), allows multiple internal network devices to share a single external IP address, effectively hiding their private IPs behind the router's public IP.

```bash
# from isdev at albion office on vlan 40 through enx803f5d090eb3
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
3: wlp114s0f0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether e0:8f:4c:51:6f:17 brd ff:ff:ff:ff:ff:ff
4: enxa0cec85afc3c: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether a0:ce:c8:5a:fc:3c brd ff:ff:ff:ff:ff:ff
5: enx803f5d090eb3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 80:3f:5d:09:0e:b3 brd ff:ff:ff:ff:ff:ff
    inet 10.187.40.200/24 brd 10.187.40.255 scope global noprefixroute enx803f5d090eb3
       valid_lft forever preferred_lft forever
7: veth0@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether f2:53:43:1c:78:a8 brd ff:ff:ff:ff:ff:ff link-netns netns1
    inet 192.168.0.1/24 scope global veth0
       valid_lft forever preferred_lft forever
    inet6 fe80::f053:43ff:fe1c:78a8/64 scope link 
       valid_lft forever preferred_lft forever

iptables -t nat -A POSTROUTING -s 192.168.0.0/255.255.255.0 -o ens5 -j MASQUERADE

-t nat: Specifies the NAT table. 
-A POSTROUTING: Appends a rule to the POSTROUTING chain. 
-o eth0: Specifies the outgoing interface (e.g., eth0). 
-j MASQUERADE: Sets the target to MASQUERADE. 

# My computer
ip a
# for wireless
iptables -t nat -A POSTROUTING -s 192.168.0.0/255.255.255.0 -o wlp114s0f0 -j MASQUERADE

# for wired
iptables -t nat -A POSTROUTING -s 192.168.0.0/255.255.255.0 -o enx803f5d090eb3 -j MASQUERADE

# verify
list rules by specification
# Purpose: The -S option is used to show the current iptables rules in a format that is easy to read and understand, and that can be used to recreate the rules if needed.
# iptables-legacy -t nat -S only microk8s uses these older tables.

sudo iptables -t nat -S
# Warning: iptables-legacy tables present, use iptables-legacy to see them
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-N LIBVIRT_PRT
-A POSTROUTING -j LIBVIRT_PRT
-A POSTROUTING -s 192.168.0.0/24 -o wlp114s0f0 -j MASQUERADE
-A POSTROUTING -s 192.168.0.0/24 -o wlp114s0f0 -j MASQUERADE
-A LIBVIRT_PRT -s 192.168.122.0/24 -d 224.0.0.0/24 -j RETURN
-A LIBVIRT_PRT -s 192.168.122.0/24 -d 255.255.255.255/32 -j RETURN
-A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p tcp -j MASQUERADE --to-ports 1024-65535
-A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -p udp -j MASQUERADE --to-ports 1024-65535
-A LIBVIRT_PRT -s 192.168.122.0/24 ! -d 192.168.122.0/24 -j MASQUERADE
```

Now we'll say that we'll forward stuff that comes in on interface x can be forwarded to our veth0 interface, which you'll remember is the end of the virtual network pair that is outside the namespace:

```bash
# for wireless
iptables -A FORWARD -i wlp114s0f0 -o veth0 -j ACCEPT

# for wired
iptables -A FORWARD -i enx803f5d090eb3 -o veth0 -j ACCEPT

# advanced https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables
iptables -A FORWARD -i enx803f5d090eb3 -o veth0 -p tcp --syn --dport 80 -m conntrack --ctstate NEW -j ACCEPT
# verify

sudo iptables -S
# Warning: iptables-legacy tables present, use iptables-legacy to see them
-P INPUT ACCEPT
-P FORWARD DROP
-P OUTPUT ACCEPT
-N LIBVIRT_FWI
-N LIBVIRT_FWO
-N LIBVIRT_FWX
-N LIBVIRT_INP
-N LIBVIRT_OUT
-A INPUT -j LIBVIRT_INP
-A FORWARD -j LIBVIRT_FWX
-A FORWARD -j LIBVIRT_FWI
-A FORWARD -j LIBVIRT_FWO
-A FORWARD -s 10.1.0.0/16 -m comment --comment "generated for MicroK8s pods" -j ACCEPT
-A FORWARD -d 10.1.0.0/16 -m comment --comment "generated for MicroK8s pods" -j ACCEPT
-A FORWARD -i wlp114s0f0 -o veth0 -j ACCEPT
```

...and then the routing in the other direction:

```bash
iptables -A FORWARD -o ens5 -i veth0 -j ACCEPT

# for wireless
iptables -A FORWARD -o wlp114s0f0 -i veth0 -j ACCEPT

# for wired
iptables -A FORWARD -o enx803f5d090eb3 -i veth0 -j ACCEPT

# verify
sudo iptables -S
# In iptables, the -S option instructs the command to display the current firewall ruleset in a verbose, human-readable format, showing the rules as they were originally entered
# Warning: iptables-legacy tables present, use iptables-legacy to see them
-P INPUT ACCEPT
-P FORWARD DROP
-P OUTPUT ACCEPT
-N LIBVIRT_FWI
-N LIBVIRT_FWO
-N LIBVIRT_FWX
-N LIBVIRT_INP
-N LIBVIRT_OUT
-A INPUT -j LIBVIRT_INP
-A FORWARD -j LIBVIRT_FWX
-A FORWARD -j LIBVIRT_FWI
-A FORWARD -j LIBVIRT_FWO
-A FORWARD -s 10.1.0.0/16 -m comment --comment "generated for MicroK8s pods" -j ACCEPT
-A FORWARD -d 10.1.0.0/16 -m comment --comment "generated for MicroK8s pods" -j ACCEPT
-A FORWARD -i wlp114s0f0 -o veth0 -j ACCEPT
-A FORWARD -i veth0 -o wlp114s0f0 -j ACCEPT
```

Now, let's see what happens if we try to ping from inside the namespace

```bash
ip netns exec netns1 /bin/bash
ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=112 time=0.604 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=112 time=0.609 ms
^C
--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1003ms
rtt min/avg/max/mdev = 0.604/0.606/0.609/0.002 ms
```

w00t!

## Running a server with port-forwarding

Right, now we have a network namespace where we can operate as a network client -- processes running inside it can access the external Internet.

However, we don't have things working the other way around; we cannot run a server inside the namespace and access it from outside. For that, we need to configure port-forwarding. I'm not perfectly clear in my own mind exactly how this all works; take my explanations below with a cellar of salt...

We use the **["Destination NAT"](http://linux-ip.net/html/nat-dnat.html)** chain in iptables:

```bash
iptables -t nat -A PREROUTING -p tcp -i ens5 --dport 6000 -j DNAT --to-destination 192.168.0.2:8080

# for wireless
iptables -t nat -A PREROUTING -p tcp -i wlp114s0f0 --dport 6000 -j DNAT --to-destination 192.168.0.2:8080

# for wired
iptables -t nat -A PREROUTING -p tcp -i enx803f5d090eb3 --dport 6000 -j DNAT --to-destination 192.168.0.2:8080

```

Or, in other words, if something comes in for port 6000 then we should sent it on to port 8080 on the interface at 192.168.0.2 (which is the end of the virtual interface pair that is inside the namespace).

Next, we say that we're happy to forward stuff back and forth over new, established and related (not sure what that last one is) connections to the IP of our namespaced interface:

```bash
iptables -A FORWARD -p tcp -d 192.168.0.2 --dport 8080 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# My wireless network
iptables -t nat -S
-P INPUT ACCEPT
-P FORWARD DROP
-P OUTPUT ACCEPT
...
-A FORWARD -i wlp114s0f0 -o veth0 -j ACCEPT
-A FORWARD -i veth0 -o wlp114s0f0 -j ACCEPT
-A FORWARD -d 192.168.0.2/32 -p tcp -m tcp --dport 8080 -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT

# My wireless network
iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
...
-A PREROUTING -i wlp114s0f0 -p tcp -m tcp --dport 6000 -j DNAT --to-destination 192.168.0.2:8080
...
-A POSTROUTING -s 192.168.0.0/24 -o wlp114s0f0 -j MASQUERADE
-A POSTROUTING -s 192.168.0.0/24 -o wlp114s0f0 -j MASQUERADE

```

## Add DNS to network namespace

## **[Port Forwarding example](../../architecture/netfilter/firewall/iptables/port_forwarding.md)**

This is much more exact for port forwarding conntrack connection states.

## run server

So, with that set up, we should be able to run a server inside the namespace on port 8080. Using this Python code in the file server.py

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Flask!\n'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
```

```bash
pushd .
cd ~/src/repsys/volumes/python/tutorials/veths_and_namespaces.md
sudo ip netns exec netns1 /bin/bash
uv init
Initialized project `veths-and-namespaces-md`
uv add flask
uv run server.py
...then we run it:

# ip netns exec netns1 /bin/bash
# python3.7 server.py
 * Serving Flask app "server" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
```

...and from a completely separate machine on the same network as the one where we're running the server, we curl it using the machine's external IP address, on port 6000:

```bash
curl http://172.25.188.34:6000/
Hello from Flask!

```

$

## start here

```bash
lxc info | grep firewall
- network_firewall_filtering
- firewall_driver
  firewall: nftables
```
