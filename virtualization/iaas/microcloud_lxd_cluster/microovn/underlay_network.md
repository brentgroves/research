# **[](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/ovn_underlay/)**

How to configure an OVN underlay network
For an explanation of the benefits of using an OVN underlay network, see **[Dedicated underlay network](https://documentation.ubuntu.com/microcloud/latest/microcloud/explanation/networking/#exp-networking-ovn-underlay)**.

When running microcloud init, if you chose to set up distributed networking and you have at least one network interface per cluster member with an IP address, MicroCloud asks if you want to configure an underlay network for OVN:

Configure dedicated underlay networking? (yes/no) [default=no]: <answer>

You can choose to skip this question (just hit Enter). MicroCloud then uses its internal network as an OVN ‘underlay’, which is the same as the OVN management network (‘overlay’ network).

You could also choose to configure a dedicated underlay network for OVN by typing yes. A list of available network interfaces with an IP address will be displayed. You can then select one network interface per cluster member to be used as the interfaces for the underlay network of OVN.

The following instructions build on the Get started with MicroCloud tutorial and show how you can test setting up a MicroCloud with an OVN underlay network.

Create the dedicated network for the OVN underlay:

First, create a dedicated network for the OVN cluster members to be used as an underlay. Let’s call it ovnbr0:

```bash
lxc network create ovnbr0
```
