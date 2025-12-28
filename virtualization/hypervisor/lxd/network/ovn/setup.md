# **[How to set up OVN with LXD](https://documentation.ubuntu.com/lxd/latest/howto/network_ovn_setup/)**

See the following sections for how to set up a basic OVN network, either as a standalone network or to host a small LXD cluster.

## Set up a standalone OVN network

Complete the following steps to create a standalone OVN network that is connected to a managed LXD parent bridge network (for example, lxdbr0) for outbound connectivity.

Install the OVN tools on the local server:

`sudo apt install ovn-host ovn-central`

Configure the OVN integration bridge:

```bash
sudo ovs-vsctl set open_vswitch . \
   external_ids:ovn-remote=unix:/var/run/ovn/ovnsb_db.sock \
   external_ids:ovn-encap-type=geneve \
   external_ids:ovn-encap-ip=127.0.0.1
```

Create an OVN network:

```bash
lxc network list
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
|   NAME    |   TYPE   | MANAGED |      IPV4       |           IPV6            |     DESCRIPTION     | USED BY |  STATE  |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| UPLINK    | physical | YES     |                 |                           |                     | 1       | CREATED |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| br-int    | bridge   | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| default   | ovn      | YES     | 10.233.212.1/24 | fd42:40d7:53e9:d1cc::1/64 | Default OVN network | 3       | CREATED |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno1      | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno2      | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno3      | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+
| eno4      | physical | NO      |                 |                           |                     | 0       |         |
+-----------+----------+---------+-----------------+---------------------------+---------------------+---------+---------+

lxc network get default ipv4.dhcp.ranges=<IP_range> ipv4.ovn.ranges=<IP_range>
# lxc network set <parent_network> ipv4.dhcp.ranges=<IP_range> ipv4.ovn.ranges=<IP_range>
lxc network set <parent_network> ipv4.dhcp.ranges=<IP_range> ipv4.ovn.ranges=<IP_range>

lxc network create ovntest --type=ovn network=<parent_network>
```

On the first machine, create and configure the uplink network:

```bash
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_1>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_2>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_3>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_4>
lxc network create UPLINK --type=physical \
   ipv4.ovn.ranges=<IP_range> \
   ipv6.ovn.ranges=<IP_range> \
   ipv4.gateway=<gateway> \
   ipv6.gateway=<gateway> \
   dns.nameservers=<name_server>

# lxc network get UPLINK ipv4.dhcp.ranges=<IP_range> ipv4.ovn.ranges=<IP_range>
lxc network get UPLINK ipv4.ovn.ranges
lxc network get UPLINK ipv4.ovn.ranges
10.188.50.206-10.188.50.212
```

To determine the required values:

Uplink interface
A high availability OVN cluster requires a shared layer 2 network, so that the active OVN chassis can move between cluster members (which effectively allows the OVN router’s external IP to be reachable from a different host).

Therefore, you must specify either an unmanaged bridge interface or an unused physical interface as the parent for the physical network that is used for OVN uplink. The instructions assume that you are using a manually created unmanaged bridge. See How to configure network bridges for instructions on how to set up this bridge.

Gateway
Run ip -4 route show default and ip -6 route show default.

Name server
Run resolvectl.

IP ranges
Use suitable IP ranges based on the assigned IPs.
