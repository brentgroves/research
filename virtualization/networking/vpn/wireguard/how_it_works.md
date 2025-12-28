# how does wireguard encapsolate packets

WireGuard encapsulates original IP packets by first encrypting them with a temporary session key, then adding WireGuard headers, and finally wrapping the encrypted data in a UDP packet addressed to a specific peer's endpoint. The Linux kernel routes IP packets destined for a peer to the virtual WireGuard interface, which uses cryptokey routing to match the destination IP address to a peer's public key. This encrypted UDP packet is then sent over the physical network to the peer's public IP address and UDP port.  

1. Packet Ingestion & Routing
Kernel Route to Virtual Interface: When a packet is sent from a system, the Linux kernel recognizes that the destination IP address matches the WireGuard peer's configuration. It then routes this packet to the virtual WireGuard interface (e.g., wg0).
2. Cryptographic Handshake & Session Key Creation
Handshake: Before any data is exchanged, WireGuard peers establish a secure, encrypted session by performing a cryptographic handshake.
Temporary Keys: This handshake results in temporary session keys for encryption and authentication, which are valid for a set period.
3. Packet Encryption & Authentication
ChaCha20-Poly1305: The original IP packet is encrypted using the ChaCha20 algorithm, and its authenticity is guaranteed by the Poly1305 message authentication code.
Session Counter: A session counter is included to prevent replay attacks.
4. Encapsulation in UDP
UDP Wrapper: The encrypted data is then wrapped in a UDP packet.
Peer Endpoint: The destination IP address and UDP port for this outer UDP packet are the public IP address and configured UDP listen port of the WireGuard peer.
5. Transmission
Physical Network: The final UDP packet, containing the encrypted original packet, is then sent out over the physical network interface (e.g., Ethernet or Wi-Fi) to the internet or local network.
Cryptokey Routing:
WireGuard uses a mechanism called cryptokey routing to match the destination IP address of the original packet with a specific peer's public key and allowed IP addresses. This creates a simple, secure routing table where the association between public keys and allowed IP addresses determines packet destinations.
