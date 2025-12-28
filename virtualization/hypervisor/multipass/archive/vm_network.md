# **[VM Network](https://multipass.run/docs/configure-static-ips)**

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## references

- **[bridge on ubuntu server](https://multipass.run/docs/create-an-instance#heading--create-an-instance-with-multiple-network-interfaces)**
- **[nmcli bridge tutorial](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking)**
- **[Add network bridge with nmcli (NetworkManager)](https://www.cyberciti.biz/faq/how-to-add-network-bridge-with-nmcli-networkmanager-on-linux/#google_vignette)**
- **[How to add network interfaces in Multipass](https://discourse.ubuntu.com/t/how-to-add-network-interfaces/19544)**

## Create a network internal to the host

This document explains how to create instances with static IPs in a new network, internal to the host. With this approach, instances get an extra IP that does not change with restarts. By using a separate, local network we avoid any IP conflicts. Instances retain the usual default interface with a DHCP-allocated IP, which gives them connectivity to the outside.

Install multipass

```bash
ssh brent@repsys13
# To uninstall Multipass, simply run:
snap remove multipass

snap install multipass
# Make sure you’re part of the group that Multipass gives write access to its socket (sudo in this case, but it may also be adm or admin, depending on your distribution):

ls -l /var/snap/multipass/common/multipass_socket
srw-rw---- 1 root sudo 0 May 29 16:14 /var/snap/multipass/common/multipass_socket
groups | grep sudo
brent adm cdrom sudo dip plugdev lpadmin lxd sambashare
```

## **[Step 0: Change to LXD driver](https://jon.sprig.gs/blog/post/2800)**

Currently only the LXD driver supports the networks command on Linux.

So, let’s make multipass on Ubuntu use LXD! (Be prepared for entering your password a few times!)

```bash
multipass networks

networks failed: The networks feature is not implemented on this backend.
```

Firstly, we need to install LXD. Dead simple:

LXD ( [lɛks'di:] 🔈) is a modern, secure and powerful system container and virtual machine manager. It provides a unified experience for running and managing full Linux systems inside containers or virtual machines.

```bash
sudo snap install lxd
lxd (5.21/stable) 5.21.1-d46c406 from Canonical✓ installed
```

Next, we need to tell snap that it’s allowed to connect LXD to multipass:

```bash
sudo snap connect multipass:lxd lxd
sudo snap connections multipass
Interface          Plug                         Slot                Notes
firewall-control   multipass:firewall-control   :firewall-control   -
home               multipass:all-home           :home               -
home               multipass:home               :home               -
kvm                multipass:kvm                :kvm                -
libvirt            multipass:libvirt            -                   -
lxd                multipass:lxd                lxd:lxd             -
multipass-support  multipass:multipass-support  :multipass-support  -
network            multipass:network            :network            -
network-bind       multipass:network-bind       :network-bind       -
network-control    multipass:network-control    :network-control    -
network-manager    multipass:network-manager    :network-manager    -
network-observe    multipass:network-observe    :network-observe    -
removable-media    multipass:removable-media    -                   -
system-observe     multipass:system-observe     :system-observe     -
unity7             multipass:unity7             :unity7             -
wayland            multipass:wayland            :wayland            -
x11                multipass:x11                :x11                -```

And lastly, we tell multipass to use lxd:

```bash
multipass set local.driver=lxd
multipass networks

Name        Type       Description
eno1        ethernet   Ethernet device
eno2        ethernet   Ethernet device
eno3        ethernet   Ethernet device
eno4        ethernet   Ethernet device
enp66s0f0   ethernet   Ethernet device
enp66s0f1   ethernet   Ethernet device
enp66s0f2   ethernet   Ethernet device
enp66s0f3   ethernet   Ethernet device
mpbr0       bridge     Network bridge for Multipass
```

## Step 1: Create a Bridge

A **[network bridge](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking)** is a link-layer device which forwards traffic between networks based on a table of MAC addresses. A bridge requires a network device in each network the bridge should connect. When you configure a bridge, the bridge is called controller and the devices it uses ports. To set a static IPv4 address, network mask, default gateway, and DNS server to the bridge0 connection, enter:

```bash
# nmcli connection modify bridge0 ipv4.addresses '192.0.2.1/24' ipv4.gateway '192.0.2.254' ipv4.dns '192.0.2.253' ipv4.dns-search 'example.com' ipv4.method manual
```

The first step is to create a new bridge/switch with a static IP on your host. This is beyond the scope of Multipass but, as an example, here is how this can be achieved with NetworkManager (e.g. on Ubuntu Desktop):

```bash
# clean install of ubuntu 22.04 desktop and multipass
ssh brent@repsys13
nmcli -t -f UUID,TYPE,DEVICE connection show
nmcli connection delete $UUID
sudo nmcli connection delete 65380f4f-d384-4d03-8b8c-bdf9160ea065

sudo nmcli connection add type bridge con-name localbr ifname localbr \
    ipv4.method manual ipv4.addresses 10.13.31.1/24

Connection 'localbr' (65380f4f-d384-4d03-8b8c-bdf9160ea065) successfully added.

nmcli device show localbr
GENERAL.DEVICE:                         localbr
GENERAL.TYPE:                           bridge
GENERAL.HWADDR:                         AE:6F:D9:34:27:8A
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected)
GENERAL.CONNECTION:                     localbr
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/4
IP4.ADDRESS[1]:                         10.13.31.1/24
IP4.GATEWAY:                            --
IP4.ROUTE[1]:                           dst = 10.13.31.0/24, nh = 0.0.0.0, mt = 425
IP6.GATEWAY:                            --
```

This created a bridge named localbr with IP 10.13.31.1/24. You can see the new device and address with:

```bash
ip -c -br addr show dev localbr 

localbr           DOWN           10.13.31.1/24
```

You can also run multipass networks to confirm the bridge is available for Multipass to connect to.

```bash
multipass networks
Name        Type       Description
eno1        ethernet   Ethernet device
eno2        ethernet   Ethernet device
eno3        ethernet   Ethernet device
eno4        ethernet   Ethernet device
enp66s0f0   ethernet   Ethernet device
enp66s0f1   ethernet   Ethernet device
enp66s0f2   ethernet   Ethernet device
enp66s0f3   ethernet   Ethernet device
localbr     bridge     Network bridge
mpbr0       bridge     Network bridge for Multipass
```

**[Display the network interfaces](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking)**, and note the names of the interfaces you want to add to the bridge:

```bash
nmcli device status
DEVICE     TYPE      STATE                   CONNECTION         
eno2       ethernet  connected               Wired connection 2 
mpbr0      bridge    connected (externally)  mpbr0              
eno1       ethernet  connected               Wired connection 1 
localbr    bridge    connected               localbr  

ip -4 a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
3: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    altname enp1s0f0
    inet 10.1.0.135/22 brd 10.1.3.255 scope global noprefixroute eno1
       valid_lft forever preferred_lft forever
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    altname enp1s0f1
    inet 10.1.0.136/22 brd 10.1.3.255 scope global noprefixroute eno2
       valid_lft forever preferred_lft forever
10: mpqemubr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    inet 10.195.237.1/24 brd 10.195.237.255 scope global mpqemubr0
       valid_lft forever preferred_lft forever
11: localbr: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    inet 10.13.31.1/24 brd 10.13.31.255 scope global noprefixroute localbr
       valid_lft forever preferred_lft forever

```

Since '''/etc/hosts``` has 10.1.0.135 as the static ip for repsys13 don't enslave the eno1 interface so I can still ssh to the system. Use the eno2 interface to add to the bridge.

To use this device as a port, multipass will modify its connection profile.

## Step 2: Launch an instance with a manual network

**[Generate 5 MAC address](https://www.browserling.com/tools/random-mac)**

```bash
5c:13:55:48:43:58
d5:eb:35:ee:b4:14
3f:40:f5:5d:17:65
7f:71:f0:b2:55:dd
03:dc:c9:c4:c4:14
```

**[Notes launch command](https://multipass.run/docs/launch-command)**

```
--network <spec>                      Add a network interface to the
                                        instance, where <spec> is in the
                                        "key=value,key=value" format, with the
                                        following keys available:
                                         name: the network to connect to
                                        (required), use the networks command for
                                        a list of possible values, or use
                                        'bridged' to use the interface
                                        configured via `multipass set
                                        local.bridged-network`.
                                         mode: auto|manual (default: auto)
                                         mac: hardware address (default:
                                        random).
                                        You can also use a shortcut of "<name>"
                                        to mean "name=<name>".
```

Next we launch an instance with an extra network in manual mode, connecting it to this bridge:

```bash
multipass launch --name test1 --network name=localbr,mode=manual,mac="5c:13:55:48:43:58"
```

## Step 3: Configure the extra interface

We now need to configure the manual network interface inside the instance. We can achieve that using Netplan. The following command plants the required Netplan configuration file in the instance:

```bash
$ multipass exec -n test1 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "5c:13:55:48:43:58"
            addresses: [10.13.31.13/24]
EOF'

multipass exec -n test1 -- sudo bash -c 'cat /etc/netplan/10-custom.yaml'
multipass exec -n test1 -- sudo netplan apply
** (generate:2661): WARNING **: 18:37:57.672: Permissions for /etc/netplan/10-custom.yaml are too open. Netplan configuration should NOT be accessible by others.
```

Step 5: Confirm that it works
You can confirm that the new IP is present in the instance with Multipass:

```bash
multipass info test1

Name:           test1
State:          Running
IPv4:           10.161.38.77
                10.13.31.13
Release:        Ubuntu 24.04 LTS
Image hash:     08c7ba960c16 (Ubuntu 24.04 LTS)
CPU(s):         1
Load:           0.00 0.00 0.00
Disk usage:     1.4GiB out of 9.6GiB
Memory usage:   343.6MiB out of 945.6MiB
Mounts:         --

```

The command above should show two IPs, the second of which is the one we just configured (10.13.31.13). You can use ping to confirm that it can be reached from the host:

```bash
PING 10.13.31.13 (10.13.31.13) 56(84) bytes of data.
64 bytes from 10.13.31.13: icmp_seq=1 ttl=64 time=0.648 ms
```

Conversely, you can also ping from the instance to the host:

```bash
multipass exec -n test1 -- ping 10.13.31.1

PING 10.13.31.1 (10.13.31.1) 56(84) bytes of data.
64 bytes from 10.13.31.1: icmp_seq=1 ttl=64 time=0.273 ms
```

Step 6: More instances
If desired, repeat steps 2-5 with different names/MACs/IP terminations (e.g. 10.13.31.14) to launch other instances with static IPs in the same network. You can ping from one instance to another to confirm that they are connected. For example:

```bash
multipass exec -n test1 -- ping 10.13.31.14
multipass exec -n test1 -- ping google.com
PING google.com (142.250.191.238) 56(84) bytes of data.
64 bytes from ord38s32-in-f14.1e100.net (142.250.191.238): icmp_seq=1 ttl=116 time=9.71 ms


```

Conclusion
You have now created a small internal network, local to your host, with Multipass instances that you can reach on the same IP across reboots. Instances still have the default NAT-ed network, which they can use to reach the outside world. You can combine this with other networks if you want to (e.g. for bridging).
