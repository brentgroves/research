# Bridged Networking

**[Back to Research List](../../research_list.md)**\
**[Back to Networking Menu](./networking_menu.md)**\
**[Back to Current Status](../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../README.md)**

## references

<https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm>

<https://superuser.com/questions/1745465/bridge-a-dummy-and-physical-ethernet-interface-on-linux>

## How to use bridged networking with libvirt and KVM

Libvirt is a free and open source software which provides API to manage various aspects of virtual machines. On Linux it is commonly used in conjunction with KVM and Qemu. Among other things, libvirt is used to create and manage virtual networks. The default network created when libvirt is used is called “default” and uses NAT (Network Address Translation) and packet forwarding to connect the emulated systems with the “outside” world (both the host system and the internet). In this tutorial we will see how to create a different setup using Bridged networking

## The “default” network

When libvirt is in use and the libvirtd daemon is running, a default network is created. We can verify that this network exists by using the virsh utility, which on the majority of Linux distribution usually comes with the libvirt-client package. To invoke the utility so that it displays all the available virtual networks, we should include the net-list subcommand:

```bash
sudo virsh net-list --all
```

In the example above we used the --all option to make sure also the inactive networks are included in the result, which should normally correspond to the one displayed below:

```table
Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes

```

To obtain detailed information about the network, and eventually modify it, we can invoke virsh with the edit subcommand instead, providing the network name as argument:

```bash
sudo virsh net-edit default
```

A temporary file containing the xml network definition will be opened in our favorite text editor. In this case the result is the following:

```xml
<network>
  <name>default</name>
  <uuid>168f6909-715c-4333-a34b-f74584d26328</uuid>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
  <mac address='52:54:00:48:3f:0c'/>
  <ip address='192.168.122.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='192.168.122.2' end='192.168.122.254'/>
    </dhcp>
  </ip>
</network>
```

As we can see, the default network is based on the use of the virbr0 virtual bridge, and uses NAT based connectivity to connect the virtual machines which are part of the network to the outside world. We can verify that the bridge exists using the ip command:

```bash
ip link show type bridge

```

In our case the command above returns the following output:

```bash
5: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 52:54:00:48:3f:0c brd ff:ff:ff:ff:ff:ff
# on reports51
ip link show type bridge
3: br-742c7d722f37: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default 
    link/ether 02:42:2c:dd:d5:40 brd ff:ff:ff:ff:ff:ff
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default 
    link/ether 02:42:94:88:fe:e0 brd ff:ff:ff:ff:ff:ff

```

To show the interfaces which are part of the bridge, we can use the ip command and query only for interfaces which have the virbr0 bridge as master:

```bash
ip link show master virbr0
# on reports51
ip link show master br-742c7d722f37
8: vethff79956@if7: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-742c7d722f37 state UP mode DEFAULT group default 
    link/ether 6a:4b:3a:e2:e1:5e brd ff:ff:ff:ff:ff:ff link-netnsid 1
10: veth7314d37@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-742c7d722f37 state UP mode DEFAULT group default 
    link/ether ba:cc:4a:d1:b0:df brd ff:ff:ff:ff:ff:ff link-netnsid 0

```
