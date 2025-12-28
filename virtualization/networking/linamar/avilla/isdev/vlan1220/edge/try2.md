# vlan 1220 - try 2

Configured port 30 for vlan 1220.

```yaml
port: 30
    vlan: 1220
    ip: 10.187.220.203
    gw: 10.187.220.254
    ns: 
        - 10.225.50.203
        - 10.224.50.203
```

```bash
ping 10.187.220.254
PING 10.187.220.254 (10.187.220.254) 56(84) bytes of data.
^C
--- 10.187.220.254 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2077ms
```
