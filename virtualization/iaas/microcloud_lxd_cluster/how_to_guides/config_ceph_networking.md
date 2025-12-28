# **[How to configure ceph networking](https://documentation.ubuntu.com/microcloud/stable/microcloud/how-to/ceph_networking/#howto-ceph-networking)**

When running microcloud init, you are asked if you want to provide custom subnets for the Ceph cluster. Here are the questions you will be asked:

What subnet (either IPv4 or IPv6 CIDR notation) would you like your Ceph internal traffic on? [default: 203.0.113.0/24]: <answer>

What subnet (either IPv4 or IPv6 CIDR notation) would you like your Ceph public traffic on? [default: 203.0.113.0/24]: <answer>

You can choose to skip both questions (just hit Enter) and use the default value which is the subnet used for the internal MicroCloud traffic. This is referred to as a usual Ceph networking setup.

![i1](https://documentation.ubuntu.com/microcloud/stable/microcloud/_images/ceph_network_usual_setup.svg)

Sometimes, you want to be able to use different network interfaces for some Ceph related usages. Let’s imagine you have machines with network interfaces that are tailored for high throughput and low latency data transfer, like 100 GbE+ QSFP links, and other ones that might be more suited for management traffic, like 1 GbE or 10 GbE links.

In this case, it would probably be ideal to set your Ceph internal (or cluster) traffic on the high throughput network interface and the Ceph public traffic on the management network interface. This is referred to as a fully disaggregated Ceph networking setup.

![i2](https://documentation.ubuntu.com/microcloud/stable/microcloud/_images/ceph_network_full_setup.svg)

You could also decide to put both types of traffic on the same high throughput and low latency network interface. This is referred to as a partially disaggregated Ceph networking setup.

![i3](https://documentation.ubuntu.com/microcloud/stable/microcloud/_images/ceph_network_partial_setup.svg)

To use a fully or partially disaggregated Ceph networking setup with your MicroCloud, specify the corresponding subnets during the MicroCloud initialisation process.

The following instructions build on the Get started with MicroCloud tutorial and show how you can test setting up a MicroCloud with disaggregated Ceph networking inside a LXD setup.
