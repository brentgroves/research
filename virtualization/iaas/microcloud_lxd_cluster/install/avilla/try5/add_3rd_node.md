# **[add node](https://www.youtube.com/watch?v=M0y0hQ16YuE&t=359s)**

time: 13:25

## **[add machine](https://documentation.ubuntu.com/microcloud/stable/microcloud/how-to/add_machine/)**

```bash
# micro11
microcloud add
Waiting for services to start ...
Use the following command on systems that you want to join the cluster:

 microcloud join

When requested enter the passphrase:

 urchin jealous unyielding crawfish

Verify the fingerprint "7b580ad43271" is displayed on joining systems.
Waiting to detect systems ...
```

```bash
# micro13
# multicast allowed
microcloud join
# unicast only
microcloud join --initiator-address 10.188.50.201

Waiting for services to start ...
Select an address for MicroCloud's internal traffic:

 Using address "10.188.50.203" for MicroCloud

Verify the fingerprint "6d9615985e50" is displayed on the other system.
Specify the passphrase for joining the system: thorn jukebox enchilada gnomish

 Found system "micro11" at "10.188.50.201" using fingerprint "7b580ad43271"

Select "micro13" on "micro11" to let it join the cluster

```

```bash
# micro11
Select the systems that should join the cluster:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +---------+---------------+--------------+
       |  NAME   |    ADDRESS    | FINGERPRINT  |
       +---------+---------------+--------------+
> [x]  | micro13 | 10.188.50.203 | 6d9615985e50 |
       +---------+---------------+--------------+
```

communication secured with password. secured channel then used to pass a join tokens.

```bash
Select exactly one disk from each cluster member:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
       | LOCATION |         MODEL          | CAPACITY  | TYPE  |                          PATH                          |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
> [ ]  | micro12  | HL-DT-ST DVD-ROM DU70N | 0B        | cdrom | /dev/disk/by-id/wwn-0x5001480000000000                 |
  [ ]  | micro12  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002fedeb29d615b9b9 |
  [ ]  | micro12  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002fedeb53d8986a2b |
  [ ]  | micro12  | PERC H710              | 465.25GiB | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002ffb0029198533d2 |
       +----------+------------------------+-----------+-------+--------------------------------------------------------
       
Select which disks to wipe:

 Using "/dev/disk/by-id/wwn-0x6c81f660dba9cc002fedeb29d615b9b9" on "micro12" for local storage pool

Would you like to set up distributed storage? (yes/no) [default=yes]:     
Select from the available unpartitioned disks:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
       | LOCATION |         MODEL          | CAPACITY  | TYPE  |                          PATH                          |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+
  [ ]  | micro12  | HL-DT-ST DVD-ROM DU70N | 0B        | cdrom | /dev/disk/by-id/wwn-0x5001480000000000                 |
> [x]  | micro12  | PERC H710              | 1.82TiB   | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002fedeb53d8986a2b |
  [ ]  | micro12  | PERC H710              | 465.25GiB | scsi  | /dev/disk/by-id/wwn-0x6c81f660dba9cc002ffb0029198533d2 |
       +----------+------------------------+-----------+-------+--------------------------------------------------------+

Select which disks to wipe:

 Using 1 disk(s) on "micro12" for remote storage pool

Interface "eno150" ("10.188.50.201/24") detected on cluster member "micro11"
Interface "eno150" ("10.188.50.203/24") detected on cluster member "micro13"
Interface "eno150" ("10.188.50.202/24") detected on cluster member "micro12"

Configure distributed networking? (yes/no) [default=yes]: 
Select an available interface per system to provide external connectivity for distributed network(s):
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+--------+----------+
       | LOCATION | IFACE  |   TYPE   |
       +----------+--------+----------+
  [ ]  | micro12  | eno3   | physical |
> [x]  | micro12  | eno250 | vlan     |
  [ ]  | micro12  | eno350 | vlan     |
  [ ]  | micro12  | eno1   | physical |
  [ ]  | micro12  | eno2   | physical |
       +----------+--------+----------+

Using "eno250" on "micro12" for OVN uplink

Configure dedicated OVN underlay networking? (yes/no) [default=no]:
Configure dedicated OVN underlay networking? (yes/no) [default=no]: 
Initializing new services
Awaiting cluster formation ...
 Peer "micro13" has joined the cluster
Configuring cluster-wide devices ...
MicroCloud is ready

```

## test

