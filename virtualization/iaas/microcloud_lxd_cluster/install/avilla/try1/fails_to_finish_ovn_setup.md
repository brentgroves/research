# **[Fails to finish setting up OVN network (ovn-nbctl: database connection failed (End of file)) #175](<https://github.com/canonical/microcloud/issues/175>)**

Had tried deploying microcloud on freshly installed Ubuntu 22.04 servers (3 nodes). I did have to reinstall lxd snap (as it had 5.0 version after OS installation, updated to latest/stable - 5.18-db8c6f9 after having some other issues related to this: #107). So before microcloud init I have the following snaps installed:

ubuntu@microcloud1:~$ sudo snap list
Name        Version                 Rev    Tracking       Publisher   Notes
core20      20230622                1974   latest/stable  canonical✓  base
core22      20230801                864    latest/stable  canonical✓  base
lxd         5.18-db8c6f9            25846  latest/stable  canonical✓  -
microceph   0+git.e327ed3           692    quincy/stable  canonical✓  -
microcloud  0+git.9cb7ccd           412    latest/stable  canonical✓  -
microovn    22.03.2+snap4a6fea39cd  244    22.03/stable   canonical✓  -
snapd       2.59.5                  19457  latest/stable  canonical✓  snapd

```bash
ubuntu@microcloud1:~$ sudo microcloud init
Using address "10.8.16.251" for MicroCloud
Limit search for other MicroCloud servers to 10.8.16.251/24? (yes/no) [default=yes]: 
Scanning for eligible servers ...

 Selected "microcloud2" at "10.8.16.224"
 Selected "microcloud3" at "10.8.16.223"

Would you like to set up local storage? (yes/no) [default=yes]: 
Select exactly one disk from each cluster member:

Select which disks to wipe:

 Using "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi2" on "microcloud1" for local storage pool
 Using "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi2" on "microcloud2" for local storage pool
 Using "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi2" on "microcloud3" for local storage pool

Would you like to set up distributed storage? (yes/no) [default=yes]: 
Select from the available unpartitioned disks:

Select which disks to wipe:

 Using 1 disk(s) on "microcloud1" for remote storage pool
 Using 1 disk(s) on "microcloud2" for remote storage pool
 Using 1 disk(s) on "microcloud3" for remote storage pool

Configure distributed networking? (yes/no) [default=yes]: 

 Using "ens20" on "microcloud3" for OVN uplink
 Using "ens20" on "microcloud1" for OVN uplink
 Using "ens20" on "microcloud2" for OVN uplink

Specify the IPv4 gateway (CIDR) on the uplink network (empty to skip IPv4): 10.8.17.1/24
Specify the first IPv4 address in the range to use with LXD: 10.8.17.2
Specify the last IPv4 address in the range to use with LXD: 10.8.17.14
Specify the IPv6 gateway (CIDR) on the uplink network (empty to skip IPv6): 
Initializing a new cluster
 Local MicroCloud is ready
 Local LXD is ready
 Local MicroOVN is ready
 Local MicroCeph is ready
Awaiting cluster formation ...
 Peer "microcloud2" has joined the cluster
 Peer "microcloud3" has joined the cluster
Cluster initialization is complete
Error: Failed to run: ovn-nbctl --timeout=10 --db tcp:10.8.16.251:6641,tcp:10.8.16.224:6641,tcp:10.8.16.223:6641 --wait=sb ha-chassis-group-add lxd-net2: exit status 1 (ovn-nbctl: tcp:10.8.16.251:6641,tcp:10.8.16.224:6641,tcp:10.8.16.223:6641: database connection failed (End of file))
```

my error

```bash
 Error: Failed to notify peer micro13 at 10.188.50.203:8443: Failed getting port group UUID for network "default" setup: Failed to run: ovn-nbctl --timeout=10 --db ssl:10.188.50.201:6641,ssl:10.188.50.203:6641,ssl:10.188.50.202:6641 -c /proc/self/fd/3 -p /proc/self/fd/4 -C /proc/self/fd/5 --wait=sb --format=csv --no-headings --data=bare --colum=_uuid,name,acl find port_group name=lxd_net2: exit status 1 (2025-07-10T22:16:17Z|00001|stream_ssl|WARN|SSL_read: error:0A000412:SSL routines::sslv3 alert bad certificate
2025-07-10T22:16:17Z|00002|jsonrpc|WARN|ssl:10.188.50.201:6641: receive error: Input/output error
2025-07-10T22:16:17Z|00003|reconnect|WARN|ssl:10.188.50.201:6641: connection dropped (Input/output error)
ovn-nbctl: ssl:10.188.50.201:6641,ssl:10.188.50.203:6641,ssl:10.188.50.202:6641: database connection failed (Connection refused))
```

Any idea what I'm missing here? I can provide other logs if needed.

I also have found some microovn logs:

```bash
2023-10-04T15:03:36Z ovsdb-server[117841]: ovs|00021|stream_ssl|WARN|SSL_accept: error:0A00010B:SSL routines::wrong version number
2023-10-04T15:03:36Z ovsdb-server[117841]: ovs|00022|stream_ssl|WARN|ssl:[::ffff:10.8.16.251]:57070: received JSON-RPC data on SSL channel
2023-10-04T15:03:36Z ovsdb-server[117841]: ovs|00023|jsonrpc|WARN|ssl:[::ffff:10.8.16.251]:57070: receive error: Protocol error
2023-10-04T15:03:36Z ovsdb-server[117841]: ovs|00024|reconnect|WARN|ssl:[::ffff:10.8.16.251]:57070: connection dropped (Protocol error)
```

Could this actually be a microovn issue actually? As far as I can tell, at this point, microcloud fails to create the actual OVN network
(I get the same message when executing lxc network create default --type=ovn network=UPLINK).

From cursory view:

Error: Failed to run: ovn-nbctl --timeout=10 --db tcp:10.8.16.251:6641,tcp:10.8.16.224:6641,tcp:10.8.16.223:6641 --wait=sb ha-chassis-group-add lxd-net2: exit status 1 (ovn-nbctl: tcp:10.8.16.251:6641,tcp:10.8.16.224:6641,tcp:10.8.16.223:6641: database connection failed (End of file))

That message indicates to me that LXD thinks it should use OVN from the system and not from the MicroOVN snap. MicroOVN uses TLS by default and provides ssl:x.x.x.x:nnnn values in the connection string provided in its environment file.

Does it help to install/restart LXD as the last snap to ensure it detects the presence of MicroOVN?

```bash
ovn-nbctl show

https://canonical-microovn.readthedocs-hosted.com/en/latest/how-to/tls/
sudo microovn certificates list
[sudo] password for brent: 
[OVN CA]
/var/snap/microovn/common/data/pki/cacert.pem (OK: Present)

[OVN Northbound Service]
/var/snap/microovn/common/data/pki/ovnnb-cert.pem (OK: Present)
/var/snap/microovn/common/data/pki/ovnnb-privkey.pem (OK: Present)

[OVN Southbound Service]
/var/snap/microovn/common/data/pki/ovnsb-cert.pem (OK: Present)
/var/snap/microovn/common/data/pki/ovnsb-privkey.pem (OK: Present)

[OVN Northd Service]
/var/snap/microovn/common/data/pki/ovn-northd-cert.pem (OK: Present)
/var/snap/microovn/common/data/pki/ovn-northd-privkey.pem (OK: Present)

[OVN Chassis Service]
/var/snap/microovn/common/data/pki/ovn-controller-cert.pem (OK: Present)
/var/snap/microovn/common/data/pki/ovn-controller-privkey.pem (OK: Present)

[Client]
/var/snap/microovn/common/data/pki/client-cert.pem (OK: Present)
/var/snap/microovn/common/data/pki/client-privkey.pem (OK: Present)
```

<https://canonical-microovn.readthedocs-hosted.com/en/latest/how-to/tls/#common-issues>

This section contains some well known or expected issues that you can encounter.

I’m getting failed to load certificates error
If you run commands like ovn-sbctl and you get complaints about missing certificates while the rest of the commands seem to work fine.

Example:

ovn-sbctl show
Example output:

2023-06-14T15:09:31Z|00001|stream_ssl|ERR|SSL_use_certificate_file: error:80000002:system library::No such file or directory
2023-06-14T15:09:31Z|00002|stream_ssl|ERR|SSL_use_PrivateKey_file: error:10080002:BIO routines::system lib
2023-06-14T15:09:31Z|00003|stream_ssl|ERR|failed to load client certificates from /var/snap/microovn/common/data/pki/cacert.pem: error:0A080002:SSL routines::system lib
Chassis microovn-0
    hostname: microovn-0
    Encap geneve
        ip: "10.5.3.129"
        options: {csum="true"}
