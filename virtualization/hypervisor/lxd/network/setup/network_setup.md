# **[](https://documentation.ubuntu.com/lxd/latest/explanation/networks/)**

## network notes

## laptop lxd minimal setup

```bash
lxc profile show default
name: default
description: Default LXD profile
config: {}
devices:
  eth0:
    name: eth0
    network: lxdbr0
    type: nic
  root:
    path: /
    pool: default
    type: disk
used_by:
- /1.0/instances/ubuntu-container
- /1.0/instances/win11
```

## microcloud lxd setup

```bash
lxc profile show default 
name: default
description: Default LXD profile
config:
  migration.stateful: "true"
devices:
  eth0:
    name: eth0
    network: default
    type: nic
  root:
    path: /
    pool: remote
    type: disk
used_by:
- /1.0/instances/win11
- /1.0/instances/v1
- /1.0/instances/v3
- /1.0/instances/ubuntu

ip a
...
5: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f0
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
    inet6 fe80::baca:3aff:fe6a:3599/64 scope link 
       valid_lft forever preferred_lft forever
8: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
    altname enp1s0f2
    inet6 fe80::baca:3aff:fe6a:359a/64 scope link 
       valid_lft forever preferred_lft forever
10: eno4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:9b brd ff:ff:ff:ff:ff:ff
    altname enp1s0f3
12: eno11220@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.187.220.201/24 brd 10.187.220.255 scope global eno11220
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
13: eno1220@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.188.220.201/24 brd 10.188.220.255 scope global eno1220
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
14: eno150@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.188.50.201/24 brd 10.188.50.255 scope global eno150
       valid_lft forever preferred_lft forever
    inet 10.188.50.200/24 scope global secondary eno150
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
15: eno250@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master ovs-system state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
16: eno350@eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
    inet 10.188.50.197/24 brd 10.188.50.255 scope global eno350
       valid_lft forever preferred_lft forever
17: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 4e:62:9b:e2:4f:d9 brd ff:ff:ff:ff:ff:ff
18: br-int: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 6e:e4:51:97:a1:61 brd ff:ff:ff:ff:ff:ff
19: lxdovn1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
20: genev_sys_6081: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65000 qdisc noqueue master ovs-system state UNKNOWN group default qlen 1000
    link/ether e6:1f:08:de:61:ec brd ff:ff:ff:ff:ff:ff
    inet6 fe80::cc4f:d4ff:fe8b:3833/64 scope link 
       valid_lft forever preferred_lft forever
...


lxc network show default
name: default
description: Default OVN network
type: ovn
managed: true
status: Created
config:
  bridge.mtu: "1442"
  ipv4.address: 10.233.212.1/24
  ipv4.nat: "true"
  ipv6.address: fd42:40d7:53e9:d1cc::1/64
  ipv6.nat: "true"
  network: UPLINK
  volatile.network.ipv4.address: 10.188.50.206
used_by:
- /1.0/instances/ubuntu
- /1.0/instances/v1
- /1.0/instances/v3
- /1.0/instances/win11
- /1.0/profiles/default
locations:
- micro13
- micro11
- micro12

lxc network show UPLINK
name: UPLINK
description: ""
type: physical
managed: true
status: Created
config:
  dns.nameservers: 10.225.50.203,10.224.50.203
  ipv4.gateway: 10.188.50.254/24
  ipv4.ovn.ranges: 10.188.50.206-10.188.50.212
  volatile.last_state.created: "false"
used_by:
- /1.0/networks/default
locations:
- micro11
- micro12
- micro13
```

Also see **[How to configure networks for a cluster](https://documentation.ubuntu.com/lxd/latest/howto/cluster_config_networks/#cluster-config-networks)**.

## Networking setups

There are different ways to connect your instances to the Internet. The easiest method is to have LXD create a network bridge during initialization and use this bridge for all instances, but LXD supports many different and advanced setups for networking.

## Network devices

To grant direct network access to an instance, you must assign it at least one network device, also called NIC. You can configure the network device in one of the following ways:

Use the default network bridge that you set up during the LXD initialization. Check the default profile to see the default configuration:

`lxc profile show default`

This method is used if you do not specify a network device for your instance.

- Use an existing network interface by adding it as a network device to your instance. This network interface is outside of LXD control. Therefore, you must specify all information that LXD needs to use the network interface.

Use a command similar to the following:

```bash
lxc config device add <instance_name> <device_name> nic nictype=<nic_type> ...
```

See Type: nic for a list of available NIC types and their configuration properties.

For example, you could add a pre-existing Linux bridge (br0) with the following command:

```bash
lxc config device add <instance_name> eth0 nic nictype=bridged parent=br0
```

Create a **[managed network](https://documentation.ubuntu.com/lxd/latest/howto/network_create/)** and add it as a network device to your instance. With this method, LXD has all required information about the configured network, and you can directly attach it to your instance as a device:

```bash
lxc network attach <network_name> <instance_name> <device_name>
```

## Understanding LXD Network Types (Bridged Networking)

Bridged Networks: LXD creates a Layer 2 (L2) bridge that connects multiple instances (VMs or containers) onto a single L2 network segment.
Inter-Instance Communication: Instances attached to the same bridge can pass traffic to each other.
DHCP and DNS: The LXD bridge can also provide local DHCP and DNS services to the attached instances, by default.

```bash
lxc network list  
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
|      NAME       |   TYPE   | MANAGED |      IPV4       |           IPV6            | DESCRIPTION | USED BY |  STATE  |
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| enxa0cec85afc3c | physical | NO      |                 |                           |             | 0       |         |
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| lxdbr0          | bridge   | YES     | 10.181.197.1/24 | fd42:deb7:6459:9916::1/64 |             | 3       | CREATED |
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| wlp114s0f0      | physical | NO      |                 |                           |             | 0       |         |
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
```

## microcloud

```bash
lxc network list

+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
|   NAME    |   TYPE   | MANAGED |      IPV4       |           IPV6            |     DESCRIPTION     | USED BY |  STATE  |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| UPLINK    | physical | YES     |                 |                           |                     | 1       | CREATED |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| br-int    | bridge   | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| default   | ovn      | YES     | 10.233.212.1/24 | fd42:40d7:53e9:d1cc::1/64 | Default OVN network | 5       | CREATED |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno1      | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno2      | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno3      | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno4      | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno150    | vlan     | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno250    | vlan     | NO      |                 |                           |                     | 1       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno350    | vlan     | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno1220   | vlan     | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno11220  | vlan     | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| enp65s0f0 | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| enp65s0f1 | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| enp66s0f0 | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| enp66s0f1 | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| enp66s0f2 | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| enp66s0f3 | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| lxdovn1   | bridge   | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+

brent@micro11:~$ lxc exec v1 -- bash
root@v1:~# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1442 qdisc mq state UP group default qlen 1000
    link/ether 00:16:3e:cb:cb:fd brd ff:ff:ff:ff:ff:ff
    inet 10.233.212.2/24 metric 100 brd 10.233.212.255 scope global dynamic enp5s0
       valid_lft 2365sec preferred_lft 2365sec
    inet6 fd42:40d7:53e9:d1cc:216:3eff:fecb:cbfd/64 scope global mngtmpaddr noprefixroute 
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fecb:cbfd/64 scope link 
       valid_lft forever preferred_lft forever
```
