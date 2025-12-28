# **[libvert networking](https://wiki.libvirt.org/VirtualNetworking.html)**

## references

<https://libvirt.org/formatnetwork.html>
<https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm>

## Virtual Networking

How the virtual networks used by guests work

Networking using libvirt is generally fairly simple, and in this section you'll learn the concepts you need to be effective with it.

Also please bear in mind that advanced users can change important parts of how the network layer operates, far past the concepts outlined here. This section will be enough to get you up and running though. :)

Virtual network switches
Firstly, libvirt uses the concept of a virtual network switch.

![](https://wiki.libvirt.org/images/Virtual_network_switch_by_itself.png)

This is a simple software construction on a host server, that your virtual machines "plug in" to, and direct their traffic through.

![](https://wiki.libvirt.org/images/Host_with_a_virtual_network_switch_and_two_guests.png)

On a Linux host server, the virtual network switch shows up as a network interface.
The default one, created when the libvirt daemon is first installed and started, shows up as virbr0.

![](https://wiki.libvirt.org/images/Linux_host_with_only_a_virtual_network_switch.png)

If you're familiar with the ifconfig command, you can use that to show it:

```bash
$ ifconfig virbr0
virbr0    Link encap:Ethernet  HWaddr 1A:D4:92:CF:FD:17
          inet addr:192.168.122.1  Bcast:192.168.122.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:11 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:3097 (3.0 KiB)
```

If you're more familiar with the ip command instead, this is how it looks:

```bash
$ ip addr show virbr0
3: virbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN
    link/ether 1a:d4:92:cf:fd:17 brd ff:ff:ff:ff:ff:ff
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
```

```bash
ifconfig br-eno1          
br-eno1: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 10.1.2.139  netmask 255.255.252.0  broadcast 10.1.3.255
        inet6 fe80::4eb4:eadc:ee5f:6055  prefixlen 64  scopeid 0x20<link>
        ether 46:3f:25:e1:b5:9c  txqueuelen 1000  (Ethernet)
        RX packets 283606  bytes 1122433244 (1.1 GB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 56391  bytes 4290274 (4.2 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

ifconfig docker0
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ether 02:42:be:c8:f6:20  txqueuelen 0  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

```

Network Address Translation (NAT)
By default, a virtual network switch operates in NAT mode (using IP masquerading rather than SNAT or DNAT).

This means any guests connected through it, use the host IP address for communication to the outside world. Computers external to the host can't initiate communications to the guests inside, when the virtual network switch is operating in NAT mode.

![](https://wiki.libvirt.org/images/Host_with_a_virtual_network_switch_in_nat_mode_and_two_guests.png)

WARNING - The NAT is set up using iptables rules. Be careful if you change these while the virtual switch is running. If something goes wrong with the iptables rules, your virtual machines may stop communicating properly.

List all iptable rules

```bash
sudo iptables -S
-P INPUT ACCEPT
-P FORWARD DROP
-P OUTPUT ACCEPT
-N DOCKER
-N DOCKER-ISOLATION-STAGE-1
-N DOCKER-ISOLATION-STAGE-2
-N DOCKER-USER
-A FORWARD -j DOCKER-USER
-A FORWARD -j DOCKER-ISOLATION-STAGE-1
-A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -o docker0 -j DOCKER
-A FORWARD -i docker0 ! -o docker0 -j ACCEPT
-A FORWARD -i docker0 -o docker0 -j ACCEPT
-A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
-A DOCKER-ISOLATION-STAGE-1 -j RETURN
-A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
-A DOCKER-ISOLATION-STAGE-2 -j RETURN
-A DOCKER-USER -j RETURN
```

DNS & DHCP
Each virtual network switch can be given a range of IP addresses, to be provided to guests through DHCP.

Libvirt uses a program, dnsmasq, for this. An instance of dnsmasq is automatically configured and started by libvirt for each virtual network switch needing it.

![](https://wiki.libvirt.org/images/Virtual_network_switch_with_dnsmasq.jpg)

Other virtual network switch routing types
Virtual network switches can operate in two other modes, instead of NAT:

## Routed mode

With routed mode, the virtual switch is connected to the physical host LAN, passing guest network traffic back and forth without using NAT.

The virtual switch sees the IP addresses in each packet, using that information when deciding what to do.

In this mode all virtual machines are in a subnet routed through the virtual switch. This on its own is not sufficient. because no other hosts on the physical network know this subnet exists or how to reach it. It is thus necessary to configure routers in the physical network (e.g. using a static route).

![](https://wiki.libvirt.org/images/Virtual_network_switch_in_routed_mode.png)

If you are familiar with the ISO 7 layer network model, this mode operates on layer 3, the Network layer.

**[Example of routed network setup](https://wiki.libvirt.org/TaskRoutedNetworkSetupVirtManager.html)**
