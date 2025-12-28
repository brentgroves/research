# **[Open Virtual Network](https://www.ovn.org/en/)**

OVN (Open Virtual Network) is a series of daemons for the Open vSwitch that translate virtual network configurations into OpenFlow. OVN is licensed under the open source Apache 2 license.

OVN provides a higher-layer of abstraction than Open vSwitch, working with logical routers and logical switches, rather than flows. OVN is intended to be used by cloud management software (CMS). For details about the architecture of OVN, see the ovn-architecture manpage. Some high-level features offered by OVN include:

- Distributed virtual routers
- Distributed logical switches
- Access Control Lists
- DHCP
- DNS server
- Like Open vSwitch, OVN is written in platform-independent C. OVN runs entirely in userspace and therefore requires no kernel modules to be installed.
