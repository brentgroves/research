# **[Create a forward in an OVN network](https://documentation.ubuntu.com/lxd/stable-5.21/howto/network_forwards/#create-a-forward-in-an-ovn-network)**

You must configure the **[allowed listen addresses](https://documentation.ubuntu.com/lxd/stable-5.21/howto/network_forwards/#network-forwards-listen-addresses)** before you can create a forward in an OVN network.

The IP addresses and ports shown in the examples below are only examples. It is up to you to choose the allowed and available addresses and ports for your setup.

## issue

<https://discourse.ubuntu.com/t/microcloud-exposing-an-instance-on-an-external-ip/43905>

Hi, I’m having trouble configuring external access to an instance within Microcloud.

I followed the tutorial Get started with MicroCloud (very helpful btw, thank you) and things seem to be set up correctly…I’m able to launch/create instances and those instances can ping each other and the external world. Where I’m struggling is with allowing access from outside the cluster (or even from one of the cluster nodes to a instance), I suspect this maybe be my lack of understanding with respect to lxc/ovn forwarding/routing.

I’ve looked in the command cheat sheet at the “Expose an instance on an external IP” section. This doesn’t seem to work for me (is there a syntax error here?). Following the links to the documentation How to configure network forwards it seems like the syntax is different. Unfortunately, I still can’t get it working and I suspect this is due to something to do with routes and/or my lack of understanding. Here’s details on the cluster, what I’ve tried, and what errors I’m running into (thanks in advance for your time/help):

```bash
lxc cluster ls

+---------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
|     NAME      |             URL             |      ROLES      | ARCHITECTURE | FAILURE DOMAIN | DESCRIPTION | STATE  |      MESSAGE      |
+---------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro-node-01 | https://10.190.176.149:8443 | database-leader | x86_64       | default        |             | ONLINE | Fully operational |
|               |                             | database        |              |                |             |        |                   |
+---------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro-node-02 | https://10.190.176.176:8443 | database        | x86_64       | default        |             | ONLINE | Fully operational |
+---------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro-node-03 | https://10.190.176.163:8443 | database        | x86_64       | default        |             | ONLINE | Fully operational |
+---------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
```

```bash
lxc network ls

+---------+----------+---------+----------------+---------------------------+-------------+---------+---------+
|  NAME   |   TYPE   | MANAGED |      IPV4      |           IPV6            | DESCRIPTION | USED BY |  STATE  |
+---------+----------+---------+----------------+---------------------------+-------------+---------+---------+
| UPLINK  | physical | YES     |                |                           |             | 1       | CREATED |
+---------+----------+---------+----------------+---------------------------+-------------+---------+---------+
| br-int  | bridge   | NO      |                |                           |             | 0       |         |
+---------+----------+---------+----------------+---------------------------+-------------+---------+---------+
| default | ovn      | YES     | 10.24.241.1/24 | fd42:e7f6:6278:66e3::1/64 |             | 4       | CREATED |
+---------+----------+---------+----------------+---------------------------+-------------+---------+---------+
| enp5s0  | physical | NO      |                |                           |             | 0       |         |
+---------+----------+---------+----------------+---------------------------+-------------+---------+---------+
| enp6s0  | physical | NO      |                |                           |             | 1       |         |
+---------+----------+---------+----------------+---------------------------+-------------+---------+---------+
| lxdovn1 | bridge   | NO      |                |                           |             | 0       |         |
+---------+----------+---------+----------------+---------------------------+-------------+---------+---------+

```

```bash
lxc network show default

config:
  bridge.mtu: "1442"
  ipv4.address: 10.24.241.1/24
  ipv4.nat: "true"
  ipv6.address: fd42:e7f6:6278:66e3::1/64
  ipv6.nat: "true"
  network: UPLINK
  volatile.network.ipv4.address: 10.38.122.100
  volatile.network.ipv6.address: fd42:86ee:ffe1:1529:216:3eff:fe97:935d
description: ""
name: default
type: ovn
used_by:
- /1.0/instances/u1
- /1.0/instances/u2
- /1.0/instances/u3
- /1.0/profiles/default
managed: true
status: Created
locations:
- micro-node-01
- micro-node-02
- micro-node-03
```

```bash
lxc network show UPLINK

config:
  ipv4.gateway: 10.38.122.1/24
  ipv4.ovn.ranges: 10.38.122.100-10.38.122.254
  ipv6.gateway: fd42:86ee:ffe1:1529::1/64
  volatile.last_state.created: "false"
description: ""
name: UPLINK
type: physical
used_by:

- /1.0/networks/default
managed: true
status: Created
locations:
- micro-node-01
- micro-node-02
- micro-node-03
```

Note: I don’t have a ipv4.routes: section
then listing the instances

```bash
lxc ls

+------+---------+----------------------+-------------------------------------------------+-----------------+-----------+---------------+
| NAME |  STATE  |         IPV4         |                      IPV6                       |      TYPE       | SNAPSHOTS |   LOCATION    |
+------+---------+----------------------+-------------------------------------------------+-----------------+-----------+---------------+
| u1   | RUNNING | 10.24.241.2 (eth0)   | fd42:e7f6:6278:66e3:216:3eff:feed:53d0 (eth0)   | CONTAINER       | 0         | micro-node-01 |
+------+---------+----------------------+-------------------------------------------------+-----------------+-----------+---------------+
| u2   | RUNNING | 10.24.241.3 (eth0)   | fd42:e7f6:6278:66e3:216:3eff:fea6:b07 (eth0)    | CONTAINER       | 0         | micro-node-02 |
+------+---------+----------------------+-------------------------------------------------+-----------------+-----------+---------------+
| u3   | RUNNING | 10.24.241.4 (enp5s0) | fd42:e7f6:6278:66e3:216:3eff:fefd:35ea (enp5s0) | VIRTUAL-MACHINE | 0         | micro-node-03 |
+------+---------+----------------------+-------------------------------------------------+-----------------+-----------+---------------+
```

testing access/connectivity
ping instance u1 from micro-node-01

root@micro-node-01:~# ping -c 3 10.24.241.2
PING 10.24.241.2 (10.24.241.2) 56(84) bytes of data.

--- 10.24.241.2 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2050ms
then login to u1

lxc shell u1
and test connectivity

ping api.snapcraft.io
root@u1:~# ping -c 3 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=16.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=9.72 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=57 time=12.7 ms

--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 9.722/12.992/16.584/2.810 ms
root@u1:~# ping -c 3 10.24.241.3
PING 10.24.241.3 (10.24.241.3) 56(84) bytes of data.
64 bytes from 10.24.241.3: icmp_seq=1 ttl=64 time=1.63 ms
64 bytes from 10.24.241.3: icmp_seq=2 ttl=64 time=0.905 ms
64 bytes from 10.24.241.3: icmp_seq=3 ttl=64 time=0.874 ms

--- 10.24.241.3 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 0.874/1.137/1.634/0.351 ms
root@u1:~# curl google.com
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
so it looks like connectivity works for egress.

## Trying to configure ingress

This is where I’m struggling.
On micro-node-01 ping the router

`ping -c 3 10.38.122.100`

Now I’m trying to configure a forward so that the external IP address 10.38.122.101 get forwarded to u1 at 10.24.241.2, but I suspect I’m misunderstanding/missing something. Here’s what I’ve tried:

lxc network forward create default 10.38.122.101 target_address=10.24.241.2
Error: Failed creating forward: Uplink network doesn't contain "10.38.122.101/32" in its routes
So, I suspect I need to add a route or something like a **[routing relationship](https://documentation.ubuntu.com/lxd/en/latest/howto/network_ovn_peers/)**, but I’m a confused on how I would do this for this case or if this is even the right approach?

From my MicroCloud set up

```bash
root@micro-node-01:~# microcloud init
Waiting for LXD to start...
Select an address for MicroCloud's internal traffic:

You must select exactly one address
Retry selecting an address? (yes/no) [default=yes]:
Select an address for MicroCloud's internal traffic:

 Using address "10.190.176.149" for MicroCloud

Limit search for other MicroCloud servers to 10.190.176.149/24? (yes/no) [default=yes]:
Scanning for eligible servers ...

 Selected "micro-node-03" at "10.190.176.163"
 Selected "micro-node-01" at "10.190.176.149"
 Selected "micro-node-02" at "10.190.176.176"

Would you like to set up local storage? (yes/no) [default=yes]:
Select exactly one disk from each cluster member:

Select which disks to wipe:

 Using "/dev/disk/by-id/scsi-SQEMU_QEMU_HARDDISK_lxd_local1" on "micro-node-01" for local storage pool
 Using "/dev/disk/by-id/scsi-SQEMU_QEMU_HARDDISK_lxd_local2" on "micro-node-02" for local storage pool
 Using "/dev/disk/by-id/scsi-SQEMU_QEMU_HARDDISK_lxd_local3" on "micro-node-03" for local storage pool

Would you like to set up distributed storage? (yes/no) [default=yes]:
Select from the available unpartitioned disks:

Select which disks to wipe:

 Using 1 disk(s) on "micro-node-02" for remote storage pool
 Using 1 disk(s) on "micro-node-03" for remote storage pool
 Using 1 disk(s) on "micro-node-01" for remote storage pool

Configure distributed networking? (yes/no) [default=yes]:
Select exactly one network interface from each cluster member:

 Using "enp6s0" on "micro-node-03" for OVN uplink
 Using "enp6s0" on "micro-node-01" for OVN uplink
 Using "enp6s0" on "micro-node-02" for OVN uplink

Specify the IPv4 gateway (CIDR) on the uplink network (empty to skip IPv4): 10.38.122.1/24
Specify the first IPv4 address in the range to use with LXD: 10.38.122.100
Specify the last IPv4 address in the range to use with LXD: 10.38.122.254
Specify the IPv6 gateway (CIDR) on the uplink network (empty to skip IPv6): fd42:86ee:ffe1:1529::1/64
Initializing a new cluster
 Local MicroCloud is ready
 Local LXD is ready
 Local MicroOVN is ready
 Local MicroCeph is ready
Awaiting cluster formation ...
 Peer "micro-node-02" has joined the cluster
 Peer "micro-node-03" has joined the cluster
Configuring cluster-wide devices ...
MicroCloud is ready
```

To me it seems like the range 10.38.122.100-10.38.122.254 would be my “floating-ips” and this is how I’d configure external access to my MicroCloud instances. Is this correct?

I hope this is sufficient background/information. Please let me know if you need anything else.

## Questions

Am I on the right track to configuring external access to instances?
What am I missing or what are my misconcerptions?
Is there a toy example I can follow to configure external access to one of the instances?
Thanks for reading all this :smile:

## answer

Error: Failed creating forward: Uplink network doesn't contain "10.38.122.101/32" in its routes

This error means that the OVN networks connected to the UPLINK network are not permitted to use (and thus advertise to the uplink network) those IPs because the UPLINK network hasn’t been configured by the admin (you) to allow it.

So you should be able to do this:

`lxc network set UPLINK ipv4.routes=10.38.122.101/32`

Or if you want to set up multiple listeners on external IPs you can use a wider CIDR or multiple items in a comma separated list, e.g.

`lxc network set UPLINK ipv4.routes=10.38.122.0/24,192.168.1.2/32`

Then you should be able to create the network forward and the OVN virtual router should respond to ARP requests on the UPLINK network for that IP and then forward via DNAT into your instance.

```bash
lxc network set UPLINK ipv4.routes 10.188.50.207/32
lxc network show UPLINK
config:
...
ipv4.routes: 10.188.50.207/32
...
```

To me it seems like the range 10.38.122.100-10.38.122.254 would be my “floating-ips” and this is how I’d configure external access to my MicroCloud instances. Is this correct?

LXD doesn’t support ranges for ipv4.routes, but you can use CIDR format to delegate an entire subnet for use by OVN networks.

## create forward

### external

Now the ovn network is allowed to add a listener to UPLINK.

```bash
lxc network set UPLINK ipv4.routes=10.188.50.207/32
lxc network show UPLINK
lxc network forward create default 10.188.50.207
lxc network show default
```

## internal

Could not get this to work.

```bash
lxc network set UPLINK ipv4.routes=10.188.50.207/32,10.233.212.200/32
lxc network show UPLINK
lxc network forward create default 10.233.212.200
lxc network forward ls default

lxc network forward edit default 10.233.212.200
lxc network forward show default 10.233.212.200
```

Configure static IPs for containers (if needed): If your containers have dynamic IPs, it's best to configure them with static IPs using lxc config device set <instance> ipv4.address=<ip_address> to ensure the forward always points to the correct instance.
