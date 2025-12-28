# **[netplan](https://ubuntu.com/blog/introducing-netplan-v1)**

## references

<https://ubuntu.com/blog/netplan-configuration-across-desktop-server-cloud-and-iot>

## Netplan 1.0 highlights

In addition to stability and maintainability improvements, it’s worth looking at some of the new features that were also included in the latest release:

Simultaneous WPA2 & WPA3 support.
Introduction of a stable libnetplan1 API.
Mellanox VF-LAG support for high performance SR-IOV networking.
New hairpin and port-mac-learning settings, useful for VXLAN tunnels with FRRouting.
New netplan status –diff subcommand, finding differences between configuration and system state.

We released Ubuntu 23.10 ‘Mantic Minotaur’ on 12 October 2023, shipping its proven and trusted network stack based on Netplan. Netplan is the default tool to configure Linux networking on Ubuntu since 2016. In the past, it was primarily used to control the Server and Cloud variants of Ubuntu, while on Desktop systems it would hand over control to NetworkManager. In Ubuntu 23.10 this disparity in how to control the network stack on different Ubuntu platforms was closed by integrating NetworkManager with the underlying Netplan stack.

Netplan could already be used to describe network connections on Desktop systems managed by NetworkManager. But network connections created or modified through NetworkManager would not be known to Netplan, so it was a one-way street. Activating the bidirectional NetworkManager-Netplan integration allows for any configuration change made through NetworkManager to be propagated back into Netplan. Changes made in Netplan itself will still be visible in NetworkManager, as before. This way, Netplan can be considered the “single source of truth” for network configuration across all variants of Ubuntu, with the network configuration stored in /etc/netplan/, using Netplan’s common and declarative YAML format.

Netplan Desktop integration
On workstations, the most common scenario is for users to configure networking through NetworkManager’s graphical interface, instead of driving it through Netplan’s declarative YAML files. Netplan ships a “libnetplan” library that provides an API to access Netplan’s parser and validation internals, which is now used by NetworkManager to store any network interface configuration changes in Netplan. For instance, network configuration defined through NetworkManager’s graphical UI or D-Bus API will be exported to Netplan’s native YAML format in the common location at /etc/netplan/. This way, the only thing administrators need to care about when managing a fleet of Desktop installations is Netplan. Furthermore, programmatic access to all network configuration is now easily accessible to other system components integrating with Netplan, such as snapd. This solution has already been used in more confined environments, such as Ubuntu Core and is now enabled by default on Ubuntu 23.10 Desktop.
