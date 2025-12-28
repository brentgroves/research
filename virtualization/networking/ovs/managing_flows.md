# **[OpenvSwitch. Managing simple flows](https://albertomolina.wordpress.com/2022/11/29/openvswitch-managing-simple-flows/)**

Following the previous post OpenvSwitch. Basic usage, the manual management of Openflow flows with some simple examples is introduced.

Flows are usually automatically managed by a software component called SDN controller or programmatically by an additional software such as OpenStack Neutron, but the manual management shown in this post allows to better understand the internals of OpenvSwitch, specifically OpenFlow.

The starting point is a OVS bridge (br1) with 4 lxc containers using **[veth interfaces](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#veth)** (a veth interface is a pair of connected network interfaces, so the MAC of the interface connected to the bridge is different to the one used by the container).

List of containers IP and interfaces on the host:

```bash
lxc-ls --fancy
NAME  STATE   AUTOSTART GROUPS IPV4          IPV6 UNPRIVILEGED
test1 RUNNING 0         -      192.168.100.2 -    false
test2 RUNNING 0         -      192.168.100.3 -    false
test3 RUNNING 0         -      192.168.100.4 -    false
test4 RUNNING 0         -      192.168.100.5 -    false


ip -o l
 
4: br1: mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000\ link/ether 4e:76:98:43:ff:44 brd ff:ff:ff:ff:ff:ff
10: veth5iN8R7@if2: mtu 1500 qdisc noqueue master ovs-system state UP mode DEFAULT group default qlen 1000\ link/ether fe:bb:51:63:29:b7 brd ff:ff:ff:ff:ff:ff link-netnsid 0
11: vethJbYk7I@if2: mtu 1500 qdisc noqueue master ovs-system state UP mode DEFAULT group default qlen 1000\ link/ether fe:64:4e:57:4d:09 brd ff:ff:ff:ff:ff:ff link-netnsid 1
12: veth1op1Yp@if2: mtu 1500 qdisc noqueue master ovs-system state UP mode DEFAULT group default qlen 1000\ link/ether fe:38:de:4b:56:64 brd ff:ff:ff:ff:ff:ff link-netnsid 2
13: vethQKhnrW@if2: mtu 1500 qdisc noqueue master ovs-system state 
```

A SNAT iptables rule is added to allow communication from the containers to the external networks:

`iptables -t nat -A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 -j MASQUERADE`

Ports connected to the OVS br1:

```bash
ovs-vsctl show
572ef28b-6429-4a71-aad8-f634d8274930
    Bridge br1
        Port vethJbYk7I
            Interface vethJbYk7I
        Port vethQKhnrW
            Interface vethQKhnrW
        Port br1
            Interface br1
                type: internal
        Port veth1op1Yp
            Interface veth1op1Yp
        Port veth5iN8R7
            Interface veth5iN8R7
    ovs_version: "2.15.0"
```

Similar output obtained using ovs-ofctl:

```bash
ovs-ofctl show br1
OFPT_FEATURES_REPLY (xid=0x2): dpid:00004e769843ff44
n_tables:254, n_buffers:0
capabilities: FLOW_STATS TABLE_STATS PORT_STATS QUEUE_STATS ARP_MATCH_IP
actions: output enqueue set_vlan_vid set_vlan_pcp strip_vlan mod_dl_src mod_dl_dst mod_nw_src mod_nw_dst mod_nw_tos mod_tp_src mod_tp_dst
 1(veth5iN8R7): addr:fe:bb:51:63:29:b7
     config:     0
     state:      0
     current:    10GB-FD COPPER
     speed: 10000 Mbps now, 0 Mbps max
 2(vethJbYk7I): addr:fe:64:4e:57:4d:09
     config:     0
     state:      0
     current:    10GB-FD COPPER
     speed: 10000 Mbps now, 0 Mbps max
 3(veth1op1Yp): addr:fe:38:de:4b:56:64
     config:     0
     state:      0
     current:    10GB-FD COPPER
     speed: 10000 Mbps now, 0 Mbps max
 4(vethQKhnrW): addr:fe:86:0c:9e:5f:4e
     config:     0
     state:      0
     current:    10GB-FD COPPER
     speed: 10000 Mbps now, 0 Mbps max
 LOCAL(br1): addr:4e:76:98:43:ff:44
     config:     0
     state:      0
     speed: 0 Mbps now, 0 Mbps max
OFPT_GET_CONFIG_REPLY (xid=0x4): frags=normal miss_send_len=0
```

## Initial flow

OVS uses a standard flow that allows it to behave as a simple L2 bridge:

```bash
ovs-ofctl dump-flows br1
 cookie=0x0, duration=1377.508s, table=0, n_packets=15, n_bytes=1756, priority=
```

This predefined flow is fine to start using OVS and allow everything to be connected to an standard L2 switch, but it doesn’t provide any additional features, so using OVS that way is like using traditional linux bridge.

## ARP

Deleting the predefined flow (deleting all flows or rules), disables all the traffic between the devices connected to br1:

```bash
ovs-ofctl del-flows br1
ovs-ofctl dump-flows br1
(empty output)
```

After deleting the predefined flow, it’s possible to check that any communication between the containers is disabled, for example using ping from test2 (192.168.100.3) to test1 (192.168.100.2):

```bash
ping -c2 192.168.100.2
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.

--- 192.168.100.2 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1013ms

ip n
192.168.100.2 dev eth0  FAILED
```

The first rule to add is the one allowing arp traffic (0x806 is used in Ethernet to identify a ARP frames) and the action «flood» is set to send the package to all the ports except the incoming one, this is the proper behaviour for a broadcast message such as ARP:

```bash
ovs-ofctl add-flow br1 dl_type=0x806,actions=flood # Also valid: ovs-ofctl add-flow br1 arp,actions=flood
```

Ping is still not working, but ARP worked (the MAC address was obtained):

Display neighbour/arp cache. The syntax is: $ ip n show $ ip neigh show. Sample outputs (note: I masked out some data with alphabets): 74.xx ...

```bash
ip n
192.168.100.2 dev eth0 lladdr 00:16:3e:b1:20:18 REACHABLE
```

Checking the flow again, we can see the counter n_packet is 2 (two packets matched the flow and they were sent over all the ports, the arp request and the response):

```bash
ovs-ofctl dump-flows br1
 cookie=0x0, duration=405.715s, table=0, n_packets=2, n_bytes=84, arp actions=FLOOD
```

A detailed description of actions available is in the **[ovs-actions](https://www.man7.org/linux/man-pages/man7/ovs-actions.7.html)** man page (7).

## L2 traffic

The next step is to add flows allowing traffic to specific ports when the destination MAC address is the correct one for the containers test1 and test2, but not for test3 and test4. The packet with destination MAC is forwarded to the corresponding port:

```bash
ovs-ofctl add-flow br1 dl_dst=00:16:3e:b1:20:18,actions=output:1
ovs-ofctl add-flow br1 dl_dst=00:16:3e:df:65:65,actions=output:2
```

The traffic between test1 and test2 is allowed, but not with the others containers:

```bash

ping -c2 192.168.100.2
PING 192.168.100.2 (192.168.100.2) 56(84) bytes of data.
64 bytes from 192.168.100.2: icmp_seq=1 ttl=64 time=0.238 ms
64 bytes from 192.168.100.2: icmp_seq=2 ttl=64 time=0.070 ms
 
--- 192.168.100.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1031ms
rtt min/avg/max/mdev = 0.070/0.154/0.238/0.084 ms
 
ip n
192.168.100.2 dev eth0 lladdr 00:16:3e:b1:20:18 STALE
192.168.100.4 dev eth0 lladdr 00:16:3e:da:39:33 STALE
192.168.100.5 dev eth0 lladdr 00:16:3e:07:c2:a5 STALE
 
ovs-ofctl dump-flows br1
 cookie=0x0, duration=1229.273s, table=0, n_packets=10, n_bytes=420, arp actions=FLOOD
 cookie=0x0, duration=422.177s, table=0, n_packets=2, n_bytes=196, dl_dst=00:16:3e:b1:20:18 actions=output:veth5iN8R7
 cookie=0x0, duration=406.238s, table=0, n_packets=2, n_bytes=196, dl_dst=00:16:3e:df:65:65 actions=output:vethJbYk7I
```

## Priority and tables

It’s possible (and recommendable) to define priorities for the rules and to store them in different tables than can be applied in the appropriate order. A good practice for the above configuration is to allow all the L2 traffic and add additional restrictions in table 1:

```bash
ovs-ofctl add-flow br1 priority=100,dl_type=0x806,actions=flood
ovs-ofctl add-flow br1 priority=100,dl_dst=00:16:3e:b1:20:18,actions=goto_table:1
ovs-ofctl add-flow br1 priority=100,dl_dst=00:16:3e:df:65:65,actions=goto_table:1
ovs-ofctl add-flow br1 priority=100,dl_dst=00:16:3e:da:39:33,actions=goto_table:1
ovs-ofctl add-flow br1 priority=100,dl_dst=00:16:3e:07:c2:a5,actions=goto_table:1
ovs-ofctl add-flow br1 priority=50,actions=drop
```

The allowed traffic uses a a higher priority (100), but a generic drop rule is added disabling all the undefined or lower priority traffic. The rule with higher priority is applied, the order doesn’t matter (!).

It’s possible to define rules depending on L2, L3 or L4 parameters, so a deep control of the allowed traffic can be achieved and must be carefully managed.

## Full example

In this example, OpenFlow rules for the OpenvSwitch are defined step by step to meet the following constraints:

- All the internal traffic between the containers is allowed, but limited to the IP assigned
- Traffic to the external network through the br1 interface is limited to ping, dns, http and https

## Table 0. MAC restrictions

Similar to the previous example, but adding an additional rule for the external traffic (br1 MAC address is selected for destination MAC and redirected to table 10, so all the outgoing traffic is handled in table 10 and following):

```bash
ovs-ofctl add-flow br1 table=0,priority=100,dl_type=0x806,actions=flood
ovs-ofctl add-flow br1 table=0,priority=100,dl_dst=00:16:3e:b1:20:18,actions=goto_table:1
ovs-ofctl add-flow br1 table=0,priority=100,dl_dst=00:16:3e:df:65:65,actions=goto_table:1
ovs-ofctl add-flow br1 table=0,priority=100,dl_dst=00:16:3e:da:39:33,actions=goto_table:1
ovs-ofctl add-flow br1 table=0,priority=100,dl_dst=00:16:3e:07:c2:a5,actions=goto_table:1
ovs-ofctl add-flow br1 table=0,priority=100,dl_dst=4e:76:98:43:ff:44,actions=goto_table:10
ovs-ofctl add-flow br1 table=0,priority=50,actions=drop
```

## Table 1. Disable IP spoofing

At layer 3, the constraint used is forward the traffic for the selected IP to the corresponding port:

```bash
ovs-ofctl add-flow br1 table=1,priority=100,ip,nw_dst=192.168.100.2/32,actions=output:1
ovs-ofctl add-flow br1 table=1,priority=100,ip,nw_dst=192.168.100.3/32,actions=output:2
ovs-ofctl add-flow br1 table=1,priority=100,ip,nw_dst=192.168.100.4/32,actions=output:3
ovs-ofctl add-flow br1 table=1,priority=100,ip,nw_dst=192.168.100.5/32,actions=output:4
ovs-ofctl add-flow br1 table=1,priority=50,actions=drop
```

When these rules are applied all the traffic is allowed internally, but the outgoing traffic from the containers through the gateway is disabled, because the traffic through the port br1 is not set.

## Table 10. Security groups

Table 10 manages all the traffic sent to the gateway (port br1 and IP 192.168.100.1), but not only with the destination IP 192.168.100.1, because the packages with any other destination IP are also sent through the br1 port. L4 constraints can be applied, allowing outgoing traffic only for specific UDP/TCP ports or ICMP types (echo request and reply):

```bash
ovs-ofctl add-flow br1 table=10,priority=100,ip,nw_dst=192.168.100.1,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=100,udp,tp_dst=53,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=100,udp,tp_src=53,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=100,tcp,tp_dst=80,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=100,tcp,tp_src=80,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=100,tcp,tp_dst=443,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=100,tcp,tp_src=443,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=100,icmp,icmp_type=8,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=100,icmp,icmp_type=0,actions=goto_table:11
ovs-ofctl add-flow br1 table=10,priority=50,actions=drop
```

Due to the analogy with the term used in cloud computing, these rules can be called «security groups».

## Table 11. Send to port br1

Finally, all the allowed traffic arriving to table 11 is forwarded to the port br1 (LOCAL):

`ovs-ofctl add-flow br1 table=11,actions=output:LOCAL`

The outgoing traffic is allowed again from the containers (with the following command from a container it’s possible to check that DNS and http traffic is enabled):

```bash
root@test1:~# apt update
Hit:1 http://deb.debian.org/debian stable InRelease
Hit:2 http://security.debian.org/debian-security stable-security InRelease
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
34 packages can be upgraded. Run 'apt list --upgradable' to see them.
```

Conclusion
With the rules shown defining different flows for the traffic between the containers connected to the OpenvSwitch we can see that it is possible to transform a basic software bridge into a «complex» one with many functionalities. There are other features that have not been shown, but we have not tried to show a complete document including all the functionalities, but some significant examples of how to work with OpenFlow rules in OpenvSwitch.
