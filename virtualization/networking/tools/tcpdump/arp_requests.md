# **[Linux - ARP and how to tcpdump ARP](https://www.lixu.ca/2014/10/linux-arp-and-how-to-tcpdump-arp.html)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

TCP/IP suite operates at transport and network layer, when it goes down to data link layer such as an Ethernet or a token ring, you need to know the hardware address (48-bit address, for example, 1C:6F:65:4F:54:6B). When an Ethernet frame is sent from one host to another, it is the 48-bit ethernet address that determines for which interface the frame is destined. Device drivers never look at the destination IP in the IP datagram.

That's where ARP (Address resolution protocol) comes in, ARP provides a dynamic mapping between the two different forms of address: IP address (32-bits) and HW address (48-bits) the data link uses. ARP is in OSI model level 2 which is the data link layer. Data link layer addresses are hardware addresses on Ethernet cards, and it may be known by many different names: Ethernet addresses, MAC (Media Access Control) addresses and even hardware addresses.

The kernel keeps an ARP look-up table where they store information about IP - MAC address mapping. When the host is trying to send a packet to an another host, the kernel will first consult the ARP table to see if it already knows about the MAC address. If the MAC address is found, ARP will not be used. If the MAC is not found, the host will send a broadcast packet to the network usin ARP protocol to ask "who has IP xxx". Because this is a broadcast packet, it is sent to a special MAC address that causes all hosts o nthe network to receive it. Any host with the requested IP address will reply with an ARP packet says "I am IP xxx".

Let's use a simple example:
Open two terminals, on terminal 1, type:

# arping 192.168.1.23 -c 2

# on terminal two, type

# tcpdump -ennqti eth0 \( arp or icmp \)

1c:6f:65:4f:54:6b > ff:ff:ff:ff:ff:ff, ARP, length 42: Request who-has 192.168.1.23 (ff:ff:ff:ff:ff:ff) tell 192.168.1.3, length 28
1c:6f:65:4d:bb:98 > 1c:6f:65:4f:54:6b, ARP, length 60: Reply 192.168.1.23 is-at 1c:6f:65:4d:bb:98, length 46

In the above example, you can see form my localhost I use command "arping" to broadcast a ARP packet and ask who is"192.168.1.23", and 192.168.1.23 (1c:6f:65:4d:bb:98) replied.

Note: "ff:ff:ff:ff:ff:ff" is the Ethernet broadcast address.

ARP conversation between two hosts (192.168.1.3 and 192.168.1.23):
On 192.168.1.3, terminal 1

# tcpdump -ennqti eth0 \( arp or icmp \)

tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 65535 bytes
1c:6f:65:4f:54:6b > ff:ff:ff:ff:ff:ff, ARP, length 42: Request who-has 192.168.1.23 (ff:ff:ff:ff:ff:ff) tell 192.168.1.3, length 28
1c:6f:65:4d:bb:98 > 1c:6f:65:4f:54:6b, ARP, length 60: Reply 192.168.1.23 is-at 1c:6f:65:4d:bb:98, length 46

On 192.168.1.3, terminal 2

# arping 192.168.1.23 -c 2

ARPING 192.168.1.23 from 192.168.1.3 eth0
Unicast reply from 192.168.1.23 [1C:6F:65:4D:BB:98]  0.662ms

Gratuitous ARP reply frames:
Gratuitous ARP is a speical feature of ARP. It occurs when a host sends out an ARP packet looking for its own IP address. This is usually done when the interface is configured at bootstrap time.

There are two features that gratuitous ARP provides:

It lets a host determine if another host is already configured with the same IP. If another host has the same IP, a error message "duplicate IP address sent from Ethernet address: a:b:c:d:e:f" will be printed.
If the host sending the gratuitous ARP has just changed its hardware address (perhaps the host was shut down, the interface card replaced, and then the host was rebooted), this packet causes any other host on the cable that has an entry in its cache for the old hardware address to update its ARP cache entry accordingly.

Note: The way ARP protocol works is if a host receives an ARP request from an IP address that is already in its ARP table, then that entry will be updated.

On host 192.168.1.3 terminal 1

# arping -q -c 3 -A -I eth0 192.168.1.3

On host 192.168.1.3 terminal 2

# tcpdump -c 3 -nni eth0 arp

tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 65535 bytes
15:19:57.374715 ARP, Reply 192.168.1.3 is-at 1c:6f:65:4f:54:6b, length 28
15:19:58.374854 ARP, Reply 192.168.1.3 is-at 1c:6f:65:4f:54:6b, length 28
15:19:59.374946 ARP, Reply 192.168.1.3 is-at 1c:6f:65:4f:54:6b, length 28
3 packets captured
3 packets received by filter
0 packets dropped by kernel

Duplicate Address Detection:
In a dynamic network environment, it is important to detect duplicate IP address.
On 192.168.1.3, terminal 1

# arping -D -I eth0 192.168.1.23; echo $?

ARPING 192.168.1.23 from 0.0.0.0 eth0
Unicast reply from 192.168.1.23 [1C:6F:65:4D:BB:98]  0.768ms
Sent 1 probes (1 broadcast(s))
Received 1 response(s)
1

On 192.168.1.3, terminal 2

# tcpdump -eqtnni eth0 arp

tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 65535 bytes
1c:6f:65:4f:54:6b > ff:ff:ff:ff:ff:ff, ARP, length 42: Request who-has 192.168.1.23 (ff:ff:ff:ff:ff:ff) tell 0.0.0.0, length 28
1c:6f:65:4d:bb:98 > 1c:6f:65:4f:54:6b, ARP, length 60: Reply 192.168.1.23 is-at 1c:6f:65:4d:bb:98, length 46

tcpdump parameters:

-e Print the link-level header on each dump line.
-q Quick output. Print less protocol information so output lines are shorter.
-t Don't print a timestamp on each dump line.
-i Interface.
-n Don't convert addresses (i.e., host addresses, port numbers, etc.) to names.
-A Print each packet (minus its link level header) in ASCII.
