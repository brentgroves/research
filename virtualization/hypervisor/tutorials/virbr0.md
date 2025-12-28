# **[how does virbr0 nat traffic](https://wiki.libvirt.org/Networking.html#:~:text=Every%20standard%20libvirt%20installation%20provides,also%20attempt%20to%20enable%20ip_forward.)**

## AI

how does virbr0 nat traffic

"virbr0" acts as a virtual bridge that handles Network Address Translation (NAT) for virtual machines, essentially allowing them to access the external network by translating their private IP addresses to the host machine's public IP address, enabling outbound internet connectivity for the virtual guests while keeping their internal network isolated; this translation is managed through iptables rules on the host system. 
Key points about virbr0 and NAT:
Function:
When a virtual machine on the "virbr0" network tries to access the internet, the traffic is intercepted by the host system, where the source IP address is changed to the host's public IP address before being sent out to the network. 
Isolation:
Virtual machines connected to "virbr0" can communicate with each other using their private IP addresses within the virtual network, but external systems cannot directly access them without proper port forwarding rules. 
Implementation:
The NAT functionality is typically implemented using iptables rules on the host machine, which are automatically managed by the virtualization software like libvirt.

The two common setups are "virtual network" or "shared physical device". The former is identical across all distributions and available out-of-the-box. The latter needs distribution specific manual configuration.

## NAT forwarding (aka "virtual networks")
Host configuration (NAT)

Every standard libvirt installation provides NAT based connectivity to virtual machines out of the box. This is the so called 'default virtual network'. You can verify that it is available with

##  virsh net-list --all
Name                 State      Autostart
-----------------------------------------
default              active     yes

If it is missing, then the example XML config can be reloaded & activated

# virsh net-define /usr/share/libvirt/networks/default.xml
Network default defined from /usr/share/libvirt/networks/default.xml
# virsh net-autostart default
Network default marked as autostarted
# virsh net-start default
Network default started
When the libvirt default network is running, you will see an isolated bridge device. This device explicitly does *NOT* have any physical interfaces added, since it uses NAT + forwarding to connect to outside world. Do not add interfaces

# brctl show
bridge name bridge id       STP enabled interfaces
virbr0      8000.000000000000   yes
Libvirt will add iptables rules to allow traffic to/from guests attached to the virbr0 device in the INPUT, FORWARD, OUTPUT and POSTROUTING chains. It will also attempt to enable ip_forward. Some other applications may disable it, so the best option is to add the following to /etc/sysctl.conf

net.ipv4.ip_forward = 1
If you are already running dnsmasq on your machine, please see libvirtd and dnsmasq.

```bash
iptables-nft
```