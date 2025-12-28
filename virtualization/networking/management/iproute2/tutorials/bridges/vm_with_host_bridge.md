# **[How to use bridged networking with libvirt and KVM](https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm)**

**[Back to Research List](../../../../../research/research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![cn](https://linuxconfig.org/wp-content/uploads/2021/03/00-how_to_use_bridged_networking_with_libvirt_and_kvm.avif)

## references

- **[NSI](https://60sec.site/terms/what-is-nsi-in-computing-network-service-interface#:~:text=What%20Is%20Nsi%20In%20Computing,networks%20operate%20smoothly%20and%20efficiently.)**
  
AI Overview
Learn more
To access the host network interface in QEMU, you need to configure a "bridged" network setting, which essentially connects the virtual machine's network card directly to your host machine's physical network interface by creating a bridge between them, allowing the guest to access the host's network directly; this is usually achieved by using the -netdev bridge option with the appropriate bridge name in your QEMU command line.

Libvirt is a free and open source software which provides API to manage various aspects of virtual machines. On Linux it is commonly used in conjunction with KVM and Qemu. Among other things, libvirt is used to create and manage virtual networks. The default network created when libvirt is used is called “default” and uses NAT (Network Address Translation) and packet forwarding to connect the emulated systems with the “outside” world (both the host system and the internet). In this tutorial we will see how to create a different setup using Bridged networking.

## In this tutorial you will learn

- How to create a virtual bridge
- How to add a physical interface to a bridge
- How to make the bridge configuration persistent
- How to modify firmware rules to allow traffic to the virtual machine
- How to create a new virtual network and use it in a virtual machine

## Software requirements and conventions used

| Category    | Requirements, Conventions or Software Version Used                                                                                                                                                               |
|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| System      | Distribution independent                                                                                                                                                                                         |
| Software    | libvirt, iproute, brctl                                                                                                                                                                                          |
| Other       | Administrative privileges to create and manipulate the bridge interface                                                                                                                                          |
| Conventions | # – requires given linux-commands to be executed with root privileges either directly as a root user or by use of sudo command $ – requires given linux-commands to be executed as a regular non-privileged user |

## The “default” network

When libvirt is in use and the libvirtd daemon is running, a default network is created. We can verify that this network exists by using the virsh utility, which on the majority of Linux distribution usually comes with the libvirt-client package. To invoke the utility so that it displays all the available virtual networks, we should include the net-list subcommand:

```bash
sudo virsh net-list --all

 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes

```

In the example above we used the --all option to make sure also the inactive networks are included in the result, which should normally correspond to the one displayed below:

```bash
Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
```

To obtain detailed information about the network, and eventually modify it, we can invoke virsh with the edit subcommand instead, providing the network name as argument:

```bash
sudo virsh net-edit default
Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano        <---- easiest
  2. /usr/bin/vim.tiny
  3. /usr/bin/code
  4. /bin/ed

Choose 1-4 [1]: 
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
5: lxdbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 00:16:3e:a6:6d:bf brd ff:ff:ff:ff:ff:ff
7: lxcbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 00:16:3e:00:00:00 brd ff:ff:ff:ff:ff:ff
9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 42:86:f0:20:a4:84 brd ff:ff:ff:ff:ff:ff
18: virbr0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:eb:f6:cd brd ff:ff:ff:ff:ff:ff
```

In our case the command above returns the following output:

```bash
5: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 52:54:00:48:3f:0c brd ff:ff:ff:ff:ff:ff
```

To show the interfaces which are part of the bridge, we can use the ip command and query only for interfaces which have the virbr0 bridge as master:

```bash
ip link show master virbr0
20: vnet1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master virbr0 state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether fe:54:00:66:d7:b9 brd ff:ff:ff:ff:ff:ff
```

The result of running the command is:

```bash
6: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc fq_codel master virbr0 state DOWN mode DEFAULT group default qlen 1000
    link/ether 52:54:00:48:3f:0c brd ff:ff:ff:ff:ff:ff
```

As we can see, there is only one interface currently attached to the bridge, virbr0-nic. The virbr0-nic interface is a virtual ethernet interface: it is created and added to the bridge automatically, and its purpose is just to provide a stable MAC address (52:54:00:48:3f:0c in this case) for the bridge.

In my case I see that link/ether fe:54:00:66:d7:b9 is showing on the vm and the bridge.

Other virtual interfaces will be added to the bridge when we create and launch virtual machines. For the sake of this tutorial I created and launched a Debian (Buster) virtual machine; if we re-launch the command we used above to display the bridge slave interfaces, we can see a new one was added, vnet0:

```bash
$ ip link show master virbr0
6: virbr0-nic: <BROADCAST,MULTICAST> mtu 1500 qdisc fq_codel master virbr0 state DOWN mode DEFAULT group default qlen 1000
    link/ether 52:54:00:48:3f:0c brd ff:ff:ff:ff:ff:ff
7: vnet0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master virbr0 state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether fe:54:00:e2:fe:7b brd ff:ff:ff:ff:ff:ff
```

In my case I only see 1 interface and that is to the running vm.

```bash
ip link show master virbr0
20: vnet1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master virbr0 state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether fe:54:00:66:d7:b9 brd ff:ff:ff:ff:ff:ff
```

## IMPORTANT

No physical interfaces should ever be added to the virbr0 bridge, since it uses NAT to provide connectivity.

## Use bridged networking for virtual machines

The default network provides a very straightforward way to achieve connectivity when creating virtual machines: everything is “ready” and works out of the box. Sometimes, however, we want to achieve a full bridgining connection, where the guest devices are connected to the host LAN, without using NAT, we should create a new bridge and share one of the host physical ethernet interfaces. Let’s see how to do this step by step.

## Creating a new bridge

To create a new bridge, we can still use the ip command. Let’s say we want to name this bridge br0; we would run the following command:

```bash
sudo ip link add br0 type bridge
```

To verify the bridge is created we do as before:

```bash
sudo ip link show type bridge
5: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 52:54:00:48:3f:0c brd ff:ff:ff:ff:ff:ff
8: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 26:d2:80:7c:55:dd brd ff:ff:ff:ff:ff:ff
```

As expected, the new bridge, br0 was created and is now included in the output of the command above. Now that the new bridge is created, we can proceed and add the physical interface to it.

Adding a physical ethernet interface to the bridge
In this step we will add a host physical interface to the bridge. Notice that you can’t use your main ethernet interface in this case, since as soon as it is added to the bridge you would loose connectivity, since it will loose its IP address. In this case we will use an additional interface, enp0s29u1u1: this is an interface provided by an ethernet to usb adapter attached to my machine.

First we make sure the interface state is UP:

```bash
sudo ip link set enp0s29u1u1 up
```

To add the interface to bridge, the command to run is the following:

```bash
sudo ip link set enp0s29u1u1 master br0
```

## To verify the interface was added to the bridge, instead

```bash
$ sudo ip link show master br0
3: enp0s29u1u1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master br0 state UP mode DEFAULT group default qlen 1000
    link/ether 18:a6:f7:0e:06:64 brd ff:ff:ff:ff:ff:ff
```

Assigning a static IP address to the bridge
At this point we can assign a static IP address to the bridge. Let’s say we want to use 192.168.0.90/24; we would run:

```bash
sudo ip address add dev br0 192.168.0.90/24
```

To very that the address was added to the interface, we run:

```bash
$ ip addr show br0
9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 26:d2:80:7c:55:dd brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.90/24 scope global br0
       valid_lft forever preferred_lft forever
   [...]
```

## Firewall Issue

- **[disable iptable for bridges](https://wiki.libvirt.org/Net.bridge.bridge-nf-call_and_sysctl.conf.html)**

## Making the configuration persistent

Our bridge configuration is ready, however, as it is, it will not survive a machine reboot. To make our configuration persistent we must edit some configuration files, depending on the distribution we use.

## **[Persist network changes in ubuntu](../../../../networking/netplan/documentation/documentation.md))**

## Disabling netfilter for the bridge

To allow all traffic to be forwarded to the bridge, and therefore to the virtual machines connected to it, we need to disable netfilter. This is necessary, for example, for DNS resolution to work in the guest machines attached to the bridge. To do this we can create a file with the .conf extension inside the /etc/sysctl.d directory, let’s call it 99-netfilter-bridge.conf. Inside of it we write the following content:

```bash
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0
```

To load the settings written in the file, fist we ensure that the br_netfilter module is loaded:

- **[modprob](https://phoenixnap.com/kb/modprobe-command#:~:text=The%20Linux%20kernel%20has%20a,add%20or%20remove%20kernel%20modules.)**

```bash

lsmod | grep -wq "br_netfilter"

cat /proc/modules | grep -c br_netfilter
sudo modinfo br_netfilter
$ sudo modprobe br_netfilter
```

To load the module automatically at boot, let’s create the /etc/modules-load.d/br_netfilter.conf file: it should contain only the name of the module itself:

br_netfilter
Once the module is loaded, to load the settings we stored in the 99-netfilter-bridge.conf file, we can run:

```bash
sudo sysctl -p /etc/sysctl.d/99-netfilter-bridge.conf
```

## Creating a new virtual network

At this point we should define a new “network” to be used by our virtual machines. We open a file with our favorite editor and paste the following content inside of it, than save it as bridged-network.xml:

```xml
<network>
    <name>bridged-network</name>
    <forward mode="bridge" />
    <bridge name="br0" />
</network>
```

Once the file is ready we pass its position as argument to the net-define virsh subcommand:

```bash
sudo virsh net-define bridged-network.xml
```

To activate the new network and make so that it is auto-started, we should run:

```bash
sudo virsh net-start bridged-network
sudo virsh net-autostart bridged-network
```

We can verify the network has been activated by running the virsh net-list
command, again:

```bash
sudo virsh net-list
```

Name              State    Autostart   Persistent
----------------------------------------------------

bridged-network   active   yes         yes
default           active   yes         yes

We can now select the network by name when using the --network option:

```bash
$ sudo virt-install \
  --vcpus=1 \
  --memory=1024 \
  --cdrom=debian-10.8.0-amd64-DVD-1.iso \
  --disk size=7 \
  --os-variant=debian10 \
  --network network=bridged-network
  ```

If using the virt-manager graphical interface, we will be able to select the network when creating the new virtual machine:

![sn](https://linuxconfig.org/wp-content/uploads/2021/03/01-how_to_use_bridged_networking_with_libvirt_and_kvm.avif)
