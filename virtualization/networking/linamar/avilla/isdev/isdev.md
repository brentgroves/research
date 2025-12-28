# isdev

## Routes and Name Servers

```yaml
routes: 
    default: 10.187.x.254
    routes:
      - github1:
          subnet: 140.82.112.0
          netmask: 255.255.255.0
          gw: 10.188.50.254
          metric: 100
      - github2:
          subnet: 140.82.113.0/24 
          netmask: 255.255.255.0
          gw: 10.188.50.254
          metric: 100
      - github3:
          subnet: 140.82.114.0 
          netmask: 255.255.255.0
          gw: 10.188.50.254
          metric: 100
ns: 
  - 10.225.50.203 
  - 10.224.50.203 
  - 10.254.0.204

```

## system

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
      - 10.188.40.0/24
      - 255.255.255.0
    ns: 
      - 10.225.50.203 
      - 10.224.50.203 
      - 10.254.0.204
    routes: 
        - default: 10.188.40.254
    office_switch: 11

adapter: 2
    mac: ?
    vlan: 50
    link: ?
    ip: 10.188.50.212
    subnet: 
      - 10.188.50.0/24
      - 255.255.255.0
    ns: 
      - 10.225.50.203 
      - 10.224.50.203 
      - 10.254.0.204
    routes:
      - default: 172.24.189.254

      - github1:
          subnet: 140.82.112.0
          netmask: 255.255.255.0
          gw: 10.188.50.254
          metric: 100
      - github2:
          subnet: 140.82.113.0/24 
          netmask: 255.255.255.0
          gw: 10.188.50.254
          metric: 100
      - github3:
          subnet: 140.82.114.0 
          netmask: 255.255.255.0
          gw: 10.188.50.254
          metric: 100
    office_switch: 10
adapter: 3
    mac: 80:3F:5D:09:0E:B3
    link: enx803f5d090eb3
    vlan: 220
    ip: 10.188.220.212
    subnet: 
      - 10.188.220.0/24
      - 255.255.255.0
    ns: 
      - 10.225.50.203 
      - 10.224.50.203 
      - 10.254.0.204
    routes:
      - default: 10.188.220.254
    office_switch: 12

adapter: 3
    mac: 80:3F:5D:09:0E:B3
    link: enx803f5d090eb3
    vlan: 1220
    ip: 10.187.220.212
    subnet: 
      - 10.187.220.0/24
      - 255.255.255.0
    ns: 
      - 10.225.50.203 
      - 10.224.50.203 
      - 10.254.0.204
    routes:
      - default: 10.187.220.254
    office_switch: 9
