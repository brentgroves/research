# **[Linux Bridging Part 2](https://www.youtube.com/watch?v=6aJG0ztP0GQ&list=PLmZU6NElARbZtvrVbfz9rVpWRt5HyCeO7&index=2)**


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
ip -c -br link show br0
br0              UP             ba:ea:cb:63:00:4a <BROADCAST,MULTICAST,UP,LOWER_UP> 

ip -c -j -p -d link show br0 | grep vlan
6: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether ba:ea:cb:63:00:4a brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535 
    bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filtering 0 vlan_protocol 802.1Q bridge_id 8000.ba:ea:cb:63:0:4a designated_root 8000.ba:ea:cb:63:0:4a root_port 0 root_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_change_timer    0.00 gc_timer    1.40 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast_hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000 mcast_startup_query_interval 3124 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_version 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 

# bridge sub commands
bridge
Usage: bridge [ OPTIONS ] OBJECT { COMMAND | help }
       bridge [ -force ] -batch filename
where  OBJECT := { link | fdb | mdb | vlan | monitor }
       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] |
                    -o[neline] | -t[imestamp] | -n[etns] name |
                    -c[ompressvlans] -color -p[retty] -j[son] }
# manage the ports of bridge 
bridge link help
Usage: bridge link set dev DEV [ cost COST ] [ priority PRIO ] [ state STATE ]
                               [ guard {on | off} ]
                               [ hairpin {on | off} ]
                               [ fastleave {on | off} ]
                               [ root_block {on | off} ]
                               [ learning {on | off} ]
                               [ learning_sync {on | off} ]
                               [ flood {on | off} ]
                               [ mcast_flood {on | off} ]
                               [ mcast_to_unicast {on | off} ]
                               [ neigh_suppress {on | off} ]
                               [ vlan_tunnel {on | off} ]
                               [ isolated {on | off} ]
                               [ hwmode {vepa | veb} ]
                               [ backup_port DEVICE ] [ nobackup_port ]
                               [ self ] [ master ]
       bridge link show [dev DEV]

bridge link
8: vth1@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2 
10: vth2@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2

bridge link show br0
8: vth1@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2 
10: vth2@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2

# important FDB forwarding data base

bridge fdb help
Usage: bridge fdb { add | append | del | replace } ADDR dev DEV
              [ self ] [ master ] [ use ] [ router ] [ extern_learn ]
              [ sticky ] [ local | static | dynamic ] [ vlan VID ]
              { [ dst IPADDR ] [ port PORT] [ vni VNI ] | [ nhid NHID ] }
               [ via DEV ] [ src_vni VNI ]
       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ]
              [ state STATE ] [ dynamic ] ]
       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV
              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]
bridge fdb show
01:00:5e:00:00:01 dev enp0s31f6 self permanent
33:33:00:00:00:01 dev enp0s31f6 self permanent
01:00:5e:00:00:fb dev enp0s31f6 self permanent
33:33:ff:46:a7:09 dev enp0s31f6 self permanent
33:33:ff:00:07:87 dev enp0s31f6 self permanent
33:33:00:00:00:fb dev enp0s31f6 self permanent
33:33:00:00:00:01 dev br-2c4c88ba5dfd self permanent
01:00:5e:00:00:6a dev br-2c4c88ba5dfd self permanent
33:33:00:00:00:6a dev br-2c4c88ba5dfd self permanent
01:00:5e:00:00:01 dev br-2c4c88ba5dfd self permanent
01:00:5e:00:00:fb dev br-2c4c88ba5dfd self permanent
02:42:ff:bd:27:1c dev br-2c4c88ba5dfd vlan 1 master br-2c4c88ba5dfd permanent
02:42:ff:bd:27:1c dev br-2c4c88ba5dfd master br-2c4c88ba5dfd permanent
33:33:00:00:00:01 dev docker0 self permanent
01:00:5e:00:00:6a dev docker0 self permanent
33:33:00:00:00:6a dev docker0 self permanent
01:00:5e:00:00:01 dev docker0 self permanent
01:00:5e:00:00:fb dev docker0 self permanent
02:42:7f:e9:b2:91 dev docker0 vlan 1 master docker0 permanent
02:42:7f:e9:b2:91 dev docker0 master docker0 permanent
33:33:00:00:00:01 dev br0 self permanent
01:00:5e:00:00:6a dev br0 self permanent
33:33:00:00:00:6a dev br0 self permanent
01:00:5e:00:00:01 dev br0 self permanent
33:33:ff:63:00:4a dev br0 self permanent
33:33:00:00:00:fb dev br0 self permanent
ba:ea:cb:63:00:4a dev br0 vlan 1 master br0 permanent
ba:ea:cb:63:00:4a dev br0 master br0 permanent
a2:66:1a:95:cb:36 dev vth1 vlan 1 master br0 permanent
a2:66:1a:95:cb:36 dev vth1 master br0 permanent
33:33:00:00:00:01 dev vth1 self permanent
01:00:5e:00:00:01 dev vth1 self permanent
33:33:ff:95:cb:36 dev vth1 self permanent
33:33:00:00:00:fb dev vth1 self permanent
c6:30:62:f3:90:da dev vth2 vlan 1 master br0 permanent
c6:30:62:f3:90:da dev vth2 master br0 permanent
33:33:00:00:00:01 dev vth2 self permanent
01:00:5e:00:00:01 dev vth2 self permanent
33:33:ff:f3:90:da dev vth2 self permanent
33:33:00:00:00:fb dev vth2 self permanent

