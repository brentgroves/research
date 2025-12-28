# **[How to Bridge Two Network Interfaces in Linux Using Netplan](https://www.tecmint.com/netplan-bridge-network-interfaces/)**

## netplan

Netplan is a utility for easily configuring networking on a Linux system, typically used in Ubuntu. It allows users to configure network interfaces through a simple YAML file.

One common use case is creating a network bridge, which is useful for connecting two or more network interfaces to share a network segment, which is particularly useful in virtualized environments.

## Why Bridging Interfaces is Useful

Bridging network interfaces can be highly beneficial in various scenarios:

- When running virtual machines (VMs), you often need the VMs to communicate with the external network. A bridge allows VMs to appear as if they are physically connected to the same network as the host machine.
- It allows multiple network interfaces to share a single IP subnet, facilitating easier management and communication within the network.
- In complex network setups, bridges can simplify configurations and reduce the need for additional routing.

## Installing bridge-utils in Ubuntu

To bridge network interfaces, you need to install a bridge-utils package which is used to configure and manage network bridges in Linux-based systems.

```bash
sudo apt install bridge-utils
```

## Creating a Network Bridge Using Static IP

Similar to the DHCP configuration, you can also configure static IP addresses on the bridge in the same configuration file.

```bash
# create backup
cd ~
sudo cp /etc/netplan/50-cloud-init.yaml .
sudo vi /etc/netplan/50-cloud-init.yaml
```

## Configure network with netplan and a bridge

This is the config file for our r620s which our connected to a trunk port with 2 vlan configured, vlan 50 being the default tag when no packet tag info is present.

```yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled
network:
  version: 2
  ethernets:
    eno1:
      dhcp4: false
      dhcp6: false
  vlans:
    vlan220:
      id: 220
      link: eno1
  bridges:
    br0:
      dhcp4: false
      dhcp6: false  
      addresses:
      - 10.188.50.202/24    
      routes:
      - to: default
        via: 10.188.50.254
      nameservers:
        addresses:
        - 10.225.50.203
        - 10.224.50.203
      interfaces: [eno1] 
    br1:
      interfaces: ["vlan220"]
      dhcp4: false
      dhcp6: false  
      addresses:
      - 10.188.220.202/24
      nameservers:
        addresses:
        - 10.225.50.203
        - 10.224.50.203
      routes:
        - to: 10.188.73.0/24
          via: 10.188.220.254      
```

Apply the Configuration Changes: Once you’ve edited the configuration file, apply the changes to update your network settings.

```bash
sudo netplan try
$ sudo netplan apply
reboot
```

## Verify routing tables

**[references iproute2 intro for ip commands](../networking/iproute2/introduction_to_iproute.md)**

```bash
ip route list table local
local 10.130.245.1 dev mpqemubr0 proto kernel scope host src 10.130.245.1 
broadcast 10.130.245.255 dev mpqemubr0 proto kernel scope link src 10.130.245.1 
local 10.188.50.203 dev br0 proto kernel scope host src 10.188.50.203 
broadcast 10.188.50.255 dev br0 proto kernel scope link src 10.188.50.203 
local 10.188.220.203 dev vlan220 proto kernel scope host src 10.188.220.203 
broadcast 10.188.220.255 dev vlan220 proto kernel scope link src 10.188.220.203 
local 127.0.0.0/8 dev lo proto kernel scope host src 127.0.0.1 
local 127.0.0.1 dev lo proto kernel scope host src 127.0.0.1 
broadcast 127.255.255.255 dev lo proto kernel scope link src 127.0.0.1 

# there should be only 1 default route
# ip route list table main
ip route show
default via 10.188.50.254 dev br0 proto static 
10.130.245.0/24 dev mpqemubr0 proto kernel scope link src 10.130.245.1 
10.188.50.0/24 dev br0 proto kernel scope link src 10.188.50.203 
10.188.73.0/24 via 10.188.220.254 dev vlan220 proto static 
10.188.220.0/24 dev vlan220 proto kernel scope link src 10.188.220.203 


# You can view your machines current arp/neighbor cache/table like so:
ip neigh show
10.130.245.2 dev mpqemubr0 FAILED 
10.130.245.158 dev mpqemubr0 lladdr 52:54:00:12:cb:af STALE 
10.188.50.25 dev br0 lladdr 50:6b:8d:de:4f:7b STALE 
10.188.220.251 dev vlan220 lladdr e4:db:ae:c2:29:0d STALE 
10.188.50.254 dev br0 lladdr 00:00:5e:00:01:0a DELAY 
10.188.220.50 dev vlan220 lladdr 50:6b:8d:b2:79:c0 STALE 
10.188.220.254 dev vlan220 lladdr 00:00:5e:00:01:66 STALE 
10.188.50.252 dev br0 lladdr e4:db:ae:c6:f9:0c STALE 
10.188.50.251 dev br0 lladdr e4:db:ae:c2:29:0c STALE 
10.188.220.252 dev vlan220 lladdr e4:db:ae:c6:f9:0d STALE 
10.188.50.79 dev br0 lladdr 50:6b:8d:d3:fd:1f STALE 

# view devices linked to bridge
ip link show master br0
6: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP mode DEFAULT group default qlen 1000
    link/ether b8:ca:3a:6a:37:18 brd ff:ff:ff:ff:ff:ff
    altname enp1s0f0

# vlan filtering at the bridge seems unnecessary since vlan is configured outside of bridge.
ip -j -p -d link show br0 | grep vlan
                "vlan_filtering": 0,
                "vlan_protocol": "802.1Q",
                "vlan_default_pvid": 1,
                "vlan_stats_enabled": 0,
                "vlan_stats_per_port": 0,
                "mcast_vlan_snooping": 0, 

