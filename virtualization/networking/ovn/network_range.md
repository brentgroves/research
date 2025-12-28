# # **[configure the uplink network](https://documentation.ubuntu.com/lxd/latest/howto/network_ovn_setup/)**

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

In Open Virtual Network (OVN), static IP addresses are typically assigned to logical ports within the OVN logical network using the OVN southbound database. This is done by specifying the dynamic_address option when creating logical ports, effectively disabling DHCP and allowing for static assignment of IP addresses.
Here's a breakdown of how static IP addresses are handled in OVN:

1. Logical Ports and Static IP Assignment:
OVN uses logical ports (lifs) to represent virtual network interfaces within the logical network.
To assign a static IP, you modify the options column of the Logical_Switch_Port table in the OVN SB database.
The dynamic_address option is set to false for the specific logical port, indicating that the IP address is not assigned dynamically via DHCP.

2. Setting the IP Address:
Once dynamic_address is disabled, you can specify the desired IP address for the logical port using the ipv4 option in the options column.
This IP address will be used by the virtual machine or container connected to that logical port.

3. Example (using OVN CLI):
To create a logical port with a static IP, you can use commands like:
Code

```bash
ovn-nbctl ls-add my_ls
ovn-nbctl lsp-add my_ls my_port
ovn-nbctl lsp-set-addresses my_port "static_ip"
ovn-nbctl lsp-set-options my_port dynamic_address=false
ovn-nbctl lsp-set-options my_port ipv4="your_static_ip"
```

In the example above:
my_ls is the name of the logical switch.
my_port is the name of the logical port.
static_ip would be the MAC address associated with the port.
your_static_ip is the static IP address you want to assign.

4. Considerations:
IP Address Conflicts:
.
Ensure the static IP you choose is not already in use within the logical network or the underlying physical network (if applicable).
OVN Features:
.
OVN's features like logical routing and NAT rely on the correct assignment of IP addresses, so static IP assignments should be done carefully.
External Networks:
.
For communication with external networks, you might need to configure logical router ports and NAT rules in OVN to properly route traffic between static and dynamic IP addresses.

Configure distributed networking? (yes/no) [default=yes]: yes
Select an available interface per system to provide external connectivity for distributed network(s):
Space to select; enter to confirm; type to filter results.
Up/down to move; right to select all; left to select none.
       +----------+--------+----------+
       | LOCATION | IFACE  |   TYPE   |
       +----------+--------+----------+
  [ ]  | micro11  | eno1   | physical |
  [ ]  | micro11  | eno2   | physical |
  [ ]  | micro11  | eno3   | physical |
> [x]  | micro11  | eno250 | vlan     |
  [ ]  | micro11  | eno350 | vlan     |
       +----------+--------+----------+

nmap -sP 10.188.50.0/24

 Using "eno250" on "micro11" for OVN uplink

Specify the IPv4 gateway (CIDR) on the uplink network (empty to skip IPv4): 10.188.50.254/24
Specify the first IPv4 address in the range to use on the uplink network: 10.188.50.6
Specify the last IPv4 address in the range to use on the uplink network: 10.188.50.12

# no ipv6 on network

Specify the IPv6 gateway (CIDR) on the uplink network (empty to skip IPv6):
Specify the DNS addresses (comma-separated IPv4 / IPv6 addresses) for the distributed network (default: 10.188.50.254): 10.225.50.203,10.224.50.203
Configure dedicated OVN underlay networking? (yes/no) [default=no]:
