# **[Dedicated underlay network](https://documentation.ubuntu.com/microcloud/latest/microcloud/explanation/networking/#exp-networking-ovn-underlay)**

During MicroCloud initialization, you can choose to configure a dedicated underlay network for OVN traffic. This requires an additional network interface on each cluster member.

A dedicated underlay network serves as the physical infrastructure over which the virtual (overlay) network is constructed. While optional, it offers several potential benefits:

- **Traffic isolation:** Keeps overlay traffic separate from management and other traffic.
- **Reduced congestion:** Dedicating physical resources minimizes network bottlenecks.
- **Optimized performance:** Enables predictable latency and bandwidth for sensitive applications.
- **Scalable design:** Allows the overlay network to scale independently of other networks.

## Alternatives

If you decide to not use MicroOVN, MicroCloud falls back on the **[Ubuntu fan](https://wiki.ubuntu.com/FanNetworking)** for basic networking. MicroCloud will still be usable, but you will see some limitations, including:

- When you migrate an instance from one cluster member to another, its IP address changes.
- Egress traffic leaves from the local cluster member (while OVN provides shared egress). As a result of this, network forwarding works at a basic level only, and external addresses must be forwarded to a specific cluster member and don’t fail over.
- There is no support for hardware acceleration, load balancers, or ACL functionality within the local network.
