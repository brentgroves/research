# **[How to configure network forwards](https://documentation.ubuntu.com/lxd/latest/howto/network_forwards/)**

## **[ref](https://www.youtube.com/watch?v=vYK1aLSDVIw)**

Network forwards are available for the OVN network and the Bridge network.

Network forwards allow an external IP address (or specific ports on it) to be forwarded to an internal IP address (or specific ports on it) in the network that the forward belongs to.

This feature can be useful if you have limited external IP addresses and want to share a single external address between multiple instances. In this case, you have two options:

- Forward all traffic from the external address to the internal address of one instance. This method makes it easy to move the traffic destined for the external address to another instance by simply reconfiguring the network forward.

```bash
# from isdev laptop
lxc ls
+---------+---------+-------------------------+-------------------------------------------------+-----------------+-----------+
|  NAME   |  STATE  |          IPV4           |                      IPV6                       |      TYPE       | SNAPSHOTS |
+---------+---------+-------------------------+-------------------------------------------------+-----------------+-----------+
| qemu-vm | STOPPED |                         |                                                 | VIRTUAL-MACHINE | 0         |
+---------+---------+-------------------------+-------------------------------------------------+-----------------+-----------+
| uvm1    | RUNNING | 10.44.173.1 (lxdbr0)    | fd42:deb7:6459:9916:216:3eff:fe65:6413 (enp5s0) | VIRTUAL-MACHINE | 0         |
|         |         | 10.181.197.193 (enp5s0) | fd42:918a:5074:9366::1 (lxdbr0)                 |                 |           |
+---------+---------+-------------------------+-------------------------------------------------+-----------------+-----------+
| win11   | STOPPED |                         |                                                 | VIRTUAL-MACHINE | 0         |
+---------+---------+-------------------------+-------------------------------------------------+-----------------+-----------+
```

- Forward traffic from different port numbers of the external address to different instances (and optionally different ports on those instances). This method allows to “share” your external IP address and expose more than one instance at a time.

