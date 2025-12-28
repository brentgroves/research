# isdev-alb

```yaml
system: "Dell Laptop"
ram: 16GB
hostname: isdev
adapter: 1
    mac: A0:CE:C8:5A:FC:3C
    vlan: 40
    link: enxa0cec85afc3c
    ip: dhcp
    subnet: 
      - 10.187.40.0/24
      - 255.255.255.0
    ns: 
      - 10.225.50.203 
      - 10.224.50.203 
      - 10.254.0.204
    routes: 
        - default: 10.187.40.254
    office_switch: 2
adapter: 3 
    mac: 80:3F:5D:09:0E:B3
    link: enx803f5d090eb3
    vlan: 586
    ip: 172.24.189.200
    subnet: 
        - 172.24.188.0/23
        - 255.255.254.0
    ns: 
        - 8.8.8.8
        - 8.8.4.4
    routes: 
        - default: 172.24.189.254
    ns: 
        - 8.8.8.8
        - 8.8.4.4
    office_switch: 4

```
