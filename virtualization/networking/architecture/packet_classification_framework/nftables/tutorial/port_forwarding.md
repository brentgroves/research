# **[port forwarding](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-configuring_port_forwarding_using_nftables#sec-Forwarding_incoming_packets_on_a_specific_local_port_to_a_different_host)**

## 6.6. Configuring port forwarding using nftables

Port forwarding enables administrators to forward packets sent to a specific destination port to a different local or remote port.
For example, if your web server does not have a public IP address, you can set a port forwarding rule on your firewall that forwards incoming packets on port 80 and 443 on the firewall to the web server. With this firewall rule, users on the internet can access the web server using the IP or host name of the firewall.
6.6.1. Forwarding incoming packets to a different local port
This section describes an example of how to forward incoming IPv4 packets on port 8022 to port 22 on the local system.
Procedure 6.17. Forwarding incoming packets to a different local port

Create a table named nat with the ip address family:

# nft add table ip nat

Add the prerouting and postrouting chains to the table:

# nft -- add chain ip nat prerouting { type nat hook prerouting priority -100 \; }

Note
Pass the -- option to the nft command to avoid that the shell interprets the negative priority value as an option of the nft command.
Add a rule to the prerouting chain that redirects incoming packets on port 8022 to the local port 22:

# nft add rule ip nat prerouting tcp dport 8022 redirect to :22

6.6.2. Forwarding incoming packets on a specific local port to a different host
You can use a destination network address translation (DNAT) rule to forward incoming packets on a local port to a remote host. This enables users on the Internet to access a service that runs on a host with a private IP address.
The procedure describes how to forward incoming IPv4 packets on the local port 443 to the same port number on the remote system with the 192.0.2.1 IP address.
Prerequisite
You are logged in as the root user on the system that should forward the packets.
Procedure 6.18. Forwarding incoming packets on a specific local port to a different host

Create a table named nat with the ip address family:

# nft add table ip nat

Add the prerouting and postrouting chains to the table:

# nft -- add chain ip nat prerouting { type nat hook prerouting priority -100 \; }

# nft add chain ip nat postrouting { type nat hook postrouting priority 100 \; }

Note
Pass the -- option to the nft command to avoid that the shell interprets the negative priority value as an option of the nft command.
Add a rule to the prerouting chain that redirects incoming packets on port 443 to the same port on 192.0.2.1:

# nft add rule ip nat prerouting tcp dport 443 dnat to 192.0.2.1

Add a rule to the postrouting chain to masquerade outgoing traffic:

# nft add rule ip nat postrouting ip daddr 192.0.2.1 masquerade

Enable packet forwarding:

# echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/95-IPv4-forwarding.conf

# sysctl -p /etc/sysctl.d/95-IPv4-forwarding.conf
