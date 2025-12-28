# **[](https://albertomolina.wordpress.com/2022/06/10/openvswitch-basic-usage/)**

Note: This tutorial use lxc not lxd. lxc cli is lxc-x the lxd cli is lxc only and it uses a database and not config files to change container configurations.

Open vSwitch (OVS) is an open source OpenFlow implementation mainly used in virtualized environments. OpenvSwitch has a lot of features and it can be confusing when starting out, so the idea is to write several post with information related to the the use of OpenvSwitch, virtual network interfaces and related items, which can be used as a reference in the future

To start working with OVS only a linux box is needed (debian of course! :) ) and OVS is installed just with the openvswitch-switch package:

don't install this yet. in ubuntu it is different.

`apt install openvswitch-switch`

It’s also possible to install the package openvswitch-switch-dpdk for DPDK enabled OVS used in specific situations where high performance network throughput is needed, but it implies the use of network interfaces supported by dpdk.

## Basic OVS CLI

There are different OVS related command line interfaces, the main ones are the following:

```bash
ovs-appctl
ovs-ofctl
ovs-dpctl
ovs-vsctl
```

For example, to create a new OVS bridge, just type (autocomplete is enabled when used by root user):

Don't do this yet!

```bash
ovs-vsctl br-add br1

ovs-vsctl show 
572ef28b-6429-4a71-aad8-f634d8274930
    Bridge br1
        Port br1
            Interface br1
                type: internal
    ovs_version: "2.15.0"
 ```

Following the previous post OpenvSwitch. Basic usage, the manual management of Openflow flows with some simple examples is introduced.

Flows are usually automatically managed by a software component called SDN controller or programmatically by an additional software such as OpenStack Neutron, but the manual management shown in this post allows to better understand the internals of OpenvSwitch, specifically OpenFlow.

```bash
ip a
...
8: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 4e:e6:18:c3:77:20 brd ff:ff:ff:ff:ff:ff
9: br1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 4e:76:98:43:ff:44 brd ff:ff:ff:ff:ff:ff
```

The ovs bridge is down, the following steps are taken to bring it up, assign an IP address and set iptables rule to allow NAT access to the Internet:

```bash
ip l set br1 up

ip a add 192.168.100.1/24 dev br1

iptables -t nat -A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 \
-j MASQUERADE

ip a show dev br1
9: br1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 4e:76:98:43:ff:44 brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.1/24 scope global br1
       valid_lft forever preferred_lft forever
    inet6 fe80::4c76:98ff:fe43:ff44/64 scope link 
       valid_lft forever preferred_lft forever
```

