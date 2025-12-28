#!/bin/bash
# cd ~/src/repsys/research/m_z/virtualization/networking/tutorial/iptables_nft/port_forwarding/namespaces/research21/
# ./recreate_rules

# The bash variable $EUID shows the effective UID the script is running at, if you want to make sure the script runs as root, check wether $EUID contains the value 0 or not:
if [[ $EUID -ne 0 ]]; then
    echo "$0 is not running as root. Try using sudo."
    exit 2
fi
# nat: This table is consulted when a packet that creates a new connection is encountered. 
# It consists of three built-ins: PREROUTING (for altering packets as soon as they come in), 
# OUTPUT (for altering locally-generated packets before routing), and POSTROUTING (for altering 
# packets as they are about to go out).

# Parameter Description
# -p, --protocol The protocol, such as TCP, UDP, etc.
# -s, --source Can be an address, network name, hostname, etc.
# -d, --destination An address, hostname, network name, etc.
# -j, --jump Specifies the target of the rule; i.e. what to do if the packet matches.
# -m is for matching module name and not string. By using a particular module you get 
# certain options to match. See the cpu module example above. With the -m tcp the module tcp is loaded. The tcp module allows certain options: --dport, --sport, --tcp-flags, --syn, --tcp-option to use in iptables rules

# iptables -t nat -S
# allow inbound and outbound forwarding
iptables -D FORWARD -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.188.50.202 --dport 8080 -j ACCEPT

iptables -D FORWARD -s 10.188.50.202/32 -p tcp -m tcp --sport 8080 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.188.50.202 --sport 8080 -j ACCEPT

# iptables -t nat -S
# route packets arriving at external IP/port to LAN machine
iptables -t nat -D PREROUTING -d 10.187.40.123/32 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
iptables -t nat -A PREROUTING  -p tcp -d 10.187.40.123 --dport 8080 -j DNAT --to-destination 10.188.50.202:8080

# rewrite packets going to LAN machine (identified by address/port)
# to originate from gateway's internal address
iptables -t nat -D PREROUTING -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j SNAT --to-source 10.187.40.123
iptables -t nat -A POSTROUTING -t nat -p tcp -d 10.188.50.202 --dport 8080 -j SNAT --to-source 10.187.40.123

