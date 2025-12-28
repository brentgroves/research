# **[](https://albertomolina.wordpress.com/2022/06/10/openvswitch-basic-usage/)**

Open vSwitch (OVS) is an open source OpenFlow implementation mainly used in virtualized environments. OpenvSwitch has a lot of features and it can be confusing when starting out, so the idea is to write several post with information related to the the use of OpenvSwitch, virtual network interfaces and related items, which can be used as a reference in the future

To start working with OVS only a linux box is needed (debian of course! :) ) and OVS is installed just with the openvswitch-switch package:

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

```bash
ovs-vsctl br-add br1

ovs-vsctl show 
572ef28b-6429-4a71-aad8-f634d8274930
    Bridge br1
        Port br1
            Interface br1
                type: internal
    ovs_version: "2.15.0"

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

netdevice - low-level access to Linux network devices. SYNOPSIS top #include <sys/ioctl.h> #include <net/if.h> DESCRIPTION top NOTES top

## LXC test environment

Once OVS is installed on the host machine, several virtual instances can be created to connect to OVS bridges and to interact to each other. In this case we’re going to use LXC (linux containers), but any other virtualization technology can be used.

The default bridge used can be changed to br1 on /etc/lxc/default.conf, and the container can be easily created:

```bash
snap install lxd --channel=5.21/stable --cohort="+"
snap refresh --hold lxd
lxc init ubuntu:24.04 uvm1 --device root,size=50GiB --config limits.cpu=2 --config limits.memory=8GiB --vm
```

## **[basic ovn/lxd setup](https://documentation.ubuntu.com/lxd/latest/howto/network_ovn_setup/#how-to-set-up-ovn-with-lxd)**

```bash
lxc start uvm1
lxc exec uvm1 -- bash
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

## Minimal setup

To create a minimal setup with default options, you can skip the configuration steps by adding the --minimal flag to the lxd init command:

`lxd init --minimal`
Note

The minimal setup provides a basic configuration, but the configuration is not optimized for speed or functionality. Especially the dir storage driver, which is used by default, is slower than other drivers and doesn’t provide fast snapshots, fast copy/launch, quotas and optimized backups.

If you want to use an optimized setup, go through the interactive configuration process instead.

See the following sections for how to set up a basic OVN network, either as a standalone network or to host a small LXD cluster.

## Set up a standalone OVN network

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

**[look at tests](https://github.com/lxc/lxc-ci/blob/main/bin/test-incus-network-ovn)**

```c
ovn_basic_tests() {
    incus network create incusbr0 \
        ipv4.address=10.10.10.1/24 ipv4.nat=true \
        ipv4.dhcp.ranges=10.10.10.2-10.10.10.199 \
        ipv4.ovn.ranges=10.10.10.200-10.10.10.254 \
        ipv6.address=fd42:4242:4242:1010::1/64 ipv6.nat=true \
        ipv6.ovn.ranges=fd42:4242:4242:1010::200-fd42:4242:4242:1010::254
```

```bash
# https://discuss.linuxcontainers.org/t/static-ip-addresses-dhcp-ranges-and-non-interactive-network-configuration-commands/8282
# lxc network set <parent_network> ipv4.dhcp.ranges=<IP_range> ipv4.ovn.ranges=<IP_range>
lxc network set lxdbr0 ipv4.dhcp.ranges=10.1.10.200-10.1.10.254 ipv4.ovn.ranges=10.1.10.1-10.1.10.254
Error: Failed parsing ipv4.ovn.ranges: IP range "10.1.10.1-10.1.10.254" does not fall within any of the allowed networks [10.215.235.0/24]

# ipv4.ovn.ranges -> IPv4 ranges to use for child OVN network routers
lxc network set lxdbr0 ipv4.dhcp.ranges=10.215.235.2-10.215.235.199 ipv4.ovn.ranges=10.215.235.205-10.215.235.254
# lxc network create ovntest --type=ovn network=<parent_network>
lxc network create ovntest --type=ovn network=lxdbr0
Network ovntest created

```

## 4.Create an instance that uses the ovntest network

```bash
lxc init ubuntu:24.04 c1
lxc config device override c1 eth0 network=ovntest
lxc start c1
```
