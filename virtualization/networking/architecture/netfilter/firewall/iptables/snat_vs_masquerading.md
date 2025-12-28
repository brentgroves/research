# **[](http://linux-ip.net/html/snat-intro.html)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../../README.md)**

## 6.1.1. Differences Between SNAT and Masquerading

Though SNAT and masquerading perform the same fundamental function, mapping one address space into another one, the details differ slighly. Most noticeably, masquerading chooses the source IP address for the outbound packet from the IP bound to the interface through which the packet will exit.

## AI Overview

Difference from SNAT:
While both SNAT and masquerade are forms of NAT, masquerade is a special case of SNAT that is used when the external IP address is not known or changes dynamically. SNAT requires you to specify the external IP address, while masquerade uses the IP address of the interface.

SNAT Example:
If a device with the internal IP 192.168.1.10 wants to access the internet, and the firewall's public IP is 203.0.113.1, the SNAT rule will change the source IP of the packet from 192.168.1.10 to 203.0.113.1 before sending it out.
Masquerade vs SNAT:
Masquerade is a type of SNAT, but it dynamically uses the outgoing interface's IP address for translation, while SNAT allows you to specify a fixed IP address.
