# AI Overview

LXD network forwards can be configured using YAML. This allows for defining a listen address on an LXD network and directing traffic from that address (and optionally specific ports) to a target address, typically an LXD instance's IP.
Here is a YAML example for configuring an LXD network forward:

```yaml
listen_address: 192.168.1.100 # The IP address on the LXD network to listen on
description: "Forward for web server" # Optional description for the forward
config:
  target_address: 10.0.0.50 # The default target IP address for traffic
ports:

- description: "HTTP traffic to instance"
    listen_port: "80"
    protocol: "tcp"
    target_address: 10.0.0.50 # Target IP for this specific port rule
    target_port: "80"
- description: "HTTPS traffic to instance"
    listen_port: "443"
    protocol: "tcp"
    target_address: 10.0.0.50
    target_port: "443"
- description: "SSH access"
    listen_port: "2222"
    protocol: "tcp"
    target_address: 10.0.0.50
    target_port: "22"
```

Explanation of fields:

- listen_address: This is the mandatory IP address on the LXD network that the forward will listen on.
description: An optional string to describe the network forward.
config: This section contains general configuration for the forward.
- target_address: An optional default target IP address for traffic arriving at listen_address that is not matched by a specific port rule.
- ports: An optional list of port-specific forwarding rules. Each entry in the list defines a rule for a particular port or range of ports.
- description: An optional description for the specific port forward rule.
- listen_port: The port or port range on the listen_address to listen on (e.g., "80", "8000-8010").
- protocol: The network protocol for the forward, typically "tcp" or "udp".
- target_address: The IP address of the target instance or service where the traffic will be forwarded.
- target_port: The port or port range on the target_address to which the traffic will be forwarded. This can be different from listen_port.

To apply this YAML configuration, you would typically use the lxc network forward edit <network_name> <listen_address> command, which opens the configuration in your default editor for modification.
