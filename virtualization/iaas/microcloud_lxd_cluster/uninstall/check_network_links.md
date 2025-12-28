# check network interfaces

```bash
ip a
eno250@eno2: <BROADCAST,MULTICAST> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
    link/ether b8:ca:3a:6a:35:99 brd ff:ff:ff:ff:ff:ff

sudo ip link set eno250 up
# reboot system    
```