br1 shows an administrative state UP (because we have brought it up), the operational state LOWER_UP means that the link is detected at the «physical layer» (Driver signals L1 up according to **[netdevice man page](https://man7.org/linux/man-pages/man7/netdevice.7.html)**) and the state will remain UNKNOWN becase iproute2 can’t obtain ovs states.

The administrative state of a network link indicates the configured intent for the interface (e.g., whether it's enabled or disabled by an administrator), while the operational state reflects the actual, real-time status of the link, which could be up or down due to physical conditions like a missing cable or a negotiation failure with a connected device. For example, an interface might be administratively "up" but operationally "down" if no network cable is plugged in.

**[linux kernel states](https://docs.kernel.org/6.2/networking/operstates.html#:~:text=1.,from%20userspace%20under%20certain%20rules.)**

## LXC test environment

I use LXD later on but here we are using lxc which has clis with the format of lxc-*

Once OVS is installed on the host machine, several virtual instances can be created to connect to OVS bridges and to interact to each other. In this case we’re going to use LXC (linux containers), but any other virtualization technology can be used.

The **default bridge** used can be changed to br1 on /etc/lxc/default.conf, and the container can be easily created:

`lxc-create -n test1 -t debian`

Once the container is created, the corresponding config file (/var/lib/lxc/test1/config) can be modified (in this case, we’re going to add static IP address for the container and the gateway because there’s no DHCP server connected to the OVS bridge, adding the following lines):

```bash
lxc.net.0.ipv4.address = 192.168.100.2/24
lxc.net.0.ipv4.gateway = 192.168.100.1
```

Note: Config file can be checked with lxc-checkconfig

Once the container is started, a veth interface is created and added as a port to br1:

```bash
lxc-start -n test1

ovs-vsctl show
572ef28b-6429-4a71-aad8-f634d8274930
    Bridge br1
        Port vethrVi2DI
            Interface vethrVi2DI
        Port br1
            Interface br1
                type: internal
    ovs_version: "2.15.0"

ip l show dev vethrVi2DI
14: vethrVi2DI@if2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master ovs-system state UP mode DEFAULT group default qlen 1000
    link/ether fe:0d:8f:5c:88:f2 brd ff:ff:ff:ff:ff:ff link-netnsid 0
```

The same name is used for a ovs interface and a ovs port. The difference is that a port can contain several interfaces in a link aggregation (bond), but in this case only one interface is used for each port.

lxc-attach can be initially used to access to the container, and the network configuration and external connectivity can be tested:

```bash
ip a s dev eth0
2: eth0@if14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:b1:20:18 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.100.2/24 brd 192.168.100.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:feb1:2018/64 scope link
       valid_lft forever preferred_lft forever
```

We’re using a veth interface that is a virtual Ethernet interface with interconnected pairs, in this case one pair (vethrVi2DI) is in the host and the other (eth0) is in the container, but the link between them is shown with the «@» sign:

So it’s easy to know what interface in the host is connected to each container.

`14: vethrVi2DI@if2 <-> 2: eth0@if14`

Note: The interface number, the OVS port and the veth name is going to change on the host every time the container is restarted

We can get information about different tables on the OVS database (Open_vSwitch, Bridge, Port, Datapath, Flow_Table, Port, Interface, …):

```bash
ovs-vsctl list Open_vSwitch
_uuid               : 572ef28b-6429-4a71-aad8-f634d8274930
bridges             : [4398764d-ef3e-44ff-a303-55bb02bd0662]
cur_cfg             : 8
datapath_types      : [netdev, system]
datapaths           : {}
db_version          : "8.2.0"
dpdk_initialized    : false
dpdk_version        : none
external_ids        : {hostname=mut, rundir="/var/run/openvswitch", system-id="5c827fe2-b53d-4eb9-9f4c-541043e61294"}
iface_types         : [bareudp, erspan, geneve, gre, gtpu, internal, ip6erspan, ip6gre, lisp, patch, stt, system, tap, vxlan]
manager_options     : []
next_cfg            : 8
other_config        : {}
ovs_version         : "2.15.0"
ssl                 : []
statistics          : {}
system_type         : debian
system_version      : "11"
```

```bash
ovs-vsctl list Bridge
_uuid               : 4398764d-ef3e-44ff-a303-55bb02bd0662
auto_attach         : []
controller          : []
datapath_id         : "00004e769843ff44"
datapath_type       : ""
...

ovs-vsctl list Port
_uuid               : bce0532e-9a1f-486f-8098-4a1c180c207b
bond_active_slave   : []
bond_downdelay      : 0
bond_fake_iface     : false
...

_uuid               : a2004f73-ee71-466a-a364-82ff0c5af87f
bond_active_slave   : []
bond_downdelay      : 0
bond_fake_iface     : false
...
```

```bash
ovs-vsctl list Interface
_uuid               : 88f9d3d0-9357-49bd-9811-d363304f2153
admin_state         : up
bfd                 : {}
...
mac_in_use          : "4e:76:98:43:ff:44"
mtu                 : 1500
mtu_request         : []
name                : br1
ofport              : 65534
ofport_request      : []
options             : {}
other_config        : {}
statistics          : {collisions=0, rx_bytes=278193, rx_crc_err=0, rx_dropped=0, rx_errors=0, rx_frame_err=0, rx_missed_errors=0, rx_over_err=0, rx_packets=4120, tx_bytes=12172817, tx_dropped=0, tx_errors=0, tx_packets=9745}
status              : {driver_name=openvswitch}
type                : internal

_uuid               : 1830b2f7-d50b-48a3-a033-2dbda929c3f2
admin_state         : up
bfd                 : {}
...
link_speed          : 10000000000
link_state          : up
lldp                : {}
mac                 : []
mac_in_use          : "fe:0d:8f:5c:88:f2"
mtu                 : 1500
mtu_request         : []
name                : vethrVi2DI
ofport              : 4
ofport_request      : []
options             : {}
other_config        : {}
statistics          : {collisions=0, rx_bytes=333025, rx_crc_err=0, rx_dropped=0, rx_errors=0, rx_frame_err=0, rx_missed_errors=0, rx_over_err=0, rx_packets=4104, tx_bytes=12074340, tx_dropped=0, tx_errors=0, tx_packets=9291}
status              : {driver_name=veth, driver_version="1.0", firmware_version=""}
type                : ""
```

Other basic commands to get information:

```bash
ovs-ofctl show br1
OFPT_FEATURES_REPLY (xid=0x2): dpid:00004e769843ff44
n_tables:254, n_buffers:0
capabilities: FLOW_STATS TABLE_STATS PORT_STATS QUEUE_STATS ARP_MATCH_IP
actions: output enqueue set_vlan_vid set_vlan_pcp strip_vlan mod_dl_src mod_dl_dst mod_nw_src mod_nw_dst mod_nw_tos mod_tp_src mod_tp_dst
 4(vethrVi2DI): addr:fe:0d:8f:5c:88:f2
     config:     0
     state:      0
     current:    10GB-FD COPPER
     speed: 10000 Mbps now, 0 Mbps max
 LOCAL(br1): addr:4e:76:98:43:ff:44
     config:     0
     state:      0
     speed: 0 Mbps now, 0 Mbps max
OFPT_GET_CONFIG_REPLY (xid=0x4): frags=normal miss_send_len=0

ovs-dpctl show
system@ovs-system:
  lookups: hit:42 missed:48 lost:0
  flows: 0
  masks: hit:52 total:0 hit/pkt:0.58
  port 0: ovs-system (internal)
  port 1: br1 (internal)
  port 4: vethrVi2DI
```

**[Introduction to Open vSwitch (OVS)](https://www.youtube.com/watch?v=rYW7kQRyUvA)**

netdevice - low-level access to Linux network devices. SYNOPSIS top #include <sys/ioctl.h> #include <net/if.h> DESCRIPTION top NOTES top

## these are the bridges ovn sets up

```bash
root@uvm1:~# ovs-vsctl show 
fe406455-697a-44b0-94a2-13caf1463fab
    Bridge lxdovn1
        Port lxdovn1
            Interface lxdovn1
                type: internal
        Port patch-lxd-net2-ls-ext-lsp-provider-to-br-int
            Interface patch-lxd-net2-ls-ext-lsp-provider-to-br-int
                type: patch
                options: {peer=patch-br-int-to-lxd-net2-ls-ext-lsp-provider}
        Port lxdovn1b
            Interface lxdovn1b
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port br-int
            Interface br-int
                type: internal
        Port veth4338d9e7
            Interface veth4338d9e7
        Port patch-br-int-to-lxd-net2-ls-ext-lsp-provider
            Interface patch-br-int-to-lxd-net2-ls-ext-lsp-provider
                type: patch
                options: {peer=patch-lxd-net2-ls-ext-lsp-provider-to-br-int}
        Port vethf2db2b21
            Interface vethf2db2b21
    ovs_version: "3.3.4"
```

after configuring 3 containers we see 3 new interfaces. The first one is identical to the port on br-int. The third one used the lxd default network and not ovn.

```bash
ip a
10: vethf2db2b21@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master ovs-system state UP group default qlen 1000
    link/ether 7a:5d:0b:61:b0:ba brd ff:ff:ff:ff:ff:ff link-netnsid 0
12: veth4338d9e7@if11: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master ovs-system state UP group default qlen 1000
    link/ether 6a:6f:aa:6c:87:6f brd ff:ff:ff:ff:ff:ff link-netnsid 1
14: vethf5ba137b@if13: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master lxdbr0 state UP group default qlen 1000
    link/ether 56:62:97:99:b7:dc brd ff:ff:ff:ff:ff:ff link-netnsid 2
```

## continue tutorial

The ovs bridge is down, the following steps are taken to bring it up, assign an IP address and set iptables rule to allow NAT access to the Internet:

```bash
ip l set br1 up

ip a add 192.168.100.1/24 dev br1

iptables -t nat -A POSTROUTING -s 192.168.100.0/24 ! -d 192.168.100.0/24 \
-j MASQUERADE

ip a show dev br1
9: br1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 4e:76:98:43:ff:44 brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.1/24 scope global br1
       valid_lft forever preferred_lft forever
    inet6 fe80::4c76:98ff:fe43:ff44/64 scope link
       valid_lft forever preferred_lft forever

## LXC test environment

Once OVS is installed on the host machine, several virtual instances can be created to connect to OVS bridges and to interact to each other. In this case we’re going to use LXC (linux containers), but any other virtualization technology can be used.

The default bridge used can be changed to br1 on /etc/lxc/default.conf, and the container can be easily created:

```bash
lxc init ubuntu:24.04 uvm1 --device root,size=50GiB --config limits.cpu=2 --config limits.memory=8GiB --vm
lxc start uvm1
lxc exec uvm1 -- bash

apt update
snap install lxd --channel=5.21/stable --cohort="+"
snap refresh --hold lxd
```

## **[lxd init](https://documentation.ubuntu.com/lxd/latest/howto/initialize/)**

How to initialize LXD
Before you can create a LXD instance, you must configure and initialize LXD.

Interactive configuration
Run the following command to start the interactive configuration process:

Note

For simple configurations, you can run this command as a normal user. However, some more advanced operations during the initialization process (for example, joining an existing cluster) require root privileges. In this case, run the command with sudo or as root.

```bash
lxd init
```

## **[basic ovn/lxd setup](https://documentation.ubuntu.com/lxd/latest/howto/network_ovn_setup/#how-to-set-up-ovn-with-lxd)**

## LXD Minimal setup on vm

To create a minimal setup with default options, you can skip the configuration steps by adding the --minimal flag to the lxd init command:

```bash
lxc exec uvm1 -- bash
lxd init --minimal
# this gives us lxdbr0 and its ip 10.44.173.1/
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:16:3e:65:64:13 brd ff:ff:ff:ff:ff:ff
    inet 10.181.197.193/24 metric 100 brd 10.181.197.255 scope global dynamic enp5s0
       valid_lft 3460sec preferred_lft 3460sec
    inet6 fd42:deb7:6459:9916:216:3eff:fe65:6413/64 scope global mngtmpaddr noprefixroute 
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fe65:6413/64 scope link 
       valid_lft forever preferred_lft forever
3: lxdbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 00:16:3e:b9:64:1e brd ff:ff:ff:ff:ff:ff
    inet 10.44.173.1/24 scope global lxdbr0
       valid_lft forever preferred_lft forever
    inet6 fd42:918a:5074:9366::1/64 scope global 
       valid_lft forever preferred_lft forever
```

Note

The minimal setup provides a basic configuration, but the configuration is not optimized for speed or functionality. Especially the dir storage driver, which is used by default, is slower than other drivers and doesn’t provide fast snapshots, fast copy/launch, quotas and optimized backups.

If you want to use an optimized setup, go through the interactive configuration process instead.

See the following sections for how to set up a basic OVN network, either as a standalone network or to host a small LXD cluster.

<!-- GOTO different article of ovn setup with lxd -->
## **[Set up a standalone OVN network](https://documentation.ubuntu.com/lxd/latest/howto/network_ovn_setup/)**

Complete the following steps to create a standalone OVN network that is connected to a managed LXD parent bridge network (for example, lxdbr0) for outbound connectivity.

## 1. Install the OVN tools on the local server

```bash
lxc exec uvm1 -- bash
apt install ovn-host ovn-central
```

## 2. Configure the OVN integration bridge

```bash
lxc exec uvm1 -- bash
ovs-vsctl set open_vswitch . \
   external_ids:ovn-remote=unix:/var/run/ovn/ovnsb_db.sock \
   external_ids:ovn-encap-type=geneve \
   external_ids:ovn-encap-ip=127.0.0.1
```

## 3. Create an OVN network

First look at the ovs configuration.

```bash
## look at network on host vm

```bash
ovs-vsctl show
fe406455-697a-44b0-94a2-13caf1463fab
    Bridge lxdovn1
        Port lxdovn1
            Interface lxdovn1
                type: internal
        Port patch-lxd-net2-ls-ext-lsp-provider-to-br-int
            Interface patch-lxd-net2-ls-ext-lsp-provider-to-br-int
                type: patch
                options: {peer=patch-br-int-to-lxd-net2-ls-ext-lsp-provider}
        Port lxdovn1b
            Interface lxdovn1b
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port br-int
            Interface br-int
                type: internal
        Port patch-br-int-to-lxd-net2-ls-ext-lsp-provider
            Interface patch-br-int-to-lxd-net2-ls-ext-lsp-provider
                type: patch
                options: {peer=patch-lxd-net2-ls-ext-lsp-provider-to-br-int}
    ovs_version: "3.3.4"
```

```bash
# https://discuss.linuxcontainers.org/t/static-ip-addresses-dhcp-ranges-and-non-interactive-network-configuration-commands/8282
# lxc network set <parent_network> ipv4.dhcp.ranges=<IP_range> ipv4.ovn.ranges=<IP_range>

# find lxdbr0 ip and use it for dhcp and ovn ip ranges

ip a
...
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:16:3e:65:64:13 brd ff:ff:ff:ff:ff:ff
    inet 10.181.197.193/24 metric 100 brd 10.181.197.255 scope global dynamic enp5s0
       valid_lft 3460sec preferred_lft 3460sec
    inet6 fd42:deb7:6459:9916:216:3eff:fe65:6413/64 scope global mngtmpaddr noprefixroute 
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fe65:6413/64 scope link 
       valid_lft forever preferred_lft forever
3: lxdbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 00:16:3e:b9:64:1e brd ff:ff:ff:ff:ff:ff
    inet 10.44.173.1/24 scope global lxdbr0
       valid_lft forever preferred_lft forever
    inet6 fd42:918a:5074:9366::1/64 scope global 
       valid_lft forever preferred_lft forever

# ipv4.ovn.ranges -> IPv4 ranges to use for child OVN network routers
lxc network set lxdbr0 ipv4.dhcp.ranges=10.44.173.2-10.44.173.199 ipv4.ovn.ranges=10.44.173.205-10.44.173.254
# lxc network create ovntest --type=ovn network=<parent_network>
lxc network create ovntest --type=ovn network=lxdbr0
Network ovntest created

```

Note we did not specify an ip range for the ovn network. It seems to default to one not used by lxdbr0

## 4.Create an instance that uses the ovntest network

```bash
lxc init ubuntu:24.04 c1
lxc config show c1 --expanded
architecture: x86_64
config:
  image.architecture: amd64
  image.description: ubuntu 24.04 LTS amd64 (release) (20250805)
  image.label: release
  image.os: ubuntu
  image.release: noble
  image.serial: "20250805"
  image.type: squashfs
  image.version: "24.04"
  volatile.apply_template: create
  volatile.base_image: 5199328c409d5b9763c2eaead13eff38489b36510f97a43a681f5b9ee69b38eb
  volatile.cloud-init.instance-id: de9e6e56-c884-42a0-a47e-2c57a901efb2
  volatile.eth0.hwaddr: 00:16:3e:12:71:57
  volatile.idmap.base: "0"
  volatile.idmap.next: '[{"Isuid":true,"Isgid":false,"Hostid":1000000,"Nsid":0,"Maprange":1000000000},{"Isuid":false,"Isgid":true,"Hostid":1000000,"Nsid":0,"Maprange":1000000000}]'
  volatile.last_state.idmap: '[]'
  volatile.uuid: 1e348380-a0c2-4f33-9b00-602f27671c65
  volatile.uuid.generation: 1e348380-a0c2-4f33-9b00-602f27671c65
devices:
  eth0:
    name: eth0
    network: lxdbr0
    type: nic
  root:
    path: /
    pool: default
    type: disk
ephemeral: false
profiles:
- default
stateful: false
description: ""

# notice eth0 is set to lxdbr0 network. change this to ovn network.
lxc config device override c1 eth0 network=ovntest
Device eth0 overridden for c1
lxc config show c1 --expanded
...
devices:
  eth0:
    name: eth0
    network: ovntest
    type: nic
  root:
    path: /
    pool: default
    type: disk
ephemeral: false
profiles:
- default
stateful: false
description: ""
lxc start c1
```

## 5. Run lxc list to show the instance information

```bash
lxc ls
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| NAME |  STATE  |        IPV4         |                     IPV6                      |   TYPE    | SNAPSHOTS |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| c1   | RUNNING | 10.136.192.2 (eth0) | fd42:7180:738e:7cb8:216:3eff:fee2:d1b6 (eth0) | CONTAINER | 0         |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
```

looks like lxd used a 10.136.19.0/24 network ip and not an ip from the lxdbr0 range.

```bash
lxc network set lxdbr0 ipv4.dhcp.ranges=10.44.173.2-10.44.173.199 ipv4.ovn.ranges=10.44.173.205-10.44.173.254
```

## look at network on host vm

```bash
ovs-vsctl show
fe406455-697a-44b0-94a2-13caf1463fab
    Bridge lxdovn1
        Port lxdovn1
            Interface lxdovn1
                type: internal
        Port patch-lxd-net2-ls-ext-lsp-provider-to-br-int
            Interface patch-lxd-net2-ls-ext-lsp-provider-to-br-int
                type: patch
                options: {peer=patch-br-int-to-lxd-net2-ls-ext-lsp-provider}
        Port lxdovn1b
            Interface lxdovn1b
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port br-int
            Interface br-int
                type: internal
        Port patch-br-int-to-lxd-net2-ls-ext-lsp-provider
            Interface patch-br-int-to-lxd-net2-ls-ext-lsp-provider
                type: patch
                options: {peer=patch-lxd-net2-ls-ext-lsp-provider-to-br-int}
        Port veth8598645e
            Interface veth8598645e
    ovs_version: "3.3.4"
```

We now have a new port on br-int and we can see a new network interface.

```bash
ip a
...
10: veth8598645e@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master ovs-system state UP group default qlen 1000
    link/ether 9a:d2:fa:4e:79:5e brd ff:ff:ff:ff:ff:ff link-netnsid 0
```

## from host system notice that the host vm has a tap device with lxdbr0 as master

```bash
ip a
...
4: lxdbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 00:16:3e:ac:6c:f3 brd ff:ff:ff:ff:ff:ff
    inet 10.181.197.1/24 scope global lxdbr0
       valid_lft forever preferred_lft forever
    inet6 fd42:deb7:6459:9916::1/64 scope global 
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:feac:6cf3/64 scope link 
       valid_lft forever preferred_lft forever
6: tapf33ccc71: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master lxdbr0 state UP group default qlen 1000
    link/ether 4e:d3:ad:e7:ea:fb brd ff:ff:ff:ff:ff:ff
```

Create another instance that uses the ovntest network:

```bash
lxc ls
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| NAME |  STATE  |        IPV4         |                     IPV6                      |   TYPE    | SNAPSHOTS |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| c1   | RUNNING | 10.136.192.2 (eth0) | fd42:7180:738e:7cb8:216:3eff:fee2:d1b6 (eth0) | CONTAINER | 0         |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+

lxc init ubuntu:24.04 c2
lxc config device override c2 eth0 network=ovntest
Device eth0 overridden for c2
lxc start c2

lxc ls
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| NAME |  STATE  |        IPV4         |                     IPV6                      |   TYPE    | SNAPSHOTS |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| c1   | RUNNING | 10.136.192.2 (eth0) | fd42:7180:738e:7cb8:216:3eff:fee2:d1b6 (eth0) | CONTAINER | 0         |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| c2   | RUNNING | 10.136.192.3 (eth0) | fd42:7180:738e:7cb8:216:3eff:fef3:3574 (eth0) | CONTAINER | 0         |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
```

## ping test

```bash
# create 2 terminals 
# from 1st terminal
lxc exec uvm1 -- bash
lxc exec c1 -- bash
# from 2nd terminal
lxc exec uvm1 -- bash
lxc exec c2 -- bash
ping c1
PING c1 (fd42:7180:738e:7cb8:216:3eff:fee2:d1b6) 56 data bytes
64 bytes from c1.lxd (fd42:7180:738e:7cb8:216:3eff:fee2:d1b6): icmp_seq=1 ttl=255 time=0.706 ms
64 bytes from c1.lxd (fd42:7180:738e:7cb8:216:3eff:fee2:d1b6): icmp_seq=2 ttl=255 time=0.086 ms
^C
--- c1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.086/0.396/0.706/0.310 ms

ping google.com
PING google.com (142.250.191.238) 56(84) bytes of data.
64 bytes from ord38s32-in-f14.1e100.net (142.250.191.238): icmp_seq=1 ttl=114 time=7.76 ms
64 bytes from ord38s32-in-f14.1e100.net (142.250.191.238): icmp_seq=2 ttl=114 time=7.59 ms

```

## create a container using the default non-ovn network

```bash
# from a 3rd terminal
lxc exec uvm1 -- bash
lxc init ubuntu:24.04 c3
lxc start c3

lxc ls
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| NAME |  STATE  |        IPV4         |                     IPV6                      |   TYPE    | SNAPSHOTS |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| c1   | RUNNING | 10.136.192.2 (eth0) | fd42:7180:738e:7cb8:216:3eff:fee2:d1b6 (eth0) | CONTAINER | 0         |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| c2   | RUNNING | 10.136.192.3 (eth0) | fd42:7180:738e:7cb8:216:3eff:fef3:3574 (eth0) | CONTAINER | 0         |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
| c3   | RUNNING | 10.44.173.62 (eth0) | fd42:918a:5074:9366:216:3eff:fe29:fac1 (eth0) | CONTAINER | 0         |
+------+---------+---------------------+-----------------------------------------------+-----------+-----------+
```

Notice the container using the default network is using the ip range configured for lxdbr0 on the host vm.

```bash
lxc network set lxdbr0 ipv4.dhcp.ranges=10.44.173.2-10.44.173.199 ipv4.ovn.ranges=10.44.173.205-10.44.173.254
lxc exec c3 -- bash
root@c3:~# ping c1
ping: c1: Temporary failure in name resolution

ping google.com
PING google.com (142.250.191.238) 56(84) bytes of data.
64 bytes from ord38s32-in-f14.1e100.net (142.250.191.238): icmp_seq=1 ttl=115 time=6.82 ms
64 bytes from ord38s32-in-f14.1e100.net (142.250.191.238): icmp_seq=2 ttl=115 time=7.36 ms
```
