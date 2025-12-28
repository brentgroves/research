# **[How to configure network forwards](https://documentation.ubuntu.com/lxd/en/latest/howto/network_forwards/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

Network forwards are available for the OVN network and the Bridge network.

▶
**[Watch on YouTube](https://www.youtube.com/watch?v=B-Uzo9WldMs)**

Network forwards allow an external IP address (or specific ports on it) to be forwarded to an internal IP address (or specific ports on it) in the network that the forward belongs to.

This feature can be useful if you have limited external IP addresses and want to share a single external address between multiple instances. There are two different ways how you can use network forwards in this case:

Forward all traffic from the external address to the internal address of one instance. This method makes it easy to move the traffic destined for the external address to another instance by simply reconfiguring the network forward.

Forward traffic from different port numbers of the external address to different instances (and optionally different ports on those instances). This method allows to “share” your external IP address and expose more than one instance at a time.

Network forwards are very similar to using a **[proxy device](https://documentation.ubuntu.com/lxd/en/latest/reference/devices_proxy/#devices-proxy)** in NAT mode.

The difference is that network forwards are applied on a network level, while a proxy device is added for an instance. In addition, proxy devices can be used to proxy traffic between different connection types (for example, TCP and Unix sockets).

## View network forwards

View a list of forwards configured on a network:

lxc network forward list <network_name>
Example:

```bash
lxc network forward list lxdbr0
```

## View a network forward

View information about a specific network forward:

lxc network forward show <network_name> <listen_address>
Example:

```bash
lxc network forward list lxdbr0 192.0.2.1
```

## Create a network forward

Requirements for listen addresses
Before you can create a network forward, you must understand the requirements for listen addresses.

For both OVN and bridge networks, the listen addresses must not overlap with any subnet in use by other networks on the host. Otherwise, the listen address requirements differ by network type.

A bridge network does not require you to define allowed listen addresses. Use any non-conflicting IP address available on the host.

## Create a forward in a bridge network

Use the following command to create a forward in a bridge network:

lxc network forward create <bridge_network_name> <listen_address> [target_address=<target

- For <bridge_network_name>, specify the name of the bridge network on which to create the forward.
- Immediately following the network name, provide a listen IP address allowed by the Requirements for listen addresses (no port number).
- Optionally provide a default target_address (no port number). Any traffic that does not match a port specification is forwarded to this address. This must be an IP address within the bridge network’s subnet.
- Optionally provide custom user.* keys to be stored in the network forward’s configuration.
- You cannot use the --allocate flag with bridge networks.

This example shows how to create a network forward on a network named ovn1 with a specific listen address and a target address:


```bash
lxd network forward create bridge1 192.0.2.1 target_address=10.41.211.2
```