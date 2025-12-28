# Network interface

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## references

<https://www.linode.com/docs/products/compute/compute-instances/guides/netplan/>
<https://www.baeldung.com/linux/network-interface-configure>

## What Is a Network Interface?

Simply, a network interface is the point of connection between a computer and a network. In other words, how the Linux system links up the software side of networking to the hardware side.

## Network Interface Types

The Linux system distinguishes two types of network interfaces – the physical network interface and the virtual network interface.

A physical network interface represents a network hardware device such as NIC (Network Interface Card), WNIC (Wireless Network Interface Card), or a modem.

A virtual network interface does not represent a hardware device but is linked to a network device. It can be associated with a physical or virtual interface.

## Network Interface Name

Linux systems use two different styles of naming the network interfaces. The first style is the old-style name, such as eth0, eth1, and wlan0. The new ones are based on hardware locations like enp3s0 and wlp2s0.

So, we can use the ls command and the sys file system to quickly list the available network interfaces. Each entry in the /sys/class/net directory represents a physical or virtual network interface:

```bash
$ ls /sys/class/net
eth0 lo wlan0

To get more details about the network interfaces. we can use the ip link command:

$ ip link 
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 54:ee:74:c1:19:92 brd ff:ff:ff:ff:ff:ff
3: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 52:54:00:f0:27:9a brd ff:ff:ff:ff:ff:ff permaddr 94:e9:79:fd:51:5d
Copy
```

Here, we can see three network interfaces, their type, and their state. Alternatively, we can also use the ifconfig command.

In addition, to get the IP address and other related information, we use  the ip addr command:

```bash
$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 54:ee:74:c1:19:92 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.122/24 brd 192.168.0.255 scope global dynamic noprefixroute enp3s0
       valid_lft 80953sec preferred_lft 80953sec
    inet6 fe80::bb4c:8096:6:3695/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
3: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 52:54:00:f0:27:9a brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.13/24 brd 192.168.1.255 scope global dynamic noprefixroute wlp2s0
       valid_lft 42974sec preferred_lft 42974sec
    inet6 fe80::f73c:2d98:746f:9582/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

## What Is the /etc/network/interfaces File?

To clarify,  /etc/network/interfaces file is a way to configure network interfaces. It’s mostly used by Lihttps://askubuntu.com/questions/1429945/what-is-the-default-ubuntu-server-22-04-network-rendererher statically or dynamically. Further, we can set up routing information, a DNS server, etc.

Moreover, when we use the network interface management commands, they bring up and down the interfaces and configure them based on the /etc/network/interfaces file: the ifup command brings the network interface up, while the ifdown command takes it down.

## Why /etc/network/interface File Is Empty

As we saw earlier, there multiple ways to configure the network interfaces on the Linux system. So, if we find the config file empty, this probably means that our network is managed by another tool.

In many distributions and often in desktop installations, Linux systems use the network manager to manage the network. Therefore, the config file can be empty.

In this case, we’ve to disable the network manager to avoid interfering with the /etc/network/interfaces file :

```bash
sudo systemctl status NetworkManager.service
sudo systemctl stop NetworkManager.service
sudo systemctl disable NetworkManager.service
```

## 4. How to Configure Network Interface Using /etc/network/interfaces

Before going into the configuration details, let’s get familiar with the syntax of the /etc/network/interfaces file. We’ll understand some keywords so that we can configure the network correctly.

4.1. The /etc/network/interfaces File Syntax
To enable a network interface at boot time automatically, we use the following syntax:

```
auto <interface>
```

Here, <interface> is the network interface name, like, eth0.

We declare a network interface with the keyword iface:

```iface lo inet loopback```

The lo stands for loopback, a virtual network interface for local usage, and inet means internet protocol family (IPv4). In short, we assign a special IP address (127.0.0.1).

Here’s the format for the declaration of an interface:

```iface <interface> <address_family> <method>```

For example, we could declare an interface eth0 and get an IP address dynamically using DHCP:

```iface eth0 inet dhcp```

To configure an interface statically, we follow these steps. First, we define the interface eth1 as a static:

```iface eth1 inet static```

After that, we set the IP address, network mask, and gateway:

```
address 192.168.1.100 
netmask 255.255.255.0 
gateway 192.168.1.1
```

To configure the DNS servers, we add:

```dns-nameservers 8.8.8.8 8.8.4.4```

Here’s a way to define an interface manually without giving it an IP address:

```iface <interface> inet manual```

To be able to execute a command or a script after enabling the interface, we use:

```post-up <command>```

We can also run a command or a script before enabling the network interface:

```pre-up <command>```

In the same vein, we can use pre-down and post-down options. We run the command before taking the interface down:

```pre-down <command>```

Here’s how we can execute a command after taking the interface down:

```post-down <command>```

## Enabling and Disabling Network Interfaces

To manually activate or deactivate a network interface, we use ifup/ifdown commands. It’s necessary to have super-user privileges to execute these commands.

In order to enable the interface eth0, for example, we do:

```bash
$ sudo ifup eth0
# In the same way, we can disable the network interface eth0:
$ sudo ifdown eth0
```
