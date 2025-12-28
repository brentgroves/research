# **[How to create a nat bridge using iproute2](https://wiki.archlinux.org/title/Network_bridge)**

**[Back to Research List](../../../../../research/research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![cn](https://linuxconfig.org/wp-content/uploads/2021/03/00-how_to_use_bridged_networking_with_libvirt_and_kvm.avif)

To create a NAT bridge using iproute2 on Linux, you first need to create a regular bridge interface, then configure NAT rules on that bridge using the ip nat command to translate packets between the bridged network and the external network; essentially, you're bridging traffic and applying NAT on the bridge itself.

Create a bridge interface.

```bash
ip link add name br0 type bridge  # Create a bridge named br0 [1, 2, 6]

ip link set dev br0 up  # Bring the bridge up [1, 2, 6]
```

Add interfaces to the bridge.

```bash
ip link set dev eth0 master br0  # Add interface eth0 to bridge br0 [1, 2, 6]

ip link set dev eth1 master br0  # Add interface eth1 to bridge br0 [1, 2, 6]
```

Configure NAT rules on the bridge.

```bash
    # Example: Translate traffic from internal network (10.0.0.0/8) to external IP (192.168.1.1)

ip nat add rule pre-routing  interface br0  from 10.0.0.0/8 to 0.0.0.0/0  nat to 192.168.1.1
```

Explanation:

```bash
ip link add name br0 type bridge:
# This command creates a new network interface named "br0" with the type "bridge". 
ip link set dev br0 up:
# This brings the bridge interface "br0" up and makes it active. 
ip link set dev ethX master br0:
# This command adds the specified network interface (e.g., "eth0", "eth1") to the bridge "br0" as a "slave" interface. 
ip nat add rule ...:
# pre-routing: This specifies that the NAT rule should be applied before the routing process. 
# interface br0: The NAT rule will be applied to packets coming from the "br0" bridge interface. 
from 10.0.0.0/8 to 0.0.0.0/0: This indicates that packets originating from the internal network (10.0.0.0/8) will be translated. 
nat to 192.168.1.1: This sets the source IP address of the translated packets to the external IP "192.168.1.1". 
```

## virbr0

```bash
ip route 
default via 10.188.40.254 dev enx803f5d090eb3 proto static metric 100 
default via 172.25.189.254 dev wlp114s0f0 proto dhcp src 172.25.188.26 metric 600 
10.0.3.0/24 dev lxcbr0 proto kernel scope link src 10.0.3.1 linkdown 
10.31.209.0/24 dev lxdbr0 proto kernel scope link src 10.31.209.1 
10.188.40.0/24 dev enx803f5d090eb3 proto kernel scope link src 10.188.40.230 metric 100 
172.25.188.0/23 dev wlp114s0f0 proto kernel scope link src 172.25.188.26 metric 600 
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 

ip rule show 
0:      from all lookup local
32766:  from all lookup main
32767:  from all lookup default

 ip route list table all
default via 10.188.40.254 dev enx803f5d090eb3 proto static metric 100 
default via 172.25.189.254 dev wlp114s0f0 proto dhcp src 172.25.188.26 metric 600 
10.0.3.0/24 dev lxcbr0 proto kernel scope link src 10.0.3.1 linkdown 
10.31.209.0/24 dev lxdbr0 proto kernel scope link src 10.31.209.1 
10.188.40.0/24 dev enx803f5d090eb3 proto kernel scope link src 10.188.40.230 metric 100 
172.25.188.0/23 dev wlp114s0f0 proto kernel scope link src 172.25.188.26 metric 600 
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 
local 10.0.3.1 dev lxcbr0 table local proto kernel scope host src 10.0.3.1 
broadcast 10.0.3.255 dev lxcbr0 table local proto kernel scope link src 10.0.3.1 linkdown 
local 10.31.209.1 dev lxdbr0 table local proto kernel scope host src 10.31.209.1 
broadcast 10.31.209.255 dev lxdbr0 table local proto kernel scope link src 10.31.209.1 
local 10.188.40.230 dev enx803f5d090eb3 table local proto kernel scope host src 10.188.40.230 
broadcast 10.188.40.255 dev enx803f5d090eb3 table local proto kernel scope link src 10.188.40.230 
local 127.0.0.0/8 dev lo table local proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo table local proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo table local proto kernel scope link src 127.0.0.1 
local 172.25.188.26 dev wlp114s0f0 table local proto kernel scope host src 172.25.188.26 
broadcast 172.25.189.255 dev wlp114s0f0 table local proto kernel scope link src 172.25.188.26 
local 192.168.122.1 dev virbr0 table local proto kernel scope host src 192.168.122.1 
broadcast 192.168.122.255 dev virbr0 table local proto kernel scope link src 192.168.122.1 
fd42:7277:90ec:a57f::/64 dev lxdbr0 proto kernel metric 256 pref medium
fe80::/64 dev lxdbr0 proto kernel metric 256 pref medium
fe80::/64 dev vth1 proto kernel metric 256 pref medium
fe80::/64 dev vth2 proto kernel metric 256 pref medium
fe80::/64 dev br0 proto kernel metric 256 pref medium
fe80::/64 dev vth3 proto kernel metric 256 pref medium
fe80::/64 dev vth4 proto kernel metric 256 pref medium
fe80::/64 dev vnet1 proto kernel metric 256 pref medium
fe80::/64 dev wlp114s0f0 proto kernel metric 1024 pref medium
local ::1 dev lo table local proto kernel metric 0 pref medium
anycast fd42:7277:90ec:a57f:: dev lxdbr0 table local proto kernel metric 0 pref medium
local fd42:7277:90ec:a57f::1 dev lxdbr0 table local proto kernel metric 0 pref medium
anycast fe80:: dev lxdbr0 table local proto kernel metric 0 pref medium
anycast fe80:: dev wlp114s0f0 table local proto kernel metric 0 pref medium
anycast fe80:: dev vth1 table local proto kernel metric 0 pref medium
anycast fe80:: dev vth2 table local proto kernel metric 0 pref medium
anycast fe80:: dev br0 table local proto kernel metric 0 pref medium
anycast fe80:: dev vth3 table local proto kernel metric 0 pref medium
anycast fe80:: dev vth4 table local proto kernel metric 0 pref medium
anycast fe80:: dev vnet1 table local proto kernel metric 0 pref medium
local fe80::da:56ff:fe4b:ef16 dev vth3 table local proto kernel metric 0 pref medium
local fe80::216:3eff:fea6:6dbf dev lxdbr0 table local proto kernel metric 0 pref medium
local fe80::10d2:48ff:fe84:1522 dev vth1 table local proto kernel metric 0 pref medium
local fe80::17a5:ad3b:4171:8dc0 dev wlp114s0f0 table local proto kernel metric 0 pref medium
local fe80::20e6:ccff:fe13:6a8f dev vth2 table local proto kernel metric 0 pref medium
local fe80::4086:f0ff:fe20:a484 dev br0 table local proto kernel metric 0 pref medium
local fe80::bca2:50ff:fe57:b23c dev vth4 table local proto kernel metric 0 pref medium
local fe80::fc54:ff:fe66:d7b9 dev vnet1 table local proto kernel metric 0 pref medium
multicast ff00::/8 dev lxdbr0 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev wlp114s0f0 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev vth1 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev vth2 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev br0 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev enxf8e43bed63bd table local proto kernel metric 256 pref medium
multicast ff00::/8 dev vth3 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev vth4 table local proto kernel metric 256 pref medium
multicast ff00::/8 dev vnet1 table local proto kernel metric 256 pref medium
```
