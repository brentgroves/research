# try 5

Try adding 1 node only after initializing a single node cluster.

## try 4 issue

when joining node received an error concerning the trust certificate not valid yet. Checked the times on the initiator was 5 minutes behind the node being added. I believe the joining node creates a trust certificates with a valid date range beginning at creation time.  Since joining node was 5 minutes in the future compared to the initiator. The initiator said it could not establish a trusted connection. Found that I had to change to Linamar NTP server addresses in Ubuntu so that the times could all be in sync.

```bash
Error: System "micro12" failed to join the cluster: Failed to update cluster status of services: Failed to join "LXD" cluster: Failed to configure cluster: Failed to setup cluster trust: Failed to add server cert to cluster: The provided certificate isn't valid yet
micro11 date
Mon Jul 14 11:30:28 PM UTC 2025
micro12
Mon Jul 14 11:35:14 PM UTC 2025
micro13
Mon Jul 14 11:35:14 PM UTC 2025
# password
```

[text](../../../../../timesync/ubuntu_24_04/setup_timesyncd.md) [text](../../../../../timesync/ubuntu_24_04/timesyncd_linamar.conf)

```bash
sudo snap install lxd --channel=5.21/stable --cohort="+"
sudo snap install microceph --channel=squid/stable --cohort="+"
sudo snap install microovn --channel=24.03/stable --cohort="+"
sudo snap install microcloud --channel=2/stable --cohort="+"
```

To indefinitely hold all updates to the snaps needed for MicroCloud, run:

`sudo snap refresh --hold lxd microceph microovn microcloud`

```bash
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

lsblk
NAME                      MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
loop0                       7:0    0  66.8M  1 loop /snap/core24/1006
loop1                       7:1    0  73.9M  1 loop /snap/core22/2010
loop2                       7:2    0  73.9M  1 loop /snap/core22/2045
loop3                       7:3    0  50.9M  1 loop /snap/snapd/24718
loop4                       7:4    0  49.3M  1 loop /snap/snapd/24792
loop5                       7:5    0  66.8M  1 loop /snap/core24/1055
loop6                       7:6    0 111.8M  1 loop /snap/microceph/1393
loop7                       7:7    0  21.1M  1 loop /snap/microovn/667
loop8                       7:8    0 114.4M  1 loop /snap/lxd/33110
loop9                       7:9    0  10.4M  1 loop /snap/microcloud/1144
sda                         8:0    0 278.9G  0 disk 
├─sda1                      8:1    0     1G  0 part /boot/efi
├─sda2                      8:2    0     2G  0 part /boot
└─sda3                      8:3    0 275.8G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0   270G  0 lvm  /
sdb                         8:16   0   1.8T  0 disk 
sdc                         8:32   0   1.8T  0 disk 
sdd                         8:48   0 465.3G  0 disk 
sde                         8:64   0   1.9G  0 disk 
└─sde1                      8:65   0   1.9G  0 part 
sr0                        11:0    1  1024M  0 rom 
```

## initialize single-node microcloud

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
Using 1 disk(s) on "micro11" for remote storage pool

Do you want to encrypt the selected disks? (yes/no) [default=no]: no
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
  [ ]  | micro11  | eno1   | physical |
  [ ]  | micro11  | eno2   | physical |
  [ ]  | micro11  | eno3   | physical |
> [x]  | micro11  | eno250 | vlan     |
  [ ]  | micro11  | eno350 | vlan     |
       +----------+--------+----------+

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
```
