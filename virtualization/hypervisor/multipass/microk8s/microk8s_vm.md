# **[MicroK8s VM]()**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## references

- **[How to Bridge Two Network Interfaces in Linux Using Netplan](https://www.tecmint.com/netplan-bridge-network-interfaces/)**
- **[bridge commands](https://developers.redhat.com/articles/2022/04/06/introduction-linux-bridging-commands-and-features#spanning_tree_protocol)

## **[Create a Bridge](../create_bridges_with_netplan.md)**

```yaml
# This file is generated from information provided by the datasource.  Changes
# to it will not persist across an instance reboot.  To disable cloud-init's
# network configuration capabilities, write a file
# /etc/cloud/cloud.cfg.d/99-disable-network-config.cfg with the following:
# network: {config: disabled}
network:
    ethernets:
        eno1:
            addresses:
            - 10.1.0.125/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: [BUSCHE-CNC.COM]
            routes:
            -   to: default
                via: 10.1.1.205
        eno2:
            dhcp4: no
        eno3:
            dhcp4: true
        eno4:
            dhcp4: true
        enp66s0f0:
            dhcp4: true
        enp66s0f1:
            dhcp4: true
        enp66s0f2:
            dhcp4: true
        enp66s0f3:
            dhcp4: true
    bridges:
        br0:
            dhcp4: no
            addresses:
            - 10.1.0.126/22
            nameservers:
                addresses:
                - 10.1.2.69
                - 10.1.2.70
                - 172.20.0.39
                search: [BUSCHE-CNC.COM]
            interfaces: [eno2]
        br1:
            dhcp4: no
            addresses:
            - 10.13.31.1/24
    version: 2
```

Show bridge details in a pretty JSON format (which is a good way to get bridge key-value pairs):

```bash
# ip -j -p -d link show br0
ip -j -p -d link show br0

# show tap devices and master bridges
bridge link show
# bridge link show master br0
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 5 
13: tap434bfb4d: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master mpbr0 state forwarding priority 32 cost 2 
14: tap34dcb760: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br0 state forwarding priority 32 cost 2 
15: tap7a27ad4e: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master mpbr0 state forwarding priority 32 cost 2 
16: tapf48799c9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master br1 state forwarding priority 32 cost 2
```
