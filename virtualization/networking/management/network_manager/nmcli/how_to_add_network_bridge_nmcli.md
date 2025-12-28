# **[How to add network bridge with nmcli (NetworkManager) on Linux](https://www.cyberciti.biz/faq/how-to-add-network-bridge-with-nmcli-networkmanager-on-linux/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## references

<https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking>

## **[What is a network bridge](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-a-network-bridge_configuring-and-managing-networking)**

A network bridge is a link-layer device which forwards traffic between networks based on a table of MAC addresses. The bridge builds the MAC addresses table by listening to network traffic and thereby learning what hosts are connected to each network. For example, you can use a software bridge on a Red Hat Enterprise Linux host to emulate a hardware bridge or in virtualization environments, to integrate virtual machines (VM) to the same network as the host.

A bridge requires a network device in each network the bridge should connect. When you configure a bridge, the bridge is called controller and the devices it uses ports.

You can create bridges on different types of devices, such as:

Physical and virtual Ethernet devices
Network bonds
Network teams
VLAN devices
Due to the IEEE 802.11 standard which specifies the use of 3-address frames in Wi-Fi for the efficient use of airtime, you cannot configure a bridge over Wi-Fi networks operating in Ad-Hoc or Infrastructure modes.

Procedure

Create a bridge interface:

```bash
# nmcli connection add type bridge con-name bridge0 ifname bridge0
```

This command creates a bridge named bridge0, enter:

Display the network interfaces, and note the names of the interfaces you want to add to the bridge:

```bash
nmcli device status
DEVICE  TYPE      STATE         CONNECTION
enp7s0  ethernet  disconnected  --
enp8s0  ethernet  disconnected  --
bond0   bond      connected     bond0
bond1   bond      connected     bond1
...
```

In this example:

enp7s0 and enp8s0 are not configured. To use these devices as ports, add connection profiles in the next step.
bond0 and bond1 have existing connection profiles. To use these devices as ports, modify their profiles in the next step.

Assign the interfaces to the bridge.

If the interfaces you want to assign to the bridge are not configured, create new connection profiles for them:

```bash
# nmcli connection add type ethernet slave-type bridge con-name bridge0-port1 ifname enp7s0 master bridge0
# nmcli connection add type ethernet slave-type bridge con-name bridge0-port2 ifname enp8s0 master bridge0
```

If you want to assign an existing connection profile to the bridge:

Set the master parameter of these connections to bridge0:

```bash
# nmcli connection modify bond0 master bridge0
# nmcli connection modify bond1 master bridge0
```

These commands assign the existing connection profiles named bond0 and bond1 to the bridge0 connection.

Reactivate the connections:

```bash
# nmcli connection up bond0
# nmcli connection up bond1
```

## Configure the IPv4 settings

- To use this bridge device as a port of other devices, enter:

```bash
# nmcli connection modify bridge0 ipv4.method disabled
```

- To use DHCP, no action is required.
- To set a static IPv4 address, network mask, default gateway, and DNS server to the bridge0 connection, enter:

```bash
# nmcli connection modify bridge0 ipv4.addresses '192.0.2.1/24' ipv4.gateway '192.0.2.254' ipv4.dns '192.0.2.253' ipv4.dns-search 'example.com' ipv4.method manual
```

Optional: Configure further properties of the bridge. For example, to set the Spanning Tree Protocol (STP) priority of bridge0 to 16384, enter:

```bash
# nmcli connection modify bridge0 bridge.priority '16384'
```

By default, STP is enabled.

Activate the connection:

```bash
# nmcli connection up bridge0
```

Verify that the ports are connected, and the CONNECTION column displays the port’s connection name:

```bash
# nmcli device
DEVICE   TYPE      STATE      CONNECTION
...
enp7s0   ethernet  connected  bridge0-port1
enp8s0   ethernet  connected  bridge0-port2
```

When you activate any port of the connection, NetworkManager also activates the bridge, but not the other ports of it. You can configure that Red Hat Enterprise Linux enables all ports automatically when the bridge is enabled:

Enable the connection.autoconnect-slaves parameter of the bridge connection:

```bash
nmcli connection modify bridge0 connection.autoconnect-slaves 1
```

Reactivate the bridge:

```bash
# nmcli connection up bridge0
```

Verification

Use the ip utility to display the link status of Ethernet devices that are ports of a specific bridge:

```bash
# ip link show master bridge0
3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bridge0 state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:62:61:0e brd ff:ff:ff:ff:ff:ff
4: enp8s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master bridge0 state UP mode DEFAULT group default qlen 1000
    link/ether 52:54:00:9e:f1:ce brd ff:ff:ff:ff:ff:ff
```

Use the bridge utility to display the status of Ethernet devices that are ports of any bridge device:

```bash
# bridge link show
3: enp7s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master bridge0 state forwarding priority 32 cost 100
4: enp8s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master bridge0 state listening priority 32 cost 100
5: enp9s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master bridge1 state forwarding priority 32 cost 100
6: enp11s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 master bridge1 state blocking priority 32 cost 100
...
```

