# **[](https://documentation.ubuntu.com/microcloud/latest/microcloud/explanation/networking/#networking-architecture)**

Networking architecture
OVN requires the use of cloud management software (CMS) to connect OVN logical networks to a physical network. Since MicroCloud is built on LXD clusters, LXD acts as the CMS for MicroCloud, enabling the connection of an OVN network to an existing managed Bridge network or **[Physical network](https://documentation.ubuntu.com/microcloud/latest/lxd/reference/network_physical/#network-physical)** for external connectivity.

The following figure shows the OVN network traffic flow in a MicroCloud/LXD cluster:
![i1](https://documentation.ubuntu.com/microcloud/latest/microcloud/_images/ovn_networking_1.svg)

In MicroCloud, each OVN network spans across all cluster members. Intra-cluster traffic (communication between instances on members within the same cluster, also known as OVN east/west traffic) travels through an OVN tunnel over a designated NIC (eth1 in the figure above).

For external connectivity (called OVN north/south traffic), the OVN network connects to an uplink network via a virtual router on a designated NIC (eth0 in the figure above). The virtual router is active on only one cluster member at a time but can migrate between cluster members as needed. This ensures uplink connectivity in case the member with the active router becomes unavailable.

An instance (container or virtual machine) within a cluster member connects to the OVN network via its virtual NIC. Through the OVN network, it can communicate with the uplink network.

The strengths of using OVN become apparent when considering a networking architecture with more than one OVN network:

![i2](https://documentation.ubuntu.com/microcloud/latest/microcloud/_images/ovn_networking_2.svg)

## OVN networking (two networks)

Both OVN networks depicted are completely independent. Both networks are available on all cluster members (with each virtual router active on one random cluster member). Any instance can use either of the networks, and the traffic on one network is completely isolated from the other network.

See the **[LXD documentation on OVN networks](https://documentation.ubuntu.com/microcloud/latest/lxd/reference/network_ovn/#network-ovn)** for more information.

Dedicated underlay network
During MicroCloud initialization, you can choose to configure a dedicated underlay network for OVN traffic. This requires an additional network interface on each cluster member.

A dedicated underlay network serves as the physical infrastructure over which the virtual (overlay) network is constructed. While optional, it offers several potential benefits:

- Traffic isolation: Keeps overlay traffic separate from management and other traffic.
- Reduced congestion: Dedicating physical resources minimizes network bottlenecks.
- Optimized performance: Enables predictable latency and bandwidth for sensitive applications.
- Scalable design: Allows the overlay network to scale independently of other networks.
