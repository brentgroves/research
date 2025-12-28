# **[How to add network bridge](https://www.cyberciti.biz/faq/how-to-add-network-bridge-with-nmcli-networkmanager-on-linux/)**

## How to create/add network bridge with nmcli

The procedure to add a bridge interface on Linux is as follows when you want to use Network Manager:

```bash
nmcli con show
nmcli connection show --active
```

I have a “Wired connection 1” which uses the eno1 Ethernet interface. My system has a VPN interface too. I am going to setup a bridge interface named br0 and add, (or enslave) an interface to eno1.

## How to create a bridge, named br0

```bash
sudo nmcli con add ifname br0 type bridge con-name br0
sudo nmcli con add type bridge-slave ifname eno1 master br0
nmcli connection show
```

You can disable STP too:

```bash
sudo nmcli con modify br0 bridge.stp no
nmcli con show
nmcli -f bridge con show br0
nmcli -f bridge con show lxcbr0
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
ip a s lxdbr0
ip a s lxcbr0

```
