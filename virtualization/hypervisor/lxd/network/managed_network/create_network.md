# **[How to create a network](https://documentation.ubuntu.com/lxd/latest/howto/network_create/)**

To create a managed network, use the lxc network command and its subcommands. Append --help to any command to see more information about its usage and available flags.

Network types
The following network types are available:

| Network type | Documentation    | Configuration options |
|--------------|------------------|-----------------------|
| bridge       | **[Bridge network](https://documentation.ubuntu.com/lxd/latest/reference/network_bridge/#network-bridge)**   | **[Configuration options](https://documentation.ubuntu.com/lxd/latest/reference/network_bridge/#network-bridge-options)** |
| ovn          | **[OVN network](https://documentation.ubuntu.com/lxd/latest/reference/network_ovn/#network-ovn)**      | **[Configuration options](https://documentation.ubuntu.com/lxd/latest/reference/network_ovn/#network-ovn-options)**s |
| macvlan      | Macvlan network  | Configuration options |
| sriov        | SR-IOV network   | Configuration options |
| physical     | Physical network | Configuration options |

## create network

Use the following command to create a network:

```bash
lxc network create <name> --type=<network_type> [configuration_options...]
```

See Network types for a list of available network types and links to their configuration options.

If you do not specify a --type argument, the default type of bridge is used.

## Create a network in a cluster

If you are running a LXD cluster and want to create a network, you must create the network for each cluster member separately. The reason for this is that the network configuration, for example, the name of the parent network interface, might be different between cluster members.

Therefore, you must first create a pending network on each member with the --target=<cluster_member> flag and the appropriate configuration for the member. Make sure to use the same network name for all members. Then create the network without specifying the --target flag to actually set it up.

For example, the following series of commands sets up a physical network with the name UPLINK on three cluster members:

```bash
~$lxc network create UPLINK --type=physical parent=br0 --target=vm01
Network UPLINK pending on member vm01
~$lxc network create UPLINK --type=physical parent=br0 --target=vm02
Network UPLINK pending on member vm02
~$lxc network create UPLINK --type=physical parent=br0 --target=vm03
Network UPLINK pending on member vm03
~$lxc network create UPLINK --type=physical
Network UPLINK created

lxc network show default
name: default
description: Default OVN network
type: ovn
managed: true
status: Created
config:
  bridge.mtu: "1442"
  ipv4.address: 10.233.212.1/24
  ipv4.nat: "true"
  ipv6.address: fd42:40d7:53e9:d1cc::1/64
  ipv6.nat: "true"
  network: UPLINK
  volatile.network.ipv4.address: 10.188.50.206
used_by:

- /1.0/instances/ubuntu
- /1.0/instances/v1
- /1.0/instances/v3
- /1.0/instances/win11
- /1.0/profiles/default
locations:
- micro13
- micro11
- micro12

lxc network show UPLINK
name: UPLINK
description: ""
type: physical
managed: true
status: Created
config:
  dns.nameservers: 10.225.50.203,10.224.50.203
  ipv4.gateway: 10.188.50.254/24
  ipv4.ovn.ranges: 10.188.50.206-10.188.50.212
  volatile.last_state.created: "false"
used_by:

- /1.0/networks/default
locations:
- micro11
- micro12
- micro13

```

Also see **[How to configure networks for a cluster](https://documentation.ubuntu.com/lxd/latest/howto/cluster_config_networks/#cluster-config-networks)**.

## Attach a network to an instance

After creating a managed network, you can attach it to an instance as a NIC device.

To do so, use the following command:

```bash
lxc network attach <network_name> <instance_name> [<device_name>] [<interface_name>]
```

The device name and the interface name are optional, but we recommend specifying at least the device name. If not specified, LXD uses the network name as the device name, which might be confusing and cause problems. For example, LXD images perform IP auto-configuration on the eth0 interface, which does not work if the interface is called differently.

For example, to attach the network my-network to the instance my-instance as eth0 device, enter the following command:

```bash
lxc network attach my-network my-instance eth0
```

## Attach the network as a device

The lxc network attach command is a shortcut for adding a NIC device to an instance. Alternatively, you can add a NIC device based on the network configuration in the usual way:

```bash
lxc config device add <instance_name> <device_name> nic network=<network_name>
```

When using this way, you can add further configuration to the command to override the default settings for the network if needed. See NIC device for all available device options.
