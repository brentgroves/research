# tcpdump

```bash
[root@tristan]# ping -c 1 -n 10.1.0.113 >/dev/null 2>&1 &
[root@tristan]# tcpdump -nnqtei eno
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eno1, link-type EN10MB (Ethernet), snapshot length 262144 bytes
b8:ca:3a:6a:35:98 > 18:03:73:1f:84:a4, IPv4, length 254: 10.1.0.135.22 > 10.1.0.113.39196: tcp 188
18:03:73:1f:84:a4 > b8:ca:3a:6a:35:98, IPv4, length 66: 10.1.0.113.39196 > 10.1.0.135.22: tcp 0

tcpdump: listening on eth0
0:80:c8:f8:be:ef ff:ff:88:ff:ff:88 42: arp who-has 192.168.99.254 tell 192.168.99.35
0:80:c8:f8:be:ef ff:ff:88:ff:ff:88 42: arp who-has 192.168.99.254 tell 192.168.99.35
```
