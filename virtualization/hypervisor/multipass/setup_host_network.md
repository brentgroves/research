# **[Setup Host Network](https://www.tecmint.com/netplan-bridge-network-interfaces/)**

## Installing bridge-utils in Ubuntu

To bridge network interfaces, you need to install a bridge-utils package which is used to configure and manage network bridges in Linux-based systems.

```bash
sudo apt install bridge-utils
```

## Configure network with netplan and a bridge

**[netplan config directory](./netplan/)**

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

## show host routing table

```bash
ssh brent@10.188.50.202
ip route 
default via 10.188.50.254 dev br0 proto static 
10.97.219.0/24 dev mpqemubr0 proto kernel scope link src 10.97.219.1 
10.188.50.0/24 dev br0 proto kernel scope link src 10.188.50.202 
10.188.73.0/24 via 10.188.220.254 dev br1 proto static 
10.188.220.0/24 dev br1 proto kernel scope link src 10.188.220.202
```

## verify the host can access routable networks

```yaml
frt: 10.184
mus: 10.181
sou: 10.185
alb1: 10.187
avi: 10.188
alb2: 10.189
```

```bash
ssh brent@10.188.50.202
ping 10.188.50.79
ping 10.188.220.50
ping 10.188.73.11
ping 10.188.40.230
ping 10.188.42.11
ping 172.20.88.64
ping 10.185.50.11
ping 10.181.50.15
ping 10.187.40.15
# FW rules
curl https://api.snapcraft.io
snapcraft.io store API service - Copyright 2018-2022 Canonical.
# Test snap
sudo snap install hello-world
```

## verify access from routable network to the each host IP

```yaml
frt: 10.184
mus: 10.181
sou: 10.185
alb1: 10.187
avi: 10.188
alb2: 10.189
```

### Repeat for every network that has access to host

```bash
ssh brent@10.188.40.230
ping 10.188.50.202
ping 10.188.220.202
```
