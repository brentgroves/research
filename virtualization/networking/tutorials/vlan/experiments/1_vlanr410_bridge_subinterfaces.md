# **[How To Configure VLAN Tagging In Linux [A Step-by-Step Guide]](https://ostechnix.com/configure-vlan-tagging-in-linux/)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

## purpose

Can you get 1 multipass vm to use 2 vlan?

- create bridge
- On r410 configure 2 vlan sub-interfaces
- put the 2 sub-interfaces in a bridge.

## create the 2 sub-interfaces

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eno1:
      dhcp4: no
      addresses:
        - "192.168.1.65/24"
      routes:
        - to: "default"
          via: 192.168.1.1
      nameservers:
        addresses:
          - 192.168.1.1
          - 8.8.8.8
          - 8.8.4.4
  vlans:
    vlan10:
      id: 10
      link: eno1
      addresses:
        - "192.168.10.2/24"
    vlan20:
      id: 20
      link: eno1
      addresses:
        - "192.168.20.2/24"
```

```bash
ip link
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
    link/ether 78:2b:cb:23:45:b0 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f0
3: eno2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 78:2b:cb:23:45:b1 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
4: vlan10@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 78:2b:cb:23:45:b0 brd ff:ff:ff:ff:ff:ff
5: vlan20@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 78:2b:cb:23:45:b0 brd ff:ff:ff:ff:ff:ff

ip addr show vlan10
4: vlan10@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 78:2b:cb:23:45:b0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.2/24 brd 192.168.10.255 scope global vlan10
       valid_lft forever preferred_lft forever
    inet6 fe80::7a2b:cbff:fe23:45b0/64 scope link 
       valid_lft forever preferred_lft forever

ip link show vlan10    
4: vlan10@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 78:2b:cb:23:45:b0 brd ff:ff:ff:ff:ff:ff

ip addr show vlan20
5: vlan20@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 78:2b:cb:23:45:b0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.20.2/24 brd 192.168.20.255 scope global vlan20
       valid_lft forever preferred_lft forever
    inet6 fe80::7a2b:cbff:fe23:45b0/64 scope link 
       valid_lft forever preferred_lft forever
ip link show vlan20    
5: vlan20@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 78:2b:cb:23:45:b0 brd ff:ff:ff:ff:ff:ff
```

## **[Showing current network configuration](https://netplan.readthedocs.io/en/stable/netplan-tutorial/#showing-current-netplan-configuration)**

Netplan 0.106 introduced the netplan status command. The command displays the current network configuration of the system. Try it by running:

```bash
netplan status --all
     Online state: online
    DNS Addresses: 127.0.0.53 (stub)
       DNS Search: .

●  1: lo ethernet UNKNOWN/UP (unmanaged)
      MAC Address: 00:00:00:00:00:00
        Addresses: 127.0.0.1/8
                   ::1/128

●  2: eno1 ethernet UP (networkd: eno1)
      MAC Address: 78:2b:cb:23:45:b0 (Broadcom Inc. and subsidiaries)
        Addresses: 192.168.1.65/24
                   2605:7b00:201:e540::ce6/128 (dynamic, dhcp)
                   fe80::7a2b:cbff:fe23:45b0/64 (link)
    DNS Addresses: 192.168.1.1
                   8.8.8.8
                   8.8.4.4
                   2605:7b00:201:e540::1
           Routes: default via 192.168.1.1 (static)
                   192.168.1.0/24 from 192.168.1.65 (link)
                   2605:7b00:201:e540::/64 metric 1024 (ra)
                   2605:7b00:201:e540::/60 via fe80::62db:98ff:fe28:eded metric 1024 (ra)
                   fe80::/64 metric 256
                   default via fe80::62db:98ff:fe28:eded metric 1024 (ra)

●  3: eno2 ethernet DOWN (unmanaged)
      MAC Address: 78:2b:cb:23:45:b1 (Broadcom Inc. and subsidiaries)

●  4: vlan10 vlan UP (networkd: vlan10)
      MAC Address: 78:2b:cb:23:45:b0
        Addresses: 192.168.10.2/24
                   fe80::7a2b:cbff:fe23:45b0/64 (link)
           Routes: 192.168.10.0/24 from 192.168.10.2 (link)
                   fe80::/64 metric 256

●  5: vlan20 vlan UP (networkd: vlan20)
      MAC Address: 78:2b:cb:23:45:b0
        Addresses: 192.168.20.2/24
                   fe80::7a2b:cbff:fe23:45b0/64 (link)
           Routes: 192.168.20.0/24 from 192.168.20.2 (link)
                   fe80::/64 metric 256
```

## create the bridge

```bash
# moto
sudo su
# -c is coloring
# -br is brief
# -d details
ip -c -br link show type bridge
# nonesudo
ip link add name br0 type bridge
ip -c -br link show br0
br0              DOWN           0a:d3:da:99:e8:ff <BROADCAST,MULTICAST> 

```

## enable vlan filtering and stats

```bash
ip link set dev br0 type bridge help

