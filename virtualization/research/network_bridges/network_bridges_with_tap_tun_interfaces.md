# **[Network bridges and tun/tap interfaces in Linux](https://krackout.wordpress.com/2020/03/08/network-bridges-and-tun-tap-interfaces-in-linux/)**

Here are some net bridges and tun/tap setups on Linux. I use them for qemu/kvm VMs and LXC containers. I’ll try to explain each one.

## Private bridge, VM to VM only (tap to tap)

It’s used for communication between two or more VMs. They communicate only to each other, no access to Internet or host.

```bash
# add a net bridge named Gefyra0
ip link add Gefyra0 type bridge
ip link set Gefyra0 up
# add 2 tun/tap interfaces for VMs
ip tuntap add QemuTap0 mode tap user A_Username
ip tuntap add QemuTap1 mode tap user A_Username
ip link set QemuTap0 up
ip link set QemuTap1 up
# connect tun/tap interfaces with brigde
ip link set QemuTap0 master Gefyra0
ip link set QemuTap1 master Gefyra0
```

VM’s qemu command-line. Each VM must have a different tap interface and mac adress:
1st:
-device virtio-net-pci,netdev=network0,mac=52:54:00:21:34:56 \
-netdev tap,ifname=QemuTap0,id=network0,script=no
2st:
-device virtio-net-pci,netdev=network0,mac=52:54:00:21:34:57 \
-netdev tap,ifname=QemuTap1,id=network0,script=no

Inside the VMs, you can configure network interfaces using an arbitrary subnet and IPs on that subnet for each VM.

## Bridge using routed subnet, VM<->host

In this scenario, host and VM access and vice versa is possible.

```bash
# add a net bridge named Gefyra0
ip link add Gefyra0 type bridge
ip addr add 192.168.223.1/24 dev Gefyra0
ip link set Gefyra0 up
# add 2 tun/tap interfaces for VMs
ip tuntap add QemuTap0 mode tap user A_Username
ip tuntap add QemuTap1 mode tap user A_Username
ip link set QemuTap0 up
ip link set QemuTap1 up
# connect tun/tap interfaces with brigde
ip link set QemuTap0 master Gefyra0
ip link set QemuTap1 master Gefyra0
```

The difference with the previous setup is the 2nd line: An IP in a new subnet is assigned to the host’s bridge interface. This new subnet must not be used anywhere else.
The VMs should be configured using different tap interfaces and mac addresses (see above). The IP of each VM should be in the same subnet as the subnet of the bridge, in order for the host and VMs to communicate.

Bridge using routed subnet, VM <-> host-LAN-Internet:
It’s time for the VM to access the Internet, don’t you think? 🙂

```bash
# add a net bridge named Gefyra0
ip link add Gefyra0 type bridge
ip addr add 192.168.223.1/24 dev Gefyra0
ip link set Gefyra0 up
# add 2 tun/tap interfaces for VMs
ip tuntap add QemuTap0 mode tap user A_Username
ip tuntap add QemuTap1 mode tap user A_Username
ip link set QemuTap0 up
ip link set QemuTap1 up
# connect tun/tap interfaces with brigde
ip link set QemuTap0 master Gefyra0
ip link set QemuTap1 master Gefyra0
# enable routing
echo '1' > /proc/sys/net/ipv4/ip_forward
# -o takes as argument the interface you want to use for routing, in this example enp2s0
iptables -t nat -A POSTROUTING -o enp2s0 -j MASQUERADE
```

As usual, each VM must have each own tap int, mac addr, and assigned IP on the configured subnet of the bridge; see above.

Bridge to layer2 – connect VM to switch host is connected:
More explanatory title is needed, suggestions are welcome!
In this type of connection the VM is plugged – sort of – on the same switch the host machine is connected. For example, if there is a DHCP server on the network and the host machine gets its IP from that DHCP, the VM will also be capable of acquiring an IP from the same DHCP. It’s the scenario mainly used in production ESXi, Xen or HyperV VMs.

Warning: When the physical nic is assigned to a bridge it loses connection. IP must be assigned to bridge, not to physical network interface of host.

```bash
# add a net bridge named Gefyra0
ip link add Gefyra0 type bridge
ip link set Gefyra0 up
# Add one of your physical interface to the bridge, e.g for eth0:
ip link set eth0 master Gefyra0
# At this point connection to network on host is lost. If you want to restore connection:
# dhclient -v Gefyra0 (for dhcp)
# dhclient -v Gefyra0 -r (to release IP)
# ip addr add 192.168.223.1/24 dev Gefyra0 (for static IP)
# add 2 tun/tap interfaces for VMs
ip tuntap add QemuTap0 mode tap user A_Username
ip link set QemuTap0 up
ip link set QemuTap0 master Gefyra0
```

The network can be configured now on the VM.

Notes: If network-manager is used on the host, it may interfere. To be on the safe side, disable it before starting:
sudo systemctl stop NetworkManager
pkill nm-applet

Miscellaneous notes:

```bash
delete bridge:
ip link del Gefyra0

delete tap:
ip tuntap del tap0 mode tap

View all iptables firewall rules and NAT netfilter table
iptables -t nat -vL

no resolving
iptables -t nat -vL -n

show line numbers – priorities:
iptables -t nat -vL --line-number

delete line, using numbers shown by above command:
iptables -t nat -D POSTROUTING {number}

sudo iptables-legacy -t nat -vL
Chain PREROUTING (policy ACCEPT 569K packets, 56M bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain INPUT (policy ACCEPT 23368 packets, 3962K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 22953 packets, 2010K bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain POSTROUTING (policy ACCEPT 489K packets, 32M bytes)
 pkts bytes target     prot opt in     out     source               destination  
 
sudo iptables -t nat -vL
[sudo] password for brent: 
# Warning: iptables-legacy tables present, use iptables-legacy to see them
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         

Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
 487K   32M LIBVIRT_PRT  all  --  any    any     anywhere             anywhere            

Chain LIBVIRT_PRT (1 references)
 pkts bytes target     prot opt in     out     source               destination         
   60  6757 RETURN     all  --  any    any     192.168.122.0/24     base-address.mcast.net/24 
    0     0 RETURN     all  --  any    any     192.168.122.0/24     255.255.255.255     
    0     0 MASQUERADE  tcp  --  any    any     192.168.122.0/24    !192.168.122.0/24     masq ports: 1024-65535
    0     0 MASQUERADE  udp  --  any    any     192.168.122.0/24    !192.168.122.0/24     masq ports: 1024-65535
    0     0 MASQUERADE  all  --  any    any     192.168.122.0/24    !192.168.122.0/24  
```
