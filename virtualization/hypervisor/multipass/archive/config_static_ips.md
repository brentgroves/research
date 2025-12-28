# **[Configure Static IPs in Multipass](https://multipass.run/docs/configure-static-ips)**

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

sudo nmcli connection add type bridge con-name mybr ifname mybr \
    ipv4.method manual ipv4.addresses 10.15.31.1/24
10.15.31.16/24
Connection 'localbr' (65380f4f-d384-4d03-8b8c-bdf9160ea065) successfully added.

nmcli connection show 
NAME                UUID                                  TYPE      DEVICE      
Wired connection 2  74830679-74b4-3a2a-8711-e20103c77322  ethernet  eno2        
mpbr0               88ee5396-79df-46b9-a4c9-46ac56fb0798  bridge    mpbr0       
Wired connection 1  dff312d7-ea1c-3537-8be5-a1f7043797ce  ethernet  eno1        
localbr             65380f4f-d384-4d03-8b8c-bdf9160ea065  bridge    localbr 

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

Use the ip utility to display the link status of Ethernet devices that are ports of a specific bridge:

```bash
ip link show master localbr
14: tap3910decf: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master localbr state UP mode DEFAULT group default qlen 1000
    link/ether ae:da:0f:d7:33:6a brd ff:ff:ff:ff:ff:ff

# After adding 2nd instance
ip link show master localbr
14: tap3910decf: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master localbr state UP mode DEFAULT group default qlen 1000
    link/ether ae:da:0f:d7:33:6a brd ff:ff:ff:ff:ff:ff
16: tapb82c4330: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master localbr state UP mode DEFAULT group default qlen 1000
    link/ether 86:8c:70:a9:59:01 brd ff:ff:ff:ff:ff:ff

nmcli device show tap3910decf
GENERAL.DEVICE:                         tap3910decf
GENERAL.TYPE:                           tun
GENERAL.HWADDR:                         AE:DA:0F:D7:33:6A
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected (externally))
GENERAL.CONNECTION:                     tap3910decf
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/7
IP4.GATEWAY:                            --
IP6.GATEWAY:                            --

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

## Step 2: Launch an instance with a manual network (could not get manual to work)

**[Generate 5 MAC address](https://www.browserling.com/tools/random-mac)**

Note: I never got process to work if these mac addresses were passed in manually, so I stared letting multipass generate them instead. Found someplace in KVM ubuntu docs the first digit has to be even for libvirt.

```bash
5c:13:55:48:43:58
d5:eb:35:ee:b4:14
3f:40:f5:5d:17:65
7f:71:f0:b2:55:dd
03:dc:c9:c4:c4:14
```

**[Notes launch command](https://multipass.run/docs/launch-command)**

```bash
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
multipass launch --name test8 --network name=mybr-eno3
multipass launch --name test8 --network name=mybr-eno3
multipass exec -n test8 -- sudo networkctl -a status
3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:b6:62:e9
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.3.39 (DHCP4 via 10.1.2.69)
                              fe80::5054:ff:feb6:62e9
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x24721ac8/DUID
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab1121fdaafbb0376aea

Jun 11 20:58:28 test8 systemd-networkd[715]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
Jun 11 20:58:28 test8 systemd-networkd[715]: enp6s0: Link UP
Jun 11 20:58:28 test8 systemd-networkd[715]: enp6s0: Gained carrier
Jun 11 20:58:29 test8 systemd-networkd[715]: enp6s0: Gained IPv6LL
Jun 11 20:58:35 test8 systemd-networkd[715]: enp6s0: DHCPv4 address 10.1.3.39/22, gateway 10.1.1.205 acquired from 10.1.2.69


multipass launch --name test7 --network eno2 --network name=mybr
multipass exec -n test7 -- sudo networkctl -a status
# get the mac address assigned
enp7s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra1.network
                       State: degraded (configuring)
                Online state: online                                                      
                        Type: ether
                        Path: pci-0000:07:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:58:18:4f
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no

# can't get manual mode to work
# multipass launch --name test3 --network name=mybr,mode=manual,mac="7f:71:f0:b2:55:dd"

```

## Step 3: Configure the extra interface

We now need to configure the manual network interface inside the instance. We can achieve that using Netplan. The following command plants the required Netplan configuration file in the instance:

```bash
# bridge i made with iproute2 worked when using non-main network interface eno3.
multipass exec -n test8 -- sudo networkctl -a status
3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:b6:62:e9
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.3.39 (DHCP4 via 10.1.2.69)
                              fe80::5054:ff:feb6:62e9
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x24721ac8/DUID
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab1121fdaafbb0376aea

multipass exec -n test8 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        enp6s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:b6:62:e9"
            addresses: [10.1.0.139/22]
            gateway4: 10.1.1.205
            nameservers:
                addresses: [10.1.2.69,10.1.2.70,172.20.0.39]
EOF'


multipass exec -n test7 -- sudo networkctl -a status
● 3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:41:ee:b9
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.3.159 (DHCP4 via 10.1.2.70)
                              fe80::5054:ff:fe41:eeb9
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x24721ac8/DUID
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab118fbffcae7a8a6b9a
multipass exec -n test8 -- sudo bash -c 'cat /etc/netplan/10-custom.yaml'
network:
    version: 2
    ethernets:
        enp6s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:b6:62:e9"
            addresses: [10.1.0.139/22]
            gateway4: 10.1.1.205
            nameservers:
                addresses: [10.1.2.69,10.1.2.70,172.20.0.39]
multipass exec -n test8 -- sudo netplan apply
multipass exec -n test8 -- sudo networkctl -a status

multipass exec -n test7 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        enp6s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:41:ee:b9"
            addresses: [10.1.0.137/22]
            gateway4: 10.1.1.205
            nameservers:
                addresses: [10.1.2.69,10.1.2.70,172.20.0.39]
        enp7s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:58:18:4f"
            addresses: [10.15.31.20/24]
EOF'