# vlan filtering is not enabled
ip -c -j -p -d link show br0 | grep vlan
                "vlan_filtering": 0,
                "vlan_protocol": "802.1Q",
                "vlan_default_pvid": 1,
                "vlan_stats_enabled": 0,
                "vlan_stats_per_port": 0,
                "mcast_vlan_snooping": 0,

# enable vlan filtering
ip link set br0 type bridge vlan_filtering 1

# To show the VLAN traffic state, enable VLAN statistics (added in kernel 4.7) as follows:
ip link set br0 type bridge vlan_stats_enabled 1

ip -c -j -p -d link show br0 | grep vlan
                "vlan_filtering": 1,
                "vlan_protocol": "802.1Q",
                "vlan_default_pvid": 1,
                "vlan_stats_enabled": 1,
                "vlan_stats_per_port": 0,
                "mcast_vlan_snooping": 0,
```

## create virtual network interface to put in namespaces

```bash
ip link add name vth1 type veth peer vth_1
ip link add name vth2 type veth peer vth_2
ip link add name vth3 type veth peer vth_3
ip link add name vth4 type veth peer vth_4
```

## create 1 namespace for each vlan

```bash
ip netns add ns1
ip netns add ns2
ip netns add ns3
ip netns add ns4
# verify
ip netns ls
ns1 (id: 0)
ns2 (id: 1)
ns3 (id: 2)
ns4 (id: 3)
```

## put peer devices in namespaces

```bash
ip link set dev vth_1 netns ns1
ip link set dev vth_2 netns ns2
ip link set dev vth_3 netns ns3
ip link set dev vth_4 netns ns4

```

## check the routing

```bash
ip route
default via 192.168.1.1 dev eno1 proto static 
192.168.1.0/24 dev eno1 proto kernel scope link src 192.168.1.65 
192.168.10.0/24 dev vlan10 proto kernel scope link src 192.168.10.2 
192.168.20.0/24 dev vlan20 proto kernel scope link src 192.168.20.2 
```

## assign an ip address to each peer

Pick an IP address that would be in each vlan. When defining the vlan sub-interface we already used 192.168.10.2 and 192.168.20.2 so don't use these.

```bash
ip -n ns1 link set dev vth_1 up
ip -n ns1 address add 192.168.10.3/24 dev vth_1
ip -n ns2 link set dev vth_2 up
ip -n ns2 address add 192.168.20.3/24 dev vth_2

ip -n ns3 link set dev vth_3 up
ip -n ns3 address add 192.168.10.4/24 dev vth_3
ip -n ns4 link set dev vth_4 up
ip -n ns4 address add 192.168.20.4/24 dev vth_4

```

## add virtual network interface to bridge

```bash
ip link set dev vth1 master br0
ip link set dev vth1 up
ip link set dev vth2 master br0
ip link set dev vth2 up

ip link set dev vth3 master br0
ip link set dev vth3 up
ip link set dev vth4 master br0
ip link set dev vth4 up

ip link set dev br0 up

ip -c -br link show br0
br0              UP             0a:d3:da:99:e8:ff <BROADCAST,MULTICAST,UP,LOWER_UP> 
# ip -c br link show br0 type bridge 

## look at the bridge

```bash
bridge link show br0
8: vth1@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state disabled priority 32 cost 2 
10: vth2@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state disabled priority 32 cost 2 
12: vth3@if11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state disabled priority 32 cost 2 
14: vth4@if13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state disabled priority 32 cost 2 


```

## summary

- 2 vlan sub interfaces linked to 1 physical interface
- 1 bridge with pvid 1
- 4 virtual network interfaces in bridge with peers in separate namespaces.

```bash
ip -n ns1 -c -br link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_1@if8        UP             ca:2f:9e:1a:e7:0a <BROADCAST,MULTICAST,UP,LOWER_UP> 
ip -n ns1 -c -br a s 
lo               DOWN           
vth_1@if8        UP             192.168.10.3/24 fe80::c82f:9eff:fe1a:e70a/64 


ip -n ns2 -c -br link show   
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_2@if10       UP             2a:e3:74:8a:7f:a4 <BROADCAST,MULTICAST,UP,LOWER_UP>             
ip -n ns2 -c -br a s 
lo               DOWN           
vth_2@if10       UP             192.168.20.3/24 fe80::28e3:74ff:fe8a:7fa4/64 

ip -n ns3 -c -br link show     
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_3@if12       UP             4e:28:a4:8c:48:65 <BROADCAST,MULTICAST,UP,LOWER_UP>           
ip -n ns3 -c -br a s 
lo               DOWN           
vth_3@if12       UP             192.168.10.4/24 fe80::4c28:a4ff:fe8c:4865/64 

ip -n ns4 -c -br link show     
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_4@if14       UP             92:4b:ec:5a:f5:58 <BROADCAST,MULTICAST,UP,LOWER_UP> 

ip -n ns4 -c -br a s 
lo               DOWN           
vth_4@if14       UP             192.168.20.4/24 fe80::904b:ecff:fe5a:f558/64 
netplan status --all


bridge vlan show
port              vlan-id  
br0               1 PVID Egress Untagged
vth1              1 PVID Egress Untagged
vth2              1 PVID Egress Untagged
vth3              1 PVID Egress Untagged
vth4              1 PVID Egress Untagged

ip -c -br link show
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
eno1             UP             78:2b:cb:23:45:b0 <BROADCAST,MULTICAST,UP,LOWER_UP> 
eno2             DOWN           78:2b:cb:23:45:b1 <BROADCAST,MULTICAST> 
vlan10@eno1      UP             78:2b:cb:23:45:b0 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vlan20@eno1      UP             78:2b:cb:23:45:b0 <BROADCAST,MULTICAST,UP,LOWER_UP> 
br0              UP             0a:d3:da:99:e8:ff <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth1@if7         UP             e2:42:34:b2:40:91 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth2@if9         UP             ea:ae:fd:0a:e3:49 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth3@if11        UP             a2:f4:6f:bc:1f:75 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth4@if13        UP             b2:ce:65:5c:55:e4 <BROADCAST,MULTICAST,UP,LOWER_UP>

ip -c -br address show
```

