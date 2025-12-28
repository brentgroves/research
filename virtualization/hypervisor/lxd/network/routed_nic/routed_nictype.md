# **[nictype: routed](https://documentation.ubuntu.com/lxd/en/stable-5.0/reference/devices_nic/#nic-routed)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

A routed NIC creates a virtual device pair to connect the host to the instance and sets up static routes and proxy ARP/NDP entries to allow the instance to join the network of a designated parent interface. For containers it uses a virtual Ethernet device pair, and for VMs it uses a TAP device.

This NIC type is similar in operation to ipvlan, in that it allows an instance to join an external network without needing to configure a bridge and shares the host’s MAC address. However, it differs from ipvlan because it does not need IPVLAN support in the kernel, and the host and the instance can communicate with each other.

This NIC type respects netfilter rules on the host and uses the host’s routing table to route packets, which can be useful if the host is connected to multiple networks.

IP addresses, gateways and routes
You must manually specify the IP addresses (using ipv4.address and/or ipv6.address) before the instance is started.

For containers, the NIC configures the following link-local gateway IPs on the host end and sets them as the default gateways in the container’s NIC interface:

169.254.0.1
fe80::1
For VMs, the gateways must be configured manually or via a mechanism like cloud-init (see the how to guide).

Note

If your container image is configured to perform DHCP on the interface, it will likely remove the automatically added configuration. In this case, you must configure the IP addresses and gateways manually or via a mechanism like cloud-init.

The NIC type configures static routes on the host pointing to the instance’s veth interface for all of the instance’s IPs.