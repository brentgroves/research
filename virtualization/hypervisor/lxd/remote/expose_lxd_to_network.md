# **[How to expose LXD to the network](https://documentation.ubuntu.com/lxd/latest/howto/server_expose/#server-expose)**

By default, LXD can be used only by local users through a Unix socket and is not accessible over the network.

To expose LXD to the network, you must configure it to listen to addresses other than the local Unix socket. To do so, set the core.https_address server configuration option.

For example, allow access to the LXD server on port 8443:

```bash
lxc config set core.https_address :8443
# lxc config set core.https_address 10.188.50.201
lxc config set core.https_address 10.188.50.201:8443

lxc config get core.https_address
```

To allow access through a specific IP address, use ip addr to find an available address and then set it. For example:

```bash
~$ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp5s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 00:16:3e:e3:f3:3f brd ff:ff:ff:ff:ff:ff
    inet 10.68.216.12/24 metric 100 brd 10.68.216.255 scope global dynamic enp5s0
       valid_lft 3028sec preferred_lft 3028sec
    inet6 fd42:e819:7a51:5a7b:216:3eff:fee3:f33f/64 scope global mngtmpaddr noprefixroute
       valid_lft forever preferred_lft forever
    inet6 fe80::216:3eff:fee3:f33f/64 scope link
       valid_lft forever preferred_lft forever
3: lxdbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether 00:16:3e:8d:f3:72 brd ff:ff:ff:ff:ff:ff
    inet 10.64.82.1/24 scope global lxdbr0
       valid_lft forever preferred_lft forever
    inet6 fd42:f4ab:4399:e6eb::1/64 scope global
       valid_lft forever preferred_lft forever
~$lxc config set core.https_address 10.68.216.12
```

## AI overview

All remote clients can then connect to LXD and access any image that is marked for public use.

The command lxc config set core.https_address is used to configure the address on which the LXD daemon listens for incoming HTTPS connections from clients. This effectively exposes the LXD server to the network, allowing remote clients to connect and manage containers and images.
How it works:
Binding Address:
The value provided after core.https_address specifies the IP address and optional port number on which LXD will bind.
For example, `lxc config set core.https_address 0.0.0.0:8443` would make LXD listen on all available IPv4 interfaces on port 8443.
lxc config set core.https_address [::]:8443 would make LXD listen on all available IPv4 and IPv6 interfaces on port 8443.
Specifying a specific IP address, like lxc config set core.https_address 192.168.1.100:8443, would limit LXD to listening only on that particular IP address.
Default Port:
If no port is specified, LXD defaults to port 8443.
Network Exposure:
By default, LXD only listens on a local Unix socket. Setting core.https_address enables network access to the LXD server.