# dynamic learned addresses
bridge fdb show dynamic
shows nothing but should show br0

tmux
split screen into 3
# ns1
sudo su
ip netns exec ns1 bash
ip -c -br link show
ping -c 1 192.168.1.51
PING 192.168.1.51 (192.168.1.51) 56(84) bytes of data.
64 bytes from 192.168.1.51: icmp_seq=1 ttl=64 time=0.082 ms

# ns2
sudo su
ip netns exec ns2 bash
ip -c -br link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK>
vth_2@if10       UP             fe:69:e1:e6:1d:fd <BROADCAST,MULTICAST,UP,LOWER_UP>

# default ns
ip -c -br link show
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP>
enp0s31f6        UP             f4:8e:38:b7:1e:fd <BROADCAST,MULTICAST,UP,LOWER_UP>
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP>
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP>
br0              UP             ba:ea:cb:63:00:4a <BROADCAST,MULTICAST,UP,LOWER_UP>
vth1@if7         UP             a2:66:1a:95:cb:36 <BROADCAST,MULTICAST,UP,LOWER_UP>
vth2@if9         UP             c6:30:62:f3:90:da <BROADCAST,MULTICAST,UP,LOWER_UP>

bridge fdb show dynamic
# nothing now but? after we ping from 1 namespace to the other we should see something here.
# ping from ns1
ping 192.168.1.51
Object "fdb" is unknown, try "ip help".
root@moto:/home/brent# bridge fdb show dynamic
root@moto:/home/brent# bridge fdb show dynamic
# can see the mac address that were assigned automatically when we created the veth device
72:45:86:8e:8d:6f dev vth1 master br0
fe:69:e1:e6:1d:fd dev vth2 master br0

# from ns1
# mac address shown above are correct
ip -c -br link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK>
vth_1@if8        UP             72:45:86:8e:8d:6f <BROADCAST,MULTICAST,UP,LOWER_UP>

# from ns2
# mac address shown above are correct
 ip -c -br link show
lo               DOWN           00:00:00:00:00:00 <LOOPBACK>
vth_2@if10       UP             fe:69:e1:e6:1d:fd <BROADCAST,MULTICAST,UP,LOWER_UP>

# from default
bridge fdb help
Usage: bridge fdb { add | append | del | replace } ADDR dev DEV
              [ self ] [ master ] [ use ] [ router ] [ extern_learn ]
              [ sticky ] [ local | static | dynamic ] [ vlan VID ]
              { [ dst IPADDR ] [ port PORT] [ vni VNI ] | [ nhid NHID ] }
               [ via DEV ] [ src_vni VNI ]
       bridge fdb [ show [ br BRDEV ] [ brport DEV ] [ vlan VID ]
              [ state STATE ] [ dynamic ] ]
       bridge fdb get [ to ] LLADDR [ br BRDEV ] { brport | dev } DEV
              [ vlan VID ] [ vni VNI ] [ self ] [ master ] [ dynamic ]
bridge fdb del 72:45:86:8e:8d:6f dev vth1
RTNETLINK answers: No such file or directory
# add keyword master or self
# affect forwarding database on the master device
bridge fdb del 72:45:86:8e:8d:6f dev vth1 master
bridge fdb del 72:45:86:8e:8d:6f dev vth1 master

ip link set dev br0 type bridge help
# bridge attributes added to help screen