To display the status for a specific Ethernet device, use the bridge link show dev <ethernet_device_name> command.

These commands create profiles for enp7s0 and enp8s0, and add them to the bridge0 connection.

**Note:** This assumes
Iam using Debian Linux 12/11/10/9 on the desktop. I would like to create network bridge with NetworkManager. But, I am unable to find the option to add br0. How can I create or add network bridge with nmcli for NetworkManager on Linux?

A bridge is nothing but a device which joins two local networks into one network. It works at the data link layer, i.e., layer 2 of the OSI model. Network bridge often used with virtualization and other software. Disabling NetworkManager for a simple bridge especially on Linux Laptop/desktop doesn’t make any sense. The nmcli tool can create Persistent bridge configuration without editing any files. This page shows how to create a bridge interface using the Network Manager command line tool called nmcli.

## How to create/add network bridge with nmcli

The procedure to add a bridge interface on Linux is as follows when you want to use Network Manager:

```bash
# Open the Terminal app
# Get info about the current connection:
nmcli con show
# Add a new bridge:
nmcli con add type bridge ifname br0
# Create a slave interface:
nmcli con add type bridge-slave ifname eno1 master br0
# Turn on br0:
nmcli con up br0
```

Get current network config
You can view connection from the Network Manager GUI in settings:

![](https://www.cyberciti.biz/media/new/faq/2018/01/Getting-Network-Info-on-Linux.jpg)

Another option is to type the following command:

```bash
ssh brent@reports-alb
nmcli con show
nmcli connection show --active
NAME                UUID                                  TYPE      DEVICE          
Wired connection 1  c031620b-0f27-3dea-9352-8b45b7a8b2ea  ethernet  enp0s25         
mpqemubr0           a89655e1-3df3-4eb0-b640-2b7f00ce2789  bridge    mpqemubr0       
br-860dc0d9b54b     390335bd-c36c-4bd3-b188-90aab3bbebbb  bridge    br-860dc0d9b54b 
br-924b3db7b366     1439fb5a-1611-4682-b90b-2e944bf36900  bridge    br-924b3db7b366 
br-b543cc541f49     c06fe11e-e0fd-4d3b-950e-b2b0c16a3b1a  bridge    br-b543cc541f49 
br-ef440bd353e1     fc87473a-82ab-48ed-9f67-61bafbf0b2eb  bridge    br-ef440bd353e1 
docker0             79954717-f033-4c83-96df-636f6dcef469  bridge    docker0         
tap-d951e26a898     8c208343-21f8-4fc2-9f2c-6856138b63f7  tun       tap-d951e26a898 
```

![](https://www.cyberciti.biz/media/new/faq/2018/01/View-the-connections-with-nmcli.jpg)

I have a “Wired connection 1” which uses the eno1 Ethernet interface. My system has a VPN interface too. I am going to setup a bridge interface named br0 and add, (or enslave) an interface to eno1.

How to create a bridge, named br0

```bash
sudo nmcli con add ifname br0 type bridge con-name br0
sudo nmcli con add type bridge-slave ifname eno1 master br0
nmcli connection show
```

![](https://www.cyberciti.biz/media/new/faq/2018/01/Create-bridge-interface-using-nmcli-on-Linux.jpg)

You can disable STP too:

```bash
sudo nmcli con modify br0 bridge.stp no
nmcli con show
nmcli -f bridge con show br0
```

The last command shows the bridge settings including disabled STP:

```yaml
bridge.mac-address:                     --
bridge.stp:                             no
bridge.priority:                        32768
bridge.forward-delay:                   15
bridge.hello-time:                      2
bridge.max-age:                         20
bridge.ageing-time:                     300
bridge.multicast-snooping:              yes
```

## How to turn on bridge interface

You must turn off “Wired connection 1” and turn on br0:

```bash
sudo nmcli con down "Wired connection 1"
sudo nmcli con up br0
nmcli con show
```

Use ip command (or ifconfig command) to view the IP settings:

```bash
ip a s
ip a s br0
```

![](https://www.cyberciti.biz/media/new/faq/2018/01/Build-a-network-bridge-with-nmcli-on-Linux.jpg)

## Optional: How to use br0 with KVM

Now you can connect VMs (virtual machine) created with KVM/VirtualBox/VMware workstation to a network directly without using NAT. Create a file named br0.xml for KVM using vi command or cat command:

cat /tmp/br0.xml

Append the following code:

```xml
<network>
  <name>br0</name>
  <forward mode="bridge"/>
  <bridge name="br0" />
</network>
```

Run virsh command as follows:

```bash
virsh net-define /tmp/br0.xml
virsh net-start br0
virsh net-autostart br0
virsh net-list --all
Sample outputs:

 Name                 State      Autostart     Persistent
----------------------------------------------------------
 br0                  active     yes           yes
 default              inactive   no            yes
```
