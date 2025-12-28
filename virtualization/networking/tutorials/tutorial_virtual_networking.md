# Tutorial on Virtual Networking

![](https://developers.redhat.com/sites/default/files/styles/article_feature/public/blog/2018/10/bridge.webp?itok=fic3r7Jv)

## references

<https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking>

## Introduction to Linux interfaces for virtual networking

Linux has rich virtual networking capabilities that are used as basis for hosting VMs and containers, as well as cloud environments. In this post, I will give a brief introduction to all commonly used virtual network interface types. There is no code analysis, only a brief introduction to the interfaces and their usage on Linux. Anyone with a network background might be interested in this blog post. A list of interfaces can be obtained using the command ip link help.

```bash
ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 18:03:73:1f:84:a4 brd ff:ff:ff:ff:ff:ff
3: br-ef440bd353e1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:93:30:4c:99 brd ff:ff:ff:ff:ff:ff
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:41:39:29:a3 brd ff:ff:ff:ff:ff:ff
5: br-860dc0d9b54b: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:df:51:6d:49 brd ff:ff:ff:ff:ff:ff
6: br-924b3db7b366: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:cf:f7:6f:b4 brd ff:ff:ff:ff:ff:ff
7: br-b543cc541f49: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:91:90:d3:0d brd ff:ff:ff:ff:ff:ff
```

This post covers the following frequently used interfaces and some interfaces that can be easily confused with one another:

- Bridge
- Bonded interface
- Team device
- VLAN (Virtual LAN)
- VXLAN (Virtual eXtensible Local Area Network)
- MACVLAN
- IPVLAN
- MACVTAP/IPVTAP
- MACsec (Media Access Control Security)
- VETH (Virtual Ethernet)
- VCAN (Virtual CAN)
- VXCAN (Virtual CAN tunnel)
- IPOIB (IP-over-InfiniBand)
- NLMON (NetLink MONitor)
- Dummy interface
- IFB (Intermediate Functional Block)
- netdevsim

After reading this article, you will know what these interfaces are, what's the difference between them, when to use them, and how to create them. For other interfaces like tunnel, please see **[An introduction to Linux virtual interfaces: Tunnels](https://developers.redhat.com/blog/2019/05/17/an-introduction-to-linux-virtual-interfaces-tunnels/)**

## Bridge

A Linux bridge behaves like a network switch. It forwards packets between interfaces that are connected to it. It's usually used for forwarding packets on routers, on gateways, or between VMs and network namespaces on a host. It also supports STP, VLAN filter, and multicast snooping.

![](https://developers.redhat.com/blog/wp-content/uploads/2018/10/bridge.png)

Use a bridge when you want to establish communication channels between VMs, containers, and your hosts.

### Here's how to create a bridge

```bash
# ip link add br0 type bridge
# ip link set eth0 master br0
# ip link set tap1 master br0
# ip link set tap2 master br0
# ip link set veth1 master br0
```

This creates a bridge device named br0 and sets two TAP devices (tap1, tap2), a VETH device (veth1), and a physical device (eth0) as its slaves, as shown in the diagram above.

### Why is my interface named enp0s25 instead of eth0?

<https://askubuntu.com/questions/704361/why-is-my-network-interface-named-enp0s25-instead-of-eth0>

This is known as **[Predictable Network Interface naming](http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames/)** and is part of systemd, to which Ubuntu has been transitioning as of version 15.04.

**[systemd](https://en.wikipedia.org/wiki/Systemd)**
 is a software suite that provides an array of system components for Linux[7] operating systems. The main aim is to unify service configuration and behavior across Linux distributions.[8] Its primary component is a "system and service manager" – an init system used to bootstrap user space and manage user processes. It also provides replacements for various daemons and utilities, including device management, login management, network connection management, and event logging. The name systemd adheres to the Unix convention of naming daemons by appending the letter d.[9] It also plays on the term "System D", which refers to a person's ability to adapt quickly and improvise to solve problems.[10]

Since 2015, the majority of Linux distributions have adopted systemd, having replaced other init systems such as SysV init. It has been praised by developers and users of distributions that adopted it for providing a stable, fast out-of-the-box solution for issues that had existed in the Linux space for years.[11][12][13] At the time of adoption of systemd on most Linux distributions, it was the only software suite that offered reliable parallelism during boot as well as centralized management of processes, daemons, services and mount points.

Critics of systemd contend that it suffers from mission creep and bloat; the latter affecting other software (such as the GNOME desktop), adding dependencies on systemd, reducing its compatibility with other Unix-like operating systems and making it difficult for sysadmins to integrate alternative solutions. Concerns have also been raised about Red Hat and its parent company IBM controlling the scene of init systems on Linux.[14][1] Critics also contend that the complexity of systemd results in a larger attack surface, reducing the overall security of the platform.[15]

This is known as Predictable Network Interface naming and is part of systemd, to which Ubuntu has been transitioning as of version 15.04.

Basic idea is that unlike previous *nix naming scheme where probing for hardware occurs in no particular order and may change between reboots, here interface name depends on physical location of hardware and can be predicted/guessed by looking at lspci or lshw output. Conversely we can guess information about it's physical position in the pci system. In your case that would be pci bus 0, slot 2. According to the freedesktop.org article, there actually are 3 ways how interface name is assigned: based on BIOS/Firmware for onboard cards, based on PCI information, and based on MAC address of the interface. Refer here for other examples.

According to the freedesktop.org page one of the reasons for switching to predictable naming is that classic naming convention can lead to software security risks in multi-interface systems when devices are added and removed at boot. Also, according to the comment by Sam Hanes, "On a big server with many Ethernet ports it's invaluable: you can immediately tell which interface goes to which port and adding or removing hardware doesn't change the names of other ports."

See How to rename network interface in 15.10 in case you decide to revert back to the other version of naming.

is there a way to find out the PCI bus number of an Ethernet interface or vice versa. I am looking to write a Bash/Python script which gives some thing like

pci_address = some_function(eth0)

where pci_address is sys:bus:slot:function. How can these two elements be related to each other?

<https://askubuntu.com/questions/654820/how-to-find-pci-address-of-an-ethernet-interface/654928#654928>

lshw(list hardware) is a small Linux/Unix tool which is used to generate the detailed information of the system's hardware configuration ...

```bash
$ sudo lshw -c network -businfo 
Bus info          Device      Class          Description
========================================================
pci@0000:00:19.0  enp0s25     network        82579LM Gigabit Network Connection (Lewisville)



$ lspci -D | grep 'Network\|Ethernet'
0000:00:19.0 Ethernet controller: Intel Corporation 82579LM Gigabit Network Connection (Lewisville) (rev 05)

```

## Bonded interface

The Linux bonding driver provides a method for aggregating multiple network interfaces into a single logical "bonded" interface. The behavior of the bonded interface depends on the mode; generally speaking, modes provide either hot standby or load balancing services.

![](https://developers.redhat.com/blog/wp-content/uploads/2018/10/bond.png)
