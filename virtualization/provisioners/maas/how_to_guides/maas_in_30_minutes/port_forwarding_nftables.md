# **[Configuring port forwarding using nftables](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/security_guide/sec-configuring_port_forwarding_using_nftables#sec-Configuring_port_forwarding_using_nftables)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## reference

- **[gentoo](https://wiki.gentoo.org/wiki/Nftables/Examples)**

Port forwarding enables administrators to forward packets sent to a specific destination port to a different local or remote port.

For example, if your web server does not have a public IP address, you can set a port forwarding rule on your firewall that forwards incoming packets on port 80 and 443 on the firewall to the web server. With this firewall rule, users on the internet can access the web server using the IP or host name of the firewall.

3. Add a rule to the prerouting chain that redirects incoming packets on port 8022 to the local port 22:

```bash
nft add rule ip nat prerouting tcp dport 8022 redirect to :22
```

## Forwarding incoming packets on a specific local port to a different host

You can use a destination network address translation (DNAT) rule to forward incoming packets on a local port to a remote host. This enables users on the Internet to access a service that runs on a host with a private IP address.

The procedure describes how to forward incoming IPv4 packets on the local port 443 to the same port number on the remote system with the 192.0.2.1 IP address

Prerequisite

You are logged in as the root user on the system that should forward the packets.
Procedure 6.18. Forwarding incoming packets on a specific local port to a different host

1. Create a table named nat with the ip address family:

```bash
nft list ruleset
# There is already a table named nat
# nft add table ip nat

sudo nft add table ip mynat
```

2. Add the prerouting and postrouting chains to the table:

```bash
sudo nft -- add chain ip mynat prerouting { type nat hook prerouting priority -100 \; \}
sudo nft add chain ip mynat postrouting { type nat hook postrouting priority 100 \; \}

sudo nft list ruleset

```

Note

Pass the -- option to the nft command to avoid that the shell interprets the negative priority value as an option of the nft command.

<!-- http://<MAAS_IP>:5240/MAAS -->

3. Add a rule to the prerouting chain that redirects incoming packets on port 443 to the same port on 192.0.2.1:

```bash
# nft add rule ip nat prerouting tcp dport 443 dnat to 192.0.2.1
multipass list
Name                    State             IPv4             Image
maas                    Running           10.72.173.107    Ubuntu 24.04 LTS
                                          10.10.10.1
# http://<MAAS_IP>:5240/MAAS 
#    nft add rule ip nat   prerouting tcp dport 443  dnat to 192.0.2.1
sudo nft add rule ip mynat prerouting tcp dport 5240 dnat to 10.72.173.107

```

4. Add a rule to the postrouting chain to masquerade outgoing traffic:

```bash
# nft add rule ip nat postrouting ip daddr 192.0.2.1 masquerade
sudo nft add rule ip mynat postrouting ip daddr 10.72.173.107 masquerade
sudo nft list ruleset
...
table ip mynat {
        chain prerouting {
                type nat hook prerouting priority dstnat; policy accept;
                tcp dport 5240 dnat to 10.72.173.107
        }

        chain postrouting {
                type nat hook postrouting priority srcnat; policy accept;
                ip daddr 10.72.173.107 masquerade
        }
}
```

5. Enable packet forwarding:

```bash
sudo echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/95-IPv4-forwarding.conf
sudo sysctl -p /etc/sysctl.d/95-IPv4-forwarding.conf
curl -L http://10.72.173.107:5240 
```

6. Test from remote host

```bash
curl -L http://192.168.1.65:5240
```