# IPv6

## references

<https://www.techtarget.com/iotagenda/definition/IPv6-address#:~:text=In%20precise%20terms%2C%20an%20IPv6,groups%20are%20separated%20by%20colons.&text=An%20IPv6%20address%20is%20split,network%20and%20a%20node%20component>.

<https://www.ipaddressguide.com/ipv6-cidr>

## IP6 Address assignment

![](https://cdn.ttgtmedia.com/rms/onlineimages/whatis-ipv6_address-h.png)

Overall, the process in IPv6 is usually completely different.

In IPv6 primary address auto-configuration mechanism (SLAAC) is completely stateless: the router does not issue individual addresses; it only periodically advertises the subnet address prefix and each host just combines it with its own chosen suffix. The router cannot limit hosts to just a specific sub-range; in fact the router does not receive any feedback about hosts' chosen address at all.

(Depending on each device's OS, the suffix might be a MAC address in traditional RFC4862 SLAAC; it might be a static hash value in RFC7217; it might be completely random in RFC4941 "Privacy Extensions"; and it might even be a user-provided value if the OS allows that.)

For example, the router advertises 2001:db8:123:456::/64 as the LAN address prefix; client A combines it with its own MAC address and begins using 2001:db8:123:456:6af2:68fe:ff7c:e25c.

That said, DHCP does exist in the IPv6 world and handles address leases in much the same way as IPv4 DHCP does. That means you can create DHCPv6 address pools, you can configure static address leases in DHCPv6, and so on. But not all clients support DHCPv6 at all (e.g. Android does not), so having SLAAC alongside is almost unavoidable.

So if you have a DHCPv6-capable client on a DHCPv6-capable network, chances are it'll have both a nice DHCPv6-assigned address and a longer SLAAC-autoconfigured address.

```bash
ip -6 neighbour | grep router
fe80::9a90:96ff:fec3:f483 dev enp0s25 lladdr 98:90:96:c3:f4:83 router STALE

ping6 -I enp0s25 fe80::9a90:96ff:fec3:f483
ping6 -I enp0s25 fe80::9a90:96ff:fec3:f483
10.1.1.205
https://superuser.com/questions/1321276/how-to-access-router-with-ipv6-address
```

## **[ipv6-cidr](https://www.ipaddressguide.com/ipv6-cidr)**

## IPv6 address

An IPv6 address is a 128-bit alphanumeric value that identifies an endpoint device in an Internet Protocol Version 6 (IPv6) network. IPv6 is the successor to a previous addressing infrastructure, IPv4, which had limitations IPv6 was designed to overcome. Notably, IPv6 has drastically increased address space compared to IPv4.

The Internet Protocol (IP) is a method in which data is sent to different computers over the internet. Each network interface, or computer, on the internet will have at least one IP address that is used to uniquely identify that computer. Every device that connects to the internet is assigned an IP address. Which is why there was a concern with the number of IP addresses in IPv4, and why the Internet Engineering Task Force (IETF) defined the new IPv6 standard.

Operating systems (OSes) like Windows 10, macOS and Ubuntu support IPv6. Currently, the use of address types is mixed. Devices in use now will either use IPv6 or IPv4. Domain name systems (DNSes) have supported IPv6 since 2008.

It has been a concern for some time that the IPv4 addressing scheme was running out of potential addresses. The IPv6 format was created to enable the trillions of new IP addresses to connect an ever-greater number of computing devices and the rapidly expanding numbers of items with embedded connectivity, thanks to the internet of things (IoT). The number of potential IPv6 addresses has been calculated to be over 340 undecillion (or 340 trillion trillion trillion). According to Computer History Museum docent Dick Guertin, that number allows an IPv6 address for each atom on the surface of the planet, with enough left over for more than 100 more similar planets.

## Format of an IPv6 address

In precise terms, an IPv6 address is 128 bits long and is arranged in eight groups, each of which is 16 bits. Each group is expressed as four hexadecimal digits and the groups are separated by colons.

```bash
ping alb-utl.busche-cnc.com               
PING alb-utl.busche-cnc.com (10.1.1.150) 56(84) bytes of data.
64 bytes from ALB-UTL.BUSCHE-CNC.com (10.1.1.150): icmp_seq=1 ttl=128 time=1.29 ms
64 bytes from ALB-UTL.BUSCHE-CNC.com (10.1.1.150): icmp_seq=2 ttl=128 time=0.707 ms
^C
--- alb-utl.busche-cnc.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 0.707/0.997/1.288/0.290 ms

dig AAAA alb-utl.busche-cnc.com


; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> AAAA alb-utl.busche-cnc.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 44755
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;alb-utl.busche-cnc.com.                IN      AAAA

;; AUTHORITY SECTION:
busche-cnc.com.         3600    IN      SOA     alb-ad01.busche-cnc.com. . 3201245 900 600 86400 3600

;; Query time: 3 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 14 14:42:31 EST 2024
;; MSG SIZE  rcvd: 95
```

An example of a full IPv6 address could be:

FE80:CD00:0000:0CDE:1257:0000:211E:729C

An IPv6 address is split into two parts: a network and a node component. The network component is the first 64 bits of the address and is used for routing. The node component is the later 64 bits and is used to identify the address of the interface. It is derived from the physical, or MAC address, using the 64-bit extended unique identifier (EUI-64) format defined by the Institute of Electrical and Electronics Engineers (IEEE).

A MAC address (media access control address) is a 12-digit hexadecimal number assigned to each device connected to the network.

![](https://cdn.ttgtmedia.com/rms/onlineimages/osi_model-f.png)

## Types of MAC addresses

There are three types of MAC addresses:

- **Unicast MAC address**. A unicast address is attached to a specific NIC on the local network. Therefore, this address is only used when a frame is sent from a single transmitting device to a single destination device.
- **Multicast MAC address**. A source device can transmit a data frame to multiple devices by using a Multicast A multicast group IP address is assigned to devices belonging to the multicast group.
- **Broadcast MAC address**. This address represents every device on a given network. The purpose of a broadcast domain is to enable a source device to send data to every device on the network by using the broadcast address as the destination's MAC address.

![](https://cdn.ttgtmedia.com/rms/onlineimages/networking-mac_vs_ip_address.png)

The network node can be split even further into a block of 48 bits and a block of 16 bits. The upper 48-bit section is used for global network addresses. The lower 16-bit section is controlled by network administrators and is used for subnets on an internal network.

Further, the example address can be shortened, as the addressing scheme allows the omission of any leading zero, as well as any sequences consisting of only zeros. The shortened version would look like:

FE80:CD00:0:CDE:1257:0:211E:729C

The specific layout of an IPv6 address may vary somewhat, depending on its format. Three basic parts that make up the address are the routing prefix, the subnet ID and the interface ID.

![](https://cdn.ttgtmedia.com/rms/onlineimages/whatis-ipv6_address-h.png)

Both the routing prefix and the subnet ID represent two main levels in which the address is constructed -- either global or site-specific. The routing prefix is the number of bits that can be subdivided -- typically, decided by Internet Registries and Internet Service Providers (ISPs). If you were to look at an IPv6 address, the leftmost set of numbers -- the first 48 bits -- is called the site prefix. The subnet ID is the next 16 bits. The subnet ID lays out site topology. The last 64-bits are called the interface ID, which can be automatically or manually configured.

## Types of IPv6 addresses

There are different types and formats of IPv6 addresses, of which, it's notable to mention that there are no broadcast addresses in IPv6. Some examples of IPv6 formats include:

- **Global unicast**. These addresses are routable on the internet and start with "2001:" as the prefix group. Global unicast addresses are the equivalent of IPv4 public addresses.
- **Unicast address**: Used to identify the interface of an individual node.
- **Anycast address**: Used to identify a group of interfaces on different nodes.
- **Multicast address**: An address used to define Multicast Multicasts are used to send a single packet to multiple destinations at one time.
- **Link local addresses**: One of the two internal address types that are not routed on the internet. Link local addresses are used inside an internal network, are self-assigned and start with "fe80:" as the prefix group.
- **Unique local addresses**: This is the other type of internal address that is not routed on the internet. Unique local addresses are equivalent to the IPv4 addresses 10.0.0.0/8, 172.16.0.0/12 and 192.168.0.0/16.

## Advantages and disadvantages of IPv6 addresses

IPv6 addresses can bring a variety of benefits, including:

- More efficient routing with smaller routing tables and aggregation of prefixes.
- Simplified packet processing due to more streamlined packet headers.
