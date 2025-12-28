# **[Network Connection Bridge](https://help.ubuntu.com/community/NetworkConnectionBridge)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

NOTE: Bridging is popular, and so it has reference material in several places that may not all be updated at once. These are the links I know of;

- **[KVM Networking](https://help.ubuntu.com/community/KVM/Networking)** - This page.
- **[Network Connection Bridge](https://help.ubuntu.com/community/NetworkConnectionBridge)** - An in depth page on bridging.
- **[Installing bridge utilities](https://help.ubuntu.com/community/BridgingNetworkInterfaces)** - A similar page from a Bridge-Utils point of view.
- **[Network Monitoring Bridge](https://help.ubuntu.com/community/NetworkMonitoringBridge)** - An in-line sniffer page.

## Bridging Ethernet Connections (as of Ubuntu 16.04)

These instructions work for current Ubuntu versions as of this writing.

This covers how to bridge connections using the package bridge-utils. It is assumed that the bridging computer is not directly connected to the Internet. This article contains information from several sources, including;

<http://www.linuxfoundation.org/collaborate/workgroups/networking/bridge>.

<https://wiki.debian.org/BridgeNetworkConnections>

<http://www.microhowto.info/howto/persistently_bridge_traffic_between_two_or_more_ethernet_interfaces_on_debian.html>

Please visit these sites if you need a more in-depth discussion of network bridges and the commands used here.

## Why bridge?

It is possible to "bridge" two Ethernet adapters together (for example, eth0 and eth1). When you bridge two Ethernet networks, the two networks become one single (larger) Ethernet network.

One reason you would bridge Ethernet connections is to monitor traffic flowing across an Ethernet cable. For example, an inline sniffer to monitor the traffic flowing between these two devices, such as a router and the switch. (Using tools like ntop, Wireshark, and tcpdump.)

How to bridge? (short version)
The Debian wiki provides a good overview of how to use brctl and the /etc/network/interfaces file to create and set up bridges. Typing man bridge-utils-interfaces at a command prompt provides additional detail.

You can set up a simple Ethernet bridge by installing bridge-utils placing this text into /etc/network/interfaces file:

```bash
# repsys13 does not have that file
ls /etc/network/          
if-down.d  if-post-down.d  if-pre-up.d  if-up.d

auto lo
iface lo inet loopback

auto br0
iface br0 inet dhcp
  bridge_ports eth0 eth1
```

Using auto br0 ensures that the bridge starts when the computer reboots, and using iface br0 inet dhcp provides the computer with its own IP address on the single (larger) Ethernet network.

You will note that auto eth0 and iface eth0 inet manual are not in the file. This is because br0 will bring up the components assigned to it.

Once you have edited the /etc/network/interfaces file, it may be easiest to reboot your computer to turn on the bridging. (It is possible to start the bridge without rebooting or logging out, but you may have some problems with the Network Connection Manager interfering with your settings.)

## Bridging Ethernet Connections from the GUI

As of Ubuntu 15.04 you can bridge from the desktop using network manager. This is covered in a website at **[ask.xmodulo.com/configure-linux-bridge-network-manager-ubuntu.html](http://ask.xmodulo.com/configure-linux-bridge-network-manager-ubuntu.html)**.

The easiest way to create a bridge with Network Manager is via nm-connection-editor. This GUI tool allows you to configure a bridge in easy-to-follow steps.

To start, invoke nm-connection-editor.

The editor window will show you a list of currently configured network connections. Click on Add button in the top right to create a bridge.

![](https://www.xmodulo.com/img/51a.png)

Next, choose Bridge as a connection type.

![](https://www.xmodulo.com/img/51b.png)

Now it's time to configure a bridge, including its name and bridged connection(s). With no other bridges created, the default bridge interface will be named bridge0.

Recall that the goal of creating a bridge is to share your Ethernet interface via the bridge. So you need to add the Ethernet interface to the bridge. This is achieved by adding a new bridged connection in the GUI. Click on Add button.

![](https://www.xmodulo.com/img/51c.png)

Choose Ethernet as a connection type.

![](https://www.xmodulo.com/img/51d.png)

In Device MAC address field, choose the interface that you want to enslave into the bridge. In this example, assume that this interface is eth0.

![](https://www.xmodulo.com/img/51e.png)

Click on General tab, and enable both checkboxes that say Automatically connect to this network when it is available and All users may connect to this network.

![](https://www.xmodulo.com/img/51f.png)

Save the change.

Now you will see a new slave connection created in the bridge.

![](https://www.xmodulo.com/img/51g.png)

Click on General tab of the bridge, and make sure that top-most two checkboxes are enabled.

![](https://www.xmodulo.com/img/51h.png)

Go to IPv4 Settings tab, and configure either DHCP or static IP address for the bridge. Note that you should use the same IPv4 settings as the enslaved Ethernet interface eth0. In this example, we assume that eth0 is configured via DHCP. Thus choose Automatic (DHCP) here. If eth0 is assigned a static IP address, you should assign the same IP address to the bridge.

![](https://www.xmodulo.com/img/51i.png)

Finally, save the bridge settings.

Now you will see an additional bridge connection created in Network Connections window. You no longer need a previously-configured wired connection for the enslaved interface eth0. So go ahead and delete the original wired connection.

At this point, the bridge connection will automatically be activated. You will momentarily lose a connection, since the IP address assigned to eth0 is taken over by the bridge. Once an IP address is assigned to the bridge, you will be connected back to your Ethernet interface via the bridge. You can confirm that by checking Network settings.

![](https://www.xmodulo.com/img/51k.png)

Also, check the list of available interfaces. As mentioned, the bridge interface must have taken over whatever IP address was possessed by your Ethernet interface.

![](https://www.xmodulo.com/img/51l.png)

```bash
nmcli con mod "br-eno2" ipv4.method "manual"

nmcli con mod "br-eno2" ipv4.dns "172.20.0.39,10.1.2.69,10.1.2.70"
nmcli con mod "br-eno2" ipv4.dns-search "BUSCHE-CNC.COM"
nmcli con mod "br-eno2" ipv4.addresses "10.1.0.136/22"
nmcli con mod "br-eno2" ipv4.gateway "10.1.1.205"

# this shows the ip6 address
ip address show eno2   
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
    inet 10.1.0.136/22 brd 10.1.3.255 scope global noprefixroute eno2
       valid_lft forever preferred_lft forever
    inet6 fe80::5597:8f60:13a3:3a3/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

# eno2 connection is pingable 
ping6 -I enp0s25 fe80::5597:8f60:13a3:3a3
ping6: Warning: source address might be selected on device other than: enp0s25
PING fe80::5597:8f60:13a3:3a3(fe80::5597:8f60:13a3:3a3) from :: enp0s25: 56 data bytes
64 bytes from fe80::5597:8f60:13a3:3a3%enp0s25: icmp_seq=1 ttl=64 time=0.715 ms
64 bytes from fe80::5597:8f60:13a3:3a3%enp0s25: icmp_seq=2 ttl=64 time=0.395 ms

# br-eno2 does not show the ip6 address for some reason
ip address show br-eno2
12: br-eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether de:28:04:da:3a:48 brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.136/22 brd 10.1.3.255 scope global noprefixroute br-eno2
       valid_lft forever preferred_lft forever


ip link show br-eno2    
28: br-eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether de:28:04:da:3a:48 brd ff:ff:ff:ff:ff:ff
```
