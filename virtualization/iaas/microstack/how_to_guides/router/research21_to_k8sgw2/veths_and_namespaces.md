# **[Fun with network namespaces](https://www.gilesthomas.com/2021/03/fun-with-network-namespaces)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../../README.md)**

## reference

- **[try](https://github.com/rootless-containers/slirp4netns)**
- **[port forwarding into namespaces](https://serverfault.com/questions/1151515/unshare-and-port-forwarding-into-namespace/1151525)**

Linux has some amazing kernel features to enable containerization. Tools like Docker are built on top of them, and at PythonAnywhere we have built our own virtualization system using them.

One part of these systems that I've not spent much time poking into is network namespaces. Namespaces are a general abstraction that allows you to separate out system resources; for example, if a process is in a mount namespace, then it has its own set of mounted disks that is separate from those seen by the other processes on a machine -- or if it's in a process namespace, then it has its own cordoned-off set of processes visible to it (so, say, ps auxwf will just show the ones in its namespace).

As you might expect from that, if you put a process into a network namespace, it will have its own restricted view of what the networking environment looks like -- it won't see the machine's main network interface,

This provides certain advantages when it comes to security, but one that I thought was interesting is that because two processes inside different namespaces would have different networking environments, they could both bind to the same port -- and then could be accessed from outside via port forwarding.

To put that in more concrete terms: my goal was to be able to start up two Flask servers on the same machine, both bound to port 8080 inside their own namespace. I wanted to be able to access one of them from outside by hitting port 6000 on the machine, and the other by hitting port 6001.

## cleanup

- **[delete rules](./delete_rules.md)**
- **[delete namespace](./delete_namespace.md)**

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
exit
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
exit
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
# from other terminal
tcpdump -i veth0

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
# from namespace
# veth1 did not see the ping until after I pressed ctrl-c to terminate
tcpdump -i veth1

# from host
# ping 192.168.0.2
PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
64 bytes from 192.168.0.2: icmp_seq=1 ttl=64 time=0.039 ms
64 bytes from 192.168.0.2: icmp_seq=2 ttl=64 time=0.043 ms
^C
--- 192.168.0.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1018ms
rtt min/avg/max/mdev = 0.039/0.041/0.043/0.002 ms

# veth1 did not see the ping until after I pressed ctrl-c to terminate
# tcpdump -i veth1 # started before ping 
^C16:13:26.139562 IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 58644, seq 1, length 64
16:13:26.139583 IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 58644, seq 1, length 64
16:13:27.173388 IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 58644, seq 2, length 64
16:13:27.173409 IP 192.168.0.2 > 192.168.0.1: ICMP echo reply, id 58644, seq 2, length 64
16:13:28.196396 IP 192.168.0.1 > 192.168.0.2: ICMP echo request, id 58644, seq 3, length 64

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
The -p option, followed by a filename (e.g., /etc/sysctl.conf), instructs sysctl to read and apply the kernel parameter settings defined in a file.
```

Then run the same command, but replace the -p flag with--system:

```bash
# --system
              # Load settings from all system configuration files. See the SYSTEM FILE PRECEDENCE section below.
sudo sysctl --system
. . .
* Applying /usr/lib/sysctl.d/50-pid-max.conf ...
kernel.pid_max = 4194304
* Applying /etc/sysctl.d/99-cloudimg-ipv6.conf ...
net.ipv6.conf.all.use_tempaddr = 0
net.ipv6.conf.default.use_tempaddr = 0
* Applying /etc/sysctl.d/99-sysctl.conf ...
net.ipv4.ip_forward = 1
* Applying /usr/lib/sysctl.d/protect-links.conf ...
fs.protected_fifos = 1
fs.protected_hardlinks = 1
fs.protected_regular = 2
fs.protected_symlinks = 1
* Applying /etc/sysctl.conf ...
net.ipv4.ip_forward = 1
```

## we are using iptables-nft

```bash
# iptables is actually iptables-nft
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
sudo tcpdump -i enp0s25 'dst 8.8.8.8 and src 10.187.40.123'

```

Now that we're forwarding packets, we want to make sure that we're not just forwarding them willy-nilly around the network. If we check the current rules in the FORWARD chain (in the default "filter" table):

```bash
oot@isdev:/home/brent/src/pki# iptables -L FORWARD
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

# Each chain is a list of rules which can match a set of packets. Each rule specifies what to do with a packet that matches. This is called a `target', which may be a jump to a user-defined chain in the same table.

```

We see that the default is ACCEPT, so we'll change that to DROP:

<!-- I left it as accept for this experiment. -->
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
# From isdev in Albion using vlan 40
iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
```

So, firstly, we'll enable masquerading from the 192.168.0.* network onto our main ethernet interface ens5:

In iptables, **[masquerading](../masquerading/masquerading.md)**, a form of SNAT (Source Network Address Translation), allows multiple internal network devices to share a single external IP address, effectively hiding their private IPs behind the router's public IP.

```bash
# from isdev at albion office on vlan 40 through enx803f5d090eb3
ip a              
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 18:03:73:1f:84:a4 brd ff:ff:ff:ff:ff:ff
    inet 10.187.40.123/24 brd 10.187.40.255 scope global dynamic noprefixroute enp0s25
       valid_lft 51365sec preferred_lft 51365sec
    inet6 fe80::6fd5:28c2:e3ca:d7fd/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
4: veth0@if3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether f6:4b:88:9d:d6:d9 brd ff:ff:ff:ff:ff:ff link-netns netns1
    inet 192.168.0.1/24 scope global veth0
       valid_lft forever preferred_lft forever
    inet6 fe80::f44b:88ff:fe9d:d6d9/64 scope link 
       valid_lft forever preferred_lft forever

# nat: This table is consulted when a packet that creates a new connection is encountered. It consists of three built-ins: PREROUTING (for altering packets as soon as they come in), OUTPUT (for altering locally-generated packets before routing), and POSTROUTING (for altering packets as they are about to go out).

# for wired
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o enp0s25 -j MASQUERADE

# -t nat: Specifies the NAT table. 
# -A POSTROUTING: Appends a rule to the POSTROUTING chain. 
# -o eth0: Specifies the outgoing interface (e.g., eth0). 
# -j MASQUERADE: Sets the target to MASQUERADE. 
# -m is for matching module name and not string. By using a particular module you get certain options to match. See the cpu module example above. With the -m tcp the module tcp is loaded. The tcp module allows certain options: --dport, --sport, --tcp-flags, --syn, --tcp-option to use in iptables rules
 # -S shows you how to type in the table rule
iptables -t nat -S
iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  all  --  192.168.0.0/24       anywhere     

# verify
# list rules by specification
# Purpose: The -S option is used to show the current iptables rules in a format that is easy to read and understand, and that can be used to recreate the rules if needed.
# iptables-legacy -t nat -S only microk8s uses these older tables.

sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A POSTROUTING -s 192.168.0.0/24 -o enp0s25 -j MASQUERADE


# from default namespace
sudo tcpdump -i enp0s25 'dst 8.8.8.8 and src 10.187.40.123'

# This produces no output because src has been changed from 192.168.0.2 to 10.187.40.123
sudo tcpdump -i enp0s25 'dst 8.8.8.8 and src 192.168.0.2'


# from netns1
ip netns exec netns1 /bin/bash
ping 8.8.8.8
```

In the FORWARD chain, you’ll accept new connections destined for port 8080 that are coming from your public interface and traveling to your virtual network interface. New connections are identified by the conntrack extension and will specifically be represented by a TCP SYN packet as in the following:

```bash
# advanced https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables
iptables -A FORWARD -i enp0s25 -o veth0 -p tcp --syn --dport 8080 -m conntrack --ctstate NEW -j ACCEPT
# verify

sudo iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -i enp0s25 -o veth0 -p tcp -m tcp --dport 8080 --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j ACCEPT
```

This will let the first packet, meant to establish a connection, through the firewall. You’ll also need to allow any subsequent traffic in both directions that results from that connection. To allow ESTABLISHED and RELATED traffic between your public and private interfaces, run the following commands. First for your public interface:

```bash
sudo iptables -A FORWARD -i enp0s25 -o veth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

sudo iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -i enp0s25 -o veth0 -p tcp -m tcp --dport 8080 --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j ACCEPT
```

Then for your virtual network interface:

```bash
sudo iptables -A FORWARD -i veth0 -o enp0s25 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -i enp0s25 -o veth0 -p tcp -m tcp --dport 8080 --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j ACCEPT
-A FORWARD -i enp0s25 -o veth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i veth0 -o enp0s25 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
```

Double check that your policy on the FORWARD chain is set to DROP:

Note: I did not make drop the default.

`sudo iptables -P FORWARD DROP`

At this point, you’ve allowed certain traffic between your public and private interfaces to proceed through your firewall. However, you haven’t configured the rules that will actually tell iptables how to translate and direct the traffic.

## Adding the NAT Rules to Direct Packets Correctly

Next, you will add the rules that will tell iptables how to route your traffic. You need to perform two separate operations in order for iptables to correctly alter the packets so that clients can communicate with the web server.

The first operation, called DNAT, will take place in the PREROUTING chain of the nat table. DNAT is an operation that alters a packet’s destination address in order to enable it to correctly route as it passes between networks. The clients on the public network will be connecting to your firewall server and will have no knowledge of your private network topology. Therefore, you need to alter the destination address of each packet so that when it is sent out on your private network, it knows how to correctly reach your web server.

Since you’re only configuring port forwarding and not performing NAT on every packet that hits your firewall, you’ll want to match port 80 on your rule. You will match packets aimed at port 80 to your web server’s private IP address (10.0.0.1 in the following example):

```bash
# sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1

sudo iptables -t nat -A PREROUTING -i enp0s25 -p tcp --dport 8080 -j DNAT --to-destination 192.168.0.2

sudo iptables -t nat -A PREROUTING -i enp0s25 -p tcp --dport 6000 -j DNAT --to-destination 192.168.0.2:8080

iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -i enp0s25 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.0.2
-A PREROUTING -i enp0s25 -p tcp -m tcp --dport 6000 -j DNAT --to-destination 192.168.0.2:8080
-A POSTROUTING -s 192.168.0.0/24 -o enp0s25 -j MASQUERADE
# iptables -t nat -L POSTROUTING --line-numbers
# iptables -t nat -D POSTROUTING 1

```

## Running a server with port-forwarding

So, with that set up, we should be able to run a server inside the namespace on port 8080. Using this Python code in the file server.py

```bash
ps -ef | grep python
kill pid
```

```python
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello from Flask!\n'

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
```

From another terminal start tcpdump

```bash
sudo tcpdump -i enp0s25 'src 10.187.40.18 and dst 10.187.40.123'
```

Start the server.

```bash
# namespace has no dns so add dependancies in default namespace
cd ~/src/repsys/volumes/python/tutorials/veths_and_namespaces
uv init
Initialized project `veths-and-namespaces-md`
uv add flask
uv run server.py
...then we run it:

# now run from namespace
sudo su
ip netns exec netns1 /bin/bash
uv run server.py

 * Serving Flask app "server" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
```

...and from a completely separate machine on the same network as the one where we're running the server, we curl it using the machine's external IP address, on port 8080:

```bash
curl http://10.187.40.123:8080/
Hello from Flask!

curl http://10.187.40.123:6000/
Hello from Flask!

```

## Running a second server in a separate namespace

Now we can set up the second server in its own namespace. Leaving the existing Flask running in the session where we started it just now, we can run through all of the steps above at speed in another:

```bash
ip netns add netns2
ip link add veth2 type veth peer name veth3
ip link set veth3 netns netns2
ip addr add 192.168.1.1/24 dev veth2
ip link set dev veth2 up

iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o enx803f5d090eb3 -j MASQUERADE

iptables -S

iptables -A FORWARD -i enx803f5d090eb3 -o veth2 -p tcp --syn --dport 8080 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -i enx803f5d090eb3 -o veth2 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i veth2 -o enx803f5d090eb3 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

iptables -t nat -S
sudo iptables -t nat -A PREROUTING -i enx803f5d090eb3 -p tcp --dport 8081 -j DNAT --to-destination 192.168.1.2:8080

ip netns exec netns2 /bin/bash
ip link set dev lo up
ip addr add 192.168.1.2/24 dev veth3
ip link set dev veth3 up
ip route add default via 192.168.1.1

cd ~/src/repsys/volumes/python/tutorials/veths_and_namespaces

# now run from namespace
sudo su
ip netns exec netns2 /bin/bash
uv run server.py

 * Serving Flask app "server" (lazy loading)
 * Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
 * Debug mode: off
 * Running on http://0.0.0.0:8080/ (Press CTRL+C to quit)
```

# python3.7 server2.py

- Serving Flask app "server2" (lazy loading)
- Environment: production
   WARNING: This is a development server. Do not use it in a production deployment.
   Use a production WSGI server instead.
- Debug mode: off
- Running on <http://0.0.0.0:8080/> (Press CTRL+C to quit)

```
