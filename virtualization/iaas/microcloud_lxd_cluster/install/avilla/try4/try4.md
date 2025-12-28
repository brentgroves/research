# try 4

Failed adding 1 node to the cluster.

## issue

when joining node received an error concerning the trust certificate not valid yet. Checked the times on the initiator was 5 minutes behind the node being added. I believe the joining node creates a trust certificates with a valid date range beginning at creation time.  Since joining node was 5 minutes in the future compared to the initiator. The initiator said it could not establish a trusted connection. found that I had to change the NTP server addresses in Ubuntu so that the times could all be in sync.

```bash
Initializing new services
Awaiting cluster formation ...
Error: System "micro12" failed to join the cluster: Failed to update cluster status of services: Failed to join "MicroCeph" cluster: failed to request disk addition Post "<http://control.socket/1.0/services/microceph/1.0/disks>": context deadline exceeded
```

## Network interface for intra-cluster traffic

- MicroCloud's internal traffic could be on `eno1220`. Don't think it needs a connection to the internet.
- Cephs internal network could also be on `eno1220`.

## Network interface to connect to the uplink network

MicroCloud requires one network interface for connecting OVN to the uplink network. This network interface must either be an unused interface that does not have an IP address configured, or a bridge.

This network interface could be given select internet connectivity and cannot have an IP address. so we could use `eno250` or `eno350`. This would give clients access to Ceph storage from the 10.188.50.0/24 network.

## Router IP for virtual network

Noticed that the VM did not have an ip address in the range given for OVNs uplink.  The speaker said these ip addresses are used for the router ips for the virtual networks.

Using "eno250" on "micro11" for OVN uplink

Specify the IPv4 gateway (CIDR) on the uplink network (empty to skip IPv4): 10.188.50.254/24
Specify the first IPv4 address in the range to use on the uplink network: 10.188.50.206
Specify the last IPv4 address in the range to use on the uplink network: 10.188.50.212

## try 3

- The IP rang 10.188.50.[200-212] has access to the internet. micro11,micro12, and micro13 consume 10.188.50.[201-203] and 10.188.50.205 is in use by the dhcp server. select ip range of 10.188.50.[206-212] to be used by containers and VM.
- Encrypt the disk
  - The dm-crypt kernel module must be available. Note that some cloud-optimised kernels do not ship dm-crypt by default. Check by running `sudo modinfo dm-crypt`
  - The snap dm-crypt plug has to be connected, and microceph.daemon subsequently restarted:

```bash
sudo snap connect microceph:dm-crypt
sudo snap restart microceph.daemon
```

- use en0250/vlan50 for ceph internal and public network

THIS COULD BE AN ISSUE BECAUSE ON TRY1
the public network in Ceph needs to be accessible by Ceph clients and daemons involved in client communication, as it acts as the primary network for accessing the Ceph Storage Cluster.

Cluster Network: This private network is dedicated to internal Ceph operations like OSD heartbeats, data replication, backfilling, and recovery. This separation improves performance by isolating the heavy replication traffic and enhances security by making the cluster network less accessible from external sources like the public network or the internet.

## try 2 summary

- On try 2 I selected address range 10.188.50.6 - 10.188.50.12 this is not what I wanted because these IP addresses can not access the internet.

- Did not encrypt disk.

Do you want to encrypt the selected disks? (yes/no) [default=no]: no

- selected the microcloud internal subnet for both internal and public traffic

What subnet (either IPv4 or IPv6 CIDR notation) would you like your Ceph internal traffic on? [default: 10.188.50.0/24]
What subnet (either IPv4 or IPv6 CIDR notation) would you like your Ceph public traffic on? [default: 10.188.50.0/24]

# **[try 2 - single node setup from video](https://www.youtube.com/watch?v=M0y0hQ16YuE&t=359s)**

**[try 2 - single node setup](https://documentation.ubuntu.com/microcloud/latest/microcloud/tutorial/get_started/)**

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

`sudo snap refresh --hold lxd microceph microovn microcloud`

```bash
