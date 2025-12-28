# cant ping lan

Nutanix troubleshooting:

1. From bare metal ahv look at all ip addresses.
ip address show
...
2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether f4:8e:38:b7:1e:fd brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.60/24 brd 192.168.1.255 scope global noprefixroute enp0s31f6
       valid_lft forever preferred_lft forever
    inet6 2605:7b00:201:e540::787/128 scope global dynamic noprefixroute
       valid_lft 2071866sec preferred_lft 84666sec
    inet6 fe80::1016:30db:2a46:a709/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
2. Examine link details of devices with ip address.
ip -details -json --pretty link show enp0s31f6
3. Try to determine if it is a physical or virtual device controlled by ovs.
4. Add an address to a physical interface. Substitute the real link name for eth0. You can add as many addresses as you want.

ip address add 10.188.50.240/24 dev eth0
5. ping other IP addresses that should be reachable.

ping 10.188.50.202
