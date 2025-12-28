# Albion isdev Laptop

Connected to 12-port extreme switch.

## GW and Name Servers

```yaml
gw: 10.187.x.254
nameservers:
    - 10.225.50.203
    - 10.224.50.203

```

```yaml
adapter: 1
    link: enxa0cec85afc3c
    ip: 10.187.70.200
    subnet: 10.187.70.0/24
    vlan: 70
    ext-port: 3
    
adapter: 2
    link: 
    ip: dhcp - 172.24.188.71/23
    subnet: 172.24.188.0/23
    vlan: 568
    ext-port: 4
    
adapter: 3
    link: enx808f5d090eb3
    ip: 10.187.40.200
    subnet: 10.187.40.0/24
    vlan: 40
    ext-port: 2
```

## VLan 70

There is no dhcp server
-

## Try 1

```bash
ping 10.187.70.254
# no replies
nmap -sP 10.187.70.0/24
# no host replies 
```

## try 2

On the 70 VLAN I changed ip to 10.187.220.200.

```bash
ping 10.187.220.254
# no replies
```

## try 3

View network traffic of enp0s25.

```bash
tcpdump -i enp0s25
ARP request who-has 10.187.70.254
# no replies
```
