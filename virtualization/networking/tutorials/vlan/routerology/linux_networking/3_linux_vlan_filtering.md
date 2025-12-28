# **[Linux VLAN Filtering](https://www.youtube.com/watch?v=a8ghZoBZcE0&list=PLmZU6NElARbZtvrVbfz9rVpWRt5HyCeO7&index=3)**


**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

## references


- **[Linux Networking](https://www.youtube.com/@routerologyblog1111/playlists)**
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


## new setup

- default
  - br0
    - vth1 -> vth_1
    - vth2 -> vth_2
    - vth3 -> vth_3
    - vth4 -> vth_4
- netns ns1
  - vlan 10
    - vth_1, 192.168.10.1/24
- netns ns2
  - vlan 10
    - vth_2 192.168.10.2/24
- netns ns3
  - vlan 20
    - vth_3, 192.168.10.3/24
- netns ns4
  - vlan 20
    - vth_4, 192.168.10.4/24


```bash
sudo su
ip -c -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enxf8e43bed63bd  UP             f8:e4:3b:ed:63:bd <BROADCAST,MULTICAST,UP,LOWER_UP> 
wlp114s0f0       UP             e0:8f:4c:51:6f:17 <BROADCAST,MULTICAST,UP,LOWER_UP> 
lxdbr0           UP             00:16:3e:a6:6d:bf <BROADCAST,MULTICAST,UP,LOWER_UP> 
tapbf580e7a      UP             8a:61:02:96:7d:55 <BROADCAST,MULTICAST,UP,LOWER_UP> 
lxcbr0           DOWN           00:16:3e:00:00:00 <NO-CARRIER,BROADCAST,MULTICAST,UP> 
enx803f5d090eb3  UP             80:3f:5d:09:0e:b3 <BROADCAST,MULTICAST,UP,LOWER_UP> 
br0              UP             42:86:f0:20:a4:84 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth1@if10        UP             12:d2:48:84:15:22 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth2@if12        UP             22:e6:cc:13:6a:8f <BROADCAST,MULTICAST,UP,LOWER_UP> 

ip link add name vth3 type veth peer vth_3
ip link add name vth4 type veth peer vth_4
ip -c -br link
...
br0              UP             42:86:f0:20:a4:84 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth1@if10        UP             12:d2:48:84:15:22 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth2@if12        UP             22:e6:cc:13:6a:8f <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth_3@vth3       DOWN           fe:bc:30:9c:dd:64 <BROADCAST,MULTICAST,M-DOWN> 
vth3@vth_3       DOWN           02:da:56:4b:ef:16 <BROADCAST,MULTICAST,M-DOWN> 
vth_4@vth4       DOWN           26:25:dc:ec:90:fe <BROADCAST,MULTICAST,M-DOWN> 
vth4@vth_4       DOWN           be:a2:50:57:b2:3c <BROADCAST,MULTICAST,M-DOWN> 

ip netns add ns3
ip netns add ns4

ip link set dev vth_3 netns ns3
ip link set dev vth_4 netns ns4

ip -n ns3 link set dev vth_3 up
ip -n ns3 address add 192.168.10.3/24 dev vth_3
ip -n ns3 address add 192.168.10.4/24 dev vth_4
ip -n ns4 link set dev vth_4 up

bridge link show br0
ip link set dev vth3 master br0
ip link set dev vth4 master br0
ip link set dev vth3 up
ip link set dev vth4 up

ip netns exec ns1 ping 192.168.10.4

# vlan filtering is not enabled
ip -c -j -p -d link show br0 | grep vlan

9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 42:86:f0:20:a4:84 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535 
    bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filtering 0 vlan_protocol 802.1Q bridge_id 8000.42:86:f0:20:a4:84 designated_root 8000.42:86:f0:20:a4:84 root_port 0 root_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_change_timer    0.00 gc_timer    0.00 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 no_linklocal_learn 0 mcast_vlan_snooping 0 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast_hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000 mcast_startup_query_interval 3125 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_version 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 tso_max_size 524280 tso_max_segs 65535 gro_max_size 65536 

ip link set dev br0 type bridge help

# bridge vlan help
# Usage: bridge vlan { add | del } vid VLAN_ID dev DEV [ tunnel_info id TUNNEL_ID ]
# [ pvid ] [ untagged ] parameters pvid any frame that enters this interface untagged will be put in this vlan,

#  [ self ] [ master ]
# master use this when not bridge itself, br0, is the default
# self when configuring bridge itself

# The following command, similar to the previous one, makes the veth2 bridge port transmit VLAN 2 data. The pvid parameter causes untagged frames to be assigned to this VLAN at ingress (veth2 to bridge), and the untagged parameter causes the packet to be untagged on egress (bridge to veth2):

# bridge vlan add dev veth2 vid 2 pvid untagged`
# The pvid parameter causes untagged frames to be assigned to this VLAN at ingress (veth2 to bridge), and the untagged parameter causes the packet to be untagged on egress (bridge to veth2):


bridge vlan add vid 10 dev vth1 pvid untagged
# master is not necessary here
bridge vlan add vid 10 dev vth2 pvid untagged master

bridge vlan show
port              vlan-id  
virbr0            1 PVID Egress Untagged
lxcbr0            1 PVID Egress Untagged
lxdbr0            1 PVID Egress Untagged
tapd957706b       1 PVID Egress Untagged
br0               1 PVID Egress Untagged
vth1              1 Egress Untagged
                  10 PVID Egress Untagged
vth2              1 Egress Untagged
                  10 PVID Egress Untagged
vth3              1 PVID Egress Untagged
vth4              1 PVID Egress Untagged

# enable vlan filtering
ip -d link show br0 | grep vlan_filterin
ip link set br0 type bridge vlan_filtering 1
# vth1 can communicate with vth2 because they share a common vlan
ip netns exec ns1 ping 192.168.10.4

bridge vlan del vid 1 dev vth1
bridge vlan del vid 1 dev vth2
bridge vlan del vid 1 dev vth3
bridge vlan del vid 1 dev vth4

# if you want to delete vid 1 from the bridge you must add the self keyword.
bridge vlan del vid 1 dev br0 self

# tag on ingress untag on egress
bridge vlan add vid 10 dev vth4 pvid untagged

bridge vlan show
port              vlan-id  
port              vlan-id  
virbr0            1 PVID Egress Untagged
lxcbr0            1 PVID Egress Untagged
lxdbr0            1 PVID Egress Untagged
tapd957706b       1 PVID Egress Untagged
vth1              10 PVID Egress Untagged
vth2              10 PVID Egress Untagged
vth4              10 PVID Egress Untagged

ip netns exec ns1 ping 192.168.10.3
# fails
ip netns exec ns1 ping 192.168.10.4

bridge vlan add vid 10 dev vth3 pvid untagged
# The pvid parameter causes untagged frames to be assigned to this VLAN at ingress (veth2 to bridge), and the untagged parameter causes the packet to be untagged on egress (bridge to veth2):

ip netns exec ns1 ping 192.168.10.3
# works now

bridge fdb show dynamic
00:16:3e:46:a8:a7 dev tapd957706b vlan 1 master lxdbr0 
92:99:9b:e4:da:1a dev vth1 vlan 10 master br0 
fe:bc:30:9c:dd:64 dev vth3 vlan 10 master br0 

# change vid
bridge vlan add vid 30 dev vth3 pvid untagged
bridge vlan add vid 20 dev vth3 pvid untagged
bridge vlan add vid 20 dev vth4 pvid untagged
bridge vlan del vid 30 dev vth3

bridge vlan show
port              vlan-id  
virbr0            1 PVID Egress Untagged
lxcbr0            1 PVID Egress Untagged
lxdbr0            1 PVID Egress Untagged
tapd957706b       1 PVID Egress Untagged
vth1              10 PVID Egress Untagged
vth2              10 PVID Egress Untagged
vth3              20 PVID Egress Untagged
vth4              20 PVID Egress Untagged

# test
# does not work
ip netns exec ns1 ping 192.168.10.4
# allowed
ip netns exec ns3 ping 192.168.10.4

 bridge fdb show dynamic
00:16:3e:46:a8:a7 dev tapd957706b vlan 1 master lxdbr0 
92:99:9b:e4:da:1a dev vth1 vlan 10 master br0 
f6:69:7c:7a:9b:ea dev vth2 vlan 10 master br0 
fe:bc:30:9c:dd:64 dev vth3 vlan 20 master br0 
26:25:dc:ec:90:fe dev vth4 vlan 20 master br0 

bridge vlan help
Usage: bridge vlan { add | del } vid VLAN_ID dev DEV [ tunnel_info id TUNNEL_ID ]
[ pvid ] [ untagged ]
[ self ] [ master ]
# stopped at 10:41

## original setup

default
- veth1
- veth2
- br0
ns1
- veth_1 peer to veth1
- 192.168.1.50
ns2
- veth_2 peer to veth2
- 192.168.1.51

```bash
```