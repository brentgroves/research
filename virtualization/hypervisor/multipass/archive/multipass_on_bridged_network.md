# **[Network Bridge](https://gist.github.com/ynott/f4bdc89b940522f2a0e4b32790ddb731)**

Environmental information
OS: Ubuntu 20.04.2 LTS (GNU/Linux 5.8.0-59-generic x86_64)
Network: 192.168.xxx.0/24
Ubuntu multipass host machine IP: 192.168.xxx.yyy(static IP)
NIC: enp2s0(bridge host NIC)
Bridge NIC:br0

## 2. Prerequisites

You need to create a network bridge.
It is recommended to use netplan to create the network bridge (I think NetworkManager can also create it, but I couldn't do it).
The Ubuntu multipass host machine have a static IP (I think DHCP will be fine).
You need lxd and initialization.
Tested with multipass 1.6.2
Existing virtual machines in multipass (qemu) will be HIDDEN!

## create a network bridge with netplan

3-1. create the netplan configuration file
It should look like this.

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    enp2s0:
      dhcp4: false
      dhcp6: true
      match:
        macaddress: 80:ee:73:zz:zz:zz
  bridges:
    br0:
      dhcp4: false
      addresses: [192.168.xxx.yyy/24]
      interfaces:
        - enp2s0
      gateway4: 192.168.xxx.1
      nameservers:
        addresses: [192.168.xxx.1,8.8.8.8,1.1.1.1 ]
      parameters:
        forward-delay: 0
        stp: false
      optional: true
```

## 3-2. apply Netplan

netplan try and if there are no errors,then netplan apply.

$ sudo netplan try
br0: reverting custom parameters for bridges and bonds is not supported
Please carefully review the configuration and use 'netplan apply' directly.
$ sudo netplan apply

## 3-3. Check the br0 NIC

Use the ip a command to check if br0 has been created.
(Note: lo and another NIC are omitted, inet6 is also omitted)

```bash
2: enp2s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master br0 state UP group default qlen 1000
    link/ether 80:ee:73:zz:zz:zz brd ff:ff:ff:ff:ff:ff
4: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 80:ee:73:zz:zz:zz brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.111/24 brd 192.168.10.255 scope global br0
       valid_lft forever preferred_lft forever
```

Let's also check the network communication.

```bash
dig www.google.co.jp | grep -v ';'
www.google.co.jp.   277 IN  A   216.58.220.99
```

## 4. install multipass

```bash
$ sudo snap install multipass
multipass 1.6.2 from Canonical✓ installed
```

This is not necessary if you already have 1.6.2 installed.

## 5. install and configure lxd

5-1. install lxd

```bash
$ sudo snap install lxd
lxd 4.15 from Canonical✓ installed
```

This is also not necessary if you already have 4.15 installed.

5-2. initialize lxd
Initialize lxd with the following command.

```bash
$ sudo lxd init
Would you like to use LXD clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]:
Name of the new storage pool [default=default]:
Name of the storage backend to use (btrfs, dir, lvm, zfs, ceph) [default=zfs]:
Create a new ZFS pool? (yes/no) [default=yes]:
Would you like to use an existing empty block device (e.g. a disk or partition)? (yes/no) [default=no]:
Size in GB of the new loop device (1GB minimum) [default=30GB]: 400GB      <---*1
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to create a new local network bridge? (yes/no) [default=yes]: no  <---*2
Would you like to configure LXD to use an existing bridge or host interface? (yes/no) [default=no]:
Would you like the LXD server to be available over the network? (yes/no) [default=no]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
The points to note are at *1 and *2.
```

*1
You will be asked the size of the storage pool to be used by lxd.
The virtual machine image of multipass will be stored in this storage pool.
Make sure it is large enough.
Or you may choose brfs or something like that instead of zfs.

*2
You will be asked if you want to create a bridge network for lxd.
In this case, let's answer no, since we have already created br0.

Would you like to create a new local network bridge? (yes/no) [default=yes]: no

## 6. connect multipass to lxd

Warning!! Warning!! Warning!!
When you switch the multipass backend to LXD, the instance running on the existing backend (qemu) will be hidden!
It is recommended to use the multipass stop --all command to stop all virtual machine instances of multipass before working with it.

6-1. change multipass local driver from qemu to lxd

```bash
sudo multipass set local.driver=lxd
#Confirm that the changes were made.
$ multipass get local.driver
lxd
# 6-2. connect multipass to lxd
sudo snap connect multipass:lxd lxd
```

Confirm that the changes were made.

```bash
$ sudo snap connections multipass
Interface          Plug                         Slot                Notes
firewall-control   multipass:firewall-control   :firewall-control   -
home               multipass:all-home           :home               -
home               multipass:home               :home               -
kvm                multipass:kvm                :kvm                -
libvirt            multipass:libvirt            -                   -
lxd                multipass:lxd                lxd:lxd             -
multipass-support  multipass:multipass-support  :multipass-support  -
network            multipass:network            :network            -
network-bind       multipass:network-bind       :network-bind       -
network-control    multipass:network-control    :network-control    -
removable-media    multipass:removable-media    -                   -
unity7             multipass:unity7             :unity7             -
wayland            multipass:wayland            :wayland            -
x11                multipass:x11                :x11                -
```

## 7. multipass network bridge

7-1. check the network bridge of multipass
At this point, the command multipass networks -vvvv will result in an error

```bash
$ multipass networks -vvvv
[2021-06-29T11:09:06.536] [trace] [lxd request] Requesting LXD: GET unix://multipass/var/snap/lxd/common/lxd/unix.socket@1.0/networks?recursion=1&project=multipass

networks failed: LXD object not found
# 7-2. start one virtual machine
# Start one virtual machine with the following command

# multipass launch 20.04
# Execution result example

$ multipass launch 20.04
Launched: dainty-rockfish

# 7-3. check the network bridge again
# Run the command multipass networks again.

$ multipass networks
Name   Type    Description
br0    bridge  Network bridge
mpbr0  bridge  Network bridge for Multipass

# The bridge network br0 is recognized.
```

## 8. running a virtual machine with multipass using a bridge network

8-1. Starting a multipass virtual machine using a bridge network
Add the --network <bridge network name> option to multipass launch.
If only a bridge network is specified, the IP address will be obtained from DHCP.

```bash
$ multipass launch 20.04 --network br0
Starting guided-papillon |
Launched: guided-papillon
Check.

$ multipass list
Name                    State             IPv4             Image
guided-papillon         Running           10.222.159.143   Ubuntu 20.04 LTS
                                          192.168.xxx.6
# The IP address of 10.222.159.143 is the IP address used to connect to multipass and multipass shell/exec.
# The IP address of 192.168.xxx.6 is the IP address assigned by DHCP for the local network (bridge network).
```

## 8-2. check NIC of Ubuntu multipass host machine

Check the NICs on my Ubuntu multipass host machine with ip a,
I see that NICs starting with tap are created. tap bridges for mpbr0 and br0.
(Note: Unrelated NICs are omitted).

```bash
12: tapf03812d0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master mpbr0 state UP group default qlen 1000
    link/ether fa:33:67:9a:e3:ec brd ff:ff:ff:ff:ff:ff
13: tap336015f4: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq master br0 state UP group default qlen 1000
    link/ether 36:b0:66:50:1f:00 brd ff:ff:ff:ff:ff:ff
```
