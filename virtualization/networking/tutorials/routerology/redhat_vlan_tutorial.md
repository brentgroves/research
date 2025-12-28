# **[An introduction to Linux bridging commands and features](https://developers.redhat.com/articles/2022/04/06/introduction-linux-bridging-commands-and-features#)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

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


## references

- **[tcpdump for vlans](https://access.redhat.com/solutions/2630851#:~:text=You%20can%20verify%20the%20incoming,To%20capture%20the%20issue%20live.)**

A Linux bridge is a kernel module that behaves like a network switch, forwarding packets between interfaces that are connected to it. It's usually used for forwarding packets on routers, on gateways, or between VMs and network namespaces on a host.

The Linux bridge has included basic support for the Spanning Tree Protocol (STP), multicast, and Netfilter since the 2.4 and 2.6 kernel series. Features that have been added in more recent releases include:

- Configuration via Netlink
- VLAN filter
- VxLAN tunnel mapping
- Internet Group Management Protocol version 3 (IGMPv3) and Multicast - - Listener Discovery version 2 (MLDv2)
- Switchdev

In this article, you'll get an introduction to these features and some useful commands to enable and control them. You'll also briefly examine Open vSwitch as an alternative to Linux bridging.

## Spanning Tree Protocol

The purpose of STP is to prevent a networking loop, which can lead to a traffic storm in the network. Figure 1 shows such a loop.

![s](https://developers.redhat.com/sites/default/files/styles/article_full_width_1440px_w/public/br_1.png.webp?itok=J-oXObCl)

With STP enabled, the bridges will send each other Bridge Protocol Data Units (BPDUs) so they can elect a root bridge and block an interface, making the network topology loop-free (Figure 2).

![st](https://developers.redhat.com/sites/default/files/styles/article_full_width_1440px_w/public/br_2.png.webp?itok=ZJbkJjVE)

## Skipped much of this tutorial to get to vlan part

## VLAN filter

The VLAN filter was introduced in Linux kernel 3.8. Previously, to separate VLAN traffic on the bridge, the administrator needed to create multiple bridge/VLAN interfaces. As illustrated in Figure 4, three bridges—br0, br2, and br3—would be needed to support three VLANs to make sure that VLAN traffic went to the corresponding VLANs.

![ow](https://developers.redhat.com/sites/default/files/styles/article_full_width_1440px_w/public/br_4.png.webp?itok=gQOf45H2)

Figure 4: Without VLAN filter, three VLANs required three bridges and network configurations.

But with the VLAN filter, just one bridge device is enough to set all the VLAN configurations, as illustrated in Figure 5.

![nv](https://developers.redhat.com/sites/default/files/br_5.png)

Figure 5: With VLAN filter, a single bridge can serve multiple VLANs.

## Create a bridge

```bash
sudo su
# -c is coloring
# -br is brief
# -d details
ip -c -br link show type bridge
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp0s31f6        UP             f4:8e:38:b7:1e:fd <BROADCAST,MULTICAST,UP,LOWER_UP> 
br-2c4c88ba5dfd  DOWN           02:42:ff:bd:27:1c <NO-CARRIER,BROADCAST,MULTICAST,UP> 
docker0          DOWN           02:42:7f:e9:b2:91 <NO-CARRIER,BROADCAST,MULTICAST,UP> 

ip link add name br200 type bridge
ip -c -br link show type bridge
```

The following commands enable the VLAN filter and configure three VLANs:

```bash
ip link set br200 type bridge vlan_filtering 1
ip -c -j -p -d link show br200 | grep vlan

Try not putting network interface into bridge to see if it is necessary to get vlan filtering to work between vms.
# ip link set eth1 master br0
# ip link set eth1 up

ip link set br200 up



# bridge vlan add dev veth1 vid 2

# bridge vlan add dev veth2 vid 2 pvid untagged

# bridge vlan add dev veth3 vid 3 pvid untagged master



# bridge vlan add dev eth1 vid 2-3



# bridge vlan show

port              vlan-id

eth1              1 PVID Egress Untagged

                  2

                  3

br0               1 PVID Egress Untagged

veth1             1 Egress Untagged

                  2

veth2             1 Egress Untagged

                  2 PVID Egress Untagged

veth3             1 Egress Untagged

                  3 PVID Egress Untagged
```

Then the following command enables a VLAN filter on the br0 bridge:

`ip link set br0 type bridge vlan_filtering 1`

This next command makes the veth1 bridge port transmit only VLAN 2 data:

`bridge vlan add dev veth1 vid 2`

The following command, similar to the previous one, makes the veth2 bridge port transmit VLAN 2 data. The pvid parameter causes untagged frames to be assigned to this VLAN at ingress (veth2 to bridge), and the untagged parameter causes the packet to be untagged on egress (bridge to veth2):

`bridge vlan add dev veth2 vid 2 pvid untagged`

The next command carries out the same operation as the previous one, this time on veth3. The master parameter indicates that the link setting is configured on the software bridge. However, because master is a default option, this command has the same effect as the previous one:

`bridge vlan add dev veth3 vid 3 pvid untagged master`

The following command enables VLAN 2 and VLAN 3 traffic on eth1:

`bridge vlan add dev eth1 vid 2-3`

To show the VLAN traffic state, enable VLAN statistics (added in kernel 4.7) as follows:

`ip link set br0 type bridge vlan_stats_enabled 1`

The previous command enables just global VLAN statistics on the bridge, and is not fine grained enough to show each VLAN's state. To enable per-VLAN statistics when there are no port VLANs in the bridge, you also need to enable vlan_stats_per_port (added in kernel 4.20). You can run:


`ip link set br0 type bridge vlan_stats_per_port 1`

Then you can show per-VLAN statistics like so:

```bash
# bridge -s vlan show

port              vlan-id

br0               1 PVID Egress Untagged

                    RX: 248 bytes 3 packets

                    TX: 333 bytes 1 packets

eth1              1 PVID Egress Untagged

                    RX: 333 bytes 1 packets

                    TX: 248 bytes 3 packets

                  2

                    RX: 0 bytes 0 packets

                    TX: 56 bytes 1 packets

                  3

                    RX: 0 bytes 0 packets

                    TX: 224 bytes 7 packets

veth1             1 Egress Untagged

                    RX: 0 bytes 0 packets

                    TX: 581 bytes 4 packets

                  2 PVID Egress Untagged

                    RX: 6356 bytes 77 packets

                    TX: 6412 bytes 78 packets

veth2             1 Egress Untagged

                    RX: 0 bytes 0 packets

                    TX: 581 bytes 4 packets

                  2 PVID Egress Untagged

                    RX: 6412 bytes 78 packets

                    TX: 6356 bytes 77 packets

veth3             1 Egress Untagged

                    RX: 0 bytes 0 packets

                    TX: 581 bytes 4 packets

                  3 PVID Egress Untagged

                    RX: 224 bytes 7 packets

                    TX: 0 bytes 0 packets
```