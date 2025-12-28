# **[How to create a nat bridge using iproute2](https://wiki.archlinux.org/title/Network_bridge)**

**[Back to Research List](../../../../../research/research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![cn](https://linuxconfig.org/wp-content/uploads/2021/03/00-how_to_use_bridged_networking_with_libvirt_and_kvm.avif)

## references

- **[vm networking libvirt/bridge](https://www.youtube.com/watch?v=6435eNKpyYw)**
- **[create a network on kvm](https://www.youtube.com/watch?v=Yl6KKRqtb9k)**
- **[multiple network interfaces](https://fmount.me/2015/06/17/qemu-multiple-networks-using-tap-networking-interfaces/)**
- **[wiki](https://wiki.qemu.org/Documentation/Networking)**
- **[virtual machine manager](https://ubuntu.com/server/docs/virtual-machine-manager)**
## AI

how to pass 2 network interfaces to qemu vm

To pass two network interfaces to a QEMU virtual machine, use the -netdev option multiple times in the QEMU command line, specifying a different network backend (like "tap" or "bridge") for each interface, then attach each network interface to the VM using the -net nic option with the corresponding id from the -netdev command; essentially creating separate network connections for each interface within the VM. 

## **[KVM - Create a virtual machine with 2 bridges interfaces](https://askubuntu.com/questions/581771/kvm-create-a-virtual-machine-with-2-bridges-interfaces)**

7

Can someone please let me know to create a VM using KVM with 2 bridged interfaces?

I have a server that has Eth0 and Eth1 configured and connects to 2 separate networks. I'd like to create a VM within this physical blade so that the VM is bridged to both networks, so that we can control network traffic even at the VM level.

Right now, we can only get the VM to connect to br0, but how would I configure a br1? Appreciate the help!

In my qemu xml file, I have the following:

```xml
<interface type='bridge'>
 <mac address='00:11:22:33:44:55'/>
 <source bridge='br0'/>
 <model type='virtio'/>
 <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
</interface>
```

8

The following worked for me:

sudo virt-install -n virt64_01 -r 8192 \
--disk path=/media/newhd/virt64_01.img,bus=virtio,size=50 \
-c ubuntu-14.04.1-server-amd64.iso \
--network bridge=br0,model=virtio,mac=52:54:00:b2:cb:b0 \
--network bridge=br1,model=virtio \
--video=vmvga --graphics vnc,listen=0.0.0.0 --noautoconsole -v --vcpus=4
Note: I specify the MAC address for BR0 because I already have that VM name in my main server dhcp server and DNS, and I want to avoid more work for myself. For BR1, I didn't care during installation, it gets setup later.

And for reference, here is the /etc/network/interfaces file on my Ubutuntu 14.04 server host computer:

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# Local network interface
auto br1
iface br1 inet static
 address 192.168.222.1
 network 192.168.222.0
 netmask 255.255.255.0
 broadcast 192.168.222.255
 bridge_ports eth1
 bridge_fd 9
 bridge_hello 2
 bridge_maxage 12
 bridge_stp off

# The primary network interface and bridge
auto br0
iface br0 inet dhcp
bridge_ports eth0
bridge_fd 9
bridge_hello 2
bridge_maxage 12
bridge_stp off
Now, after installation completed, I manually added the guest eth1 to the guest /etc/network/interfaces file:

# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp

# Local network interface
auto eth1
iface eth1 inet static
 address 192.168.222.5
 network 192.168.222.0
 netmask 255.255.255.0
 broadcast 192.168.222.255
Note that there is NOT a gateway specified for eth1. If a gateway is specified, then it will made the primary interface and the routing table populated accordingly. (In my case, and for this answer, the gateway was fake and things stopped working when it was specified. Initially things were also fine on the host server with a fake gateway specified, but eventually it also changed to use br1 as a primary interface and things stopped working, so I have edited it out completely. The alternative, if required, is to explicitly manage the routing table.)

And here is the relevant section of the defining xml file (i.e. you might be able to use virsh edit, so that you don't have to re-install your VM):

<interface type='bridge'>
  <mac address='52:54:00:b2:cb:b0'/>
  <source bridge='br0'/>
  <model type='virtio'/>
  <address type='pci' domain='0x0000' bus='0x00' slot='0x03' function='0x0'/>
</interface>
<interface type='bridge'>
  <mac address='52:54:00:d7:31:77'/>
  <source bridge='br1'/>
  <model type='virtio'/>
  <address type='pci' domain='0x0000' bus='0x00' slot='0x04' function='0x0'/>
</interface>
Edit:

The host and guest /etc/network/interfaces files for the static br0 case are:

Host:

doug@s15:~$ cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# Local network interface
auto br1
iface br1 inet static
  address 192.168.222.1
  network 192.168.222.0
  netmask 255.255.255.0
  broadcast 192.168.222.255
  bridge_ports eth1
  bridge_fd 9
  bridge_hello 2
  bridge_maxage 12
  bridge_stp off

# The primary network interface and bridge
auto br0
#iface br0 inet dhcp
iface br0 inet static
  address 192.168.111.112
  network 192.168.111.0
  netmask 255.255.255.0
  gateway 192.168.111.1
  broadcast 192.168.111.255
  dns-search smythies.com
  dns-nameservers 192.168.111.1
  bridge_ports eth0
  bridge_fd 9
  bridge_hello 2
  bridge_maxage 12
  bridge_stp off
Quest:

doug@virt64-01:~$ cat /etc/network/interfaces
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

# The loopback network interface
auto lo
iface lo inet loopback

# Local network interface
auto eth1
iface eth1 inet static
  address 192.168.222.5
  network 192.168.222.0
  netmask 255.255.255.0
  broadcast 192.168.222.255

# The primary network interface
auto eth0
# iface eth0 inet dhcp
iface eth0 inet static
  address 192.168.111.213
  network 192.168.111.0
  netmask 255.255.255.0
  broadcast 192.168.111.255
  gateway 192.168.111.1
  dns-search smythies.com
  dns-nameservers 192.168.111.1
And the routing table on the host (as a check):

doug@s15:~$ route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         192.168.111.1   0.0.0.0         UG    0      0        0 br0
192.168.111.0   0.0.0.0         255.255.255.0   U     0      0        0 br0
192.168.122.0   0.0.0.0         255.255.255.0   U     0      0        0 virbr0
192.168.222.0   0.0.0.0         255.255.255.0   U     0      0        0 br1