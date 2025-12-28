# vlan 1220 - try 1

Configured port 9 for vlan 1220.

```yaml
adapter: 3
    vlan: 1220
    ip: 10.187.220.212
    gw: 10.187.220.254
    ns: 
        - 10.225.50.203
        - 10.224.50.203
```

## Both WiFi and Wired is on

```bash
ping 10.187.220.254
PING 10.187.220.254 (10.187.220.254) 56(84) bytes of data.
^C
--- 10.187.220.254 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2077ms
```

## Only Wired on

```bash
ping 10.187.220.254
PING 10.187.220.254 (10.187.220.254) 56(84) bytes of data.
From 10.187.220.212 icmp_seq=1 Destination Host Unreachable
From 10.187.220.212 icmp_seq=2 Destination Host Unreachable
From 10.187.220.212 icmp_seq=3 Destination Host Unreachable
^C
--- 10.187.220.254 ping statistics ---
5 packets transmitted, 0 received, +3 errors, 100% packet loss, time 4106ms
pipe 3
```
