# **[Linux Bridge Workshop](https://www.youtube.com/watch?v=Ga_mAaKpKdk)**

**[Back to Research List](../../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../../README.md)**

## references

- **[disable iptable for bridges](https://wiki.libvirt.org/Net.bridge.bridge-nf-call_and_sysctl.conf.html)**
- **[Linux Networking](https://www.youtube.com/watch?v=oVu0O0UMBCc&list=PLmZU6NElARbZtvrVbfz9rVpWRt5HyCeO7)**

## netfilter subsystem hooks

![pf](https://people.netfilter.org/pablo/nf-hooks.png)

The following hooks represent these well-defined points in the networking stack:

- **NF_IP_PRE_ROUTING:** This hook will be triggered by any incoming traffic very soon after entering the network stack. This hook is processed before any routing decisions have been made regarding where to send the packet.
- **NF_IP_LOCAL_IN:** This hook is triggered after an incoming packet has been routed if the packet is destined for the local system.
- **NF_IP_FORWARD:** This hook is triggered after an incoming packet has been routed if the packet is to be forwarded to another host.
- **NF_IP_LOCAL_OUT:** This hook is triggered by any locally created outbound traffic as soon as it hits the network stack.
- **NF_IP_POST_ROUTING:** This hook is triggered by any outgoing or forwarded traffic after routing has taken place and just before being sent out on the wire.

| Tables↓/Chains→               | PREROUTING | INPUT | FORWARD | OUTPUT | POSTROUTING |
|-------------------------------|------------|-------|---------|--------|-------------|
| (routing decision)            |            |       |         | ✓      |             |
| raw                           | ✓          |       |         | ✓      |             |
| (connection tracking enabled) | ✓          |       |         | ✓      |             |
| mangle                        | ✓          | ✓     | ✓       | ✓      | ✓           |
| nat (DNAT)                    | ✓          |       |         | ✓      |             |
| (routing decision)            | ✓          |       |         | ✓      |             |
| filter                        |            | ✓     | ✓       | ✓      |             |
| security                      |            | ✓     | ✓       | ✓      |             |
| nat (SNAT)                    |            | ✓     |         |        | ✓           |

## commands

vm: red box

- ip:192.168.128.101/24

- namespace:10
  -vlan10 - enp0s1 - br100
- namespace:20
  -vlan20 - enp0s1 - br100

connect by sw bridge outside of vm:br100

vm: blue box
192.168.128/102/24

- namespace:ns-x
  - vlan10 - enp0s1 - br100
  - vlan20 - enp0s1 - br100

tcpdump on physical machine

```bash
# on host system create a bridge for vms to use
ip link add name br100 type bridge
ip -c -d link show br100
vlan filtering is off
# enable vlan filtering
ip -d link show br100 | grep vlan_filterin
ip link set br100 type bridge vlan_filtering 1
ip link set dev br100 up
ip -c -d link show br0
# create 2 vm with this bridge interface

bridge link show br100
8: tapd957706b: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master lxdbr0 state forwarding priority 32 cost 2 
11: vth1@if10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2 
13: vth2@if12: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2 
15: vth3@if14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2 
17: vth4@if16: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2 
24: vnet5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br100 state disabled priority 32 cost 2 
25: vnet6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br100 state disabled priority 32 cost 2 

ip link set dev br100 up
 ip -c -br link show 
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
br100            UP             36:1d:1f:7e:46:33 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vnet7            UNKNOWN        fe:54:00:fc:6a:39 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vnet8            UNKNOWN        fe:54:00:0d:85:ba <BROADCAST,MULTICAST,UP,LOWER_UP> 

# ssh into redbox vm
ip -br link ls
enp0s1
ip netns ls
sudo ip netns add ns-10
sudo ip netns add ns-20
ip -c netns ls
lsmod | grep 802
# it will load when you create the interfaces
ip -br -c link ls
# create subordinate to enp0s1
ip link add link enp1s0 name vlan10 type vlan id 10
ip link add link enp1s0 name vlan20 type vlan id 20
# 13:43 into video
ip -br -c link ls
lsmod | grep 802
8021q
ip link set dev vlan10 netns ns-10
ip link set dev vlan20 netns ns-20
# from host
ip -br -c link ls
# these are gone since we have put in different ns
vlan10@enp0s1
vlan20@enp0s1
# from redbox
ip -n ns-10 address add 10.0.0.10/24 dev vlan10
ip -n ns-10 link set dev vlan10 up
ip -n ns-10 -br -c address show
ip netns exec ns-20 bash
ip link ls
ip link set dev vlan20 up
ip address add 20.0.0.10/24 dev vlan20
ip -br -c address show


```
