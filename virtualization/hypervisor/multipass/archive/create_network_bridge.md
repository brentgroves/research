# **[Create a network bridge with iproute](https://wiki.archlinux.org/title/network_bridge)**

## Summary

Adding a bridge using iproute2 worked for a while but then the bridge deletes itself. Is network manager deleting it?  I don't know for sure.

## references

- **[iproute2 bridge cli](https://manpages.debian.org/unstable/iproute2/bridge.8.en.html)**

## Adding the main network interface

If you are doing this on a remote server, and the plan is to add the main network interface (e.g. eth0) to the bridge, first take note of the current network status:

```bash
ssh brent@repsys13
ip address show eno3

8: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
    altname enp1s0f2
    inet 10.1.0.138/22 brd 10.1.3.255 scope global noprefixroute eno3
       valid_lft forever preferred_lft forever
    inet6 fe80::4418:3ffb:954b:9cea/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
ip route show dev eno3
default via 10.1.1.205 proto static metric 101 
10.1.0.0/22 proto kernel scope link src 10.1.0.138 metric 101 
```

For this example, this is the relevant info:

- IP address attached to eno3: 10.1.0.138/22
- Default gateway: 10.1.1.205
- Bridge name: br0

Initial setup for the bridge:

```bash
# ip link add name br0 type bridge
# ip link set dev br0 up
# ip address add 10.1.0.138/22 dev br0
# ip route append default via 10.1.1.205 dev br0
ssh brent@repsys13
cat << EOF > bridge1.sh
ip link add name br0 type bridge
ip link set dev br0 up
ip address add 10.1.0.138/22 dev br0
ip route append default via 10.1.1.205 dev br0
ip link set eno3 master br0
ip address del 10.1.0.138/22 dev eno3
EOF
chmod +x bridge1.sh
```

Then, execute these commands in quick succession. It is advisable to put them in a script file and execute the script:

It is rarely a good idea to have sudo inside scripts. Instead, remove the sudo from the script and run the script itself with sudo:

```sudo bridge1.sh```

Was the ip address deleted from eno3?

```bash
ip address show eno3
8: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
    altname enp1s0f2
    inet6 fe80::4418:3ffb:954b:9cea/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

Was the routes removed from eno3?

```bash
ip route show dev eno3
```

Was the ip address added to br0?

```bash
ip address show br0
23: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 5e:42:d4:e4:fc:66 brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.138/22 scope global br0
       valid_lft forever preferred_lft forever
    inet6 fe80::5c42:d4ff:fee4:fc66/64 scope link 
       valid_lft forever preferred_lft forever
```

Was the default route added to br0?

```bash
ip route show dev br0
default via 10.1.1.205 
10.1.0.0/22 proto kernel scope link src 10.1.0.138
## compare this to the original route
ip route show dev eno3
default via 10.1.1.205 proto static metric 101 
10.1.0.0/22 proto kernel scope link src 10.1.0.138 metric 101 
```

Can we ping the bridge from a different host?

```bash
ping -c 1 -n 10.1.0.138

PING 10.1.0.138 (10.1.0.138) 56(84) bytes of data.
64 bytes from 10.1.0.138: icmp_seq=1 ttl=64 time=0.436 ms

--- 10.1.0.138 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.436/0.436/0.436/0.000 ms
```

check the interfaces with address command

```bash
ip address show br0  
23: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 5e:42:d4:e4:fc:66 brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.138/22 scope global br0
       valid_lft forever preferred_lft forever
    inet6 fe80::5c42:d4ff:fee4:fc66/64 scope link 
       valid_lft forever preferred_lft forever

ip address show eno3
8: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
    altname enp1s0f2
    inet6 fe80::4418:3ffb:954b:9cea/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever
```

Can we pass the bridge to multipass?

```bash
multipass launch --name test9 --network name=br0
```

Does the DHCP address show up?

```bash
multipass list 
Name                    State             IPv4             Image
test9                   Running           10.161.38.233    Ubuntu 24.04 LTS
                                          10.1.2.224
```

Check instance network settings and grab the hardware address.

```bash
multipass exec -n test9 -- sudo networkctl -a status
...
● 3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:0b:f4:73
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.2.224 (DHCP4 via 10.1.2.69)
                              fe80::5054:ff:fe0b:f473
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x24721ac8/DUID
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab117777a31c5cb67832

Jun 19 18:40:02 test9 systemd-networkd[714]: enp6s0: Configuring with /run/systemd/network/10-netplan-extra0.network.
Jun 19 18:40:02 test9 systemd-networkd[714]: enp6s0: Link UP
Jun 19 18:40:02 test9 systemd-networkd[714]: enp6s0: Gained carrier
Jun 19 18:40:02 test9 systemd-networkd[714]: enp6s0: DHCPv4 address 10.1.2.224/22, gateway 10.1.1.205 acquired from 10.1.2.69
Jun 19 18:40:04 test9 systemd-networkd[714]: enp6s0: Gained IPv6LL
```

Since the multipass VM is configured to use networkd we can use netplan to configure the enp6s0 intfaces network settings.

```bash
multipass exec -n test9 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        enp6s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:0b:f4:73"
            addresses: [10.1.0.139/22]
            routes: # i believe this replaces the gateway4 parameter
                - to: 0.0.0.0/0
                  via: 10.1.1.205  
            nameservers:
                addresses: [10.1.2.69,10.1.2.70,172.20.0.39]
EOF'

multipass exec -n test9 -- sudo bash -c 'cat /etc/netplan/10-custom.yaml'
network:
    version: 2
    ethernets:
        enp6s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:0b:f4:73"
            addresses: [10.1.0.139/22]
            routes: # i believe this replaces the gateway4 parameter
                - to: 0.0.0.0/0
                  via: 10.1.1.205  
            nameservers:
                addresses: [10.1.2.69,10.1.2.70,172.20.0.39]

multipass exec -n test9 -- sudo netplan apply
** (generate:3187): WARNING **: 18:54:10.577: Permissions for /etc/netplan/10-custom.yaml are too open. Netplan configuration should NOT be accessible by others.

multipass exec -n test9 -- sudo networkctl -a status
● 3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-enp6s0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:0b:f4:73
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.0.139
                              fe80::5054:ff:fe0b:f473
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
           Activation Policy: up
         Required For Online: yes
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab117777a31c5cb67832
```

Can we ping the VM from a different host?

```bash
ping -c 1 -n 10.1.0.139

PING 10.1.0.139 (10.1.0.139) 56(84) bytes of data.
64 bytes from 10.1.0.139: icmp_seq=1 ttl=64 time=1.29 ms

--- 10.1.0.139 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 1.291/1.291/1.291/0.000 ms
```

Can we ping the internet from the VM?

```bash
multipass shell test9 

ping -c 1 -n google.com
PING google.com (142.250.191.238) 56(84) bytes of data.
64 bytes from 142.250.191.238: icmp_seq=1 ttl=59 time=13.7 ms

--- google.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 13.733/13.733/13.733/0.000 ms
```
