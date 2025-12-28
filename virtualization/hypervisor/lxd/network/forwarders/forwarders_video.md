# **[](https://www.youtube.com/watch?v=B-Uzo9WldMs)**

- floating IPs
- elastic IPs

## flexible

bridge and OVN network supported

## internal

```bash
lxc network forward create default 10.233.212.10
```

```yaml
listen_address: 10.233.212.10 # The IP address on the LXD network to listen on
description: "My first forward" # Optional description for the forward
config:
  target_address: 10.233.212.2 # The default target IP address for traffic
ports:
- description: "netcat"
    listen_port: "1234"
    protocol: "tcp"
    target_address: 10.233.212.2 # Target IP for this specific port rule
    target_port: "80"


```

## complete

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
