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

 
thorn jukebox enchilada gnomish

Verify the fingerprint "c2e0d413926f" is displayed on joining systems.
Waiting to detect systems ...
Error: System "micro12" failed to join the cluster: Failed to update cluster status of services: Failed to join "LXD" cluster: Failed to configure cluster: Failed to setup cluster trust: Failed to add server cert to cluster: The provided certificate isn't valid yet
micro11 date
Mon Jul 14 11:30:28 PM UTC 2025
micro12
Mon Jul 14 11:35:14 PM UTC 2025
micro13
Mon Jul 14 11:35:14 PM UTC 2025
# password
```

```bash
# micro12
# multicast allowed
microcloud join
# unicast only
microcloud join --initiator-address 10.188.50.201

microcloud join --initiator-address 10.188.50.201
Waiting for services to start ...
Select an address for MicroCloud's internal traffic:

 Using address "10.188.50.202" for MicroCloud

Verify the fingerprint "6d9615985e50" is displayed on the other system.
Specify the passphrase for joining the system: thorn jukebox enchilada gnomish

 Found system "micro11" at "10.188.50.201" using fingerprint "7b580ad43271"

Select "micro12" on "micro11" to let it join the cluster

```

```bash
# micro11
Select the systems that should join the cluster:
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +---------+---------------+--------------+
       |  NAME   |    ADDRESS    | FINGERPRINT  |
       +---------+---------------+--------------+
> [x]  | micro12 | 10.188.50.202 | 6d9615985e50 |
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

Do you want to encrypt the selected disks? (yes/no) [default=no]:
Interface "eno150" ("10.188.50.202/24") detected on cluster member "micro12"
Interface "eno150" ("10.188.50.201/24") detected on cluster member "micro11" 

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
Initializing new services
Awaiting cluster formation ...
 Peer "micro12" has joined the cluster
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
| micro12 | 10.188.50.202:9443 | spare | 6d9615985e503dd6525900c3193cea884566c01c942c5a672a3dd152a25b9590 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+

root@micro11:~# microceph cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:7443 | voter | 04402869f5fc1194ac2f1afc7e2e7d3e7a4ac7b73431a50feef52bb5f5f65627 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:7443 | spare | c5d170b0644f6a15d8dfc67aa76ea6d47fab406fe6dc666bcfd3931f7e2ff072 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
root@micro11:~# microovn cluster list
+---------+--------------------+-------+------------------------------------------------------------------+--------+
|  NAME   |      ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro11 | 10.188.50.201:6443 | voter | 03b30b5002ec2410bb0055b8e0923fcf8991f6f2cc2d3554c1c8353fa2f93717 | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+
| micro12 | 10.188.50.202:6443 | spare | 5e7812ab0ac5e92bb416045d646e6821b803ad8888df6374a96ac85184c4df5c | ONLINE |
+---------+--------------------+-------+------------------------------------------------------------------+--------+

lxc cluster list
To start your first container, try: lxc launch ubuntu:24.04
Or for a virtual machine: lxc launch ubuntu:24.04 --vm

+---------+----------------------------+------------------+--------------+----------------+-------------+--------+-------------------+
|  NAME   |            URL             |      ROLES       | ARCHITECTURE | FAILURE DOMAIN | DESCRIPTION | STATE  |      MESSAGE      |
+---------+----------------------------+------------------+--------------+----------------+-------------+--------+-------------------+
| micro11 | https://10.188.50.201:8443 | database-leader  | x86_64       | default        |             | ONLINE | Fully operational |
|         |                            | database         |              |                |             |        |                   |
+---------+----------------------------+------------------+--------------+----------------+-------------+--------+-------------------+
| micro12 | https://10.188.50.202:8443 | database-standby | x86_64       | default        |             | ONLINE | Fully operational |
+---------+----------------------------+------------------+--------------+----------------+-------------+--------+-------------------+

microcloud status

 Status: WARNING

 ┃ ! Reliability risk: 3 systems are required for effective fault tolerance
 ┃ ! Data loss risk: MicroCeph OSD replication recommends at least 3 disks across 3 systems

┌─────────┬───────────────┬──────┬─────────────────┬────────────────────────┬────────┐
│  Name   │    Address    │ OSDs │ MicroCeph Units │     MicroOVN Units     │ Status │
├─────────┼───────────────┼──────┼─────────────────┼────────────────────────┼────────┤
│ micro11 │ 10.188.50.201 │  1   │   mds,mgr,mon   │ central,chassis,switch │ ONLINE │
│ micro12 │ 10.188.50.202 │  1   │   mds,mgr,mon   │ central,chassis,switch │ ONLINE │
└─────────┴───────────────┴──────┴─────────────────┴────────────────────────┴────────┘
```

## move

```bash
lxc move v1 --target micro13
ERROR
