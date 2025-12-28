# **[brctl](https://www.baeldung.com/linux/bridging-network-interfaces)**

This section describes the management of a network bridge using the legacy brctl tool from the bridge-utils package. See brctl(8) for full listing of options.

**[brctl obsolete](https://wiki.archlinux.org/title/network_bridge)**
Note: The use of brctl is deprecated and is considered obsolete. See the Notes section in brctl(8) § NOTES for details.

In Linux, bridging network interfaces is a common practice for combining two or more network interfaces into a single virtual interface. Bridging is useful for various reasons, such as improving network performance, redundancy, and load balancing.

In this article, we’ll explain what network bridging is, how to set it up, and provide some examples of how it can be used in practice.

## references

<https://linux.die.net/man/8/brctl>

## What Is Network Bridging?

A network bridge is a software component that connects two or more network interfaces together to create a virtual network. When bridging network interfaces, they function as a single network interface, seamlessly allowing data to flow between them. To achieve this, we create a logical bridge interface that acts as a layer 2 switch, forwarding packets between the physical interfaces.

We can bridge network interfaces, such as Ethernet, wireless, and virtual. Bridging can be helpful in a variety of scenarios, such as:

Combining two or more network interfaces to increase bandwidth and improve network performance
Creating a redundant network interface to ensure high availability in case of failure
Load-balancing network traffic across multiple interfaces to distribute network load
Creating a virtual network between virtual machines running on the same physical host

## How to Bridge Network Interfaces

In Linux, the most common tool used for network bridging is the bridge-utils package, which provides the brctl command-line tool for configuring and managing bridges.

Before creating a bridge, it’s important to identify the network interfaces that we want to bridge. We can do this by using the ip command to list all available network interfaces on the system. The ip command is a powerful tool for configuring and managing network interfaces in Linux.

ip link show
To list all available network interfaces, we can use the ip link show command in a terminal or shell:

```bash
$ ip link show
Copy
This command will display a list of all network interfaces and their status and configuration. Let’s see an example output:

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 00:11:22:33:44:55 brd ff:ff:ff:ff:ff:ff

3: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 66:77:88:99:aa:bb brd ff:ff:ff:ff:ff:ff

4: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc mq state DOWN mode DORMANT group default qlen 1000
    link/ether dd:ee:ff:00:11:22 brd ff:ff:ff:ff:ff:ff
```

In this example output, we can see that there are four network interfaces: lo, eth0, eth1, and wlan0. We use the lo interface as the loopback interface, which is used for local network communication. The eth0 and eth1 interfaces are Ethernet interfaces, while the wlan0 interface is a wireless interface.

To bridge two or more network interfaces, we need to identify their names or interface identifiers. In this example, we could bridge the eth0 and eth1 interfaces by creating a bridge interface named br0 and adding eth0 and eth1, as shown in the examples later.

## ifconfig

To create a bridge interface, we must ensure that we haven’t already configured the network interfaces we want to bridge with IP addresses or other network settings. We can use the ifconfig command to check the configuration of an interface and disable it if necessary.

For example, to limit the configuration of the eth0 interface and disable it, we can run:

```bash
sudo ifconfig eth0
sudo ifconfig eth0 down

# inet and inet6
ifconfig eno1
eno1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.1.0.135  netmask 255.255.252.0  broadcast 10.1.3.255
        inet6 fe80::5e6:ac5:7cdd:c873  prefixlen 64  scopeid 0x20<link>
        ether b8:ca:3a:6a:35:98  txqueuelen 1000  (Ethernet)
        RX packets 78453982  bytes 8526863780 (8.5 GB)
        RX errors 0  dropped 20688  overruns 0  frame 0
        TX packets 1048698  bytes 317606349 (317.6 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device memory 0xdcb00000-dcbfffff  

# enslave no inet line
ifconfig eno2
eno2: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether b8:ca:3a:6a:35:99  txqueuelen 1000  (Ethernet)
        RX packets 84607627  bytes 13470021961 (13.4 GB)
        RX errors 0  dropped 20688  overruns 0  frame 0
        TX packets 2086547  bytes 1230730802 (1.2 GB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device memory 0xdcc00000-dccfffff 

ifconfig eno3
eno3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.1.3.172  netmask 255.255.252.0  broadcast 10.1.3.255
        inet6 fe80::4418:3ffb:954b:9cea  prefixlen 64  scopeid 0x20<link>
        ether b8:ca:3a:6a:35:9a  txqueuelen 1000  (Ethernet)
        RX packets 1663  bytes 167560 (167.5 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 239  bytes 36419 (36.4 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        device memory 0xdcd00000-dcdfffff  

```

The first command will display detailed information about the current configuration of the eth0 interface. The second command will set the eth0 interface to the down state, temporarily disabling it and allowing us to reconfigure it without conflicts.

We can repeat this process for any other interfaces we want to bridge, making sure that they’re also in the down state before proceeding. Once we have prepared the interfaces, we can move on to creating the bridge interface and adding the interfaces to it.

Here’s an example output of running the ifconfig command on the eth0 interface:

```bash
$ sudo ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.100  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 fe80::a00:27ff:fefc:e856  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:fc:e8:56  txqueuelen 1000  (Ethernet)
        RX packets 317  bytes 33996 (33.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 103  bytes 10998 (10.7 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

This output shows that the eth0 interface is currently configured with an IP address of 192.168.1.100 and a netmask of 255.255.255.0. To prepare this interface for bridging, we would need to disable it using the ifconfig command as described above.

brctl addbr
After identifying the network interfaces we want to bridge, we can create the bridge interface using the brctl command. The brctl command is a command-line utility that is used to configure Ethernet bridge interfaces in Linux.

To create a new bridge interface, we can use the brctl addbr command followed by the name of the bridge interface we want to create. For example, let’s create a new bridge interface named br0:

```bash

sudo brctl addbr br0
```

This command creates a new bridge interface named br0. The sudo command runs the brctl command with administrative privileges, as creating a bridge interface requires root-level access.

## brctl addif

Once the bridge interface has been created, we can add the network interfaces we want to bridge to it. This is done using the brctl addif command, followed by the name of the bridge interface and the names of the network interfaces we want to add. For example, let’s add the eth0 and eth1 interfaces to our newly-created br0 bridge interface:

```bash
sudo brctl addif br0 eth0
sudo brctl addif br0 eth1
```

We can confirm that the network interfaces have been added to the bridge interface by running the brctl show command:

```bash
$ sudo brctl show
bridge name  bridge id          STP enabled  interfaces
br0          8000.000000000000  no           eth0
                                             eth1
```

After adding the network interfaces to the bridge interface, we can configure the bridge interface as we would any other network interface. This includes assigning an IP address to the bridge interface and configuring any necessary network settings, such as DNS servers or routing tables.

Finally, we need to bring up the bridge interface and the physical interfaces:

```bash
sudo ifconfig br0 up
sudo ifconfig eth0 up
sudo ifconfig eth1 up
```

This command brings up the br0 interface and the physical interfaces, making them ready for use. Let’s run the ifconfig command to check the status of the network interfaces:

```bash
$ ifconfig br0
br0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.0.10  netmask 255.255.255.0  broadcast 192.168.0.255
        inet6 fe80::c72:83ff:fe1c:88c6  prefixlen 64  scopeid 0x20<link>
        ether c6:72:83:1c:88:c6  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 100  bytes 10370 (10.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

$ ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 00:11:22:33:44:55  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 100  bytes 10370 (10.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

$ ifconfig eth1
eth1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 00:11:22:33:44:56  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 100  bytes 10370 (10.3 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

This output shows that the br0, eth0, and eth1 interfaces are all up and running. The inet field displays the IP address assigned to each interface, while the ether field displays the interface’s MAC address. The TX and RX fields display the number of packets and bytes transmitted and received by the interface, respectively.

## Practical Examples

Let’s look at some practical examples of how network bridging can be used in Linux.

### Improving Network Performance

One of the primary use cases for network bridging is to combine two or more network interfaces to increase bandwidth and improve network performance. By bridging the interfaces, we create a single virtual interface to handle more network traffic and improve overall network throughput.

For example, we have two Ethernet interfaces, eth0 and eth1, each with a maximum throughput of 1 Gbps. If we bridge these interfaces into a single virtual interface, we can achieve a maximum throughput of 2 Gbps. This can be useful in scenarios where we need to transfer large amounts of data quickly or support high-bandwidth applications.

## Creating a Redundant Network Interface

Another use case for network bridging is to create a redundant network interface to ensure high availability in case of failure. By bridging two or more network interfaces, we create a failover mechanism that automatically switches to a backup interface if the primary interface fails.

For example, if we bridge eth0 and eth1 into a single virtual interface, we can configure the system to use eth0 as the primary interface and eth1 as the backup interface. If eth0 fails, the system will automatically switch to eth1 to maintain network connectivity.

## Load Balancing Network Traffic

Another use case for network bridging is to load-balance network traffic across multiple interfaces to distribute network load. By distributing network traffic across multiple interfaces, we can avoid bottlenecks and ensure that no single interface becomes overloaded.

For example, if we bridge eth0 and eth1 into a single virtual interface, we can configure the system to distribute network traffic evenly across both interfaces. This can be useful in scenarios where multiple clients are accessing a server simultaneously or where we need to support high-bandwidth applications.

## Creating a Virtual Network

Another use case for network bridging is to create a virtual network between virtual machines running on the same physical host. By bridging the virtual network interfaces of the virtual machines, we can create a virtual network that allows them to communicate with each other as if they were connected to the same physical network.

For example, if we have two virtual machines running on the same physical host, we can bridge their virtual network interfaces into a single virtual interface. This will allow the virtual machines to communicate with each other directly without going through the physical network.

```bash
brctl show br-eno2
bridge name bridge id  STP enabled interfaces
br-eno2  8000.de2804da3a48 yes  eno2
                                tapb9f2fc68
                                tape3f5bd2d
```

```bash
nmcli con mod "br-eno2" ipv4.method "manual"

nmcli con mod "br-eno2" ipv4.dns "172.20.0.39,10.1.2.69,10.1.2.70"
nmcli con mod "br-eno2" ipv4.dns-search "BUSCHE-CNC.COM"
nmcli con mod "br-eno2" ipv4.addresses "10.1.0.136/22"
nmcli con mod "br-eno2" ipv4.gateway "10.1.1.205"
```

```bash

brctl show
bridge name bridge id  STP enabled interfaces
br-eno2  8000.de2804da3a48 yes  eno2
       tap5a31bd23
       tap6f162cbc
localbr  8000.ae6fd934278a yes  tap04270071
mpbr0  8000.00163e0f04ee no  tap539daa08
       tap5459bdcf
       tap94d4edf6
       tapc97b1123
       taped857341
       tapeed7b980
mybr  8000.e24fb4ddf41b yes  tap36ec9bf6
       tap3eec7b9d
       tap936d26a5
       tapd32106b2
       tapfde3cc51
```
