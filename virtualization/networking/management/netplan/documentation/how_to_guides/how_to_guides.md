# **[How to guides](https://netplan.readthedocs.io/en/stable/howto/)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

This is a collection of how-to guides for common scenarios. If you see a scenario missing or have one to contribute, file an issue against this documentation with the example.

To configure Netplan, save configuration files in the /etc/netplan/ directory with a .yaml extension (e.g. /etc/netplan/config.yaml), then run sudo netplan apply. This command parses and applies the configuration to the system. Configuration written to disk under /etc/netplan/ persists between reboots. Visit Applying new Netplan configuration for detailed guidance.

For each of the examples below, use the renderer that applies to your scenario. For example, for Ubuntu Desktop, the renderer is usually NetworkManager. For Ubuntu Server, it is networkd.

Quick configuration examples
How to enable DHCP on an interface
How to configure a static IP address on an interface
How to configure DNS servers and search domains
How to connect multiple interfaces with DHCP
How to connect to an open wireless network
How to configure your computer to connect to your home Wi-Fi network
How to connect to a WPA Personal wireless network without DHCP
How to connect to WPA Enterprise wireless networks with EAP+TTLS
How to connect to WPA Enterprise wireless networks with EAP+TLS
How to use multiple addresses on a single interface
How to use multiple addresses with multiple gateways
How to use NetworkManager as a renderer
How to configure interface bonding
How to configure multiple bonds
How to configure network bridges
How to create a bridge with a VLAN for libvirtd
How to create VLANs
How to use a directly connected gateway
How to configure source routing
How to configure a loopback interface
How to integrate with Windows DHCP Server
How to connect to an IPv6 over IPv4 tunnel
How to configure SR-IOV Virtual Functions
How to connect two systems with a WireGuard VPN
How to connect your home computer to a cloud instance with a WireGuard VPN
How to change Advertised MSS (‘Maximal Segment Size’) in custom route

Complex how-to guides
How to use static IP addresses
How to match the interface by MAC address
How to create link aggregation
How to use D-Bus configuration API
How to integrate Netplan with desktop
How to configure a VM host with a single network interface
How to configure a VM host with a single network interface and three VLANs
How to configure a VM host with bonded network interfaces and three VLANs
