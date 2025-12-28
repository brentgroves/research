# **[try 3 - single node setup from video](https://www.youtube.com/watch?v=M0y0hQ16YuE&t=359s)**

**[try 3 - single node setup](https://documentation.ubuntu.com/microcloud/latest/microcloud/tutorial/get_started/)**

Keep it simple like try 2 but add disk encryption and change IP range so vms and containers have access to the internet.

- The IP rang 10.188.50.[200-212] has access to the internet. micro11,micro12, and micro13 consume 10.188.50.[201-203] and 10.188.50.205 is in use by the dhcp server. select ip range of 10.188.50.[206-212] to be used by containers and VM.
- Encrypt the disk
  - The dm-crypt kernel module must be available. Note that some cloud-optimised kernels do not ship dm-crypt by default. Check by running `sudo modinfo dm-crypt`
  - The snap dm-crypt plug has to be connected, and microceph.daemon subsequently restarted:

```bash
sudo snap connect microceph:dm-crypt
sudo snap restart microceph.daemon
```

## mistake

eno250@eno2 did not show up on this list. It must be used somehow; although `ip a` does not show any address. Maybe I should have rebooted the machine after uninstalling microcloud.

Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+--------+----------+
       | LOCATION | IFACE  |   TYPE   |
       +----------+--------+----------+
  [ ]  | micro11  | eno2   | physical |
  [ ]  | micro11  | eno3   | physical |
> [ ]  | micro11  | eno350 | vlan     |
  [ ]  | micro11  | eno1   | physical |
       +----------+--------+----------+

```bash
ip a
eno250@eno2: <BROADCAST,MULTICAST> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff

sudo ip link set eno250 up
# reboot system    
```

- Used eno350 instead for distributed network.

## try 2 summary

- On try 2 I selected address range 10.188.50.6 - 10.188.50.12 this is not what I wanted because these IP addresses can not access the internet.

- Did not encrypt disk.

Do you want to encrypt the selected disks? (yes/no) [default=no]: no

- need 2 additional network interfaces
1 for uplink, 1 for microceph, 1 for microovn
- Use the latest docs.
- View the matrix of compatible versions to determine whether you need to upgrade the snap to a different channel. Follow either the update or upgrade instructions below.

| Ubuntu LTS | MicroCloud | LXD   | MicroCeph | MicroOVN |
|------------|------------|-------|-----------|----------|
| 22.04      | 2.1*       | 5.21* | Squid     | 24.03    |
| 24.04      | 2.1*       | 5.21* | Squid     | 24.03    |

```bash
sudo snap install lxd --channel=5.21/stable --cohort="+"
sudo snap install microceph --channel=squid/stable --cohort="+"
sudo snap install microovn --channel=24.03/stable --cohort="+"
sudo snap install microcloud --channel=2/stable --cohort="+"

sudo -i


snap list
Name        Version                 Rev    Tracking       Publisher   Notes
core22      20250612                2045   latest/stable  canonical✓  base
core24      20250526                1006   latest/stable  canonical✓  base
lxd         5.21.3-c5ae129          33110  5.21/stable    canonical✓  in-cohort
microceph   19.2.0+snapab139d4a1f   1393   squid/stable   canonical✓  in-cohort
microcloud  2.1.0-3e8b183           1144   2/stable       canonical✓  in-cohort
microovn    24.03.2+snapa2c59c105b  667    24.03/stable   canonical✓  in-cohort
snapd       2.70                    24792  latest/stable  canonical✓  snapd

snap services --global
Service                          Startup   Current   Notes
lxd.activate                     enabled   inactive  -
lxd.daemon                       enabled   inactive  socket-activated
lxd.user-daemon                  enabled   inactive  socket-activated
microceph.daemon                 enabled   active    -
microceph.mds                    disabled  inactive  -
microceph.mgr                    disabled  inactive  -
microceph.mon                    disabled  inactive  -
microceph.osd                    disabled  inactive  -
microceph.rbd-mirror             disabled  inactive  -
microceph.rgw                    disabled  inactive  -
microcloud.daemon                enabled   active    -
microovn.chassis                 disabled  inactive  -
microovn.daemon                  enabled   active    -
microovn.ovn-northd              disabled  inactive  -
microovn.ovn-ovsdb-server-nb     disabled  inactive  -
microovn.ovn-ovsdb-server-sb     disabled  inactive  -
microovn.refresh-expiring-certs  enabled   inactive  timer-activated
microovn.switch                  disabled  inactive  -

# reboot system
# reboot
# did not reboot
```

The --cohort flag ensures that versions remain **[synchronized during later updates](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/update_upgrade/#howto-update-sync)**.

Following installation, make sure to **[hold updates](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/update_upgrade/#howto-update-hold)**.

To indefinitely hold all updates to the snaps needed for MicroCloud, run:

```bash
sudo snap refresh --hold lxd microceph microovn microcloud
General refreshes of "lxd", "microceph", "microovn", "microcloud" held indefinitely
```

```bash
sudo -i
microcloud init
Waiting for services to start ...
Do you want to set up more than one cluster member? (yes/no) [default=yes]: no
Select an address for MicroCloud's internal traffic:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------------+----------+
       |    ADDRESS     |  IFACE   |
       +----------------+----------+
> [x]  | 10.188.50.201  | eno150   |
  [ ]  | 10.188.220.201 | eno1220  |
  [ ]  | 10.187.220.201 | eno11220 |
       +----------------+----------+

 Using address "10.188.50.201" for MicroCloud

Gathering system information ...
Would you like to set up local storage? (yes/no) [default=yes]: 

Select exactly one disk from each cluster member:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
       | LOCATION |         MODEL          | CAPACITY  | TYPE  |                          PATH                          |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
  [ ]  | micro11  | HL-DT-ST DVD-ROM DU70N | 0B        | cdrom | /dev/disk/by-id/wwn-0x5001480000000000                 |
> [x]  | micro11  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cd002fef43a819011d8a |
  [ ]  | micro11  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cd002fef438b174afe15 |
  [ ]  | micro11  | PERC H710              | 465.25GiB | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cd002ffb00930d3d91c9 |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+       

Select which disks to wipe:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
       | LOCATION |         MODEL          | CAPACITY  | TYPE  |                          PATH                          |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
> [x]  | micro11  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cd002fef43a819011d8a |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+

Would you like to set up distributed storage? (yes/no) [default=yes]: yes
Select from the available unpartitioned disks:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
       | LOCATION |         MODEL          | CAPACITY  | TYPE  |                          PATH                          |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
  [ ]  | micro11  | HL-DT-ST DVD-ROM DU70N | 0B        | cdrom | /dev/disk/by-id/wwn-0x5001480000000000                 |
> [x]  | micro11  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cd002fef438b174afe15 |
  [ ]  | micro11  | PERC H710              | 465.25GiB | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cd002ffb00930d3d91c9 |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+

Select which disks to wipe:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
       | LOCATION |         MODEL          | CAPACITY  | TYPE  |                          PATH                          |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
> [x]  | micro11  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cd002fef438b174afe15 |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+    

Disk configuration does not meet recommendations for fault tolerance. At least 3 systems must supply disks.
Continuing with this configuration will inhibit MicroCloud's ability to retain data on system failure
Change disk selection? (yes/no) [default=yes]: no
Do you want to encrypt the selected disks? (yes/no) [default=no]: yes
Would you like to set up CephFS remote storage? (yes/no) [default=yes]: yes
# diff from tutorial. he selected another subnet for both internal and public traffic.
What subnet (either IPv4 or IPv6 CIDR notation) would you like your Ceph internal traffic on? [default: 10.188.50.0/24]
# if you change this to another network setup up will check for an existing IP address and show you it
What subnet (either IPv4 or IPv6 CIDR notation) would you like your Ceph public traffic on? [default: 10.188.50.0/24]

Configure distributed networking? (yes/no) [default=yes]: yes
Select an available interface per system to provide external connectivity for distributed network(s):
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.

       +----------+--------+----------+
       | LOCATION | IFACE  |   TYPE   |
       +----------+--------+----------+
  [ ]  | micro11  | eno2   | physical |
  [ ]  | micro11  | eno3   | physical |
> [x]  | micro11  | eno350 | vlan     |
  [ ]  | micro11  | eno1   | physical |
       +----------+--------+----------+
# Mistake uninstalling. did not set eno250 up and reboot the system before running microcloud init. so I selected eno350 instead of en0250.

       +----------+--------+----------+
       | LOCATION | IFACE  |   TYPE   |
       +----------+--------+----------+
  [ ]  | micro11  | eno1   | physical |
  [ ]  | micro11  | eno2   | physical |
  [ ]  | micro11  | eno3   | physical |
> [x]  | micro11  | eno250 | vlan     |
  [ ]  | micro11  | eno350 | vlan     |
       +----------+--------+----------+

nmap -sP 10.188.50.0/24

 Using "eno250" on "micro11" for OVN uplink

Specify the IPv4 gateway (CIDR) on the uplink network (empty to skip IPv4): 10.188.50.254/24
Specify the first IPv4 address in the range to use on the uplink network: 10.188.50.206
Specify the last IPv4 address in the range to use on the uplink network: 10.188.50.212
# no ipv6 on network
Specify the IPv6 gateway (CIDR) on the uplink network (empty to skip IPv6):
Specify the DNS addresses (comma-separated IPv4 / IPv6 addresses) for the distributed network (default: 10.188.50.254): 10.225.50.203,10.224.50.203
Configure dedicated OVN underlay networking? (yes/no) [default=no]: 
Initializing new services
 Local MicroCloud is ready
 Local MicroOVN is ready
 Local MicroCeph is ready
 Local LXD is ready
Awaiting cluster formation ...
Configuring cluster-wide devices ...
MicroCloud is ready

Awaiting cluster formation ...
Configuring cluster-wide devices ...
MicroCloud is ready

microcloud cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:9443 | voter | ab52ab70fe321d44f5d52ef6a0b04fc6abb62421d2da8b989e89103ffbaf5293 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+

lxc cluster list

+---------+----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
|  NAME   |            URL             |      ROLES      | ARCHITECTURE | FAILURE DOMAIN | DESCRIPTION | STATE  |      MESSAGE      |
+---------+----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro11 | https://10.188.50.201:8443 | database-leader | x86_64       | default        |             | ONLINE | Fully operational |
|         |                            | database        |              |                |             |        |                   |
+---------+----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
microceph cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:7443 | voter | 5808ceb7f4a6495842e1631b6044869b8264b944d773c49f755b43e27c7c5a15 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
microovn cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:6443 | voter | 96f4464e62c8244d37e77517d3faf43d63e73d33194931eaed215308cd410d9d | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+

lxc profile list
+---------+---------------------+---------+
|  NAME   |     DESCRIPTION     | USED BY |
+---------+---------------------+---------+
| default | Default LXD profile | 0       |
+---------+---------------------+---------+

configured to default ovn network and default root disk which is on the remote storage pool managed by ceph. 
Question: Is the RBD or CephFS remote storage?

lxc profile show default
name: default
description: Default LXD profile
config: {}
devices:
  eth0:
    name: eth0
    network: default
    type: nic
  root:
    path: /
    pool: remote
    type: disk
used_by: []
```

## set lxd configuration

In LXD, migration.stateful is a profile setting that controls whether a virtual machine supports stateful operations like live migration, stateful snapshots, and stateful stop/start. When enabled (set to true), it allows for these operations, but it also disables certain features like virtiofs shares and requires specific storage configurations.

<!-- not necessary for single node but will need it later -->
```bash
lxc profile set default migration.stateful true
lxc profile get default migration.stateful
true
```

## launch instance

retrieve the image from image server, unpack it onto the remote storage, and then create the instance root volume so lxc can launch it

```bash
lxc launch ubuntu:noble v1 --vm
Launching v1

lxc list
+------+---------+---------------------+-------------------------------------------------+-----------------+-----------+----------+
| NAME |  STATE  |        IPV4         |                      IPV6                       |      TYPE       | SNAPSHOTS | LOCATION |
+------+---------+---------------------+-------------------------------------------------+-----------------+-----------+----------+
| v1   | RUNNING | 10.93.23.2 (enp5s0) | fd42:4f94:2f1d:d135:216:3eff:fe75:448a (enp5s0) | VIRTUAL-MACHINE | 0         | micro11  |
+------+---------+---------------------+-------------------------------------------------+-----------------+-----------+----------+

```

## look at network

```bash
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp66s0f0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0a:f7:3e:f4:60 brd ff:ff:ff:ff:ff:ff
3: enp66s0f1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0a:f7:3e:f4:61 brd ff:ff:ff:ff:ff:ff
4: enp66s0f2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0a:f7:3e:f4:62 brd ff:ff:ff:ff:ff:ff
5: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f0
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
6: enp66s0f3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0a:f7:3e:f4:63 brd ff:ff:ff:ff:ff:ff
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
    inet6 fe80::baca:3aff:fe6a:3599/64 scope link 
       valid_lft forever preferred_lft forever
8: enp65s0f0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 98:b7:85:20:18:0e brd ff:ff:ff:ff:ff:ff
9: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
    altname enp1s0f2
    inet6 fe80::baca:3aff:fe6a:359a/64 scope link 
       valid_lft forever preferred_lft forever
10: eno4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:9b brd ff:ff:ff:ff:ff:ff
    altname enp1s0f3
11: enp65s0f1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 98:b7:85:20:18:0f brd ff:ff:ff:ff:ff:ff
12: eno150@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.188.50.201/24 brd 10.188.50.255 scope global eno150
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
13: eno1220@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.188.220.201/24 brd 10.188.220.255 scope global eno1220
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
14: eno11220@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.187.220.201/24 brd 10.187.220.255 scope global eno11220
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
15: eno250@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
16: eno350@eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master ovs-system state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
24: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 4e:62:9b:e2:4f:d9 brd ff:ff:ff:ff:ff:ff
25: br-int: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ca:72:e7:98:35:3b brd ff:ff:ff:ff:ff:ff
26: lxdovn1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
27: tap494a10fe: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master ovs-system state UP group default qlen 1000
    link/ether 32:41:60:4d:af:38 brd ff:ff:ff:ff:ff:ff
```

## does vm have expected network access

yes. same as host system. except no routes to 220 or 1220 vlans.

```bash
lxc exec v1 -- bash
ping 10.188.50.202
```

## does storage work

i think so.

```bash
touch t.txt
root@v1:~# vi t.txt
root@v1:~# cat t.txt
test
```

## what does the network look like

looks the same except for additional interfaces. All the newly created interfaces are down except for tap interface whos master is the  ovs-system interface.

```bash
24: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 4e:62:9b:e2:4f:d9 brd ff:ff:ff:ff:ff:ff
25: br-int: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ca:72:e7:98:35:3b brd ff:ff:ff:ff:ff:ff
26: lxdovn1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
27: tap494a10fe: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master ovs-system state UP group default qlen 1000
    link/ether 32:41:60:4d:af:38 brd ff:ff:ff:ff:ff:ff
```

```bash
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp66s0f0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0a:f7:3e:f4:60 brd ff:ff:ff:ff:ff:ff
3: enp66s0f1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0a:f7:3e:f4:61 brd ff:ff:ff:ff:ff:ff
4: enp66s0f2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0a:f7:3e:f4:62 brd ff:ff:ff:ff:ff:ff
5: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f0
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
6: enp66s0f3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 00:0a:f7:3e:f4:63 brd ff:ff:ff:ff:ff:ff
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f1
    inet6 fe80::baca:3aff:fe6a:3599/64 scope link 
       valid_lft forever preferred_lft forever
8: enp65s0f0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 98:b7:85:20:18:0e brd ff:ff:ff:ff:ff:ff
9: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
    altname enp1s0f2
    inet6 fe80::baca:3aff:fe6a:359a/64 scope link 
       valid_lft forever preferred_lft forever
10: eno4: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:9b brd ff:ff:ff:ff:ff:ff
    altname enp1s0f3
11: enp65s0f1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 98:b7:85:20:18:0f brd ff:ff:ff:ff:ff:ff
12: eno150@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.188.50.201/24 brd 10.188.50.255 scope global eno150
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
13: eno1220@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.188.220.201/24 brd 10.188.220.255 scope global eno1220
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
14: eno11220@eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:98 brd ff:ff:ff:ff:ff:ff
    inet 10.187.220.201/24 brd 10.187.220.255 scope global eno11220
       valid_lft forever preferred_lft forever
    inet6 fe80::baca:3aff:fe6a:3598/64 scope link 
       valid_lft forever preferred_lft forever
15: eno250@eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff
16: eno350@eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master ovs-system state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
24: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 4e:62:9b:e2:4f:d9 brd ff:ff:ff:ff:ff:ff
25: br-int: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether ca:72:e7:98:35:3b brd ff:ff:ff:ff:ff:ff
26: lxdovn1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
27: tap494a10fe: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master ovs-system state UP group default qlen 1000
    link/ether 32:41:60:4d:af:38 brd ff:ff:ff:ff:ff:ff
```

## START HERE

<https://www.youtube.com/watch?v=M0y0hQ16YuE&t=359s>
13 MINutes into video

## questions

### 1. created an instance but the ipv4 address is not in the ip address range we configured

He selected an address range of 10.2.123.[100-120] on the enp75s0 ovn uplink interface. but his instance showed an ip of 10.22

answer: at time 6.50 of video he says this range will be used for the virtual network.

### 0. configured to default ovn network and default root disk which is on the remote storage pool managed by ceph

Question: Is the RBD or CephFS remote storage?

### 1. why does lxc profile show eth0 network device instead of en0150 vlan interface chosen

Do you want to set up more than one cluster member? (yes/no) [default=yes]: no
Select an address for MicroCloud's internal traffic:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------------+----------+
       |    ADDRESS     |  IFACE   |
       +----------------+----------+
> [x]  | 10.188.50.201  | eno150   |
  [ ]  | 10.188.220.201 | eno1220  |
  [ ]  | 10.187.220.201 | eno11220 |
       +----------------+----------+

### 2. why is root disk's pool remote

Would you like to set up CephFS remote storage? (yes/no) [default=yes]: yes

CephFS, or Ceph File System, is a POSIX-compliant distributed file system built on top of the Ceph storage cluster. It allows multiple clients to access and share the same file system concurrently, handling concurrency and data consistency issues that can arise with other approaches. Essentially, it provides a network-attached file storage service that is highly scalable and reliable.

### 3. how does disk id relate to

/dev/disk/by-id/wwn-0x6c81f660dba9cd002fef438b174afe15 |

blkid
/dev/mapper/ubuntu--vg-ubuntu--lv: UUID="ff34f3e2-3f87-4a3e-8119-fb0ba771d6a0" BLOCK_SIZE="4096" TYPE="ext4"
/dev/sde1: SEC_TYPE="msdos" LABEL="KINGSTON" UUID="287B-247C" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="d70045f0-01"
/dev/sda2: UUID="249b2b3e-e87d-4fd9-8354-6403dcf85107" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="ff56bce9-57f3-4b43-9292-468fbb9f950e"
/dev/sda3: UUID="9XERwy-sfj4-F2BZ-a5dW-gTJP-Z2zv-E57dx2" TYPE="LVM2_member" PARTUUID="867c650e-4b68-433e-8a1b-586aa0966511"
/dev/sda1: UUID="EDE1-1B25" BLOCK_SIZE="512" TYPE="vfat" PARTUUID="f6fef289-f9c9-4ec0-a556-a95f1762ffb0"
/dev/loop1: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop8: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/sdb: TYPE="ceph_bluestore"
/dev/loop6: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop4: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop2: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop0: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/sdc9: PARTUUID="023e4e0e-8501-4641-ad5c-f84be59c4e0f"
/dev/sdc1: LABEL="local" UUID="18386152112845316707" UUID_SUB="2075457474700030707" BLOCK_SIZE="512" TYPE="zfs_member" PARTLABEL="zfs-b2668239f5165c61" PARTUUID="9ef5cc25-af3f-4e40-b0f5-21c1afcf767b"
/dev/loop7: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop5: BLOCK_SIZE="131072" TYPE="squashfs"
/dev/loop3: BLOCK_SIZE="131072" TYPE="squashfs"

In Linux, a disk ID is a unique identifier that can refer to either a physical disk drive or a specific partition on that drive. It's often used to ensure reliable identification and mounting of storage devices, especially when device names might change. Two common forms of disk IDs are the UUID (Universally Unique Identifier) and device names like /dev/sda1.

UUIDs are 128-bit values assigned to partitions or block devices.
They are more robust than device names because they remain consistent even if the device's order changes in the system.
You can find UUIDs using commands like blkid or by looking in /dev/disk/by-uuid.
UUIDs are often used in /etc/fstab to mount partitions, providing a reliable way to identify them.
Device Names:
Device names like /dev/sda, /dev/sda1, /dev/sdb, etc., are assigned to disks and their partitions by the system. These can change, especially if devices are added or removed.
lsblk is a command that displays block devices, including their names, sizes, and mount points.
/dev/disk/by-id provides symbolic links to devices based on various identifiers, including those from the manufacturer.

## START HERE VIDE TIME 10:23

## **[ovn underlay network](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/ovn_underlay/)**

### physical server underlay

For an explanation of the benefits of using an OVN underlay network, see **[Dedicated underlay network](https://documentation.ubuntu.com/microcloud/latest/microcloud/explanation/networking/#exp-networking-ovn-underlay)**.

When running microcloud init, if you chose to set up distributed networking and you have at least one network interface per cluster member with an **IP address**, MicroCloud asks if you want to configure an underlay network for OVN:

Configure dedicated underlay networking? (yes/no) [default=no]: <answer>

You can choose to skip this question (just hit Enter). MicroCloud then uses its internal network as an OVN ‘underlay’, which is the same as the OVN management network (‘overlay’ network).

You could also choose to configure a dedicated underlay network for OVN by typing yes. A list of available network interfaces with an **IP address** will be displayed. You can then select one network interface per cluster member to be used as the interfaces for the underlay network of OVN.

```yaml
underlay_network: "10.188.50.0/24"
ip: "10.188.50.231"

```

### physical server **[ceph network](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/ceph_networking/#howto-ceph-networking)**

## How to configure Ceph networking

When running microcloud init, you are asked if you want to provide custom subnets for the Ceph cluster. Here are the questions you will be asked:

What subnet (either IPv4 or IPv6 CIDR notation) would you like your Ceph internal traffic on? [default: 203.0.113.0/24]: <answer>

What subnet (either IPv4 or IPv6 CIDR notation) would you like your Ceph public traffic on? [default: 203.0.113.0/24]: <answer>

You can choose to skip both questions (just hit Enter) and use the default value which is the subnet used for the internal MicroCloud traffic. This is referred to as a usual Ceph networking setup.

![i1](https://documentation.ubuntu.com/microcloud/latest/microcloud/_images/ceph_network_usual_setup.svg)

Sometimes, you want to be able to use different network interfaces for some Ceph related usages. Let’s imagine you have machines with network interfaces that are tailored for high throughput and low latency data transfer, like 100 GbE+ QSFP links, and other ones that might be more suited for management traffic, like 1 GbE or 10 GbE links.

In this case, it would probably be ideal to set your Ceph internal (or cluster) traffic on the high throughput network interface and the Ceph public traffic on the management network interface. This is referred to as a fully disaggregated Ceph networking setup.

![i2](https://documentation.ubuntu.com/microcloud/latest/microcloud/_images/ceph_network_full_setup.svg)

In a Ceph storage cluster, public traffic refers to the network communication between Ceph clients (like virtual machines or applications) and the Ceph storage cluster, as well as communication between different Ceph daemons. It's essentially the "front-side" network, handling client requests and data access.

![i3](https://documentation.ubuntu.com/microcloud/latest/microcloud/_images/ceph_network_partial_setup.svg)

### internal traffic (unsure)

10.188.220.0/24
