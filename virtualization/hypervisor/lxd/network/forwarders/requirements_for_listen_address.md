# **[Requirements for listen addresses](https://documentation.ubuntu.com/lxd/stable-5.21/howto/network_forwards/#network-forwards-listen-addresses)**

## Create a network forward

## Requirements for listen addresses

Before you can create a network forward, you must understand the requirements for listen addresses.

For both OVN and bridge networks, the listen addresses must not overlap with any subnet in use by other networks on the host. Otherwise, the listen address requirements differ by network type. Review the netplan config file if necessary.

For an OVN network, the allowed listen addresses must be defined in at least one of the following configuration options, using CIDR notation:

- **[ipv4.routes](https://documentation.ubuntu.com/lxd/stable-5.21/reference/network_bridge/#network-bridge-network-conf:ipv4.routes)** or ipv6.routes in the OVN network’s uplink network configuration

ipv4.routing
Whether to route IPv4 traffic in and out of the bridge

```yaml
Key: ipv4.routing
Type: bool
Default: true
Condition: IPv4 address
Scope: global
```

- restricted.networks.subnets in the OVN network’s project configuration

Error: Failed creating forward: Uplink network doesn't contain "10.38.122.101/32" in its routes

This error means that the OVN networks connected to the UPLINK network are not permitted to use (and thus advertise to the uplink network) those IPs because the UPLINK network hasn’t been configured by the admin (you) to allow it.

So you should be able to do this:

```bash
lxc network set UPLINK ipv4.routes 10.188.50.207/32
```