multipass exec -n test7 -- sudo bash -c 'cat /etc/netplan/10-custom.yaml'
network:
    version: 2
    ethernets:
        enp6s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:41:ee:b9"
            addresses: [10.1.0.137/22]
            gateway4: 10.1.1.205
            nameservers:
                addresses: [10.1.2.69,10.1.2.70,172.20.0.39]
        enp7s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:58:18:4f"
            addresses: [10.15.31.20/24]

multipass exec -n test7 -- sudo netplan apply
** (generate:19032): WARNING **: 18:49:35.838: Permissions for /etc/netplan/10-custom.yaml are too open. Netplan configuration should NOT be accessible by others.

** (generate:19032): WARNING **: 18:49:35.838: `gateway4` has been deprecated, use default routes instead.
See the 'Default routes' section of the documentation for more details.

** (process:19031): WARNING **: 18:49:36.596: Permissions for /etc/netplan/10-custom.yaml are too open. Netplan configuration should NOT be accessible by others.

** (process:19031): WARNING **: 18:49:36.596: `gateway4` has been deprecated, use default routes instead.
See the 'Default routes' section of the documentation for more details.

** (process:19031): WARNING **: 18:49:37.108: Permissions for /etc/netplan/10-custom.yaml are too open. Netplan configuration should NOT be accessible by others.

** (process:19031): WARNING **: 18:49:37.108: `gateway4` has been deprecated, use default routes instead.
See the 'Default routes' section of the documentation for more details.

multipass exec -n test7 -- sudo networkctl -a status


multipass exec -n test7 -- sudo netplan apply

multipass exec -n test7 -- sudo networkctl -a status

multipass exec -n test6 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        enp7s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:0a:19:62"
            addresses: [10.15.31.19/24]
EOF'
multipass exec -n test3 -- sudo bash -c 'sudo rm /etc/netplan/10-custom.yaml'

multipass exec -n test6 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "52:54:00:0a:19:62"
            addresses: [10.15.31.18/24]
EOF'

multipass exec -n test5 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "52:54:00:36:69:4b"
            addresses: [10.15.31.17/24]
EOF'

multipass exec -n test4 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "52:54:00:3a:34:23"
            addresses: [10.15.31.16/24]
EOF'
multipass exec -n test3 -- sudo bash -c 'sudo rm /etc/netplan/10-custom.yaml'
multipass exec -n test3 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "7f:71:f0:b2:55:dd"
            addresses: [10.15.31.16/24]
EOF'
multipass exec -n test3 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "7f:71:f0:b2:55:dd"
            addresses: [10.13.31.16/24]
EOF'

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

# Step 6: More instances
# If desired, repeat steps 2-5 with different names/MACs/IP terminations (e.g. 10.13.31.14) to launch other instances with static IPs in the same network. You can ping from one instance to another to confirm that they are connected. For example:

$ multipass exec -n test2 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "d5:eb:35:ee:b4:14"
            addresses: [10.13.31.14/24]
EOF'



multipass exec -n test1 -- sudo bash -c 'cat /etc/netplan/10-custom.yaml'
multipass exec -n test2 -- sudo bash -c 'cat /etc/netplan/10-custom.yaml'
multipass exec -n test3 -- sudo bash -c 'cat /etc/netplan/10-custom.yaml'
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "7f:71:f0:b2:55:dd"
            addresses: [10.13.31.16/24]
multipass exec -n test3 -- sudo networkctl -a status

multipass exec -n test1 -- sudo netplan apply
multipass exec -n test2 -- sudo netplan apply
multipass exec -n test3 -- sudo netplan apply
multipass exec -n test3 -- sudo networkctl -a status
** (generate:2661): WARNING **: 18:37:57.672: Permissions for /etc/netplan/10-custom.yaml are too open. Netplan configuration should NOT be accessible by others.
```

Step 5: Confirm that it works
You can confirm that the new IP is present in the instance with Multipass:

```bash
multipass info test7

multipass info test6
Name:           test6
State:          Running
IPv4:           10.161.38.197
                10.1.2.129
                10.15.31.19
Release:        Ubuntu 24.04 LTS
Image hash:     08c7ba960c16 (Ubuntu 24.04 LTS)

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

multipass info test2

Name:           test2
State:          Running
IPv4:           10.161.38.109
Release:        Ubuntu 24.04 LTS
Image hash:     08c7ba960c16 (Ubuntu 24.04 LTS)
CPU(s):         1
Load:           0.00 0.10 0.07
Disk usage:     1.4GiB out of 9.6GiB
Memory usage:   314.8MiB out of 945.6MiB
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

## Verify network interfaces

**[references iproute2 intro for ip commands](../networking/iproute2/introduction_to_iproute.md)**

After launching several vm networked to mybr it seems like each a new tap device is created for each vm that gets passed mybr. I believe these are **[macvtap devices](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-virtual_networking-directly_attaching_to_physical_interface)**

