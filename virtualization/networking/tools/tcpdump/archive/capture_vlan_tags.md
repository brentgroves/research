# **[How To Configure VLAN Tagging In Linux [A Step-by-Step Guide]](https://ostechnix.com/configure-vlan-tagging-in-linux/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

- **[tcpdump with any interface](https://networkengineering.stackexchange.com/questions/1559/tcpdump-i-any-with-vlan)**
- **[protocols vlan](https://unix.stackexchange.com/questions/127245/in-which-vlan-am-i-in)**
- **[identifying vlan packets using tcpdump](https://serverfault.com/questions/562325/identifying-vlan-packets-using-tcpdump)**
- **[Capture VLAN tags by using tcpdump](https://access.redhat.com/solutions/2630851)**

## **[How can I get a VLAN interface in a Linux bridge?](https://superuser.com/questions/1833519/how-can-i-get-a-vlan-interface-in-a-linux-bridge)**

I'm experimenting with Linux bridges and vlan filtering but I'm having a few problems.

What I have is a VM with a trunk (tagged frames) that arrives on ens19. What I want to do is connect this port to a linux bridge and on this bridge have "virtual" interfaces which are labelled on the vlan I need with a complete TCP/IP stack behind it (that of the host).

For my experiments I'm limiting myself to vlan 3 and 5 but the idea is that it should be easy to extend. The use won't seem huge because it could be replaced by sub-interfaces of ens19. But later on the interest that I will connect the ens19 port with a gretap interface to circulate several vlan on a tunnel.

I've done tests with dummy and tap interfaces but it doesn't work given the nature of these interfaces, it seems to me. I tested with a br0.3 sub-interface but here my client receives the ARP reply but the PING never receives an ICMP reply ...

ip link add name br0 type bridge vlan_filtering 1
ip link set dev br0 up
ip link add link br0 name br0.3 type vlan id 3
ip link set dev ens19 master br0
ip link set ens19 up
ip link set dev br0 up
ip link set dev br0.3 up
ip addr add 10.3.0.106/22 dev br0.3

![How to use multiple addresses with multiple gateways](https://netplan.readthedocs.io/en/stable/examples/#how-to-use-multiple-addresses-on-a-single-interface)**

![mvlan](https://ostechnix.com/wp-content/uploads/2023/11/Configure-VLAN-Tagging-using-Netplan-in-Linux-1024x555.png)

Environment
Red Hat Enterprise Linux 5 (RHEL 5).
Red Hat Enterprise Linux 6 (RHEL 6).
Red Hat Enterprise Linux 7 (RHEL 7).
tcpdump

## Issue

How to capture VLAN tags that are used by tcpdump?
Server unable to ping the gateway which is on VLAN.

## Resolution

You can verify the incoming traffic to see if they have VLAN tags by using tcpdump with the -e  and vlan option.
This will show the details of the VLAN header:

```bash
# tcpdump -i bond0 -nn -e  vlan
```

To capture the issue live.

```bash
# tcpdump -i eno1 -nn -e  vlan -w /tmp/vlan.pcap
```

To write to the capture to a file.

## Root Cause

The reason why the host could ping the gateway was because the traffic seen on the host was tagged with the wrong VLAN ID. The host was not configured to use VLAN tagging so traffic was being ignored.

## Diagnostic Steps

Another check to run through via the packet capture is to check on the arp requests incoming, and see if the packets coming in are in the same subnet.
