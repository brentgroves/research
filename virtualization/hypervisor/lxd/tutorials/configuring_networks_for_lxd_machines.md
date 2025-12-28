# **[Configure Networking for LXD Virtual Machines on Ubuntu Linux](https://www.youtube.com/watch?v=vYK1aLSDVIw)**

## cidr block

10.187.40.32/24 (dhcp)

by default lxd vm will get default vnic attached to natted lxd bridge network.
route to internet is lxdbr0 on host.
my lxdbr0 has an ip of 10.181.197.1/24
all vms will get a dhcp address in the range of lxdbr0 ie. 10.181.197.1/24

## **[forwarding rules](https://documentation.ubuntu.com/lxd/latest/howto/network_forwards/)**

similar to docker

`lxd forward create
