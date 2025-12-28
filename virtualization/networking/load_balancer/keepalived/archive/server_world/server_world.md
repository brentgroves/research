# **[](https://www.server-world.info/en/note?os=Ubuntu_22.04&p=keepalived&f=1)**

Install Keepalived that uses VRRP (Virtual Router Redundancy Protocol) in order to build redundant configuration.

This example is based on the environment like follows.
Configure simply redundant settings for virtual IP address.

                            VIP:10.0.0.30
+----------------------+          |          +----------------------+
|  [node01.srv.world]  |10.0.0.51 | 10.0.0.52|  [node02.srv.world]  |
|     Keepalived#1     +----------+----------+     Keepalived#2     |
|                      |                     |                      |
+----------------------+                     +----------------------+

[1] Install Keepalived on all Nodes.

```bash
root@node01:~# apt -y install keepalived
```

Configure Keepalived on the Primary Node.

```bash
root@node01:~# vi /etc/keepalived/keepalived.conf

# create new

global_defs {
    # set hostname
    router_id node01
}

vrrp_instance VRRP1 {
    # on primary node, specify [MASTER]
    # on backup node, specify [BACKUP]
    # if specified [BACKUP] + [nopreempt] on all nodes, automatic failback is disabled
    state MASTER
    # if you like disable automatic failback, set this value with [BACKUP]
    # nopreempt
    # network interface that virtual IP address is assigned
    interface enp1s0
    # set unique ID on each VRRP interface
    # on the a VRRP interface, set the same ID on all nodes
    virtual_router_id 101
    # set priority : [Master] > [BACKUP]
    priority 200
    # VRRP advertisement interval (sec)
    advert_int 1
    # virtual IP address
    virtual_ipaddress {
        10.0.0.30/24
    }
}
```

root@node01:~# systemctl restart keepalived

```bash
root@node01:~# ip address show enp1s0
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:35:69:7c brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.51/24 brd 10.0.0.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet 10.0.0.30/24 scope global secondary enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe35:697c/64 scope link
       valid_lft forever preferred_lft forever
```

 Configure Keepalived on the Backup Node.

```bash
root@node02:~# vi /etc/keepalived/keepalived.conf

# create new

global_defs {
    router_id node02
}

vrrp_instance VRRP1 {
    state BACKUP
    # nopreempt
    interface enp1s0
    virtual_router_id 101
    priority 100
    advert_int 1
    virtual_ipaddress {
        10.0.0.30/24
    }
}

root@node02:~# systemctl restart keepalived
```

That's OK. Verify failover and failback.

```bash

# set link down on primary node

root@node01:~# ip address show enp1s0
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:35:69:7c brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.51/24 brd 10.0.0.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet 10.0.0.30/24 scope global secondary enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe35:697c/64 scope link
       valid_lft forever preferred_lft forever
root@node01:~# ip link set down enp1s0

# on backup node

root@node02:~# ip address show enp1s0
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:7d:c5:e7 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.52/24 brd 10.0.0.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet 10.0.0.30/24 scope global secondary enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe7d:c5e7/64 scope link
       valid_lft forever preferred_lft forever

# virtual IP address is assigned

# set link up on primary node

root@node01:~# ip link set up enp1s0
root@node01:~# ip address show enp1s0
2: enp1s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 52:54:00:35:69:7c brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.51/24 brd 10.0.0.255 scope global enp1s0
       valid_lft forever preferred_lft forever
    inet 10.0.0.30/24 scope global secondary enp1s0
       valid_lft forever preferred_lft forever
    inet6 fe80::5054:ff:fe35:697c/64 scope link
       valid_lft forever preferred_lft forever

# failback automatically
```
