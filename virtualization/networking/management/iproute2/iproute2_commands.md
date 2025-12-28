# **[Some useful command with iproute2](https://linuxaria.com/howto/useful-command-of-iproute2)**

## references

- **[MAC Address](https://linuxaria.com/pills/mac-address-su-linux)**

iproute2 is intended to replace this entire suite of legacy Unix networking tools that were previously used for the tasks of configuring network interfaces, routing tables, and managing the ARP table, but which have not been developed since 2001.

You can find some examples of the usage of the iproute commands on my articles about:

– **[Policy routing](https://linuxaria.com/howto/policy-routing-linux-iproute2?lang=en)**
– **[Socket Statistics on Linux](https://linuxaria.com/pills/ss-iproute2-linux?lang=en)**
– **[MAC Address Managment on Linux](https://linuxaria.com/pills/mac-address-su-linux?lang=en)**

## Interface configuration

With this task you can set an interface up and configure an IP address over it, so 2 classic command with ifconfig were:

```bash
[root@myserver.com ~]# ifconfig eth0 up
[root@myserver.com ~]# ifconfig eth0 192.168.1.1 netmask 255.255.255.0
With iproute2, control of interfaces themselves – both physical and logical – is through the link subcommand. Bringing up eth0 can be done with

[root@myserver.com ~]# ip link set eth0 up
While to add an IP address to an interface you can use:

[root@myserver.com ~]# ip addr add 192.0.2.1/24 dev eth0
If you prefer you can use also this notation:

[root@myserver.com ~]# ip addr add 192.0.2.1 255.255.255.0 dev eth0
To verify the result, or just check which IP addresses are configured on your system you can use:

[root@myserver.com ~]#ip addr ls
[root@myserver.com ~]#ip addr show
[root@myserver.com ~]#ip addr ls eth0
```

The first 2 command gave exactly the same output, while the third just shows the IP of the eth0 device.

## Creating ethernet alias

Assuming that your eth0 IP is 192.0.2.1 and you would like to create an alias eth0:0 with IP 192.0.2.2. You would use:

```bash
ifconfig eth0:0 192.0.2.2 up
Where the key was to put :number to indicate that the IP was an alias, with iproute2 you can simply use the same command :

[root@myserver.com ~]# ip addr add 192.0.2.2 255.255.255.0 dev eth0
Routing
What’s the modern alternative of the command route -n ?
A simple:

[brent@repsys11 ~]# ip ro
The output is slightly different but you get exactly the same information:
default via 10.1.1.205 dev eno1 proto static
10.1.0.0/22 dev br0 proto kernel scope link src 10.1.0.126
10.1.0.0/22 dev br2 proto kernel scope link src 10.1.0.127
10.1.0.0/22 dev br3 proto kernel scope link src 10.1.0.140
10.1.0.0/22 dev eno1 proto kernel scope link src 10.1.0.125
10.13.31.0/24 dev br1 proto kernel scope link src 10.13.31.1 linkdown
10.127.233.0/24 dev mpbr0 proto kernel scope link src 10.127.233.1
ubuntu@repsys11-c2-n2:~$ ip ro
default via 10.127.233.1 dev enp5s0 proto dhcp src 10.127.233.252 metric 100 
10.1.0.0/22 dev enp6s0 proto kernel scope link src 10.1.0.142 
blackhole 10.1.41.128/26 proto 80 
10.1.41.133 dev cali104635667e0 scope link 
10.1.41.134 dev cali96e44e3d43b scope link 
10.127.233.0/24 dev enp5s0 proto kernel scope link src 10.127.233.252 metric 100 
10.127.233.1 dev enp5s0 proto dhcp scope link src 10.127.233.252 metric 100
[me@mydesktop ~] route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.0.1     0.0.0.0         UG    0      0        0 wlan0
169.254.0.0     0.0.0.0         255.255.0.0     U     1000   0        0 wlan0
192.168.0.0     0.0.0.0         255.255.255.0   U     9      0        0 wlan0
 
[me@mydesktop ~] ip ro
default via 192.168.0.1 dev wlan0  proto static 
169.254.0.0/16 dev wlan0  scope link  metric 1000 
192.168.0.0/24 dev wlan0  proto kernel  scope link  src 192.168.0.3  metric 9
And to add and remove routes you can use the syntax ip ro add|del destination via gateway, so to add and remove a route to the lan 10.0.0.0/16 I could use:

[me@mydesktop ~]# ip ro add 10.0.0.0/16 via 192.168.0.1
[me@mydesktop ~]# ip ro del 10.0.0.0/16 via 192.168.0.1
```

## Find the Route to an IP Address

If you have multiple interfaces and switch between them (eth0 for work, wlan1 for home, tun0 for vpn) and you want to get the ip and gateway of the interface actually used to connect to an IP try this:

```bash
[root@myserver.com ~]# ip route get IP
So for example you could use the IP 8.8.8.8 (Google DNS server) to check which interface the computer will use:

[me@mydesktop ~] ip route get 8.8.8.8
8.8.8.8 via 192.168.0.1 dev wlan0  src 192.168.0.3
So to reach 8.8.8.8 my desktop uses wlan0, the gatway located at 192.168.0.1 and the private ip 192.168.0.3

Neighbours
In iproute2 there is also a subcommand equivalent to the traditional arp -na, useful to know the ARP table on a UNIX machine.
You can get the same result with iproute2 using ip neighbor, with ip n being the shortened extreme:

[me@mydesktop ~] ip neigh
192.168.0.1 dev wlan0 lladdr 00:18:4d:af:a0:64 REACHABLE
So what are you waiting for ?
It’s time to switch to the “new” iproute suite, the commands are easy and powerful !
```

## First task: find the MAC address of your network devices

we will use the iproute2 package, which we have already discussed in previous articles

```bash
ip link show

Example of output:

1: lo: mtu 16436 qdisc noqueue state UNKNOWN
link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
link/ether 00:0d:60:12:78:bc brd ff:ff:ff:ff:ff:ff
3: eth1: mtu 1500 qdisc pfifo_fast state UP qlen 1000
link/ether 00:02:8a:9f:21:34 brd ff:ff:ff:ff:ff:ff
4: wifi0: mtu 2312 qdisc noop state DOWN qlen 100
link/ieee802.11 00:02:8a:9f:21:34 brd ff:ff:ff:ff:ff:ff
```

The ip utility will sequentially number the network cards in the output. These numbers are dynamically calcualted, so should not be used to refer to the interfaces. It is far better (and more intuitive) to refer to the interfaces by name.

For each device, two lines will summarize the link state and characteristics. If you are familiar with ifconfig output, you should notice that these two lines are a terse summary of lines 1 and 3 of each ifconfig device entry.

The flags here are the same flags reported by ifconfig, although by contrast to ifconfig, ip link show seems to report the state of the device flags accurately.

Line one summarizes the current name of the device, the flags set on the device, the maximum transmission unit (MTU) the active queueing mechanism (if any), and the queue size if there is a queue present.
The second line will always indicate the type of link layer in use on the device, and link layer specific information. For Ethernet, the common case, the current hardware address (MAC Address) and Ethernet broadcast address will be displayed.

## Second task: change the MAC address of your network devices

```bash
ip link set dev eth0 address 00:80:c8:f8:be:ef

The command does not provides any output, giving the command ip link show eth0 we have now:

2: eth0: mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
link/ether 00:80:c8:f8:be:ef brd ff:ff:ff:ff:ff:ff
```

So we successfully change the MAC address of our eth0 network device.

ARP
The Address Resolution Protocol (ARP) is a computer networking protocol for determining a network host’s Link Layer or hardware address when only its Internet Layer (IP) or Network Layer address is known. This function is critical in local area networking as well as for routing internetworking traffic across gateways (routers) based on IP addresses when the next-hop router must be determined

## Third task: change the flag of eth0 to remove the ARP answering ability

```bash
ip link set arp off dev eth0

The command does not provides any output, giving the command ip link show eth0 we have now:


2: eth0: mtu 1500 qdisc pfifo_fast state DOWN qlen 1000
link/ether 00:80:c8:f8:be:ef brd ff:ff:ff:ff:ff:ff
```

So we see now the flag NOARP and the interface will not answer anymore to ARP request.

For more information check:  <http://linux-ip.net/html/tools-ip-link.html>

## B.3. **[ip link](http://linux-ip.net/html/tools-ip-link.html)**

Part of the iproute2 suite, ip link provides the ability to display link layer information, activate an interface, deactivate an interface, change link layer state flags, change MTU, the name of the interface, and even the hardware and Ethernet broadcast address.

The ip link tool provides the following two verbs: ip link show and ip link set.

B.3.1. Displaying link layer characteristics with ip link show
To display link layer information, ip link show will fetch characteristics of the link layer devices currently available. Any networking device which has a driver loaded can be classified as an available device. It is immaterial to ip link whether the device is in use by any higher layer protocols (e.g., IP). You can specify which device you want to know more about with the dev <interface> option.

Example B.6. Using ip link show

```bash
[root@tristan]# ip link show
1: lo: <LOOPBACK,UP> mtu 16436 qdisc noqueue 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
```

Here we see that the only devices with drivers loaded on tristan are lo and eth0. Note, as with ip address show, the ip utility will sequentially number the output. These numbers are dynamically calcualted, so should not be used to refer to the interfaces. It is far better (and more intuitive) to refer to the interfaces by name.

For each device, two lines will summarize the link state and characteristics. If you are familiar with ifconfig output, you should notice that these two lines are a terse summary of lines 1 and 3 of each ifconfig device entry.

The flags here are the same flags reported by ifconfig, although by contrast to ifconfig, ip link show seems to report the state of the device flags accurately.

Let's take a brief tour of the ip link show output. Line one summarizes the current name of the device, the flags set on the device, the maximum transmission unit (MTU) the active queueing mechanism (if any), and the queue size if there is a queue present. The second line will always indicate the type of link layer in use on the device, and link layer specific information. For Ethernet, the common case, the current hardware address and Ethernet broadcast address will be displayed.

## B.3.2. Changing link layer characteristics with ip link set

Frankly, with the exception of ip link set up and ip link set down I have not found need to use the ip link set command with any of the toggle flags Regardless, here's an example of the proper operation of the utility. Paranoid network administrators or those who wish to map Ethernet addresses manually should take special note of the ip link set arp off command.

Example B.7. Using ip link set to change device flags

```bash
[root@tristan]# ip link set dev eth0 promisc on
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,MULTICAST,PROMISC,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
[root@tristan]# ip link set dev eth0 multicast off promisc off
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
[root@tristan]# ip link set arp off
Not enough of information: "dev" argument is required.
[root@tristan]# ip link set arp off dev eth0
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,NOARP,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
[root@enclitic root]# ip link set dev eth0 arp on 
[root@tristan root]# ip link show dev eth0
2: eth0: <BROADCAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
```

Any of the below flags are valid on any device.

Table B.1. ip link link layer device states

Flag Possible States
arp on | off
promisc on | off
allmulti on | off
multicast on | off
dynamic on | off

Users who would like more information about flags on link layer devices and their meanings should refer to Alexey Kuznetsov's excellent iproute2 reference. See the Section I.1.6, “iproute2 documentation” for further links

## B.3.3. Deactivating a device with ip link set

In the same way that using the tool ifconfig <interface> down can summarily stop networking, ip link set dev <interface> down will have a number of side effects for higher networking layers which are bound to this device.

Let's look at the side effects of using ip link to bring an interface down.

Example B.8. Deactivating a link layer device with ip link set

```bash
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
[root@tristan]# ip route show
192.168.99.0/24 dev eth0  proto kernel  scope link  src 192.168.99.35
127.0.0.0/8 dev lo  scope link 
default via 192.168.99.254 dev eth0
[root@tristan]# ip link set dev eth0 down
[root@tristan]# ip address show dev eth0
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
    inet 192.168.99.35/24 brd 192.168.99.255 scope global eth0
[root@tristan]# ip route show
127.0.0.0/8 dev lo  scope link
```

In our first command, we are able to determine that the eth0 is in an UP state. Naturally, ip link will not tell us if there is an IP bound to the device (use ip address to answer this question). Let's assume that tristan was operating normally on 192.168.199.35. If so, the routing table will appear exactly is it appears in Example B.8, “Deactivating a link layer device with ip link set”.

Now when we down the link layer on eth0, we'll see that there is now no longer a flag UP in the link layer output of ip address. More interesting, though, all of our IP routes to destinations via eth0 are now missing.

## B.3.4. Activating a device with ip link set

Before an interface can be bound to a device, the kernel needs to support the physical networking device (beyond the scope of this document) either as a module or as part of the monolithic kernel. If ip link show lists the device, then this condition has been satisfied, and ip link set dev <interface> can be used to activate the interface.

Example B.9. Activating a link layer device with ip link set

```bash
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
[root@tristan]# arping -D -I eth0 192.168.99.35
Interface "eth0" is down
[root@tristan]# ip link set dev eth0 up
[root@tristan]# ip address show dev eth0
2: eth0: <BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
    inet 192.168.99.35/24 brd 192.168.99.255 scope global eth0
[root@tristan]# ip route show
192.168.99.0/24 dev eth0  proto kernel  scope link  src 192.168.99.35
127.0.0.0/8 dev lo  scope link
```

Once the device itself has been activated, operations which require the ability to read data from the device or write data to the device will succeed. Refer to Example B.5, “Duplicate Address Detection with arping” for a clear example of a network operation which does not require a functional IP layer but need access to a functioning link layer.

I'll suggest that the reader consider what other common networking device might not want to have a functional IP layer, but would need a functioning link layer. FIXME -- Why in the world does tcpdump work even though the link layer is down? -- FIXME

In Example B.9, “Activating a link layer device with ip link set”, we are bringing up a device which already has IP address information bound to the device. Notice that as soon as the link layer is brought up, the network route to the local network is entered into the main routing table. By comparing Example B.9, “Activating a link layer device with ip link set” and Example B.8, “Deactivating a link layer device with ip link set”, we notice that when the link layer is brought up the default route is not returned! This is the most significant side effect of bringing down an interface through which other networks are reachable. There are several ways to repair the frightful missing default route condition: you can use ip route add, route add, or you can run the networking startup scripts again.

## B.3.5. Using ip link set to change the MTU

Changing the MTU on an interface is a classical example of an operation which, prior to the arrival of iproute2 one could only accomplish with the ifconfig command. Since iproute2 has separate utilities for managing the link layer, addressing, routing, and other IP-related objects, it becomes clear even with the command-line utilities that the MTU is really a function of the link layer protocol.

Example B.10. Using ip link set to change device flags

```bash
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
[root@tristan]# # ip link set dev eth0 mtu 1412
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,UP> mtu 1412 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
```

This simple example demonstrates exactly how to change the MTU. For a broader discussion of MTU, please consult Section 4.10.1, “MTU, MSS, and ICMP”. The remaining options to the ip link command cannot be used while the interface is in an UP state.

## B.3.6. Changing the device name with ip link set

For the occasional need to rename an interface from one name to another, the command ip link set provides the desired functionality. Though this command must be used when the device is not in an UP state, the command itself is quite simple. Let's name the interface inside0.

Example B.11. Changing the device name with ip link set

```bash
[root@tristan]# ip link set dev eth0 mtu 1500
[root@tristan]# ip link set dev eth0 name inside
[root@tristan]# ip link show dev inside
2: inside: <BROADCAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:4a:51 brd ff:ff:ff:ff:ff:ff
```

The convenience of being able to rename devices can be substantial when you are managing many machines and want to use the same name on many different machines, which may have different hardware. Of course, by changing the name of the device, you may foil any scripts which assume conventional device names (eth0, eth1, ppp0).

## B.3.7. Changing hardware or Ethernet broadcast address with ip link set

This command changes the hardware or broadcast address of a device as used on the media to which it is connected. Supposedly there can be name clashes between two different Ethernet cards sharing the same hardware address. I have yet to see this problem, so I suspect that changing the hardware address is more commonly used in vulnerabliity testing or even more nefarious purposes.

Alternatively, one can set the broadcast address to a different value, which as Alexey remarks as an aside in the iproute2 manual will "break networking." Changing the Ethernet broadcast address implies that no conventionally configured host will answer broadcast ARP frames transmitted onto the Ethernet. Since conventional ARP requests are sent to the Ethernet broadcast of ff:ff:ff:ff:ff:ff, broadcast frames sent after changing the link layer broadcast address will not be received by other hosts on the segment. To echo Alexey's sentiments: if you are not sure what you are doing, don't change this. You'll break networking terribly.

Example B.12. Changing broadcast and hardware addresses with ip link set

```bash
[root@tristan]# ip link set dev inside name eth0
[root@tristan]# ip link set dev eth0 address 00:80:c8:f8:be:ef
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:be:ef brd ff:ff:ff:ff:ff:ff
[root@tristan]# ip link set dev eth0 broadcast ff:ff:88:ff:ff:88
[root@tristan]# ip link show dev eth0
2: eth0: <BROADCAST,UP> mtu 1500 qdisc pfifo_fast qlen 100
    link/ether 00:80:c8:f8:be:ef brd ff:ff:88:ff:ff:88
[root@tristan]# ping -c 1 -n 10.1.0.113 >/dev/null 2>&1 &
[root@tristan]# tcpdump -nnqtei eno
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eno1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
b8:ca:3a:6a:35:98 > 18:03:73:1f:84:a4, IPv4, length 254: 10.1.0.135.22 > 10.1.0.113.39196: tcp 188
18:03:73:1f:84:a4 > b8:ca:3a:6a:35:98, IPv4, length 66: 10.1.0.113.39196 > 10.1.0.135.22: tcp 0

tcpdump: listening on eth0
0:80:c8:f8:be:ef ff:ff:88:ff:ff:88 42: arp who-has 192.168.99.254 tell 192.168.99.35
0:80:c8:f8:be:ef ff:ff:88:ff:ff:88 42: arp who-has 192.168.99.254 tell 192.168.99.35
```

This practical example demonstrates setting the hardware address and the broadcast address. Changing the hardware address, also known as the media access control (MAC) address, is not usually necessary. It is a simple operation without detrimental side effects, provided there is no address clash with an existing device.

Note, however, in the tcpdump output, the effect of changing the Ethernet broadcast address. As discussed in the paragraph above, changing the broadcast is probably not a good idea [42].

As you can see, the ip link utility is a treasure trove of information and allows a great deal of control over the devices on a linux system.
