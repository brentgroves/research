# **[identifying vlan packets using tcpdump](https://serverfault.com/questions/562325/identifying-vlan-packets-using-tcpdump)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

- **[tcpdump with any interface](https://networkengineering.stackexchange.com/questions/1559/tcpdump-i-any-with-vlan)**
- **[protocols vlan](https://unix.stackexchange.com/questions/127245/in-which-vlan-am-i-in)**
- **[identifying vlan packets using tcpdump](https://serverfault.com/questions/562325/identifying-vlan-packets-using-tcpdump)**
- **[Capture VLAN tags by using tcpdump](https://access.redhat.com/solutions/2630851)**

## **[How can I get a VLAN interface in a Linux bridge?](https://superuser.com/questions/1833519/how-can-i-get-a-vlan-interface-in-a-linux-bridge)**

## question

I'm trying to figure out the vlan tagged packets that my host receives or sends to other hosts. I tried

`tcpdump -i eth1 vlan 0x0070`

But it didnt work. Has anyone tried to view the vlan packets through tcpdump before? Couldn't find much help searching the web!

## Answer 1

If your host is connected to an access port, the switch will likely strip the VLAN tag off before it reaches your host. As a result, running TCPDump on the host in question will never see the VLAN tags.

You would need to setup a SPAN port and/or introduce a network tap into your network somewhere to grab traffic before the tags are dropped off the packets in order to see them in a network dump/trace.

To be accurate, a switch does not strip VLAN tags off a frame before sending it out an access port, it only adds VLAN tagging to frames before it sends them out a trunk/tagged port (and they are removed once received by the switch on the other side)

## Answer 2

```bash
tcpdump -i eth1 -e vlan
```

Output will be for instance:

```bash
16:02:26.693223 c4:c1:e2:4a:9a:06 (oui Unknown) > 00:e0:5c:8f:e0:c9 (oui Unknown), ethertype 802.1Q (0x8100), length 102: vlan 108, p 0, ethertype IPv4 (0x0800), 192.168.118.11 > 192.168.128.2: ICMP echo request, id 52, seq 2, length 64
16:02:26.694811 c4:c1:e2:4a:9a:06 (oui Unknown) > 00:e0:5c:8f:e0:c9 (oui Unknown), ethertype 802.1Q (0x8100), length 102: vlan 108, p 0, ethertype IPv4 (0x0800), 192.168.118.11 > 192.168.128.2: ICMP echo request, id 53, seq 2, length 64
16:02:26.696331 c4:c1:e2:4a:9a:06 (oui Unknown) > 00:e0:5c:8f:e0:c9 (oui Unknown), ethertype 802.1Q (0x8100), length 102: vlan 108, p 0, ethertype IPv4 (0x0800), 192.168.118.11 > 192.168.128.2: ICMP echo request, id 54, seq 2, length 64
```

Note the vlan 108 in the middle of each line.

The option -e will show the 8021.Q header.

The option vlan will only show packets containing a VLAN field, which can be specified, so in the exemple above it would be: vlan 108 (more info on this expression with man pcap-filter).

Of course, each option can be used independently. If the exemple given in the question is not working, it would be theoretically because the interface is not receiving packets tagged with VLAN Id 0x70, and this should be checked with -e.