## can you ping 1 namespace from the other

```bash
bridge fdb show dynamic
ip netns exec ns1 ping 192.168.10.4
# works
ip netns exec ns2 ping 192.168.20.4
# works
```

## Add vlan vid to virtual network interface peers

```bash
# change ns3 vlan peer interface to vid 10 ip 192.168.10.4/24
# The pvid parameter causes untagged frames to be assigned to this VLAN at ingress (veth2 to bridge), and the untagged parameter causes the packet to be untagged on egress (bridge to veth2):
bridge vlan add vid 10 dev vth3 pvid untagged
bridge vlan del vid 1 dev vth3
bridge vlan show
port              vlan-id  
br0               1 PVID Egress Untagged
vth1              1 PVID Egress Untagged
vth2              1 PVID Egress Untagged
vth3              10 PVID Egress Untagged
vth4              1 PVID Egress Untagged

```

## can you ping namespace 3 with vth3 set to pvid 10 from vth1 set to pvid 1

```bash
bridge fdb show dynamic
ip netns exec ns1 ping 192.168.10.4
# does not work
ip netns exec ns2 ping 192.168.20.4
# still works
```

## can we add vlan sub-interface to bridge

```bash
ip link set dev vlan10 master br0
# does not work
ip netns exec ns3 ping 192.168.10.2
# reset the way it was
ip link set dev vlan10 nomaster

bridge vlan show
port              vlan-id  
vlan10            1 PVID Egress Untagged
br0               1 PVID Egress Untagged
vth1              1 PVID Egress Untagged
vth2              1 PVID Egress Untagged
vth3              10 PVID Egress Untagged
vth4              1 PVID Egress Untagged

ip link set dev vth1 up

```

- **[tcpdump with any interface](https://networkengineering.stackexchange.com/questions/1559/tcpdump-i-any-with-vlan)**
- **[protocols vlan](https://unix.stackexchange.com/questions/127245/in-which-vlan-am-i-in)**
- **[identifying vlan packets using tcpdump](https://serverfault.com/questions/562325/identifying-vlan-packets-using-tcpdump)**
- **[Capture VLAN tags by using tcpdump](https://access.redhat.com/solutions/2630851)**

## **[How can I get a VLAN interface in a Linux bridge?](https://superuser.com/questions/1833519/how-can-i-get-a-vlan-interface-in-a-linux-bridge)**

I'm experimenting with Linux bridges and vlan filtering but I'm having a few problems.

What I have is a VM with a trunk (tagged frames) that arrives on ens19. What I want to do is connect this port to a linux bridge and on this bridge have "virtual" interfaces which are labelled on the vlan I need with a complete TCP/IP stack behind it (that of the host).

For my experiments I'm limiting myself to vlan 3 and 5 but the idea is that it should be easy to extend. The use won't seem huge because it could be replaced by sub-interfaces of ens19. But later on the interest that I will connect the ens19 port with a gretap interface to circulate several vlan on a tunnel.

I've done tests with dummy and tap interfaces but it doesn't work given the nature of these interfaces, it seems to me. I tested with a br0.3 sub-interface but here my client receives the ARP reply but the PING never receives an ICMP reply ...

ip link add name br0 type bridge vlan_filtering 1
ip link set dev br0 up
ip link add link br0 name br0.3 type vlan id 3
ip link set dev ens19 master br0
ip link set ens19 up
ip link set dev br0 up
ip link set dev br0.3 up
ip addr add 10.3.0.106/22 dev br0.3

![How to use multiple addresses with multiple gateways](https://netplan.readthedocs.io/en/stable/examples/#how-to-use-multiple-addresses-on-a-single-interface)**

![mvlan](https://ostechnix.com/wp-content/uploads/2023/11/Configure-VLAN-Tagging-using-Netplan-in-Linux-1024x555.png)