![](https://access.redhat.com/webassets/avalon/d/Red_Hat_Enterprise_Linux-7-Virtualization_Deployment_and_Administration_Guide-en-US/images/0d5f8cc757d821c65465afe2b12d76a0/macvtap_modes-VEPA.png)

Network **[Tap device](https://blog.cloudflare.com/virtual-networking-101-understanding-tap)**. A tap device is a virtual network interface that looks like an ethernet network card. Instead of having real wires plugged into it, it exposes a nice handy file descriptor to an application willing to send/receive packets.

```bash
ip route list table local
# after passing in eno2 to multipass --network eno2 10.1.0.136 interface is gone/enslaved and br-eno2 10.1.3.158 interface has been created. Later on when ```nmcli connection show br-eno2-child``` is ran we see eno2 referenced.

local 10.1.0.135 dev eno1 proto kernel scope host src 10.1.0.135 
local 10.1.3.158 dev br-eno2 proto kernel scope host src 10.1.3.158 
broadcast 10.1.3.255 dev eno1 proto kernel scope link src 10.1.0.135 
broadcast 10.1.3.255 dev br-eno2 proto kernel scope link src 10.1.3.158 
local 10.13.31.1 dev localbr proto kernel scope host src 10.13.31.1 
broadcast 10.13.31.255 dev localbr proto kernel scope link src 10.13.31.1 
local 10.15.31.1 dev mybr proto kernel scope host src 10.15.31.1 
broadcast 10.15.31.255 dev mybr proto kernel scope link src 10.15.31.1 
local 10.161.38.1 dev mpbr0 proto kernel scope host src 10.161.38.1 
broadcast 10.161.38.255 dev mpbr0 proto kernel scope link src 10.161.38.1 
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1 

# before passing in eno2 to multipass --network
local 10.1.0.135 dev eno1 proto kernel scope host src 10.1.0.135 
local 10.1.0.136 dev eno2 proto kernel scope host src 10.1.0.136 
broadcast 10.1.3.255 dev eno2 proto kernel scope link src 10.1.0.136 
broadcast 10.1.3.255 dev eno1 proto kernel scope link src 10.1.0.135 
local 10.13.31.1 dev localbr proto kernel scope host src 10.13.31.1 
broadcast 10.13.31.255 dev localbr proto kernel scope link src 10.13.31.1 
local 10.161.38.1 dev mpbr0 proto kernel scope host src 10.161.38.1 
broadcast 10.161.38.255 dev mpbr0 proto kernel scope link src 10.161.38.1 
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1 

ip route list table main
# after passing in eno2 to multipass --network eno2 10.1.0.136 interface is gone and br-eno2 now has route to 10.1.0.0/22 as well as our lan's gateway. Don't know what 169.254.0.0/16 dev eno2 route is for but see it again ```IP4.ROUTE[1]  dst = 169.254.0.0/16``` when ```nmcli connection show br-eno2-child``` is ran.
default via 10.1.1.205 dev eno1 proto static metric 101 
default via 10.1.1.205 dev br-eno2 proto dhcp metric 427 
10.1.0.0/22 dev eno1 proto kernel scope link src 10.1.0.135 metric 101 
10.1.0.0/22 dev br-eno2 proto kernel scope link src 10.1.3.158 metric 427 
10.13.31.0/24 dev localbr proto kernel scope link src 10.13.31.1 metric 425 
10.15.31.0/24 dev mybr proto kernel scope link src 10.15.31.1 metric 426 
10.161.38.0/24 dev mpbr0 proto kernel scope link src 10.161.38.1 
169.254.0.0/16 dev eno2 scope link metric 1000 

ip route list table main
# before passing in eno2 to multipass --network
default via 10.1.1.205 dev eno2 proto static metric 100 
default via 10.1.1.205 dev eno1 proto static metric 101 
10.1.0.0/22 dev eno2 proto kernel scope link src 10.1.0.136 metric 100 
10.1.0.0/22 dev eno1 proto kernel scope link src 10.1.0.135 metric 101 
10.13.31.0/24 dev localbr proto kernel scope link src 10.13.31.1 metric 425 
10.161.38.0/24 dev mpbr0 proto kernel scope link src 10.161.38.1 
169.254.0.0/16 dev eno2 scope link metric 1000 

# ip shows us our routes
ip route show
# same as ip route ls  
default via 10.1.1.205 dev eno2 proto static metric 100 
default via 10.1.1.205 dev eno1 proto static metric 101 
10.1.0.0/22 dev eno2 proto kernel scope link src 10.1.0.136 metric 100 
10.1.0.0/22 dev eno1 proto kernel scope link src 10.1.0.135 metric 101 
10.13.31.0/24 dev localbr proto kernel scope link src 10.13.31.1 metric 425 
10.161.38.0/24 dev mpbr0 proto kernel scope link src 10.161.38.1 
169.254.0.0/16 dev eno2 scope link metric 1000 

# You can view your machines current arp/neighbor cache/table like so:
ip neigh show
10.1.0.162 dev eno2 lladdr 4c:91:7a:64:0f:7d STALE
10.1.0.166 dev eno1 lladdr 4c:91:7a:63:c0:3a STALE
10.1.1.205 dev eno1 lladdr 34:56:fe:77:58:bc STALE

# after passing in eno2 to multipass launch --network eno2. Not only was the br-eno2 bridge created but eht br-eno2-child ethernet device has been created.

nmcli connection show 
NAME                UUID                                  TYPE      DEVICE      
Wired connection 1  dff312d7-ea1c-3537-8be5-a1f7043797ce  ethernet  eno1        
mpbr0               88ee5396-79df-46b9-a4c9-46ac56fb0798  bridge    mpbr0       
br-eno2             fbcc6e74-d4c5-4262-b33f-0aa66e9ad5aa  bridge    br-eno2     
localbr             65380f4f-d384-4d03-8b8c-bdf9160ea065  bridge    localbr     
mybr                2380dcbf-387e-44ab-988b-47fe7edeb2fe  bridge    mybr        
br-eno2-child       4b6baf2f-8e00-43a6-9b23-82ff48db7107  ethernet  eno2        
tap04270071         d67e8e38-9b03-47f5-9dec-eaf2d4c9379c  tun       tap04270071 
tap36ec9bf6         d84e1265-386d-4607-975a-cdd7db5f862d  tun       tap36ec9bf6 
tap3eec7b9d         90948c69-0d8c-4227-8aed-e48ae05683db  tun       tap3eec7b9d 
tap539daa08         82c48ed6-3794-45ee-8e9e-42b4fa296b97  tun       tap539daa08 
tap5459bdcf         7b9ae3d1-d099-447c-be91-d0c63192da36  tun       tap5459bdcf 
tap6f162cbc         1cfcb696-a47e-4d1f-bf2d-80200b8f9ce1  tun       tap6f162cbc 
tap936d26a5         d43880f7-ce65-4642-b0eb-dbd50d251b64  tun       tap936d26a5 
tap94d4edf6         cc6c782b-dd44-4ffe-b2b8-b44416582ca1  tun       tap94d4edf6 
tapc97b1123         bb6027e0-4f60-4a0e-b963-df1472cbc7f6  tun       tapc97b1123 
tapeed7b980         4770820d-6484-4d45-914d-b02fd2943d79  tun       tapeed7b980 
tapfde3cc51         b1510302-89f5-4208-b35b-1f5869764b84  tun       tapfde3cc51 

# before passing in eno2 to multipass launch --network eno2
nmcli connection show 
NAME                UUID                                  TYPE      DEVICE      
Wired connection 2  74830679-74b4-3a2a-8711-e20103c77322  ethernet  eno2        
mpbr0               88ee5396-79df-46b9-a4c9-46ac56fb0798  bridge    mpbr0       
Wired connection 1  dff312d7-ea1c-3537-8be5-a1f7043797ce  ethernet  eno1        
localbr             65380f4f-d384-4d03-8b8c-bdf9160ea065  bridge    localbr     
tap3910decf         5e15a73d-d042-4196-931f-302f9054de6a  tun       tap3910decf 
tape518c5a7         f43135b4-cc0a-4d41-8110-39d553800c23  tun       tape518c5a7 

nmcli connection show br-eno2-child 
...
connection.master:                      br-eno2
connection.slave-type:                  bridge
...
GENERAL.NAME:                           br-eno2-child
GENERAL.UUID:                           4b6baf2f-8e00-43a6-9b23-82ff48db7107
GENERAL.DEVICES:                        eno2
GENERAL.IP-IFACE:                       eno2
GENERAL.STATE:                          activated
IP4.ROUTE[1]:                           dst = 169.254.0.0/16, nh = 0.0.0.0, mt = 1000


nmcli connection show localbr 
GENERAL.NAME:                           localbr
GENERAL.UUID:                           65380f4f-d384-4d03-8b8c-bdf9160ea065
GENERAL.DEVICES:                        localbr
GENERAL.IP-IFACE:                       localbr
GENERAL.STATE:                          activated
GENERAL.DEFAULT:                        no
GENERAL.DEFAULT6:                       no
GENERAL.SPEC-OBJECT:                    --
GENERAL.VPN:                            no
GENERAL.DBUS-PATH:                      /org/freedesktop/NetworkManager/ActiveConnection/4
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/Settings/10
GENERAL.ZONE:                           --
GENERAL.MASTER-PATH:                    --
IP4.ADDRESS[1]:                         10.13.31.1/24


ip link show master mpbr0
13: tape518c5a7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mpbr0 state UP mode DEFAULT group default qlen 1000
    link/ether e6:53:77:50:74:f1 brd ff:ff:ff:ff:ff:ff

ip link show master localbr
14: tap3910decf: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master localbr state UP mode DEFAULT group default qlen 1000
    link/ether ae:da:0f:d7:33:6a brd ff:ff:ff:ff:ff:ff

# After launching several vm networked to mybr it seems like each a new tap device is created for each vm that gets passed mybr I believe these are macvtap devices explained here https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-virtual_networking-directly_attaching_to_physical_interface

# A tap device is a virtual network interface that looks like an ethernet network card. Instead of having real wires plugged into it, it exposes a nice handy file descriptor to an application willing to send/receive packets.

# IP addresses are assigned to interfaces (physical or virtual). Unnumbered, point-to-point interfaces may work without an IP address of their own though (e.g. a simple, serial interface). Also, only layer-3 interfaces can use IP addresses.

# A layer-3 device like a host or a router may have multiple interfaces, mandating multiple IP addresses. Lower-layer devices like switches or repeaters don't use IP addresses for their basic function. Note that "device" can also be used for just about any technical component. It may also very well refer to a device in the sense of Linux's hardware management.

# A link/connection is an active connection between two physical-layer interfaces. On bus networks like obsolete 10BASE5, more than two interfaces can be "linked".

ip link show master mybr    

23: tap36ec9bf6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mybr state UP mode DEFAULT group default qlen 1000
    link/ether 66:8e:b3:ae:b5:30 brd ff:ff:ff:ff:ff:ff
25: tapfde3cc51: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mybr state UP mode DEFAULT group default qlen 1000
    link/ether 1e:3f:de:ae:47:65 brd ff:ff:ff:ff:ff:ff
27: tap936d26a5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mybr state UP mode DEFAULT group default qlen 1000
    link/ether 02:66:6e:c9:10:1b brd ff:ff:ff:ff:ff:ff
31: tap3eec7b9d: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mybr state UP mode DEFAULT group default qlen 1000
    link/ether d6:bc:4f:74:11:ca brd ff:ff:ff:ff:ff:ff

# Network **[Tap device](https://blog.cloudflare.com/virtual-networking-101-understanding-tap)**
# A tap device is a virtual network interface that looks like an ethernet network card. Instead of having real wires plugged into it, it exposes a nice handy file descriptor to an application willing to send/receive packets.

ip link show master br-eno2  

ip link show master br-eno2
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-eno2 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
30: tap6f162cbc: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-eno2 state UP mode DEFAULT group default qlen 1000
    link/ether 16:43:4e:07:3b:5b brd ff:ff:ff:ff:ff:ff

nmcli con show eno2
Error: eno2 - no such connection profile.

nmcli con show tap6f162cbc
GENERAL.NAME:                           tap6f162cbc
GENERAL.UUID:                           1cfcb696-a47e-4d1f-bf2d-80200b8f9ce1
GENERAL.DEVICES:                        tap6f162cbc
GENERAL.IP-IFACE:                       tap6f162cbc
GENERAL.STATE:                          activated

ip link show tap6f162cbc
30: tap6f162cbc: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-eno2 state UP mode DEFAULT group default qlen 1000
    link/ether 16:43:4e:07:3b:5b brd ff:ff:ff:ff:ff:ff

ip link show eno2
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br-eno2 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff

nmcli device status                 
# although the eno2 device is now enslaved to the br-eno2 bridge it is still an ethernet device
DEVICE       TYPE      STATE                   CONNECTION         
eno1         ethernet  connected               Wired connection 1 
mpbr0        bridge    connected (externally)  mpbr0              
br-eno2      bridge    connected               br-eno2            
localbr      bridge    connected               localbr            
mybr         bridge    connected               mybr               
eno2         ethernet  connected               br-eno2-child 

ip tuntap list           
tape518c5a7: tap one_queue multi_queue vnet_hdr persist
tap3910decf: tap one_queue multi_queue vnet_hdr persist

nmcli con show tape518c5a7

nmcli con show tape518c5a7

connection.id:                          tape518c5a7
connection.uuid:                        f43135b4-cc0a-4d41-8110-39d553800c23
connection.stable-id:                   --
connection.type:                        tun
connection.interface-name:              tape518c5a7
connection.autoconnect:                 no
connection.autoconnect-priority:        0
connection.autoconnect-retries:         -1 (default)
connection.multi-connect:               0 (default)
connection.auth-retries:                -1
connection.timestamp:                   1717108605
connection.read-only:                   no
connection.permissions:                 --
connection.zone:                        --
connection.master:                      mpbr0
connection.slave-type:                  bridge
connection.autoconnect-slaves:          -1 (default)
connection.secondaries:                 --
connection.gateway-ping-timeout:        0
connection.metered:                     unknown
connection.lldp:                        default
connection.mdns:                        -1 (default)
connection.llmnr:                       -1 (default)
connection.dns-over-tls:                -1 (default)
connection.wait-device-timeout:         -1
bridge-port.priority:                   32
bridge-port.path-cost:                  2
bridge-port.hairpin-mode:               no
bridge-port.vlans:                      --
tun.mode:                               2 (tap)
tun.owner:                              --
tun.group:                              --
tun.pi:                                 no
tun.vnet-hdr:                           no
tun.multi-queue:                        yes
GENERAL.NAME:                           tape518c5a7
GENERAL.UUID:                           f43135b4-cc0a-4d41-8110-39d553800c23
GENERAL.DEVICES:                        tape518c5a7
GENERAL.IP-IFACE:                       tape518c5a7
GENERAL.STATE:                          activated
GENERAL.DEFAULT:                        no
GENERAL.DEFAULT6:                       no
GENERAL.SPEC-OBJECT:                    --
GENERAL.VPN:                            no
GENERAL.DBUS-PATH:                      /org/freedesktop/NetworkManager/ActiveConnection/6
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/Settings/12
GENERAL.ZONE:                           --
GENERAL.MASTER-PATH:                    /org/freedesktop/NetworkManager/Devices/12
IP4.GATEWAY:                            --
IP6.GATEWAY:                            --

nmcli device show tape518c5a7

GENERAL.DEVICE:                         tape518c5a7
GENERAL.TYPE:                           tun
GENERAL.HWADDR:                         E6:53:77:50:74:F1
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected (externally))
GENERAL.CONNECTION:                     tape518c5a7
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/6
IP4.GATEWAY:                            --
IP6.GATEWAY:                            --

nmcli device show tap3910decf

GENERAL.DEVICE:                         tap3910decf
GENERAL.TYPE:                           tun
GENERAL.HWADDR:                         AE:DA:0F:D7:33:6A
GENERAL.MTU:                            1500
GENERAL.STATE:                          100 (connected (externally))
GENERAL.CONNECTION:                     tap3910decf
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/ActiveConnection/7
IP4.GATEWAY:                            --
IP6.GATEWAY:                            --

nmcli connection show tap3910decf

connection.id:                          tap3910decf
connection.uuid:                        5e15a73d-d042-4196-931f-302f9054de6a
connection.stable-id:                   --
connection.type:                        tun
connection.interface-name:              tap3910decf
connection.autoconnect:                 no
connection.autoconnect-priority:        0
connection.autoconnect-retries:         -1 (default)
connection.multi-connect:               0 (default)
connection.auth-retries:                -1
connection.timestamp:                   1717108905
connection.read-only:                   no
connection.permissions:                 --
connection.zone:                        --
connection.master:                      localbr
connection.slave-type:                  bridge
connection.autoconnect-slaves:          -1 (default)
connection.secondaries:                 --
connection.gateway-ping-timeout:        0
connection.metered:                     unknown
connection.lldp:                        default
connection.mdns:                        -1 (default)
connection.llmnr:                       -1 (default)
connection.dns-over-tls:                -1 (default)
connection.wait-device-timeout:         -1
bridge-port.priority:                   32
bridge-port.path-cost:                  2
bridge-port.hairpin-mode:               no
bridge-port.vlans:                      --
tun.mode:                               2 (tap)
tun.owner:                              --
tun.group:                              --
tun.pi:                                 no
tun.vnet-hdr:                           no
tun.multi-queue:                        yes
GENERAL.NAME:                           tap3910decf
GENERAL.UUID:                           5e15a73d-d042-4196-931f-302f9054de6a
GENERAL.DEVICES:                        tap3910decf
GENERAL.IP-IFACE:                       tap3910decf
GENERAL.STATE:                          activated
GENERAL.DEFAULT:                        no
GENERAL.DEFAULT6:                       no
GENERAL.SPEC-OBJECT:                    --
GENERAL.VPN:                            no
GENERAL.DBUS-PATH:                      /org/freedesktop/NetworkManager/ActiveConnection/7
GENERAL.CON-PATH:                       /org/freedesktop/NetworkManager/Settings/13
GENERAL.ZONE:                           --
GENERAL.MASTER-PATH:                    /org/freedesktop/NetworkManager/Devices/11
IP4.GATEWAY:                            --
IP6.GATEWAY:                            --

multipass exec -n test6 -- ip route list table local

local 10.1.2.129 dev enp6s0 proto kernel scope host src 10.1.2.129 
broadcast 10.1.3.255 dev enp6s0 proto kernel scope link src 10.1.2.129 
local 10.15.31.19 dev enp7s0 proto kernel scope host src 10.15.31.19 
broadcast 10.15.31.255 dev enp7s0 proto kernel scope link src 10.15.31.19 
local 10.161.38.197 dev enp5s0 proto kernel scope host src 10.161.38.197 
broadcast 10.161.38.255 dev enp5s0 proto kernel scope link src 10.161.38.197 
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1 
multipass exec -n test1 -- ip route list table local

local 10.13.31.13 dev enp6s0 proto kernel scope host src 10.13.31.13 
broadcast 10.13.31.255 dev enp6s0 proto kernel scope link src 10.13.31.13 
local 10.161.38.77 dev enp5s0 proto kernel scope host src 10.161.38.77 
broadcast 10.161.38.255 dev enp5s0 proto kernel scope link src 10.161.38.77 
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1 

multipass exec -n test6 -- ip route list table main
multipass exec -n test6 -- ip route list table main
default via 10.161.38.1 dev enp5s0 proto dhcp src 10.161.38.197 metric 100 
default via 10.1.1.205 dev enp6s0 proto dhcp src 10.1.2.129 metric 200 
10.1.0.0/22 dev enp6s0 proto kernel scope link src 10.1.2.129 metric 200 
10.1.1.205 dev enp6s0 proto dhcp scope link src 10.1.2.129 metric 200 
10.1.2.69 dev enp6s0 proto dhcp scope link src 10.1.2.129 metric 200 
10.1.2.70 dev enp6s0 proto dhcp scope link src 10.1.2.129 metric 200 
10.15.31.0/24 dev enp7s0 proto kernel scope link src 10.15.31.19 
10.161.38.0/24 dev enp5s0 proto kernel scope link src 10.161.38.197 metric 100 
10.161.38.1 dev enp5s0 proto dhcp scope link src 10.161.38.197 metric 100 
172.20.0.39 via 10.1.1.205 dev enp6s0 proto dhcp src 10.1.2.129 metric 200 

multipass exec -n test1 -- ip route list table main
default via 10.161.38.1 dev enp5s0 proto dhcp src 10.161.38.77 metric 100 
10.13.31.0/24 dev enp6s0 proto kernel scope link src 10.13.31.13 
10.161.38.0/24 dev enp5s0 proto kernel scope link src 10.161.38.77 metric 100 
10.161.38.1 dev enp5s0 proto dhcp scope link src 10.161.38.77 metric 100 

# ip shows us our routes
multipass exec -n test6 -- ip route show
default via 10.161.38.1 dev enp5s0 proto dhcp src 10.161.38.197 metric 100 
default via 10.1.1.205 dev enp6s0 proto dhcp src 10.1.2.129 metric 200 
10.1.0.0/22 dev enp6s0 proto kernel scope link src 10.1.2.129 metric 200 
10.1.1.205 dev enp6s0 proto dhcp scope link src 10.1.2.129 metric 200 
10.1.2.69 dev enp6s0 proto dhcp scope link src 10.1.2.129 metric 200 
10.1.2.70 dev enp6s0 proto dhcp scope link src 10.1.2.129 metric 200 
10.15.31.0/24 dev enp7s0 proto kernel scope link src 10.15.31.19 
10.161.38.0/24 dev enp5s0 proto kernel scope link src 10.161.38.197 metric 100 
10.161.38.1 dev enp5s0 proto dhcp scope link src 10.161.38.197 metric 100 
172.20.0.39 via 10.1.1.205 dev enp6s0 proto dhcp src 10.1.2.129 metric 200

multipass exec -n test1 -- ip route show

default via 10.161.38.1 dev enp5s0 proto dhcp src 10.161.38.77 metric 100 
10.13.31.0/24 dev enp6s0 proto kernel scope link src 10.13.31.13 
10.161.38.0/24 dev enp5s0 proto kernel scope link src 10.161.38.77 metric 100 
10.161.38.1 dev enp5s0 proto dhcp scope link src 10.161.38.77 metric 100 

# When the kernel needs to make a routing decision, it finds out which table needs to be consulted. By default, there are three tables. The old 'route' tool modifies the main and local tables, as does the ip tool (by default).
multipass exec -n test1 -- ip rule list
0: from all lookup local
32766: from all lookup main
32767: from all lookup default

#This lists the priority of all rules. We see that all rules apply to all packets ('from all'). We've seen the 'main' table before, it is output by ip route ls, but the 'local' and 'default' table are new.

# If we want to do fancy things, we generate rules which point to different tables which allow us to override system wide routing rules.

# For the exact semantics on what the kernel does when there are more matching rules, see Alexey's ip-cref documentation.


# You can view your machines current arp/neighbor cache/table like so:
multipass exec -n test1 -- ip neigh show 
10.13.31.1 dev enp6s0 lladdr ae:6f:d9:34:27:8a STALE 
10.161.38.1 dev enp5s0 lladdr 00:16:3e:0f:04:ee DELAY 
fe80::216:3eff:fe0f:4ee dev enp5s0 lladdr 00:16:3e:0f:04:ee router STALE 
fd42:b403:217:3a62::1 dev enp5s0 lladdr 00:16:3e:0f:04:ee router STALE

multipass exec -n test6 -- ip neigh show 
10.1.3.128 dev enp6s0 lladdr 04:ec:d8:51:88:b2 STALE 
10.161.38.1 dev enp5s0 lladdr 00:16:3e:0f:04:ee DELAY 
10.1.0.135 dev enp6s0 lladdr b8:ca:3a:6a:35:98 STALE 
10.1.1.205 dev enp6s0 lladdr 34:56:fe:77:58:bc STALE 
10.15.31.1 dev enp7s0 lladdr e2:4f:b4:dd:f4:1b STALE 
10.1.0.32 dev enp6s0 lladdr cc:70:ed:1b:4f:c0 STALE 
10.1.0.30 dev enp6s0 lladdr d4:ad:71:bc:e7:c0 STALE 
10.1.0.31 dev enp6s0 lladdr 70:35:09:91:8f:40 STALE 
10.1.1.151 dev enp6s0 lladdr 00:50:56:ad:fb:d8 STALE 
10.1.2.69 dev enp6s0 lladdr 00:50:56:ad:44:9b STALE 
fe80::216:3eff:fe0f:4ee dev enp5s0 lladdr 00:16:3e:0f:04:ee router STALE 
fd42:b403:217:3a62::1 dev enp5s0 lladdr 00:16:3e:0f:04:ee router STALE 

# ip shows us our links
multipass exec -n test6 -- ip link list
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:0e:fc:93 brd ff:ff:ff:ff:ff:ff
3: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:f5:69:23 brd ff:ff:ff:ff:ff:ff
4: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:0a:19:62 brd ff:ff:ff:ff:ff:ff

multipass exec -n test1 -- ip link list
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:c9:3e:64 brd ff:ff:ff:ff:ff:ff
3: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 5c:13:55:48:43:58 brd ff:ff:ff:ff:ff:ff

# ip shows us our IP addresses
multipass exec -n test6 -- ip address show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 52:54:00:0e:fc:93 brd ff:ff:ff:ff:ff:ff
    inet 10.161.38.197/24 metric 100 brd 10.161.38.255 scope global dynamic enp5s0
       valid_lft 3170sec preferred_lft 3170sec
    inet6 fd42:b403:217:3a62:5054:ff:fe0e:fc93/64 scope global mngtmpaddr noprefixroute 
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe0e:fc93/64 scope link 
       valid_lft forever preferred_lft forever
3: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 52:54:00:f5:69:23 brd ff:ff:ff:ff:ff:ff
    inet 10.1.2.129/22 metric 200 brd 10.1.3.255 scope global dynamic enp6s0
       valid_lft 391505sec preferred_lft 391505sec
    inet6 fe80::5054:ff:fef5:6923/64 scope link 
       valid_lft forever preferred_lft forever
4: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 52:54:00:0a:19:62 brd ff:ff:ff:ff:ff:ff
    inet 10.15.31.19/24 brd 10.15.31.255 scope global enp7s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe0a:1962/64 scope link 
       valid_lft forever preferred_lft forever

multipass exec -n test1 -- ip address show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 52:54:00:c9:3e:64 brd ff:ff:ff:ff:ff:ff
    inet 10.161.38.77/24 metric 100 brd 10.161.38.255 scope global dynamic enp5s0
       valid_lft 3313sec preferred_lft 3313sec
    inet6 fd42:b403:217:3a62:5054:ff:fec9:3e64/64 scope global mngtmpaddr noprefixroute 
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fec9:3e64/64 scope link 
       valid_lft forever preferred_lft forever
3: enp6s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 5c:13:55:48:43:58 brd ff:ff:ff:ff:ff:ff
    inet 10.13.31.13/24 brd 10.13.31.255 scope global enp6s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5e13:55ff:fe48:4358/64 scope link 
       valid_lft forever preferred_lft forever

multipass exec -n test6 -- networkctl status
● Interfaces: 1, 4, 3, 2
         State: routable                                      
  Online state: online                                        
       Address: 10.161.38.197 on enp5s0
                10.1.2.129 on enp6s0
                10.15.31.19 on enp7s0
                fd42:b403:217:3a62:5054:ff:fe0e:fc93 on enp5s0
                fe80::5054:ff:fe0e:fc93 on enp5s0
                fe80::5054:ff:fef5:6923 on enp6s0
                fe80::5054:ff:fe0a:1962 on enp7s0
       Gateway: 10.161.38.1 on enp5s0
                10.1.1.205 on enp6s0
                fe80::216:3eff:fe0f:4ee on enp5s0
           DNS: 10.161.38.1
                fd42:b403:217:3a62::1
                fe80::216:3eff:fe0f:4ee
                10.1.2.69
                10.1.2.70
                172.20.0.39
Search Domains: lxd
                BUSCHE-CNC.COM

Jun 01 06:46:20 test6 systemd-networkd[5878]: enp7s0: Gained IPv6LL
Jun 01 06:46:20 test6 systemd-networkd[5878]: Enumeration completed
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp5s0: Configuring with /run/systemd/network/10-netplan-default.network.
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
Jun 01 06:46:20 test6 systemd[1]: Started systemd-networkd.service - Network Configuration.
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp7s0: Configuring with /run/systemd/network/10-netplan-enp7s0.network.
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp5s0: DHCPv4 address 10.161.38.197/24, gateway 10.161.38.1 acquired from 10.161.38.1
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp6s0: DHCPv4 address 10.1.2.129/22, gateway 10.1.1.205 acquired from 10.1.2.69
Jun 01 06:46:20 test6 systemd[1]: Starting systemd-networkd-wait-online.service - Wait for Network to be Configured...
Jun 01 06:46:20 test6 systemd[1]: Finished systemd-networkd-wait-online.service - Wait for Network to be Configured.

multipass exec -n test1 -- networkctl
IDX LINK   TYPE     OPERATIONAL SETUP     
  1 lo     loopback carrier     unmanaged
  2 enp5s0 ether    routable    configured
  3 enp6s0 ether    routable    configured

multipass exec -n test1 -- networkctl status
● Interfaces: 1, 3, 2
         State: routable                                      
  Online state: online                                        
       Address: 10.161.38.77 on enp5s0
                10.13.31.13 on enp6s0
                fd42:b403:217:3a62:5054:ff:fec9:3e64 on enp5s0
                fe80::5054:ff:fec9:3e64 on enp5s0
                fe80::5e13:55ff:fe48:4358 on enp6s0
       Gateway: 10.161.38.1 on enp5s0
                fe80::216:3eff:fe0f:4ee on enp5s0
           DNS: 10.161.38.1
                fd42:b403:217:3a62::1
                fe80::216:3eff:fe0f:4ee
Search Domains: lxd

May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Gained carrier
May 30 06:36:09 test1 systemd-networkd[5396]: enp5s0: Gained IPv6LL
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Gained IPv6LL
May 30 06:36:09 test1 systemd-networkd[5396]: Enumeration completed
May 30 06:36:09 test1 systemd-networkd[5396]: enp5s0: Configuring with /run/systemd/network/10-netplan-enp5s0.network.
May 30 06:36:09 test1 systemd[1]: Started systemd-networkd.service - Network Configuration.
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
May 30 06:36:09 test1 systemd-networkd[5396]: enp5s0: DHCPv4 address 10.161.38.77/24, gateway 10.161.38.1 acquired from 10.161.38.1
May 30 06:36:09 test1 systemd[1]: Starting systemd-networkd-wait-online.service - Wait for Network to be Configured...
May 30 06:36:09 test1 systemd[1]: Finished systemd-networkd-wait-online.service - Wait for Network to be Configured.
```

To list various details of specific network interface called enp7s0, you can run the following command, which will list network configuration files, type, state, IP addresses (both IPv4 and IPv6), broadcast addresses, gateway, DNS servers, domain, routing information, maximum transmission unit (MTU), and queuing discipline (QDisc).

```bash
multipass exec -n test6 -- networkctl status enp6s0

● 3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:f5:69:23
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.2.129 (DHCP4 via 10.1.2.69)
                              fe80::5054:ff:fef5:6923
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x24721ac8/DUID
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab11fdf0a14abfe669bd

May 31 21:25:10 test6 systemd-networkd[717]: enp6s0: Reconfiguring with /run/systemd/network/10-netplan-extra0.network.
May 31 21:25:10 test6 systemd-networkd[717]: enp6s0: DHCP lease lost
May 31 21:25:10 test6 systemd-networkd[717]: enp6s0: DHCPv6 lease lost
May 31 21:25:10 test6 systemd-networkd[717]: enp6s0: DHCPv4 address 10.1.2.129/22, gateway 10.1.1.205 acquired from 10.1.2.69
Jun 01 06:46:19 test6 systemd-networkd[717]: enp6s0: DHCPv6 lease lost
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp6s0: Link UP
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp6s0: Gained carrier
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp6s0: Gained IPv6LL
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
Jun 01 06:46:20 test6 systemd-networkd[5878]: enp6s0: DHCPv4 address 10.1.2.129/22, gateway 10.1.1.205 acquired from 10.1.2.69

multipass exec -n test1 -- networkctl status enp5s0
● 2: enp5s0
                   Link File: /run/systemd/network/10-netplan-enp5s0.link
                Network File: /run/systemd/network/10-netplan-enp5s0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:05:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:c9:3e:64
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.161.38.77 (DHCP4 via 10.161.38.1)
                              fd42:b403:217:3a62:5054:ff:fec9:3e64
                              fe80::5054:ff:fec9:3e64
                     Gateway: 10.161.38.1
                              fe80::216:3eff:fe0f:4ee
                         DNS: 10.161.38.1
                              fd42:b403:217:3a62::1
                              fe80::216:3eff:fe0f:4ee
              Search Domains: lxd
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x49721f47/DUID
           DHCP6 Client IAID: 0x49721f47
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab11fa956945a47e6700

May 29 18:37:58 test1 systemd-networkd[715]: enp5s0: Configuring with /run/systemd/network/10-netplan-enp5s0.network.
May 29 18:37:58 test1 systemd-networkd[715]: enp5s0: DHCP lease lost
May 29 18:37:58 test1 systemd-networkd[715]: enp5s0: DHCPv6 lease lost
May 29 18:37:58 test1 systemd-networkd[715]: enp5s0: DHCPv4 address 10.161.38.77/24, gateway 10.161.38.1 acquired from 10.161.38.1
May 30 06:36:09 test1 systemd-networkd[715]: enp5s0: DHCPv6 lease lost
May 30 06:36:09 test1 systemd-networkd[5396]: enp5s0: Link UP
May 30 06:36:09 test1 systemd-networkd[5396]: enp5s0: Gained carrier
May 30 06:36:09 test1 systemd-networkd[5396]: enp5s0: Gained IPv6LL
May 30 06:36:09 test1 systemd-networkd[5396]: enp5s0: Configuring with /run/systemd/network/10-netplan-enp5s0.network.
May 30 06:36:09 test1 systemd-networkd[5396]: enp5s0: DHCPv4 address 10.161.38.77/24, gateway 10.161.38.1 acquired from 10.161.38.1


multipass exec -n test1 -- networkctl status enp6s0

● 3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 5c:13:55:48:43:58
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.13.31.13
                              fe80::5e13:55ff:fe48:4358
           Activation Policy: up
         Required For Online: yes
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab11fa956945a47e6700

May 29 18:37:58 test1 systemd-networkd[715]: enp6s0: Link UP
May 29 18:37:58 test1 systemd-networkd[715]: enp6s0: Gained carrier
May 29 18:37:58 test1 systemd-networkd[715]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
May 29 18:37:58 test1 systemd-networkd[715]: enp6s0: DHCPv6 lease lost
May 29 18:38:00 test1 systemd-networkd[715]: enp6s0: Gained IPv6LL
May 30 06:36:09 test1 systemd-networkd[715]: enp6s0: DHCPv6 lease lost
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Link UP
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Gained carrier
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Gained IPv6LL
May 30 06:36:09 test1 systemd-networkd[5396]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.

```

Conclusion
You have now created a small internal network, local to your host, with Multipass instances that you can reach on the same IP across reboots. Instances still have the default NAT-ed network, which they can use to reach the outside world. You can combine this with other networks if you want to (e.g. for bridging).

## Start Here

**[Create an instance with multiple network interfaces](https://multipass.run/docs/create-an-instance#heading--create-an-instance-with-multiple-network-interfaces)**
