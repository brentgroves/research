# **[](https://rob-turner.net/post/vx-lan/#:~:text=In%20data%20centers%2C%20VXLAN%20is,segmentation%20on%20a%20large%20scale.%22)**

## wireguard vs vxlan

WireGuard is a VPN protocol for establishing encrypted peer-to-peer connections, focusing on security and performance. VXLAN is a network virtualization protocol for creating overlay networks, segmenting tenants, and stretching Layer 2 networks across Layer 3 domains. While different in purpose, they are often used together, with WireGuard providing the secure transport layer for VXLAN tunnels to extend virtual networks across different locations.

## WireGuard

Purpose: A modern VPN protocol designed for secure, high-performance, point-to-point connections.
Mechanism: Establishes secure, encrypted tunnels using modern cryptography, providing privacy and protection.
Key Features:
Simplicity: A small codebase that is easy to audit and maintain.
Security: Strong, modern cryptographic algorithms like ChaCha20-Poly1305.
Performance: Low overhead and excellent performance.
Use Cases: Secure remote access, site-to-site VPNs, and creating encrypted transport for other protocols.

## VXLAN

Purpose: To create large-scale overlay networks for data centers and cloud environments by virtualizing networks.
Mechanism: Encapsulates Layer 2 Ethernet frames within UDP packets, using a VXLAN Network Identifier (VNI) to separate different virtual networks.
Key Features:
Scalability: Enables the use of virtual networks in multi-tenant data centers.
Network Stretching: Allows Layer 2 networks to span across Layer 3 domains.
Use Cases: Data center virtualization, network segmentation, and cloud infrastructure.

## How They Work Together

Tunnelling VXLAN over WireGuard: You can tunnel a VXLAN network within a WireGuard encrypted tunnel. This setup provides the benefits of VXLAN's overlay network capabilities while ensuring the traffic is encrypted and secure over untrusted networks via WireGuard.
Example Scenario: In a data center, WireGuard can provide the secure connection between hypervisors, and VXLAN can run on top of this to create the actual virtual networks (overlay) that virtual machines (VMs) can connect to.
