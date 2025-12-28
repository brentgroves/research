# **[Linux Bridging Part 1](https://www.youtube.com/watch?v=oVu0O0UMBCc&list=PLmZU6NElARbZtvrVbfz9rVpWRt5HyCeO7)**


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


## configuration 

A "virtual ethernet peer" refers to the paired counterpart of a virtual Ethernet device (often called "veth") within a network, essentially creating a logical connection between two separate network namespaces, allowing them to communicate with each other as if they were directly connected by a physical Ethernet cable; each "veth" pair acts as a tunnel for data transfer between the two namespaces. 

vth_2 is peer interface for vth2 - br0 - vth1's peer interface is vth_1

default namespace:
- vth2
- br0
- vth1
namespace ns1:
- vth_2 peer interfaces
- 192.168.10.2/24
namespace ns2:
- vth_1 peer interfaces
- 192.168.10.1/24

tools
- iproute2
  - ip link
  - bridge

## commands

```bash
# moto
sudo su
# -c is coloring
# -br is brief
# -d details
ip -c -br link show 
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp0s31f6        UP             f4:8e:38:b7:1e:fd <BROADCAST,MULTICAST,UP,LOWER_UP> 
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP> 
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP> 

ip link add name br0 type bridge
ip -c -br link show 
ip -c link show # more details
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether f4:8e:38:b7:1e:fd brd ff:ff:ff:ff:ff:ff
4: br-2c4c88ba5dfd: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:ff:bd:27:1c brd ff:ff:ff:ff:ff:ff
5: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:7f:e9:b2:91 brd ff:ff:ff:ff:ff:ff
6: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ba:ea:cb:63:00:4a brd ff:ff:ff:ff:ff:ff
ip -c -d link show br0 # more details
    link/ether ba:ea:cb:63:00:4a brd ff:ff:ff:ff:ff:ff
root@moto:/home/brent/src/Reporting2/prod/volume/PipeLine# ip -c -d link show br0
6: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether ba:ea:cb:63:00:4a brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535 
    bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filtering 0 vlan_protocol 802.1Q bridge_id 8000.ba:ea:cb:63:0:4a designated_root 8000.ba:ea:cb:63:0:4a root_port 0 root_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_change_timer    0.00 gc_timer    0.00 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast_hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000 mcast_startup_query_interval 3124 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_version 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 

stp_state 0 # spanning tree state     
vlan_filtering 0 # important for vlan
vlan_protocol 802.1Q # encapsulation protocol

# create virtual ethernet interfaces because you can place them in a namespace.
ip link add name vth1 type veth peer vth_1
ip link add name vth2 type veth peer vth_2

ip -br -c link show 
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp0s31f6        UP             f4:8e:38:b7:1e:fd <BROADCAST,MULTICAST,UP,LOWER_UP> 
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP> 
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP> 
br0              DOWN           ba:ea:cb:63:00:4a <BROADCAST,MULTICAST> 
# 2 virtual ethernet pairs
vth_1@vth1       DOWN           72:45:86:8e:8d:6f <BROADCAST,MULTICAST,M-DOWN> 
vth1@vth_1       DOWN           a2:66:1a:95:cb:36 <BROADCAST,MULTICAST,M-DOWN> 
vth_2@vth2       DOWN           fe:69:e1:e6:1d:fd <BROADCAST,MULTICAST,M-DOWN> 
vth2@vth_2       DOWN           c6:30:62:f3:90:da <BROADCAST,MULTICAST,M-DOWN> 
ip netns ls
ip netns add ns1
ip netns add ns2
ip netns ls
ns2
ns1
ip link set vth_1 netns ns1
ip -n ns1 link show
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
7: vth_1@if8: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 72:45:86:8e:8d:6f brd ff:ff:ff:ff:ff:ff link-netnsid 0

ip -n ns1 -c -br link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_1@if8        DOWN           72:45:86:8e:8d:6f <BROADCAST,MULTICAST> 

ip -c -br link show 
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp0s31f6        UP             f4:8e:38:b7:1e:fd <BROADCAST,MULTICAST,UP,LOWER_UP> 
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP> 
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP> 
br0              DOWN           ba:ea:cb:63:00:4a <BROADCAST,MULTICAST> 
# Replaced
# vth_1@vth1       DOWN           72:45:86:8e:8d:6f <BROADCAST,MULTICAST,M-DOWN> 
# vth1@vth_1       DOWN           a2:66:1a:95:cb:36 <BROADCAST,MULTICAST,M-DOWN> 
# with
vth1@if7         DOWN           a2:66:1a:95:cb:36 <BROADCAST,MULTICAST> 
vth_2@vth2       DOWN           fe:69:e1:e6:1d:fd <BROADCAST,MULTICAST,M-DOWN> 
vth2@vth_2       DOWN           c6:30:62:f3:90:da <BROADCAST,MULTICAST,M-DOWN> 

ip netns exec ns1 ip -br -c link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_1@if8        DOWN           72:45:86:8e:8d:6f <BROADCAST,MULTICAST> 

ip -n ns1 link set dev vth_1 up
ip netns exec ns1 ip -br -c link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_1@if8        LOWERLAYERDOWN 72:45:86:8e:8d:6f <NO-CARRIER,BROADCAST,MULTICAST,UP> 

ip -n ns1 address add 192.168.10.1/24 dev vth_1

ip netns exec ns1 ip -br -c link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
# peer interface is down that is ok
vth_1@if8        LOWERLAYERDOWN 72:45:86:8e:8d:6f <NO-CARRIER,BROADCAST,MULTICAST,UP> 

ip -n ns2 link show
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

ip link set vth_2 netns ns2

ip -n ns2 -c -br link show

ip -n ns2 -c link show

1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
9: vth_2@if10: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether fe:69:e1:e6:1d:fd brd ff:ff:ff:ff:ff:ff link-netnsid 0

ip -n ns2 link set dev vth_2 up

ip -n ns2 -c -br link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_2@if10       LOWERLAYERDOWN fe:69:e1:e6:1d:fd <NO-CARRIER,BROADCAST,MULTICAST,UP>

ip -n ns2 address add 192.168.10.2/24 dev vth_2
ip -n ns2 -c -br address show
lo               DOWN           
vth_2@if10       LOWERLAYERDOWN 192.168.1.51/24 

ip -c -br link show type bridge
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP> 
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP> 
br0              DOWN           ba:ea:cb:63:00:4a <BROADCAST,MULTICAST> 
ip link set dev vth1 master br0
ip link set dev vth2 master br0
ip link set dev vth1 up
ip link set dev vth2 up
ip -c -br link show
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp0s31f6        UP             f4:8e:38:b7:1e:fd <BROADCAST,MULTICAST,UP,LOWER_UP> 
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP> 
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP> 
br0              DOWN           ba:ea:cb:63:00:4a <BROADCAST,MULTICAST> 
vth1@if7         UP             a2:66:1a:95:cb:36 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth2@if9         UP             c6:30:62:f3:90:da <BROADCAST,MULTICAST,UP,LOWER_UP>
ip -c -br -n ns1 link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_1@if8        UP             72:45:86:8e:8d:6f <BROADCAST,MULTICAST,UP,LOWER_UP> 
ip -c -br -n ns2 link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK> 
vth_2@if10       UP             fe:69:e1:e6:1d:fd <BROADCAST,MULTICAST,UP,LOWER_UP>
ip link set br0 up
ip -c -br link show
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp0s31f6        UP             f4:8e:38:b7:1e:fd <BROADCAST,MULTICAST,UP,LOWER_UP> 
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP> 
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP> 
br0              UP             ba:ea:cb:63:00:4a <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth1@if7         UP             a2:66:1a:95:cb:36 <BROADCAST,MULTICAST,UP,LOWER_UP> 
vth2@if9         UP             c6:30:62:f3:90:da <BROADCAST,MULTICAST,UP,LOWER_UP> 

ip netns exec ns1 ping 192.168.10.2
PING 192.168.1.51 (192.168.1.51) 56(84) bytes of data.
64 bytes from 192.168.1.51: icmp_seq=1 ttl=64 time=0.126 ms
64 bytes from 192.168.1.51: icmp_seq=2 ttl=64 time=0.031 ms

ip netns exec ns2 ping 192.168.10.1
PING 192.168.1.50 (192.168.1.50) 56(84) bytes of data.
64 bytes from 192.168.1.50: icmp_seq=1 ttl=64 time=0.093 ms
64 bytes from 192.168.1.50: icmp_seq=2 ttl=64 time=0.077 ms

# time stopped 7:01
```

A "virtual ethernet peer" refers to the paired counterpart of a virtual Ethernet device (often called "veth") within a network, essentially creating a logical connection between two separate network namespaces, allowing them to communicate with each other as if they were directly connected by a physical Ethernet cable; each "veth" pair acts as a tunnel for data transfer between the two namespaces. 


