# **[Use netplan to setup two tagged Vlans](research/m_z/virtualization/networking/vlan/questions/vlan_subinterfaces.md)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

1

For my network I have setup two VLans (VLan Ids: 1 and 2) on the switch. My ubuntu core 22.04.1 machine is connected to the switch through one tagged port that allows for VLan 1 and VLan 2 traffic. This machine will later be hosting docker containers that run dhcp, dns, OpenLDAP, etc. I would like to use netplan on my ubuntu machine, since it provides me with a nice overview about my network configuration. I want to achieve:

- to have an ip address 192.168.10.101/24 in VLan 1 that is reachable from other hosts in VLan 1
- to have an ip address 192.168.20.101/24 in VLan 2 that is reachable from other hosts in VLan 2
- routing for the ubuntu machine to other hosts in both subnets 192.168.10.0/24 and 192.168.20.0/24 through the gateways 192.168.10.1 and 192.168.20.1 respectively
routing to a default gateway 192.168.10.1 for the ubuntu machine to connect to the Internet
The file /etc/netplan/00-installer-config.yml looks like:

```yaml
network:
  version: 2
  ethernets:
    enp5s0:
      dhcp4: false
    enp6s0:
      dhcp4: false
      optional: true
  vlans:
    vlan.1:
      id: 1
      link: enp5s0
      addresses:
      - 192.168.10.101/24
      nameservers:
        addresses:
        - 192.168.10.116
      routes:
      - to: default
        via: 192.168.10.1
        metric: 100
  vlans:
    vlan.2:
      id: 2
      link: enp5s0
      addresses:
      - 192.168.20.101/32
```

The output of ip route is:

default via 192.168.10.1 dev vlan.1 proto static metric 100
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1
192.168.10.0/24 dev vlan.1 proto kernel scope link src 192.168.10.101

This configuration (applied with sudo netplan apply) provides me already very close to what I want to do:

From the ubuntu machine I can
ssh into a machine on the 192.168.10.0/24 subnet
ssh into a machine on the 192.168.20.0/24 subnet
reach the Internet
From a host in the 192.168.10.0/24 subnet I can reach the ubuntu machine through 192.168.10.101
From a host in the 192.168.20.0/24 subnet I can reach the ubuntu machine through 192.168.10.101
What I am missing are the following:

From a host in the 192.168.10.0/24 subnet to reach 192.168.20.101
From a host in the 192.168.20.0/24 subnet to reach 192.168.20.101 as well.
Looking at the netplan configuration above, I assume this is due to the 192.168.20.101/32 that does not allow to reach this IP from other hosts in both subnets. I already tried to define the address with 192.168.20.101/24, but that resulted in not being able to reach any other host on the 192.168.20.0/24 subnet from the ubuntu machine.

Can somebody please help me finding out what I did wrong that prevents the ubuntu machine from being reachable through 192.168.20.101? Can I even do this with netplan or do I need to do some steps manually after applying the configuration?

2

I am so happy that I found a solution to the problem! The issue was with the same MAC address that was used for both VLans. The solution that worked for me, was to create bridges for the VLans. I have read before about (network-) bridges, but everytime I saw an example, the bridge only used one interface. For me this made no sense to bridge only with one interface, because I expected to have a second "pillar" of the bridge. In the end it turned out that this was not necessary and defining only one interface is enough:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      dhcp4: false
      match:
        macaddress: a8:5e:45:56:38:65
        name: enp5s0
      set-name: eth0
    enp6s0:
      dhcp4: false
      optional: true
  bridges:
    br0:
      interfaces: ["vlan.1"]
      addresses:
      - 192.168.10.101/24
      nameservers:
        addresses:
        - 192.168.10.116
      routes:
      - to: default
        via: 192.168.10.1
    br1:
      interfaces: ["vlan.2"]
      addresses:
      - 192.168.20.101/24

  vlans:
    vlan.1:
      id: 1
      link: eth0
      accept-ra: no
    vlan.2:
      id: 2
      link: eth0
      accept-ra: no
```

Looking at the new netplan config, the 192.168.20.101/32 could be turned back into 192.168.20.101/24. Additionally, I renamed the interface enp5s0 to eth0 (because I like the old naming better).

ip route now prints the following:

default via 192.168.10.1 dev br0 proto static
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1
192.168.10.0/24 dev br0 proto kernel scope link src 192.168.10.101
192.168.20.0/24 dev br1 proto kernel scope link src 192.168.20.101

I confirm @Marc P's findings although for me it was working by removing the routes and nameservers in the bridge defines
