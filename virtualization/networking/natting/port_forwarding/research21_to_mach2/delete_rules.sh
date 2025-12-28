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

iptables -t nat -D POSTROUTING -s 192.168.0.0/24 -o enp0s25 -j MASQUERADE > /dev/null 2>&1
iptables -D FORWARD -i enp0s25 -o veth0 -p tcp -m tcp --dport 8080 --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j ACCEPT > /dev/null 2>&1
iptables -D FORWARD -i enp0s25 -o veth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -D FORWARD -i veth0 -o enp0s25 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -t nat -D PREROUTING -i enp0s25 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 192.168.0.2
iptables -t nat -D PREROUTING -i enp0s25 -p tcp -m tcp --dport 6000 -j DNAT --to-destination 192.168.0.2:8080
