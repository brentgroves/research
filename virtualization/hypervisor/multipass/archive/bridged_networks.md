# **[How to bridge local LAN using Multipass](https://multipass.run/docs/configure-static-ips)**

**[Back to Research List](../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## references

- **[Add network interfaces](https://discourse.ubuntu.com/t/how-to-add-network-interfaces/19544))**
- **[Need LXD](https://multipass.run/docs/networks-command)**

## **[Configure Static IP](https://multipass.run/docs/configure-static-ips)**

This document explains how to create instances with static IPs in a new network, internal to the host. With this approach, instances get an extra IP that does not change with restarts. By using a separate, local network we avoid any IP conflicts. Instances retain the usual default interface with a DHCP-allocated IP, which gives them connectivity to the outside.

![](https://jon.sprig.gs/blog/wp-content/uploads/2023/03/4405616339_69afc96727_c-750x410.jpg)

```bash
multipass networks
networks failed: The networks feature is not implemented on this backend.
```

**[Multipass on Ubuntu with Bridged Network Interfaces](https://jon.sprig.gs/blog/post/2800)**

I’m working on a new project, and I am using Multipass on an Ubuntu machine to provision some virtual machines on my local machine using cloudinit files. All good so far!

I wanted to expose one of the services I’ve created to the bridged network (so I can run avahi-daemon), and did this by running ```multipass launch -n vm01 --network enp3s0``` when, what should I see but: launch failed: The bridging feature is not implemented on this backend. OH NO!

By chance, I found a **[random Stack Overflow answer](https://askubuntu.com/a/1364507)**, which said:

Currently only the LXD driver supports the networks command on Linux.

So, let’s make multipass on Ubuntu use LXD! (Be prepared for entering your password a few times!)

Firstly, we need to install LXD. Dead simple:

LXD ( [lɛks'di:] 🔈) is a modern, secure and powerful system container and virtual machine manager. It provides a unified experience for running and managing full Linux systems inside containers or virtual machines.

```bash
sudo snap install lxd
lxd (5.21/stable) 5.21.1-d46c406 from Canonical✓ installed
```

Next, we need to tell snap that it’s allowed to connect LXD to multipass:

```bash
sudo snap connect multipass:lxd lxd
```

And lastly, we tell multipass to use lxd:

```bash
multipass set local.driver=lxd
```

Check which backend you are using with multipass get local.driver if it doesn't return lxd you need to make sure lxd is installed and set it as the driver multipass set local.driver=lxd

```bash
# repsys11
multipass networks
Name        Type       Description
docker0     bridge     Network bridge
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

Thank you Lord for every trial and problem you allow me to go through today.

```bash
multipass launch --network en01 
multipass launch --network en01 --network name=bridge0,mode=manual
```

## Step 1: Create a Bridge

The first step is to create a new bridge/switch with a static IP on your host. This is beyond the scope of Multipass but, as an example, here is how this can be achieved with NetworkManager (e.g. on Ubuntu Desktop):

```bash
sudo nmcli connection add type bridge con-name localbr ifname localbr \
    ipv4.method manual ipv4.addresses 10.1.0.127/22

nmcli connection add type bridge con-name mpbr ifname mpbr \
    ipv4.method manual ipv4.addresses 10.13.31.1/24
Connection 'mpbr' (793e1b43-e221-455c-b53b-0720befecdec) successfully added.

#This will create a bridge named localbr with IP 10.1.0.126/22. You can see the new device and address with ip -c -br addr show dev localbr. This should show:

# ip -c -br addr show dev localbr
# localbr          UP             10.1.0.127/22

ip -c -br addr show dev mpbr

mpbr             DOWN           10.13.31.1/24


```

You can also run multipass networks to confirm the bridge is available for Multipass to connect to.

## Step 2: Launch an instance with a manual network

Next we launch an instance with an extra network in manual mode, connecting it to this bridge:

```bash
multipass launch --name test6 --network name=mpbr,mode=manual,mac="4b:4b:00:4b:ab:cd"

# multipass launch --name test1 --network name=localbr,mode=manual,mac="52:54:00:4b:ab:cd"

# multipass launch --name test3 --network name=localbr,mode=manual,mac="53:54:00:4b:ab:cd" 

# multipass launch --name test4 --network name=localbr,mode=manual,mac="51:54:00:4b:ab:cd"

# multipass launch --name test5 --network name=localbr,mode=manual,mac="55:55:00:4b:ab:cd"


```

You can also leave the MAC address unspecified (just --network name=localbr,mode=manual). If you do so, Multipass will generate a random MAC for you, but you will need to retrieve it in the next step.

## Step 3: Configure the extra interface

We now need to configure the manual network interface inside the instance. We can achieve that using Netplan. The following command plants the required Netplan configuration file in the instance:

```bash
multipass exec -n test6 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "4b:4b:00:4b:ab:cd"
            addresses: [10.13.31.13/24]
EOF'


# $ multipass exec -n test6 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        extra0:
            dhcp4: no
            match:
                macaddress: "55:55:00:4b:ab:cd"
            addresses: [10.1.0.127/22]
EOF'
```

The IP address needs to be unique and in the same subnet as the bridge. The MAC address needs to match the extra interface inside the instance: either the one provided in step 2 or the one Multipass generated (you can find it with ip link).

If you want to set a different name for the interface, you can add a set-name property.

## Step 4: Apply the new configuration

We now tell netplan apply the new configuration inside the instance:

```bash
multipass exec -n test6 -- sudo netplan apply


** (generate:2634): WARNING **: 19:52:03.729: Permissions for /etc/netplan/10-custom.yaml are too open. Netplan configuration should NOT be accessible by others.
# You may also use netplan try, to have the outcome reverted if something goes wrong.

```

## Step 5: Confirm that it works

You can confirm that the new IP is present in the instance with Multipass:

```bash
Name:           test1
State:          Running
IPv4:           10.182.32.10
                10.1.0.126
Release:        Ubuntu 24.04 LTS
Image hash:     08c7ba960c16 (Ubuntu 24.04 LTS)
CPU(s):         1
Load:           0.00 0.00 0.05
Disk usage:     1.2GiB out of 9.6GiB
Memory usage:   342.6MiB out of 945.6MiB
Mounts:         --

#The command above should show two IPs, the second of which is the one we just configured (10.1.0.126). You can use ping to confirm that it can be reached from the host:

ping 10.1.0.126
# Conversely, you can also ping from the instance to the host:

multipass exec -n test1 -- ping 10.1.0.126
```

I could ping from the test1 to the host but not to reports-alb

from repsys11
ping -I mpbr0 10.1.0.113
PING 10.1.0.113 (10.1.0.113) from 10.182.32.1 mpbr0: 56(84) bytes of data.
From 10.182.32.1 icmp_seq=1 Destination Host Unreachable
From 10.182.32.1 icmp_seq=2 Destination Host Unreachable
From 10.182.32.1 icmp_seq=3 Destination Host Unreachable

ping 10.1.0.113
PING 10.1.0.113 (10.1.0.113) 56(84) bytes of data.
64 bytes from 10.1.0.113: icmp_seq=1 ttl=64 time=0.413 ms
64 bytes from 10.1.0.113: icmp_seq=2 ttl=64 time=0.403 ms

<https://github.com/canonical/multipass/issues/2680>
<https://multipass.run/docs/troubleshoot-networking>

multipass exec test2 -- ip route
default via 10.182.32.1 dev enp5s0 proto dhcp src 10.182.32.89 metric 100
10.182.32.0/24 dev enp5s0 proto kernel scope link src 10.182.32.89 metric 100
10.182.32.1 dev enp5s0 proto dhcp scope link src 10.182.32.89 metric 100

<https://discourse.ubuntu.com/t/how-to-add-network-interfaces/19544>

## start here

vm on reports-alb has no problem reaching internet.

<https://www.reddit.com/r/Ubuntu/comments/fyzkfj/cant_ping_outside_in_vm_created_by_multipass/>

nmcli -p con show docker0

nmcli -p con show mpbr0
ipv4.method:                            manual
ipv4.dns:                               --
ipv4.dns-search:                        --
ipv4.dns-options:                       --
ipv4.dns-priority:                      0
ipv4.addresses:                         10.182.32.1/24
ipv4.gateway:                           --
ipv4.routes:                            --
ipv4.route-metric:                      -1
ipv4.route-table:                       0 (unspec)
ipv4.routing-rules:                     --
...
IP4.ADDRESS[1]:                         10.182.32.1/24
IP4.GATEWAY:                            --
IP4.ROUTE[1]:                           dst = 10.182.32.0/24, nh = 0.0.0.0, mt = 0

## Conclusion

You have now created a small internal network, local to your host, with Multipass instances that you can reach on the same IP across reboots. Instances still have the default NAT-ed network, which they can use to reach the outside world. You can combine this with other networks if you want to (e.g. for bridging).

thank you Father for allowing me enjoy my work no matter if I succeed or fail.  You can not fail if you do not give up and I am in control of if you succeed or not.
