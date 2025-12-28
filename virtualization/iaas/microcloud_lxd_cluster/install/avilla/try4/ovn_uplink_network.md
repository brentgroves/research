# OVN uplink network range

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
