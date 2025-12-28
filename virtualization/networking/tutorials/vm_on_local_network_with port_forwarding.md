# **[VM on local network with Port forwarding](https://wiki.libvirt.org/Networking.html#forwarding-incoming-connections)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## references

<https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables>

<https://superuser.com/questions/1836606/how-to-set-up-port-forwarding-to-guest-vm-using-iptables>

## Forwarding Incoming Connections

By default, guests that are connected via a virtual network with <forward mode='nat'/> can make any outgoing network connection they like. Incoming connections are allowed from the host, and from other guests connected to the same libvirt network, but all other incoming connections are blocked by iptables rules.

**If you would like to make a service that is on a guest behind a NATed virtual network publicly available, you can setup libvirt's "hook" script for qemu to install the necessary iptables rules to forward incoming connections to the host on any given port HP to port GP on the guest GNAME:**

Determine a) the name of the guest "G" (as defined in the libvirt domain XML), b) the IP address of the guest "I", c) the port on the guest that will receive the connections "GP", and d) the port on the host that will be forwarded to the guest "HP".
