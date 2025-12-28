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
sudo nft list ruleset
# There is already a table named nat
# nft add table ip nat

sudo nft add table ip mynat
sudo nft delete table ip mynat

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

## Saving and Restoring Rules

To ensure that your nftables rules persist across reboots, you need to save them to a file and restore them on startup.

### Saving Rules

You can save the current nftables configuration to a file:

```bash
sudo nft list ruleset > /etc/nftables.conf
```

### Restoring Rules on Boot

To automatically restore nftables rules on boot, you can create a systemd service or modify the nftables service to load the saved configuration:

```bash
sudo systemctl enable nftables
sudo systemctl start nftables

#!/usr/sbin/nft -f

flush ruleset

table inet filter {
        chain input {
                type filter hook input priority filter;
        }
        chain forward {
                type filter hook forward priority filter;
        }
        chain output {
                type filter hook output priority filter;
        }
}


sudo nft list ruleset

# Warning: table ip filter is managed by iptables-nft, do not touch!
table ip filter {
        chain LIBVIRT_INP {
                iifname "virbr0" udp dport 53 counter packets 0 bytes 0 accept
                iifname "virbr0" tcp dport 53 counter packets 0 bytes 0 accept
                iifname "virbr0" udp dport 67 counter packets 0 bytes 0 accept
                iifname "virbr0" tcp dport 67 counter packets 0 bytes 0 accept
        }

        chain INPUT {
                type filter hook input priority filter; policy accept;
                iifname "mpqemubr0" meta l4proto tcp tcp dport 53  counter packets 0 bytes 0 accept
                iifname "mpqemubr0" meta l4proto udp udp dport 53  counter packets 125 bytes 9831 accept
                iifname "mpqemubr0" meta l4proto udp udp dport 67  counter packets 127 bytes 38359 accept
                counter packets 5235 bytes 566046 jump LIBVIRT_INP
        }

        chain LIBVIRT_OUT {
                oifname "virbr0" udp dport 53 counter packets 0 bytes 0 accept
                oifname "virbr0" tcp dport 53 counter packets 0 bytes 0 accept
                oifname "virbr0" udp dport 68 counter packets 0 bytes 0 accept
                oifname "virbr0" tcp dport 68 counter packets 0 bytes 0 accept
        }

        chain OUTPUT {
                type filter hook output priority filter; policy accept;
                oifname "mpqemubr0" meta l4proto tcp tcp sport 53  counter packets 0 bytes 0 accept
                oifname "mpqemubr0" meta l4proto udp udp sport 53  counter packets 125 bytes 17404 accept
                oifname "mpqemubr0" meta l4proto udp udp sport 67  counter packets 126 bytes 41328 accept
                counter packets 4827 bytes 547942 jump LIBVIRT_OUT
        }

        chain LIBVIRT_FWO {
                ip saddr 192.168.122.0/24 iifname "virbr0" counter packets 0 bytes 0 accept
                iifname "virbr0" counter packets 0 bytes 0 reject
        }

        chain FORWARD {
                type filter hook forward priority filter; policy accept;
                iifname "mpqemubr0" oifname "mpqemubr0"  counter packets 36 bytes 9936 accept
                iifname "mpqemubr0" ip saddr 10.72.173.0/24  counter packets 12924 bytes 793351 accept
                oifname "mpqemubr0" ip daddr 10.72.173.0/24 ct state related,established  counter packets 71958 bytes 106919940 accept
                counter packets 0 bytes 0 jump LIBVIRT_FWX
                counter packets 0 bytes 0 jump LIBVIRT_FWI
                counter packets 0 bytes 0 jump LIBVIRT_FWO
                iifname "mpqemubr0"  counter packets 0 bytes 0 reject
                oifname "mpqemubr0"  counter packets 0 bytes 0 reject
        }

        chain LIBVIRT_FWI {
                ip daddr 192.168.122.0/24 oifname "virbr0" ct state related,established counter packets 0 bytes 0 accept
                oifname "virbr0" counter packets 0 bytes 0 reject
        }

        chain LIBVIRT_FWX {
                iifname "virbr0" oifname "virbr0" counter packets 0 bytes 0 accept
        }
}
# Warning: table ip nat is managed by iptables-nft, do not touch!
table ip nat {
        chain LIBVIRT_PRT {
                ip saddr 192.168.122.0/24 ip daddr 224.0.0.0/24 counter packets 0 bytes 0 return
                ip saddr 192.168.122.0/24 ip daddr 255.255.255.255 counter packets 0 bytes 0 return
                ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 ip protocol tcp counter packets 0 bytes 0 masquerade to :1024-65535
                ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 ip protocol udp counter packets 0 bytes 0 masquerade to :1024-65535
                ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 counter packets 0 bytes 0 masquerade
        }

        chain POSTROUTING {
                type nat hook postrouting priority srcnat; policy accept;
                ip saddr 10.72.173.0/24 ip daddr != 10.72.173.0/24  counter packets 451 bytes 34872 masquerade
                meta l4proto udp ip saddr 10.72.173.0/24 ip daddr != 10.72.173.0/24  counter packets 0 bytes 0 masquerade to :1024-65535
                meta l4proto tcp ip saddr 10.72.173.0/24 ip daddr != 10.72.173.0/24  counter packets 0 bytes 0 masquerade to :1024-65535
                ip saddr 10.72.173.0/24 ip daddr 255.255.255.255  counter packets 0 bytes 0 return
                ip saddr 10.72.173.0/24 ip daddr 224.0.0.0/24  counter packets 0 bytes 0 return
                counter packets 499 bytes 46411 jump LIBVIRT_PRT
        }
}
# Warning: table ip mangle is managed by iptables-nft, do not touch!
table ip mangle {
        chain LIBVIRT_PRT {
                oifname "virbr0" udp dport 68 counter packets 0 bytes 0 xt target "CHECKSUM"
        }

        chain POSTROUTING {
                type filter hook postrouting priority mangle; policy accept;
                oifname "mpqemubr0" meta l4proto udp udp dport 68  counter packets 126 bytes 41328 xt target "CHECKSUM"
                counter packets 89996 bytes 108329901 jump LIBVIRT_PRT
        }
}
table ip6 filter {
        chain LIBVIRT_INP {
        }

        chain INPUT {
                type filter hook input priority filter; policy accept;
                counter packets 85031 bytes 125136806 jump LIBVIRT_INP
        }

        chain LIBVIRT_OUT {
        }

        chain OUTPUT {
                type filter hook output priority filter; policy accept;
                counter packets 46559 bytes 3671714 jump LIBVIRT_OUT
        }

        chain LIBVIRT_FWO {
        }

        chain FORWARD {
                type filter hook forward priority filter; policy accept;
                counter packets 41 bytes 7954 jump LIBVIRT_FWX
                counter packets 41 bytes 7954 jump LIBVIRT_FWI
                counter packets 41 bytes 7954 jump LIBVIRT_FWO
        }

        chain LIBVIRT_FWI {
        }

        chain LIBVIRT_FWX {
        }
}
table ip6 nat {
        chain LIBVIRT_PRT {
        }

        chain POSTROUTING {
                type nat hook postrouting priority srcnat; policy accept;
                counter packets 0 bytes 0 jump LIBVIRT_PRT
        }
}
table ip6 mangle {
        chain LIBVIRT_PRT {
        }

        chain POSTROUTING {
                type filter hook postrouting priority mangle; policy accept;
                counter packets 46600 bytes 3679668 jump LIBVIRT_PRT
        }
}
```

