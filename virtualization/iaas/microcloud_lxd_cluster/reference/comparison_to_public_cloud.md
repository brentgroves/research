# **[Comparison to public cloud VPCs](https://documentation.ubuntu.com/microcloud/latest/microcloud/explanation/networking/#comparison-to-public-cloud-vpcs)**

For users familiar with public cloud networking, understanding the similarities and differences between MicroCloud and Virtual Private Clouds (VPCs) can provide helpful context.

## Similarities

- Private networking: Like a VPC, MicroCloud provides a private, isolated network that allows instances to communicate privately while controlling external access.
- Subnet-like structure: MicroCloud uses OVN to define logical networks, similar to how VPCs use subnets.
- Routing and NAT: Both MicroCloud and VPCs enable internal routing between instances and support Network Address Translation (NAT) for outbound internet access.

## Differences

- Built for on-premises or self-hosted use: MicroCloud is designed for on-premises or self-hosted environments, whereas VPCs are tightly integrated into managed cloud ecosystems.
- Self-contained networking environment: Unlike public cloud VPCs, which operate within a provider’s infrastructure and managed networking services, MicroCloud runs on user-managed hardware and environments. Its networking is entirely self-contained, and users can configure external connectivity as needed.
- Use of OVN instead of vendor-specific SDN solutions: Instead of relying on vendor-specific networking solutions, MicroCloud uses OVN to manage internal communication and overlays.