```bash
root@micro11:~# microcloud cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:9443 | voter | e31d55ab72d5e9511feb2ca3ba01eaa418c103f1beba91b75d38fb34ec7d809d | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:9443 | voter | 6d9615985e503dd6525900c3193cea884566c01c942c5a672a3dd152a25b9590 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro13 | 10.188.50.203:9443 | voter | de8ffa3eaf8714a70928dd52558b643810b35e1a1434a2dcba95f2cdf4dd7c04 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+

root@micro11:~# microceph cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:7443 | voter | 04402869f5fc1194ac2f1afc7e2e7d3e7a4ac7b73431a50feef52bb5f5f65627 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:7443 | voter | c5d170b0644f6a15d8dfc67aa76ea6d47fab406fe6dc666bcfd3931f7e2ff072 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro13 | 10.188.50.203:7443 | voter | 2daba2858e73c5bba1523164824298a6632dbaac8b2287f8fdf493845ded6548 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
root@micro11:~# microovn cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:6443 | voter | 03b30b5002ec2410bb0055b8e0923fcf8991f6f2cc2d3554c1c8353fa2f93717 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:6443 | voter | 5e7812ab0ac5e92bb416045d646e6821b803ad8888df6374a96ac85184c4df5c | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro13 | 10.188.50.203:6443 | voter | 5ad68a7dd961f6bde0e88862a6fa304b547a3e63bded4f113d3d23feb21bf23f | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+

lxc cluster list
+---------+----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
|  NAME   |            URL             |      ROLES      | ARCHITECTURE | FAILURE DOMAIN | DESCRIPTION | STATE  |      MESSAGE      |
+---------+----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro11 | https://10.188.50.201:8443 | database-leader | x86_64       | default        |             | ONLINE | Fully operational |
|         |                            | database        |              |                |             |        |                   |
+---------+----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro12 | https://10.188.50.202:8443 | database        | x86_64       | default        |             | ONLINE | Fully operational |
+---------+----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro13 | https://10.188.50.203:8443 | database        | x86_64       | default        |             | ONLINE | Fully operational |
+---------+----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+

lxc profile list
+---------+---------------------+---------+
|  NAME   |     DESCRIPTION     | USED BY |
+---------+---------------------+---------+
| default | Default LXD profile | 0       |
+---------+---------------------+---------+

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

```bash
lxc profile set default migration.stateful true
```

## status

```bash
microcloud status

 Status: HEALTHY

┌─────────┬───────────────┬──────┬─────────────────┬────────────────────────┬────────┐
│  Name   │    Address    │ OSDs │ MicroCeph Units │     MicroOVN Units     │ Status │
├─────────┼───────────────┼──────┼─────────────────┼────────────────────────┼────────┤
│ micro11 │ 10.188.50.201 │  1   │   mds,mgr,mon   │ central,chassis,switch │ ONLINE │
│ micro12 │ 10.188.50.202 │  1   │   mds,mgr,mon   │ central,chassis,switch │ ONLINE │
│ micro13 │ 10.188.50.203 │  1   │   mds,mgr,mon   │ central,chassis,switch │ ONLINE │
└─────────┴───────────────┴──────┴─────────────────┴────────────────────────┴────────┘
```

## launch test

```bash
lxc cluster list
lxc launch ubuntu:noble --vm
Launching the instance
Retrieving image: rootfs: 67% (38.78MB/s) 
Retrieving image: Unpacking image: 57%      
Instance name is: open-osprey  
lxc list
+-------------+---------+---------------------+-----------------------------------------------+-----------------+-----------+----------+
|    NAME     |  STATE  |        IPV4         |                     IPV6                      |      TYPE       | SNAPSHOTS | LOCATION |
+-------------+---------+---------------------+-----------------------------------------------+-----------------+-----------+----------+
| open-osprey | RUNNING | 10.233.212.2 (eth0) | fd42:40d7:53e9:d1cc:216:3eff:fed3:c5dc (eth0) | VIRTUAL-MACHINE | 0         | micro11  |
+-------------+---------+---------------------+-----------------------------------------------+-----------------+-----------+----------+
```

## move

```bash
lxc move open-osprey --target micro13
lxc list
+-------------+---------+-----------------------+-------------------------------------------------+-----------------+-----------+----------+
|    NAME     |  STATE  |         IPV4          |                      IPV6                       |      TYPE       | SNAPSHOTS | LOCATION |
+-------------+---------+-----------------------+-------------------------------------------------+-----------------+-----------+----------+
| open-osprey | RUNNING | 10.233.212.2 (enp5s0) | fd42:40d7:53e9:d1cc:216:3eff:fed3:c5dc (enp5s0) | VIRTUAL-MACHINE | 0         | micro13  |
+-------------+---------+-----------------------+-------------------------------------------------+-----------------+-----------+----------+

lxc shell open-osprey
uptime
 23:10:52 up 4 min,  1 user,  load average: 0.04, 0.24, 0.14
```
