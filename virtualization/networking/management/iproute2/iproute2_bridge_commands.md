# **[IP route2 bridge commands](https://developers.redhat.com/articles/2022/04/06/introduction-linux-bridging-commands-and-features)**

## An introduction to Linux bridging commands and features

A Linux bridge is a kernel module that behaves like a network switch, forwarding packets between interfaces that are connected to it. It's usually used for forwarding packets on routers, on gateways, or between VMs and network namespaces on a host.

The Linux bridge has included basic support for the Spanning Tree Protocol (STP), multicast, and Netfilter since the 2.4 and 2.6 kernel series. Features that have been added in more recent releases include:

- Configuration via **[Netlink](https://man7.org/linux/man-pages/man7/netlink.7.html)**
- VLAN filter
- VxLAN tunnel mapping
- Internet Group Management Protocol version 3 (IGMPv3) and Multicast Listener Discovery version 2 (MLDv2)
- Switchdev

In this article, you'll get an introduction to these features and some useful commands to enable and control them. You'll also briefly examine **[Open vSwitch](https://www.openvswitch.org/)** as an alternative to Linux bridging.

## Basic bridge commands

All the commands used in this article are part of the iproute2 module, which invokes Netlink messages to configure the bridge. There are two iproute2 commands for setting and configuring bridges: ip link and bridge.

ip link can add and remove bridges and set their options. bridge displays and manipulates bridges on final distribution boards (FDBs), main distribution boards (MDBs), and virtual local area networks (VLANs).

**Final Distribution Boards:** A distribution board is a component of an electricity supply system which divides an electrical power feed into subsidiary circuits, ...

**MDB – Main Distribution Boards:** MDB is a panel or enclosure that houses the fuses, circuit breakers and ground leakage protection units where the electrical energy is used to distribute ...

The listings that follow demonstrate some basic uses for the two commands. Both require administrator privileges, and therefore the listings are shown with the # root prompt instead of a regular user prompt.

The listings that follow demonstrate some basic uses for the two commands. Both require administrator privileges, and therefore the listings are shown with the # root prompt instead of a regular user prompt.

Show help information about the bridge object:

```bash
ip link help bridge
Usage: ... bridge [ fdb_flush ]
    [ forward_delay FORWARD_DELAY ]
    [ hello_time HELLO_TIME ]
    [ max_age MAX_AGE ]
    [ ageing_time AGEING_TIME ]
    [ stp_state STP_STATE ]
    [ priority PRIORITY ]
    [ group_fwd_mask MASK ]
    [ group_address ADDRESS ]
    [ vlan_filtering VLAN_FILTERING ]
    [ vlan_protocol VLAN_PROTOCOL ]
    [ vlan_default_pvid VLAN_DEFAULT_PVID ]
    [ vlan_stats_enabled VLAN_STATS_ENABLED ]
    [ vlan_stats_per_port VLAN_STATS_PER_PORT ]
    [ mcast_snooping MULTICAST_SNOOPING ]
    [ mcast_router MULTICAST_ROUTER ]
    [ mcast_query_use_ifaddr MCAST_QUERY_USE_IFADDR ]
    [ mcast_querier MULTICAST_QUERIER ]
    [ mcast_hash_elasticity HASH_ELASTICITY ]
    [ mcast_hash_max HASH_MAX ]
    [ mcast_last_member_count LAST_MEMBER_COUNT ]
    [ mcast_startup_query_count STARTUP_QUERY_COUNT ]
    [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]
    [ mcast_membership_interval MEMBERSHIP_INTERVAL ]
    [ mcast_querier_interval QUERIER_INTERVAL ]
    [ mcast_query_interval QUERY_INTERVAL ]
    [ mcast_query_response_interval QUERY_RESPONSE_INTERVAL ]
    [ mcast_startup_query_interval STARTUP_QUERY_INTERVAL ]
    [ mcast_stats_enabled MCAST_STATS_ENABLED ]
    [ mcast_igmp_version IGMP_VERSION ]
    [ mcast_mld_version MLD_VERSION ]
    [ nf_call_iptables NF_CALL_IPTABLES ]
    [ nf_call_ip6tables NF_CALL_IP6TABLES ]
    [ nf_call_arptables NF_CALL_ARPTABLES ]

Where: VLAN_PROTOCOL := { 802.1Q | 802.1ad }

bridge -h
Usage: bridge [ OPTIONS ] OBJECT { COMMAND | help }
       bridge [ -force ] -batch filename
where  OBJECT := { link | fdb | mdb | vlan | monitor }
       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] |
                    -o[neline] | -t[imestamp] | -n[etns] name |
                    -c[ompressvlans] -color -p[retty] -j[son] }

```

## Create a bridge named br0

```bash
# ip link add br0 type bridge
sudo ip link add name mybr-eno3 type bridge

```

## Show bridge details

```bash
ip -d link show mybr-eno3
22: mybr-eno3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b2:3d:eb:b5:7a:92 brd ff:ff:ff:ff:ff:ff promiscuity 0 minmtu 68 maxmtu 65535 
    bridge forward_delay 1500 hello_time 200 max_age 2000 ageing_time 30000 stp_state 0 priority 32768 vlan_filtering 0 vlan_protocol 802.1Q bridge_id 8000.b2:3d:eb:b5:7a:92 designated_root 8000.b2:3d:eb:b5:7a:92 root_port 0 root_path_cost 0 topology_change 0 topology_change_detected 0 hello_timer    0.00 tcn_timer    0.00 topology_change_timer    0.00 gc_timer    0.00 vlan_default_pvid 1 vlan_stats_enabled 0 vlan_stats_per_port 0 group_fwd_mask 0 group_address 01:80:c2:00:00:00 mcast_snooping 1 mcast_router 1 mcast_query_use_ifaddr 0 mcast_querier 0 mcast_hash_elasticity 16 mcast_hash_max 4096 mcast_last_member_count 2 mcast_startup_query_count 2 mcast_last_member_interval 100 mcast_membership_interval 26000 mcast_querier_interval 25500 mcast_query_interval 12500 mcast_query_response_interval 1000 mcast_startup_query_interval 3124 mcast_stats_enabled 0 mcast_igmp_version 2 mcast_mld_version 1 nf_call_iptables 0 nf_call_ip6tables 0 nf_call_arptables 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535 
```

Show bridge details in a pretty JSON format (which is a good way to get bridge key-value pairs):

```bash
# ip -j -p -d link show br0
ip -j -p -d link show mybr-eno3
[ {
        "ifindex": 22,
        "ifname": "mybr-eno3",
        # "flags": [ "BROADCAST","MULTICAST","UP","LOWER_UP" ],
        "flags": [ "BROADCAST","MULTICAST" ],
        "mtu": 1500,
        "qdisc": "noop",
        # "operstate": "UP",
        "operstate": "DOWN",
        "linkmode": "DEFAULT",
        "group": "default",
        "txqlen": 1000,
        "link_type": "ether",
        "address": "b2:3d:eb:b5:7a:92",
        "broadcast": "ff:ff:ff:ff:ff:ff",
        "promiscuity": 0,
        "min_mtu": 68,
        "max_mtu": 65535,
        "linkinfo": {
            "info_kind": "bridge",
            "info_data": {
                "forward_delay": 1500,
                "hello_time": 200,
                "max_age": 2000,
                "ageing_time": 30000,
                # "stp_state": 1,
                "stp_state": 0,
                "priority": 32768,
                "vlan_filtering": 0,
                "vlan_protocol": "802.1Q",
                "bridge_id": "8000.b2:3d:eb:b5:7a:92",
                "root_id": "8000.b2:3d:eb:b5:7a:92",
                # "root_port": 1,
                # "root_path_cost": 127,
                "root_port": 0,
                "root_path_cost": 0,
                "topology_change": 0,
                "topology_change_detected": 0,
                "hello_timer": 0.00,
                "tcn_timer": 0.00,
                "topology_change_timer": 0.00,
                # "gc_timer": 31.25,
                "gc_timer": 0.00,
                "vlan_default_pvid": 1,
                "vlan_stats_enabled": 0,
                "vlan_stats_per_port": 0,
                "group_fwd_mask": "0",
                "group_addr": "01:80:c2:00:00:00",
                "mcast_snooping": 1,
                "mcast_router": 1,
                "mcast_query_use_ifaddr": 0,
                "mcast_querier": 0,
                "mcast_hash_elasticity": 16,
                "mcast_hash_max": 4096,
                "mcast_last_member_cnt": 2,
                "mcast_startup_query_cnt": 2,
                "mcast_last_member_intvl": 100,
                "mcast_membership_intvl": 26000,
                "mcast_querier_intvl": 25500,
                "mcast_query_intvl": 12500,
                "mcast_query_response_intvl": 1000,
                "mcast_startup_query_intvl": 3124,
                "mcast_stats_enabled": 0,
                "mcast_igmp_version": 2,
                "mcast_mld_version": 1,
                "nf_call_iptables": 0,
                "nf_call_ip6tables": 0,
                "nf_call_arptables": 0
            }
        },
        # "inet6_addr_gen_mode": "none",
        "inet6_addr_gen_mode": "eui64",
        "num_tx_queues": 1,
        "num_rx_queues": 1,
        "gso_max_size": 65536,
        "gso_max_segs": 65535
    } ]

```

Add interfaces to a bridge:

```bash
# ip link set veth0 master br0

# ip link set tap0 master br0
```

## Spanning Tree Protocol

The purpose of STP is to prevent a networking loop, which can lead to a traffic storm in the network. Figure 1 shows such a loop.

![](https://developers.redhat.com/sites/default/files/styles/article_full_width_1440px_w/public/br_1.png?itok=J-oXObCl)

With STP enabled, the bridges will send each other Bridge Protocol Data Units (BPDUs) so they can elect a root bridge and block an interface, making the network topology loop-free (Figure 2).

![](https://developers.redhat.com/sites/default/files/styles/article_full_width_1440px_w/public/br_2.png?itok=ZJbkJjVE)

Linux bridging has supported STP since the 2.4 and 2.6 kernel series. To enable STP on a bridge, enter:

```bash
# ip link set br0 type bridge stp_state 1
```

Note: The Linux bridge does not support the Rapid Spanning Tree Protocol (RSTP).

Now you can show the STP blocking state on the bridge:

```bash
# ip -j -p -d link show br0 | grep root_port

                "root_port": 1,

# ip -j -p -d link show br1 | grep root_port

                "root_port": 0,

# bridge link show

7: veth0@veth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2

8: veth1@veth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br1 state forwarding priority 32 cost 2

9: veth2@veth3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state blocking priority 32 cost 2

10: veth3@veth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br1 state forwarding priority 32 cost 2
```
