# **[VLAN](https://wiki.archlinux.org/title/VLAN)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

![cn](https://linuxconfig.org/wp-content/uploads/2021/03/00-how_to_use_bridged_networking_with_libvirt_and_kvm.avif)

## references

- **[vm networking libvirt/bridge](https://www.youtube.com/watch?v=6435eNKpyYw)**
- **[create a network on kvm](https://www.youtube.com/watch?v=Yl6KKRqtb9k)**
- **[multiple network interfaces](https://fmount.me/2015/06/17/qemu-multiple-networks-using-tap-networking-interfaces/)**
- **[wiki](https://wiki.qemu.org/Documentation/Networking)**
- **[virtual machine manager](https://ubuntu.com/server/docs/virtual-machine-manager)**


Virtual LANs give you the ability to subdivide a LAN. Linux can accept VLAN tagged traffic and presents each VLAN ID as a different network interface (eg: eth0.100 for VLAN ID 100).

## Instant Configuration

In the following examples, let us assume the interface is eth0, the assigned name is eth0.100 and the VLAN ID is 100.

## Create the VLAN device

Add the VLAN interface with the following command:

```bash
ip link add link eth0 name eth0.100 type vlan id 100
```

Run ip link to confirm that it has been created.

This interface behaves like a normal interface. All traffic routed to it will go through the master interface (in this example, eth0) but with a VLAN tag. Only VLAN-aware devices can accept them if configured correctly, else the traffic is dropped.

Using a name like eth0.100 is just convention and not enforced; you can alternatively use eth0_100 or something descriptive like IPTV. To see the VLAN ID on an interface, in case you used an unconventional name:

```bash
ip -details link show eth0.100
# The -details (-d) flag shows full details of an interface:

ip -details addr show
4: eth0.100@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
   link/ether 96:4a:9c:84:36:51 brd ff:ff:ff:ff:ff:ff promiscuity 0 
   vlan protocol 802.1Q id 100 <REORDER_HDR> 
   inet6 fe80::944a:9cff:fe84:3651/64 scope link 
      valid_lft forever preferred_lft forever
```

## Add an IP

Now add an IPv4 address to the just created VLAN link, and activate the link:

```bash
ip addr add 192.168.100.1/24 brd 192.168.100.255 dev eth0.100
ip link set dev eth0.100 up
```

## Turning down the device

To cleanly shut down the setting before you remove the link, you can do:

```bash
ip link set dev eth0.100 down
```

## Removing the device

Removing a VLAN interface is significantly less convoluted

```bash
ip link delete eth0.100
```

## Persistent Configuration

systemd-networkd
Single interface
Use the following number-prefixed configuration files (Remember the file contents are case sensitive and the number-prefix can be changed):

```bash
/etc/systemd/network/10-eth0.network
[Match]
Name=eth0

[Network]
DHCP=ipv4
;these are arbitrary names, but must match the *.netdev and *.network files
VLAN=eth0.100
VLAN=eth0.200
/etc/systemd/network/20-eth0.100.netdev
[NetDev]
Name=eth0.100
Kind=vlan

[VLAN]
Id=100
/etc/systemd/network/21-eth0.200.netdev
[NetDev]
Name=eth0.200
Kind=vlan

[VLAN]
Id=200
```
You will have to have associated .network files for each .netdev to handle addressing and routing. For example, to set the eth0.100 interface with a static IP and the eth0.200 interface with DHCP (but ignoring the supplied default route), use:

