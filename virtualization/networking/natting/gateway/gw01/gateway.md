# **[Configure Linux as a Router (IP Forwarding)](https://www.linode.com/docs/guides/linux-router-and-ip-forwarding/)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

## IMPORTANT

THIS WONT WORK IF DOCKER IS INSTALLED. IT WILL INTERFERE WITH DOCKERS POSTROUTING CHAIN AND YOU WILL NOT HAVE ACCESS TO THE INTERNET.

## gw01

- Add a 2nd IP address of 172.16.2.1/24.
- enable port-forwarding.

```bash

# sysctl is a tool and a system call used to view and modify kernel parameters at runtime. It allows administrators to fine-tune system behavior without needing to reboot, a
sudo vi /etc/sysctl.conf
# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1

# Uncomment the next line to enable packet forwarding for IPv6
#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
net.ipv6.conf.all.forwarding=1

# Once the changes are saved, run the following command (or reboot the machine) to apply them:

# Router Instance

sudo sysctl -p
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
```

Configure the utility to allow port forwarding. This is the default setting for many systems.

```bash
# accept everything
# sudo iptables -D FORWARD -j ACCEPT
sudo iptables -A FORWARD -j ACCEPT
# sudo iptables -S
# -P INPUT ACCEPT
# -P FORWARD ACCEPT
# -P OUTPUT ACCEPT
```

## Option 1: Configure NAT (network address translation) within the utility

This modifies the IP address details in network packets, allowing all systems on the private network to share the same public IP address of the router. Replace 172.16.2.0/24 in the following command with the subnet of your private VLAN.

```bash
# sudo iptables -t nat -s 172.16.2.0/24 -D POSTROUTING -j MASQUERADE
sudo iptables -t nat -s 172.16.2.0/24 -A POSTROUTING -j MASQUERADE
```

## Option # 2: set up masquerading for all subnets

```bash
# allow NAT over all traffic
sudo iptables -t nat -D POSTROUTING -j MASQUERADE
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
# sudo iptables -t nat -S
# -P PREROUTING ACCEPT
# -P INPUT ACCEPT
# -P OUTPUT ACCEPT
# -P POSTROUTING ACCEPT
# -A POSTROUTING -j MASQUERADE
```
