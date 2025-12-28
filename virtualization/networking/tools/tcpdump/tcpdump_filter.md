# **[pcap-filter(7) man page](https://www.tcpdump.org/manpages/pcap-filter.7.html)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![f](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/9ba5ca1d-95a9-487c-833c-c91fb8cdfc49/ip-header-2021-1024x505.png)

DESCRIPTION
pcap_compile(3PCAP) is used to compile a string into a filter program. The resulting filter program can then be applied to some stream of packets to determine which packets will be supplied to pcap_loop(3PCAP), pcap_dispatch(3PCAP), pcap_next(3PCAP), or pcap_next_ex(3PCAP).

The filter expression consists of one or more primitives. Primitives usually consist of an id (name or number) preceded by one or more qualifiers. There are three different kinds of qualifier:

## type

type qualifiers say what kind of thing the id name or number refers to. Possible types are host, net, port and portrange. E.g., `host foo',`net 128.3', `port 20',`portrange 6000-6008'. If there is no type qualifier, host is assumed.

## dir

dir qualifiers specify a particular transfer direction to and/or from id. Possible directions are src, dst, src or dst, src and dst, ra, ta, addr1, addr2, addr3, and addr4. E.g., `src foo',`dst net 128.3', `src or dst port ftp-data'. If there is no dir qualifier,`src or dst' is assumed. The ra, ta, addr1, addr2, addr3, and addr4 qualifiers are only valid for IEEE 802.11 Wireless LAN link layers.

## proto

proto qualifiers restrict the match to a particular protocol. Possible protocols are: ether, fddi, tr, wlan, ip, ip6, arp, rarp, decnet, sctp, tcp and udp. E.g., `ether src foo',`arp net 128.3', `tcp port 21',`udp portrange 7000-7009', `wlan addr2 0:2:3:4:5:6'. If there is no proto qualifier, all protocols consistent with the type are assumed. E.g.,`src foo' means `(ip6 or ip or arp or rarp) src foo',`net bar' means `(ip or arp or rarp) net bar' and`port 53' means `(tcp or udp or sctp) port 53' (note that these examples use invalid syntax to illustrate the principle).

In addition to the above, there are some special `primitive' keywords that don't follow the pattern: gateway, broadcast, less, greater and arithmetic expressions. All of these are described below.

More complex filter expressions are built up by using the words and, or and not (or equivalently: `&&',`||' and `!' respectively) to combine primitives. E.g.,`host foo and not port ftp and not port ftp-data'. To save typing, identical qualifier lists can be omitted. E.g., `tcp dst port ftp or ftp-data or domain' is exactly the same as`tcp dst port ftp or tcp dst port ftp-data or tcp dst port domain'.

Allowable primitives are:

dst host hostnameaddr
True if the IPv4/v6 destination field of the packet is hostnameaddr, which may be either an address or a name.
src host hostnameaddr
True if the IPv4/v6 source field of the packet is hostnameaddr.
host hostnameaddr
True if either the IPv4/v6 source or destination of the packet is hostnameaddr.
Any of the above host expressions can be prepended with the keywords, ip, arp, rarp, or ip6 as in:
ip host hostnameaddr
which is equivalent to:
ether proto \ip and host hostnameaddr
If hostnameaddr is a name with multiple IPv4/v6 addresses, each address will be checked for a match.

## there are many more primitives
