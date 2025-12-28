# **[Setup Multipass VM](https://canonical.com/multipass/docs/configure-static-ips)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## references

- **[Create an instance with multiple network interfaces](https://multipass.run/docs/create-an-instance#heading--create-an-instance-with-multiple-network-interfaces)**
- **[create bridges with netplan](./create_bridges_with_netplan.md)**

## Note

This process assumes you are using Ubuntu 24.04 server or OS that is using networkd or an OS which is setup with NetworkMangager but is completely integrated with Netplan 1.0 such as I think Ubuntu 24.04 desktop.

## Step 1: **[Goto create bridges with netplan](./create_bridges_with_netplan.md)**

```bash
networkctl
IDX LINK        TYPE     OPERATIONAL SETUP      
  1 lo          loopback carrier     unmanaged
  2 enp66s0f0   ether    no-carrier  configuring
  3 enp66s0f1   ether    no-carrier  configuring
  4 enp66s0f2   ether    no-carrier  configuring
  5 eno1        ether    routable    configured 
  6 enp66s0f3   ether    no-carrier  configuring
  7 eno2        ether    enslaved    configured 
  8 eno3        ether    no-carrier  configuring
  9 eno4        ether    no-carrier  configuring
 10 br0         bridge   routable    configured 
 11 br1         bridge   routable    configured 
 12 mpbr0       bridge   routable    unmanaged
 13 tap434bfb4d ether    enslaved    unmanaged
 14 tap34dcb760 ether    enslaved    unmanaged
 15 tap7a27ad4e ether    enslaved    unmanaged
 16 tapf48799c9 ether    enslaved    unmanaged
 17 tapfc3a97ec ether    enslaved    unmanaged
 18 tap38ceeb39 ether    enslaved    unmanaged

```

Use the ip utility to display the link status of Ethernet devices that are ports of a specific bridge:

```bash
ip link show master br0
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:37:19 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
14: tap34dcb760: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 5a:8a:38:e5:66:f1 brd ff:ff:ff:ff:ff:ff
18: tap38ceeb39: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether ce:80:f5:53:04:fb brd ff:ff:ff:ff:ff:ff

```

You can also run multipass networks to confirm the bridge is available for Multipass to connect to.

```bash
multipass networks
Name        Type       Description
br0         bridge     Network bridge with eno2
br1         bridge     Network bridge
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

## Create an instance with a specific image

To find out what images are available, run:

```bash
multipass find
Image                       Aliases           Version          Description
core                        core16            20200818         Ubuntu Core 16
core18                                        20211124         Ubuntu Core 18
core20                                        20230119         Ubuntu Core 20
core22                                        20230717         Ubuntu Core 22
20.04                       focal             20240612         Ubuntu 20.04 LTS
22.04                       jammy             20240626         Ubuntu 22.04 LTS
23.10                       mantic            20240619         Ubuntu 23.10
24.04                       noble,lts         20240622         Ubuntu 24.04 LTS
```

## Launch VM with extra network interface

The full multipass help launch output explains the available options:

```bash
$  multipass help launch
Usage: multipass launch [options] [[<remote:>]<image> | <url>]
```

```bash
# can't get manual mode in which you pass the hardware address to work
# multipass launch --name test3 --network name=mybr,mode=manual,mac="7f:71:f0:b2:55:dd"

multipass launch --network br0 --name microk8s-vm --mem 4G --disk 40G 22.04
# Add memory if going to run only sql server
multipass launch --network br0 --name microk8s-vm --mem 8G --disk 40G

multipass list
Name                    State             IPv4             Image
microk8s-vm             Running           10.127.233.194   Ubuntu 24.04 LTS
                                          10.1.2.143
test1                   Running           10.127.233.173   Ubuntu 24.04 LTS
                                          10.1.0.128
test2                   Running           10.127.233.24    Ubuntu 24.04 LTS
                                          10.13.31.201

```

Use the ip utility to display the link status of Ethernet devices that are ports of a specific bridge:

```bash
ip link show master br0
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:37:19 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
14: tap34dcb760: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 5a:8a:38:e5:66:f1 brd ff:ff:ff:ff:ff:ff
18: tap38ceeb39: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether ce:80:f5:53:04:fb brd ff:ff:ff:ff:ff:ff

```

## retrieve the hardware address

See how multipass configured the network. Until I can figure out how to pass the hardware address manaully during launch we will have to grab the one multipass or lxd creates.

```bash

multipass exec -n microk8s-vm -- sudo networkctl -a status
# skip multipass default network interface
...
enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:6e:60:8a
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.2.143 (DHCP4 via 10.1.2.69)
                              fe80::5054:ff:fe6e:608a
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x24721ac8/DUID
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab11345612d63ead6a74

Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Link UP
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Gained carrier
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: DHCPv4 address 10.1.2.143/22, gateway 10.1.1.205 acquired from 10.1.2.69
Jun 25 22:43:02 microk8s-vm systemd-networkd[730]: enp6s0: Gained IPv6LL
```

## Step 3: Configure the extra interface

We now need to configure the manual network interface inside the instance. We can achieve that using Netplan. The following command plants the required Netplan configuration file in the instance:

```bash
multipass exec -n microk8s-vm -- sudo bash -c 'cat /etc/netplan/50-cloud-init.yaml'
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        default:
            dhcp4: true
            match:
                macaddress: 52:54:00:81:c3:3e
        extra0:
            dhcp4: true
            dhcp4-overrides:
                route-metric: 200
            match:
                macaddress: 52:54:00:6e:60:8a
            optional: true
    version: 2

multipass exec -n microk8s-vm -- sudo bash -c 'cat << EOF > /etc/netplan/50-cloud-init.yaml
network:
    ethernets:
        default:
            dhcp4: true
            match:
                macaddress: 52:54:00:81:c3:3e
        extra0:
            addresses:
            - 10.1.0.129/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: [BUSCHE-CNC.COM]
            match:
                macaddress: 52:54:00:6e:60:8a
            optional: true
    version: 2
EOF'

# verify yaml

multipass exec -n microk8s-vm -- sudo bash -c 'cat /etc/netplan/50-cloud-init.yaml'
network:
    ethernets:
        default:
            dhcp4: true
            match:
                macaddress: 52:54:00:81:c3:3e
        extra0:
            addresses:
            - 10.1.0.129/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: [BUSCHE-CNC.COM]
            match:
                macaddress: 52:54:00:6e:60:8a
            optional: true
    version: 2

# if all looks good apply network changes
multipass exec -n microk8s-vm -- sudo netplan apply

# check network interfaces with networkd cli
multipass exec -n microk8s-vm -- sudo networkctl -a status
# skip multipass default network interfaces
...
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
            Hardware Address: 52:54:00:6e:60:8a
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.0.129
                              fe80::5054:ff:fe6e:608a
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab11345612d63ead6a74

Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Link UP
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: Gained carrier
Jun 25 22:43:01 microk8s-vm systemd-networkd[730]: enp6s0: DHCPv4 address 10.1.2.143/22, gateway 10.1.1.205 acquired from 10.1.2.69
Jun 25 22:43:02 microk8s-vm systemd-networkd[730]: enp6s0: Gained IPv6LL
Jun 26 20:12:11 microk8s-vm systemd-networkd[730]: enp6s0: Reconfiguring with /run/systemd/network/10-netplan-extra0.network.
Jun 26 20:12:11 microk8s-vm systemd-networkd[730]: enp6s0: DHCP lease lost
Jun 26 20:12:11 microk8s-vm systemd-networkd[730]: enp6s0: DHCPv6 lease lost
Jun 26 20:12:11 microk8s-vm systemd-networkd[730]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
Jun 26 20:12:11 microk8s-vm systemd-networkd[730]: enp6s0: DHCPv6 lease lost

```

Step 5: Confirm that it works
You can confirm that the new IP is present in the instance with Multipass:

```bash
multipass info microk8s-vm
Name:           microk8s-vm
State:          Running
IPv4:           10.127.233.194
                10.1.0.129
Release:        Ubuntu 24.04 LTS
Image hash:     f06aa34c14c9 (Ubuntu 24.04 LTS)
CPU(s):         1
Load:           0.00 0.01 0.00
Disk usage:     1.7GiB out of 38.7GiB
Memory usage:   576.3MiB out of 7.7GiB
Mounts:
```

You can use ping to confirm that it can be reached from another host on lan:

```bash
ping -c 1 -n 10.1.0.129
PING 10.1.0.129 (10.1.0.129) 56(84) bytes of data.
64 bytes from 10.1.0.129: icmp_seq=1 ttl=64 time=1.31 ms

--- 10.1.0.129 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 1.309/1.309/1.309/0.000 ms
```

Confirm VM can ping lan and wan

```bash
multipass exec -n microk8s-vm -- ping -c 1 -n 10.1.0.113
PING 10.1.0.113 (10.1.0.113) 56(84) bytes of data.
64 bytes from 10.1.0.113: icmp_seq=1 ttl=64 time=0.560 ms

--- 10.1.0.113 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.560/0.560/0.560/0.000 ms

multipass exec -n microk8s-vm -- ping -c 1 -n google.com
PING google.com (142.250.191.238) 56(84) bytes of data.
64 bytes from 142.250.191.238: icmp_seq=1 ttl=57 time=9.04 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 9.039/9.039/9.039/0.000 ms

```

## Verify routing tables

**[references iproute2 intro for ip commands](../networking/iproute2/introduction_to_iproute.md)**

```bash
ip route list table local
local 10.1.0.125 dev eno1 proto kernel scope host src 10.1.0.125 
local 10.1.0.126 dev br0 proto kernel scope host src 10.1.0.126 
broadcast 10.1.3.255 dev br0 proto kernel scope link src 10.1.0.126 
broadcast 10.1.3.255 dev eno1 proto kernel scope link src 10.1.0.125 
local 10.13.31.1 dev br1 proto kernel scope host src 10.13.31.1 
broadcast 10.13.31.255 dev br1 proto kernel scope link src 10.13.31.1 
local 10.127.233.1 dev mpbr0 proto kernel scope host src 10.127.233.1 
broadcast 10.127.233.255 dev mpbr0 proto kernel scope link src 10.127.233.1 
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1 

# there should be only 1 default route
ip route list table main
default via 10.1.1.205 dev eno1 proto static 
10.1.0.0/22 dev br0 proto kernel scope link src 10.1.0.126 
10.1.0.0/22 dev eno1 proto kernel scope link src 10.1.0.125 
10.13.31.0/24 dev br1 proto kernel scope link src 10.13.31.1 
10.127.233.0/24 dev mpbr0 proto kernel scope link src 10.127.233.1

# ip shows us our routes
ip route show
default via 10.1.1.205 dev eno1 proto static 
10.1.0.0/22 dev br0 proto kernel scope link src 10.1.0.126 
10.1.0.0/22 dev eno1 proto kernel scope link src 10.1.0.125 
10.13.31.0/24 dev br1 proto kernel scope link src 10.13.31.1 
10.127.233.0/24 dev mpbr0 proto kernel scope link src 10.127.233.1 

# You can view your machines current arp/neighbor cache/table like so:
ip neigh show
10.1.0.162 dev eno2 lladdr 4c:91:7a:64:0f:7d STALE
10.1.0.166 dev eno1 lladdr 4c:91:7a:63:c0:3a STALE
10.1.1.205 dev eno1 lladdr 34:56:fe:77:58:bc STALE

# view devices linked to bridge
ip link show master br0
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:37:19 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
14: tap34dcb760: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 5a:8a:38:e5:66:f1 brd ff:ff:ff:ff:ff:ff
18: tap38ceeb39: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether ce:80:f5:53:04:fb brd ff:ff:ff:ff:ff:ff

ip link show master mpbr0
13: tape518c5a7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mpbr0 state UP mode DEFAULT group default qlen 1000
    link/ether e6:53:77:50:74:f1 brd ff:ff:ff:ff:ff:ff

# show vm routing table
multipass exec -n microk8s-vm -- ip route list table local
local 10.1.0.129 dev enp6s0 proto kernel scope host src 10.1.0.129 
broadcast 10.1.3.255 dev enp6s0 proto kernel scope link src 10.1.0.129 
local 10.127.233.194 dev enp5s0 proto kernel scope host src 10.127.233.194 
broadcast 10.127.233.255 dev enp5s0 proto kernel scope link src 10.127.233.194 
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1 

multipass exec -n microk8s-vm -- ip route list table main
default via 10.127.233.1 dev enp5s0 proto dhcp src 10.127.233.194 metric 100 
10.1.0.0/22 dev enp6s0 proto kernel scope link src 10.1.0.129 
10.127.233.0/24 dev enp5s0 proto kernel scope link src 10.127.233.194 metric 100 
10.127.233.1 dev enp5s0 proto dhcp scope link src 10.127.233.194 metric 100
```

## **[multipass ubuntu password set](https://askubuntu.com/questions/1230753/login-and-password-for-multipass-instance)**

In multipass instance, set a password to ubuntu user. Needed to ftp from dev system. Multipass has transfer command but only works from the host.

```bash
sudo passwd ubuntu
```
