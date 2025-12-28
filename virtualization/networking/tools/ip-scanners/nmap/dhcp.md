# locate dhcp server

sudo nmap --script broadcast-dhcp-discover -e enp0s25
Starting Nmap 7.80 ( <https://nmap.org> ) at 2024-03-06 12:31 EST
Pre-scan script results:
| broadcast-dhcp-discover:
|   Response 1 of 1:
|     IP Offered: 10.1.2.127
|     DHCP Message Type: DHCPOFFER
|     Subnet Mask: 255.255.252.0
|     Renewal Time Value: 0s
|     Rebinding Time Value: 0s
|     IP Address Lease Time: 1s
|     Server Identifier: 10.1.2.69
|     Router: 10.1.1.205
|     Domain Name Server: 10.1.2.69, 10.1.2.70, 172.20.0.39
|     Domain Name: BUSCHE-CNC.COM\x00
|_    TFTP Server Name: mgavi-srv-wds.busche-cnc.com\x00
WARNING: No targets were specified, so 0 hosts scanned.
Nmap done: 0 IP addresses (0 hosts up) scanned in 0.77 seconds

Using the new iproute2 (in my case in Ubuntu 22.04.1 LTS):

$ ip route | grep default

default via 1xx.1xx.xxx.xxx dev gpd0 metric 10
default via 192.168.xxx.xxx dev wlp0s proto dhcp metric 100
