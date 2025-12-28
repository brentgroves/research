# **[How to get LXD containers obtain IP from the LAN with ipvlan networking](https://blog.simos.info/how-to-get-lxd-containers-obtain-ip-from-the-lan-with-ipvlan-networking/)**

**[How to add both a private and public network to LXD using cloud-init](<https://blog.simos.info/how-to-add-both-a-private-and-public-network-to-lxd-using-cloud-init/>)**

**[](https://blog.simos.info/configuring-public-ip-addresses-on-cloud-servers-for-lxd-containers/)**

**[](https://cloudinit.readthedocs.io/en/latest/)**

How to get LXD containers obtain IP from the LAN with ipvlan networking

You are using LXD containers and you want a container (or more) to use an IP address from the LAN (or, get an IP address just like the host does).

LXD currently supports four ways to do that, and depending on your needs, you select the appropriate way.

1. Using macvlan. See <https://blog.simos.info/how-to-make-your-lxd-container-get-ip-addresses-from-your-lan/>
