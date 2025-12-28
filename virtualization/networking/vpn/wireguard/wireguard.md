# **[wireguard](wireguard.com)**

## does wireguard use gre

No, WireGuard does not use the Generic Routing Encapsulation (GRE) protocol; it uses a simpler, modern protocol built on UDP for data transmission. However, you can route traffic through a GRE tunnel that is itself running over a WireGuard VPN, creating a combined setup for dynamic routing or other advanced network configurations.

## Why WireGuard doesn't use GRE

- **Simpler design:** WireGuard's primary goal is to provide a simple, fast, and secure VPN solution, which it achieves with its own protocol, not a complex tunneling method like GRE.
- **UDP-based:** WireGuard uses UDP (User Datagram Protocol) for its communication, which is efficient and less prone to issues like TCP-over-TCP meltdown.

## How GRE can be used with WireGuard

- **Layer 3 tunneling:** A common use case is to create a Layer 3 GRE tunnel, which encapsulates IP packets, and then tunnel this GRE traffic over WireGuard to secure it.
- **Dynamic routing:** This combination is useful for running dynamic routing protocols, such as BGP, over the VPN, allowing for more complex network designs.
- **Layer 2 tunneling (GRETAP):** You can also create a Layer 2 GRE tunnel (GRETAP) over WireGuard, though this adds complexity and reduces the MTU (Maximum Transmission Unit).

WireGuard® is an extremely simple yet fast and modern VPN that utilizes state-of-the-art cryptography. It aims to be faster, simpler, leaner, and more useful than IPsec, while avoiding the massive headache. It intends to be considerably more performant than OpenVPN. WireGuard is designed as a general purpose VPN for running on embedded interfaces and super computers alike, fit for many different circumstances. Initially released for the Linux kernel, it is now cross-platform (Windows, macOS, BSD, iOS, Android) and widely deployable. It is currently under heavy development, but already it might be regarded as the most secure, easiest to use, and simplest VPN solution in the industry.