For **[OVN networks](https://documentation.ubuntu.com/lxd/latest/reference/network_ovn/#network-ovn)**, network forwards also allow an internal IP address (or specific ports on it) to be forwarded to another internal IP address (or specific ports).

## set dhcp range

```bash
# ovn network
lxc network set lxdbr0 ipv4.dhcp.ranges=10.44.173.2-10.44.173.199 ipv4.ovn.ranges=10.44.173.205-10.44.173.254

# default lxd bridge
lxc network set lxdbr0 ipv4.dhcp.ranges=10.181.197.2-10.181.197.199

```

## add an ip address to forward from

in this case to the bridge but for a bare metal lxd cluster add to the vlan interface.

```bash
ip a add 10.188.197.200/24 dev lxdbr0
```

Tip

Network forwards are very similar to using a proxy device in NAT mode.

The difference is that network forwards are applied on a network level, while a proxy device is added for an instance. In addition, proxy devices can be used to proxy traffic between different connection types (for example, TCP and Unix sockets).

## List network forwards

View a list of all forwards configured on a network:

```bash
lxc network ls                       
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
|      NAME       |   TYPE   | MANAGED |      IPV4       |           IPV6            | DESCRIPTION | USED BY |  STATE  |
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| enxa0cec85afc3c | physical | NO      |                 |                           |             | 0       |         |
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| lxdbr0          | bridge   | YES     | 10.181.197.1/24 | fd42:deb7:6459:9916::1/64 |             | 4       | CREATED |
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| wlp114s0f0      | physical | NO      |                 |                           |             | 0       |         |
+-----------------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
# lxc network forward list <network_name>
lxc network forward list lxdbr0
```

Example:

```bash
lxc network forward list lxdbr0
```

Note

This list displays the listen address of the network forward and its default target address, if set. To view the target addresses for a network forward’s ports **[set in its port specifications](https://documentation.ubuntu.com/lxd/latest/howto/network_forwards/#network-forwards-port-specifications)**, you can **[show details about the network forward](https://documentation.ubuntu.com/lxd/latest/howto/network_forwards/#network-forward-show)** or **[edit the network forward](https://documentation.ubuntu.com/lxd/latest/howto/network_forwards/#network-forward-edit)**.

## Show a network forward

Show details about a specific network forward:

```bash
# lxc network forward show <network_name> <listen_address>
# Example:

lxc network forward show lxdbr0 192.0.2.1
```

## Create a network forward

Requirements for listen addresses
Before you can create a network forward, you must understand the requirements for listen addresses.

For both OVN and bridge networks, the listen addresses must not overlap with any subnet in use by other networks on the host. Otherwise, the listen address requirements differ by network type.

For an OVN network, the allowed listen addresses that are external IPs must be defined in at least one of the following configuration options, using CIDR notation:

- **[ipv4.routes](https://documentation.ubuntu.com/lxd/latest/reference/network_bridge/#network-bridge-network-conf:ipv4.routes)** or **[ipv6.routes](https://documentation.ubuntu.com/lxd/latest/reference/network_bridge/#network-bridge-network-conf:ipv6.routes)** in the OVN -network’s uplink network configuration

- **[restricted.networks.subnets](https://documentation.ubuntu.com/lxd/latest/reference/projects/#project-restricted:restricted.networks.subnets)** in the OVN network’s project configuration

The allowed **internal IPs do not need to be defined**. Use any non-conflicting internal IP address available on the OVN network.

A **bridge network** does not require you to define allowed listen addresses. Use any non-conflicting IP address available on the host.

## Create a forward in an OVN network

Note

You must configure the allowed listen addresses before you can create a forward in an OVN network.

The IP addresses and ports shown in the examples below are only examples. It is up to you to choose the allowed and available addresses and ports for your setup.

Use the following command to create a forward in an OVN network:

```bash
lxc network forward create <ovn_network_name> <listen_address>|--allocate=ipv{4,6} [target_address=<target_address>] [user.<key>=<value>]
```

- For <ovn_network_name>, specify the name of the OVN network on which to create the forward.
- Immediately following the network name, provide only one of the following for the listen address:

  - A listen IP address allowed by the **[Requirements for listen addresses (no port number)](https://documentation.ubuntu.com/lxd/latest/howto/network_forwards/#network-forwards-listen-addresses)**
  - The --allocate= flag with a value of either ipv4 or ipv6 for automatic allocation of an allowed external IP address
- Optionally provide a default target_address (no port number). Any traffic that does not match a port specification is forwarded to this address. This must be an IP address within the OVN network’s subnet; typically, the static IP address of an instance is used.

- Optionally provide custom user.* keys to be stored in the network forward’s configuration.

Examples

This example shows how to create a network forward on a network named ovn1 with an allocated listen address and no default target address:

`lxc network forward create ovn1 --allocate=ipv4`

This example shows how to create a network forward on a network named ovn1 with a specific listen address and a default target address:

`lxc network forward create ovn1 192.0.2.1 target_address=10.41.211.2`

## Create a forward in a bridge network

Note

The IP addresses and ports shown in the examples below are only examples. It is up to you to choose the allowed and available addresses and ports for your setup.

Use the following command to create a forward in a bridge network:

```bash
lxc network forward create <bridge_network_name> <listen_address> [`target_address=<target_address>] [user.<key>=<value>]
```

- For <bridge_network_name>, specify the name of the bridge network on which to create the forward.

- Immediately following the network name, provide an IP address allowed by the **[Requirements for listen addresses (no port number)](https://documentation.ubuntu.com/lxd/latest/howto/network_forwards/#network-forwards-listen-addresses)**.
- Optionally provide a default target_address (no port number). Any traffic that does not match a port specification is forwarded to this address. This must be an IP address within the bridge network’s subnet; typically, the static IP address of an instance is used.

- Optionally provide custom user.* keys to be stored in the network forward’s configuration.

- You cannot use the --allocate flag with bridge networks.

Example

This example shows how to create a forward on a network named bridge1. The listen address is required, and the default target address is optional:

```bash
# lxc network forward create bridge1 192.0.2.1 target_address=10.41.211.2

lxc network forward create lxdbr0 10.181.197.2 target_address=10.41.211.2

```

netplan original

```bash
cat /etc/netplan/50-cloud-init.yaml 
network:
  version: 2
  ethernets:
    enp5s0:
      dhcp4: true
root@uvm1:~# ip r
default via 10.181.197.1 dev enp5s0 proto dhcp src 10.181.197.193 metric 100 
10.44.173.0/24 dev lxdbr0 proto kernel scope link src 10.44.173.1 
10.181.197.0/24 dev enp5s0 proto kernel scope link src 10.181.197.193 metric 100 
10.181.197.1 dev enp5s0 proto dhcp scope link src 10.181.197.193 metric 100 
```

netplan uvm1

```yaml
network:
  version: 2
  ethernets:
    enp5s0:
      dhcp4: false
      addresses:
      - "10.181.197.201/24"
      routes:
      - to: "default"
        via: "10.181.197.1"
        metric: 100 # Primary default route
```

Example

This example shows how to create a forward on a network named bridge1. The listen address is required, and the default target address is optional:

```bash
# lxc network forward create bridge1 192.0.2.1 target_address=10.41.211.2

lxc network forward create lxdbr0 10.181.197.200 target_address=10.181.197.201

lxc network forward show lxdbr0 10.181.197.200
listen_address: 10.181.197.200
location: none
description: ""
config:
  target_address: 10.181.197.201
ports: []

# test
ping 10.181.197.200
PING 10.181.197.200 (10.181.197.200) 56(84) bytes of data.
64 bytes from 10.181.197.200: icmp_seq=1 ttl=64 time=0.191 ms
64 bytes from 10.181.197.200: icmp_seq=2 ttl=64 time=0.265 ms
^C
--- 10.181.197.200 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1006ms
rtt min/avg/max/mdev = 0.191/0.228/0.265/0.037 ms
```
