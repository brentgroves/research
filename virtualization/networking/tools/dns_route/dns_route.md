# dns query

```bash
nmcli device show enx803f5d090eb3 | grep IP4.DNS
IP4.DNS[1]:                             10.225.50.203
IP4.DNS[2]:                             10.224.50.203
IP4.DNS[3]:                             8.8.8.8
IP4.DNS[4]:                             8.8.4.4

ip route
default via 172.24.189.254 dev enx803f5d090eb3 proto dhcp src 172.24.188.75 metric 100 
172.24.188.0/23 dev enx803f5d090eb3 proto kernel scope link src 172.24.188.75 metric 100 
```
