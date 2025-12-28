# Tests

Configured edge switch port 28,29,31 with vlans: 50,220, and 1220

- all networked access to all machines ceased.

```bash
network:
  version: 2
  ethernets:
    eno1:
      dhcp4: false
      addresses:
      - 10.188.50.201/24    
      routes:
      - to: default
        via: 10.188.50.254
      nameservers:
        addresses:
        - 10.225.50.203
        - 10.224.50.203
```

## 1. Change edge switch back to vlans 50 and 220 only

still no network access.

## 2. try 1 configure VLAN50 only

This config is in r620_203_try_1.yaml.

## 3. try 2 configure VLAN 50 and 220

AI Overview: in netplan is it ok to assign 2 vlans to 1 network interface

Yes, it is generally okay to assign two VLANs to one network interface in Netplan, especially when configured as a trunk port. This allows for multiple VLANs to share the same physical link, improving efficiency and flexibility.

Trunking:
When you configure a physical interface as a trunk, it can carry traffic for multiple VLANs. This is different from an access port, which typically carries traffic for only one VLAN.
Netplan Configuration:
In Netplan, you can configure the physical interface to be a trunk and then assign VLANs to that interface. You'll specify the VLAN IDs and potentially the VLANs' IP addresses and subnets.
Example:
You could have a physical interface like enp0s3 and assign VLANs vlan10 and vlan20 to it, with each VLAN having its own IP address and subnet.
Advantages:
This approach avoids using separate physical interfaces for each VLAN, which can save resources and simplify configuration.
Inter-VLAN Routing:
If you want VLANs to communicate with each other, you'll need to implement inter-VLAN routing, which can be done using a router, a Layer 3 switch, or by configuring the network interface to act as a router.

This config is in r620_203_try_2.yaml.

- added no routes or nameservers on vlan220.

This worked. I could ssh into both 10.188.50.203 and 10.188.220.203

## try 3: configure VLANs 50,220, 1220

- Add vlan1220 section to the r620_203_try_2.yaml file making  r620_203_try_3.yaml.
- added no routes or nameservers on vlan1220.

### result

- I could ssh into both 10.188.50.203 and 10.188.220.203
- I could not ssh into 10.187.220.203 from my laptop.
I don't have a route to 10.187.220.203 from my laptop so I won't be able to ssh into it.

- ssh into 10.188.50.203 and `nmap -v -sn 10.187.220.0/24 | more`.
I could see no hosts on the 10.187.22.0/24 network except my own. I might need a route for responses from other hosts.

## try 4: configure VLAN 1220 only

Configured port 30 as untagged 1220 and configured only ip address 10.187.220.203 with a default route of 10.187.220.254.

- this did not work.  

Brent: It is my guess there is no route from our r620s to the nutanix VM with IP 10.187.220.51/52. What do you think?
Jared: It's a firewall exception that needs added probably. I'd have to look at the rules.

## try 5: configure k8sgw2 and k8sgw1 with 2 tagged vlans

Do this until r620s have access to VMs on core switch configured for the VLAN 1220 and 10.187.220.0/24 subnet.

### result

ssh access:
10.188.50.202: ok
10.188.220.202: ok

### extreme edge switch configuration

- port 28
  - untagged  
  - tagged
    - 50
    - 220
- port 29
  - untagged  
  - tagged
    - 50
    - 220
- port 30
  - untagged  
    - 1220
  - tagged
- port 31
  - untagged  
  - tagged
    - 50
    - 220

### R620 top

name: k8sgw3
link: eno1
port: 1 (left side)
ip:
    - 10.188.50.203
    - 10.188.220.203
    - 10.187.220.203 (no access)

### R620 Middle

name: k8sgw2
link: eno1
port: 1 (left side)
ip:
    - 10.188.50.202
    - 10.188.220.202
    - 10.188.50.214
    - 10.188.220.214

### R620 Bottom

name: k8sgw1
link: eno1
port: 1 (left side)
ip:
    - 10.188.50.201
    - 10.188.220.201
