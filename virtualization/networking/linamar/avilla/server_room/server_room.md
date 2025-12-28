# extreme

## server room

### Left rack

- Onts
- Fortigate FW
- Extreme Edge Switch - Structures Access
- Fortigate FW
- Extreme Edge Switch - Structures Access

- extreme switch AOS tunnels - Corporate

### Right Rack

- Exteme core switch - Corporate
- Netgear switch
- Nutanix cluster
- Nutanix cluster
- r620s -> extreme edge switch

rdx->edge(10.187.75.0/24)->AOS(albion)-tunnel-AOS(Avilla)->core VLAN->10.188.[50,220].0,10.187.220.

I believe AOS is part of the extreme switches that we use. So you can configure a tunnel between Albion on specified ports of the exteme switch.

## Laptop

- DHCP reservation IP
- Network config request access to 10.188.50.50 and 10.187.50.51 from reserved DHCP address.
