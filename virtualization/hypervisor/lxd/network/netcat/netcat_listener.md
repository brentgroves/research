# **[netcat listener]()**

## server machine

```bash
nc -l 1234
test
```

server machine is now listening

## client machine

connect to server from client

```bash
nc -v 172.17.250.20 1234
connected
test
```

## Edit a network forward

Use the following command to edit a network forward:

`lxc network forward edit <network_name> <listen_address>`

This command opens the network forward in YAML format for editing. You can edit both the general configuration and the port specifications.

Here's an example of what the YAML for an LXC network forward might look like

```yaml
description: 
config:
  target_address: 10.103.26.196 # The IP address of the target instance
  user.description: "Forward for web server" # Optional description
ports:

- listen_address: 5.35.6.44 # The IP address on the host to listen on
    listen_port: 80,443 # Ports or port ranges to listen on
    target_port: 80,443 # Target ports on the instance
    protocol: tcp # Protocol (tcp, udp, or empty for both)
- listen_address: 5.35.6.44
    listen_port: 2222
    target_port: 22
    protocol: tcp
```
