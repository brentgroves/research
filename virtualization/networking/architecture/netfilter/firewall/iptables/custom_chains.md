# **[Custom Chains](https://sleeplessbeastie.eu/2018/06/21/how-to-create-iptables-firewall-using-custom-chains/)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

## **[command syntax](https://www.linode.com/docs/guides/what-is-iptables/)**

POSTROUTING LIBVIRT_PRT target jumps to LIBVIRT_PRT custom chain rules.

```bash
iptables -t nat -L
# Warning: iptables-legacy tables present, use iptables-legacy to see them
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         
DNAT       tcp  --  anywhere             anywhere             tcp dpt:x11 to:192.168.0.2:8080

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
LIBVIRT_PRT  all  --  anywhere             anywhere            
MASQUERADE  all  --  192.168.0.0/24       anywhere            
MASQUERADE  all  --  192.168.0.0/24       anywhere            

Chain LIBVIRT_PRT (1 references)
target     prot opt source               destination         
RETURN     all  --  192.168.122.0/24     base-address.mcast.net/24 
RETURN     all  --  192.168.122.0/24     255.255.255.255     
MASQUERADE  tcp  --  192.168.122.0/24    !192.168.122.0/24     masq ports: 1024-65535
MASQUERADE  udp  --  192.168.122.0/24    !192.168.122.0/24     masq ports: 1024-65535
MASQUERADE  all  --  192.168.122.0/24    !192.168.122.0/24  
```

## How to create iptables firewall using custom chains

Create an iptables firewall using custom chains that will be used to control incoming and outgoing traffic.

Create an iptables firewall that will allow already established connections, incoming ssh for given source addresses, outgoing icmp, ntp, dns, ssh, http, and https.

```bash
# Flush rules and delete custom chains
iptables -F
iptables -X

# Define chain to allow particular source addresses
iptables -N chain-incoming-ssh
iptables -A chain-incoming-ssh -s 192.168.1.148 -j ACCEPT
iptables -A chain-incoming-ssh -s 192.168.1.149 -j ACCEPT
iptables -A chain-incoming-ssh -j DROP

# Define chain to allow particular services
iptables -N chain-outgoing-services
iptables -A chain-outgoing-services -p tcp --dport 53  -j ACCEPT
iptables -A chain-outgoing-services -p udp --dport 53  -j ACCEPT
iptables -A chain-outgoing-services -p tcp --dport 123 -j ACCEPT
iptables -A chain-outgoing-services -p udp --dport 123 -j ACCEPT
iptables -A chain-outgoing-services -p tcp --dport 80  -j ACCEPT
iptables -A chain-outgoing-services -p tcp --dport 443 -j ACCEPT
iptables -A chain-outgoing-services -p tcp --dport 22  -j ACCEPT
iptables -A chain-outgoing-services -p icmp            -j ACCEPT
iptables -A chain-outgoing-services -j DROP

# Define chain to allow established connections
iptables -N chain-states
iptables -A chain-states -p tcp  -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A chain-states -p udp  -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A chain-states -p icmp -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A chain-states -j RETURN

# Drop invalid packets
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# Accept everything on loopback
iptables -A INPUT  -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Accept incoming/outgoing packets for established connections
iptables -A INPUT  -j chain-states
iptables -A OUTPUT -j chain-states

# Accept incoming ICMP
iptables -A INPUT -p icmp -j ACCEPT

# Accept incoming SSH
iptables -A INPUT -p tcp --dport 22 -j chain-incoming-ssh

# Accept outgoing 
iptables -A OUTPUT -j chain-outgoing-services

## Drop everything else
iptables -P INPUT   DROP
iptables -P FORWARD DROP
iptables -P OUTPUT  DROP
```

List all firewall rules to verify that executed commands are applied as desired.

```bash
sudo iptables -L -v -n

nft list tables
table ip filter
table ip nat
table ip mangle
table ip6 filter
table ip6 nat
table ip6 mangle
table inet lxc
table ip lxc
table inet lxd
```

The 3 main tables in iptables are the `Filter, NAT, and Mangle` tables. The Filter Table is used to control the flow of packets in and out of a system. The NAT Table is used to redirect connections to other interfaces on the network. The Mangle Table is used to modify packet headers.

LIBVIRT is using IPTABLES, but LXC and LXD are using NFTABLES
