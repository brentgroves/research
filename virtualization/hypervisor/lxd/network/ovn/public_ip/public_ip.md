# **[MicroCloud/MicroOvn: exposing containers to the outside world](https://discourse.ubuntu.com/t/microcloud-microovn-exposing-containers-to-the-outside-world/45499)**

Dear all,

Similar to this topic 8, I am trying to expose containers in my MicroCloud setup to “the outside world”, i.e. the rest of my (home) network. My setup is, however, slightly different from the one in the aforementioned topic, so I decided to open a new discussion.

My MicroCloud setup consists of three Lenovo ThinkCentre Tiny M910q computers named wiske{1,2,3}, each with a 256GB NVme SSD (for local storage) and a 2TB SATA SSD (for Ceph).

These snaps are currently installed:

```bash
$ snap list
Name        Version                 Rev    Tracking       Publisher   Notes
core20      20240416                2318   latest/stable  canonical✓  base
core22      20240408                1380   latest/stable  canonical✓  base
lxd         5.21.1-2d13beb          28463  latest/stable  canonical✓  in-cohort
microceph   0+git.4a608fc           793    quincy/stable  canonical✓  in-cohort
microcloud  1.1-04a1c49             734    latest/stable  canonical✓  in-cohort
microovn    22.03.3+snap0e23a0e4f5  395    22.03/stable   canonical✓  in-cohort
snapd       2.63                    21759  latest/stable  canonical✓  snapd
```

Given the compact form factor of these Tiny boxes, they only have one physical NIC installed (and I’m wondering if that is the underlying cause of my problems). After doing a fresh Ubuntu 22.04 server install I reconfigured the NIC on each machine as a bridge. This bridge then gets its IP address assigned via DHCP, but I have configured my router to always give each bridge the same address based on its MAC. My local LAN uses 192.168.10.0/24, with the router’s address being 192.168.10.254. The three bridges in the Tiny’s get assigned 192.168.10.{20,22,24}, respectively.

In the microcloud init phase, I set the address for MicroCloud’s internal traffic to 192.168.10.20, configured 192.168.10.254 as the gateway to the uplink network, set the IPv4 range for LXD to 192.168.10.200–192.168.10.230 (my router’s DHCP range is limited to 192.168.10.1–192.168.10.199 so that shouldn’t interfere).

What (mostly) works:

- I can ping 8.8.8.8 or google.com from the three Tiny machines
- I can ping 8.8.8.8 or google.com from the containers, however, strangely enough, only the first packet of a ping series (ping -c4) gets through. All subsequent ones never make it.
From the Tiny machines, I can ping machines in my local 192.168.10.x network (via IP or DNS entries)
- From the containers, I can ping machines in my local 192.168.10.x network (via IP or DNS entries), again only the first ICMP packet seems to get through.

## host access

```bash
ping canonical.com
PING canonical.com (185.125.190.29) 56(84) bytes of data.
64 bytes from website-content-cache-3.ps5.canonical.com (185.125.190.29): icmp_seq=1 ttl=51 time=97.8 ms
64 bytes from website-content-cache-3.ps5.canonical.com (185.125.190.29): icmp_seq=2 ttl=51 time=98.2 ms
64 bytes from website-content-cache-3.ps5.canonical.com (185.125.190.29): icmp_seq=3 ttl=51 time=98.1 ms
64 bytes from website-content-cache-3.ps5.canonical.com (185.125.190.29): icmp_seq=4 ttl=51 time=97.8 ms
^C
--- canonical.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 97.790/97.982/98.231/0.192 ms

```

## container access

```bash
lxc init ubuntu:24.04 ubuntu-vm --vm
lxc config show c1 --expanded
# lxc start c1 --console
lxc exec c1 -- bash

