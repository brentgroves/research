# Dummy Interface

## references

<https://unix.stackexchange.com/questions/152331/how-can-i-create-a-virtual-ethernet-interface-on-a-machine-without-a-physical-ad>

## **[Configuring virtual network interfaces](https://linuxconfig.org/configuring-virtual-network-interfaces-in-linux)**

The methods for creating a virtual network interface have changed a bit through the years. There is more than one way to do this, but we will be using the “dummy” kernel module to set up our virtual interface in these steps.

**Start off** by enabling the dummy kernel module with the following command.
$ sudo modprobe dummy

**Step 2** Now that the module has been loaded, we can create a new virtual interface. Feel free to name yours however you want, but we will name ours eth0 in this example.

$ sudo ip link add eth0 type dummy

You will be able to verify that the link was added by executing the following command afterwards:

$ ip link show eth0

**Step 3** We have our virtual interface, but it’t not much use to us without an IP address or MAC address. Let’s give the interface a MAC address with the following command. Feel free to substitute any address you want to use, as ours is just a randomly generated one.

$ sudo ifconfig eth0 hw ether C8:D7:4A:4E:47:50

Note that if the ifconfig command is not available, you’ll need to install package **[net-tools](https://linuxconfig.org/how-to-install-missing-ifconfig-command-on-debian-linux)**

**Step 4** We can now add an alias to the interface and configure an it with an IP address.
$ sudo ip addr add 192.168.1.100/24 brd + dev eth0 label eth0:0

**Step 5** Don’t forget to put the interface up, or it probably won’t be very useful.
$ sudo ip link set dev eth0 up

**Step 6** You should now be able to use your virtual network interface for whatever you want. You can see the full configuration by viewing the output of the ip a command.

$ ip a
[...]
3: eth0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether c8:d7:4a:4e:47:50 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.100/24 brd 192.168.1.255 scope global eth0:0
       valid_lft forever preferred_lft forever

**Step 7** If the virtual network interface has finished serving its purpose, you can revert all your changes with the following commands.

$ sudo ip addr del 192.168.1.100/24 brd + dev eth0 label eth0:0
$ sudo ip link delete eth0 type dummy
$ sudo rmmod dummy

## Installing Linux Dummy-Network Interfaces

Installing The **[Linux Dummy-Network Interface](https://wiki.networksecuritytoolkit.org/nstwiki/index.php/Dummy_Interface
)**

If your NST system does not have an active NIC adapter installed or is off-line from the network, you can install a Dummy Network Interface Module to simulate a network computing environment. This can be quite useful for testing out various networking tools (e.g., Wireshark and Snort) with the Network Security Toolkit when off-line. Use the following procedure to install the Linux Dummy-Network Interface:

1. Add an IP address and host name to your "/etc/hosts" table. For example, an Internet address of 10.0.0.1 would result in:
echo 10.0.0.1 ${HOSTNAME} >> /etc/hosts;
2. Preload the dummy network driver on the machine. If this command is successful, you do not receive any messages from the server.
modprobe dummy;
3. Create the interface(s) (Example: Network Interface: dummy1):
ip link add dummy1 type dummy;
4. Bind an IPv4 Address to Network Interface dummy1:
ip addr add 10.0.0.1/24 dev dummy1;
--Or --
ip addr add ${HOSTNAME}/24 dev dummy1;
5. Bring the dummy1 Network Interface up:
ip link set dummy1 up;
6. If you need to add more than one (1) dummy interface use the following:

ip link add dummy2 type dummy;
ip link add dummy3 type dummy;
ip addr add 10.0.0.2/24 dev dummy2;
ip addr add 10.0.0.3/24 dev dummy3;
ip link set dummy2 up;
ip link set dummy3 up;
7. Check the network bindings with the linux ip command:
[root@nst28-dev ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: dummy1: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 36:f5:1b:3a:12:41 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.1/24 scope global dummy1
       valid_lft forever preferred_lft forever
    inet6 fe80::34f5:1bff:fe3a:1241/64 scope link
       valid_lft forever preferred_lft forever
3: dummy2: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 6a:5c:3f:56:dc:2d brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.2/24 scope global dummy2
       valid_lft forever preferred_lft forever
    inet6 fe80::685c:3fff:fe56:dc2d/64 scope link
       valid_lft forever preferred_lft forever
4: dummy3: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 86:d5:9f:08:f1:32 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.3/24 scope global dummy3
       valid_lft forever preferred_lft forever
    inet6 fe80::84d5:9fff:fe08:f132/64 scope link
       valid_lft forever preferred_lft forever

## Removing The Linux Dummy-Network Interface

1. Unbind the dummy established Network Interface(s):

ifconfig dummy1 down;
ifconfig dummy2 down;
ifconfig dummy3 down;
2) Remove the dummy kernel module.

rmmod dummy;

When you work on Network Namespaces (which is a feature Linux Kernel provides), you usually create bunch of virtual ethernet ports called as veth interfaces. The veth interface itself is a separate LK virtual network driver which offers this specific functionality. But sometimes besides veth you can also configure an optional interface called “dummy” interface. The dummy interface, just like veth (and other such virtual interfaces) is provided by LK via the driver drivers/net/dummy.c.

The interesting aspect of dummy interface is that it serves as an alter ego of the loop-back localhost (as mentioned in the tldp.org article link below). Which means you can set any valid IP and this can serve as alternate local host ip other than 127.0.0.1. So to learn more, kindly watch my complete video series on this fascinating network interface called Dummy Interface.

## references

<https://tldp.org/LDP/nag/node72.html>

## The Dummy Interface

The dummy interface is really a little exotic, but rather useful nevertheless. Its main benefit is with standalone hosts, and machines whose only IP network connection is a dial-up link. In fact, the latter are standalone hosts most of the time, too.
The dilemma with standalone hosts is that they only have a single network device active, the loopback device, which is usually assigned the address 127.0.0.1. On some occasions, however, you need to send data to the `official' IP address of the local host. For instance, consider the laptop vlite, that has been disconnected from any network for the duration of this example. An application on vlite may now want to send some data to another application on the same host. Looking up vlite in /etc/hosts yields an IP-address of 191.72.1.65, so the application tries to send to this address. As the loopback interface is currently the only active interface on the machine, the kernel has no idea that this address actually refers to itself! As a consequence, the kernel discards the datagram, and returns an error to the application.

This is where the dummy device steps in. It solves the dilemma by simply serving as the alter ego of the loopback interface. In the case of vlite, you would simply give it the address 191.72.1.65 and add a host route pointing to it. Every datagram for 191.72.1.65 would then be delivered locally. The proper invocation is:

           # ifconfig dummy vlite
           # route add vlite
