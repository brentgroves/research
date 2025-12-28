# **[Creating a bridge](https://wiki.archlinux.org/title/network_bridge)**

## summary

Compared the bridge I created to the bridge multipass makes below. the commented lines are the lines of the automatically generated bridge multipass makes when it enslaves the interface.  Creating a bridge using iproute2 and enslaving the secondary network interface worked ok for non-main network interface such as eno3, but I still let multipass handle the bridge creation for the primary interface but do not use manual mode unless I am sure of the mac address problem.

## With iproute2

This section describes the management of a network bridge using the ip tool from the iproute2 package, which is required by the base meta package.

Adding the main network interface
If you are doing this on a remote server, and the plan is to add the main network interface (e.g. eth0) to the bridge, first take note of the current network status:

```bash
ip address show eno3
8: eno3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mybr-eno3 state UP group default qlen 1000
    link/ether b8:ca:3a:6a:35:9a brd ff:ff:ff:ff:ff:ff
    altname enp1s0f2
    inet 10.1.0.138/22 brd 10.1.3.255 scope global noprefixroute eno3
       valid_lft forever preferred_lft forever
    inet6 fe80::4418:3ffb:954b:9cea/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

ip route show dev eno3

default via 10.1.1.205 proto dhcp metric 102 
10.1.0.0/22 proto kernel scope link src 10.1.0.138 metric 102 
```

Note: did not do anything to eno3, but it was not the main interface.

Initial setup for the bridge:

```bash
# ip link add name br0 type bridge
sudo ip link add name mybr-eno3 type bridge
# show bridge details
ip -d link show mybr-eno3
# Show bridge details in a pretty JSON format (which is a good way to get bridge key-value pairs):
ip -j -p -d link how mybr-eno3
# NOTE: compared this bridge to the bridge multipass makes below. the commented lines are the lines of the automatically generated bridge multipass makes when it enslaves the interface
ip -j -p -d link show mybr-eno3
[ {
        # "flags": [ "BROADCAST","MULTICAST","UP","LOWER_UP" ],
        "flags": [ "BROADCAST","MULTICAST" ],
        # "operstate": "UP",
        "operstate": "DOWN",
        "linkinfo": {
            "info_kind": "bridge",
            "info_data": {
                # "stp_state": 1,
                "stp_state": 0,
                # "root_port": 1,
                # "root_path_cost": 127,
                "root_port": 0,
                "root_path_cost": 0,
                # "gc_timer": 31.25,
                "gc_timer": 0.00,
            }
        },
        # "inet6_addr_gen_mode": "none",
        "inet6_addr_gen_mode": "eui64",
    } ]

# ip link set dev br0 up 
sudo ip link set dev mybr-eno3 up

# Adding the interface into the bridge is done by setting its master to bridge_name:
# ip link set eth1 master bridge_name
ip link set eno3 master mybr-eno3

# To show the existing bridges and associated interfaces, use the bridge utility (also part of iproute2). See bridge(8) for details.

bridge link

# This is how to remove an interface from a bridge:
# ip link set eth1 nomaster

# The interface will still be up, so you may also want to bring it down:
# ip link set eth1 down

# To delete a bridge issue the following command:
# ip link delete bridge_name type bridge
```

Linux bridging has supported STP since the 2.4 and 2.6 kernel series. To enable STP on a bridge, enter:

```bash
# ip link set br0 type bridge stp_state 1
ip link set mybr-eno3 type bridge stp_state 1
```

## test bridge on multipass vm

```bash
# bridge i made with iproute2 worked when using non-main network interface eno3.
multipass exec -n test8 -- sudo networkctl -a status
3: enp6s0
                   Link File: /usr/lib/systemd/network/99-default.link
                Network File: /run/systemd/network/10-netplan-extra0.network
                       State: routable (configured)
                Online state: online                                         
                        Type: ether
                        Path: pci-0000:06:00.0
                      Driver: virtio_net
                      Vendor: Red Hat, Inc.
                       Model: Virtio 1.0 network device
            Hardware Address: 52:54:00:b6:62:e9
                         MTU: 1500 (min: 68, max: 65535)
                       QDisc: mq
IPv6 Address Generation Mode: eui64
    Number of Queues (Tx/Rx): 2/2
            Auto negotiation: no
                     Address: 10.1.3.39 (DHCP4 via 10.1.2.69)
                              fe80::5054:ff:feb6:62e9
                     Gateway: 10.1.1.205
                         DNS: 10.1.2.69
                              10.1.2.70
                              172.20.0.39
              Search Domains: BUSCHE-CNC.COM
           Activation Policy: up
         Required For Online: yes
             DHCP4 Client ID: IAID:0x24721ac8/DUID
           DHCP6 Client DUID: DUID-EN/Vendor:0000ab1121fdaafbb0376aea

multipass exec -n test8 -- sudo bash -c 'cat << EOF > /etc/netplan/10-custom.yaml
network:
    version: 2
    ethernets:
        enp6s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:b6:62:e9"
            addresses: [10.1.0.139/22]
            gateway4: 10.1.1.205
            nameservers:
                addresses: [10.1.2.69,10.1.2.70,172.20.0.39]
EOF'


multipass exec -n test8 -- sudo bash -c 'cat /etc/netplan/10-custom.yaml'
network:
    version: 2
    ethernets:
        enp6s0:
            dhcp4: no
            match:
                macaddress: "52:54:00:b6:62:e9"
            addresses: [10.1.0.139/22]
            gateway4: 10.1.1.205
            nameservers:
                addresses: [10.1.2.69,10.1.2.70,172.20.0.39]
multipass exec -n test8 -- sudo netplan apply
multipass exec -n test8 -- sudo networkctl -a status
```

It works ok!
