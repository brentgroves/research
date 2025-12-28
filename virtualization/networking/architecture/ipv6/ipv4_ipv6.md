# ipv4 and ipv6 cidr

## references

<https://ip.sb/cidr/>

## **[IPv4 CIDR](https://ip.sb/cidr/)**

Class A, B, C and CIDR networks
Traditionally IP network is classified as A, B or C network. The computers identify the class by first 3 bits (A=000, B=100, C=110), while humans identify the class by first octet(8-bit) number. With scarcity of IP addresses, the class-based system has been replaced by ClasslessInter-DomainRouting (CIDR) to more efficiently allocate IP addresses.

| Class | Network Address | Number of Hosts | Netmask         |
|-------|-----------------|-----------------|-----------------|
|       | /0              | 4,294,967,296   | 0.0.0.0         |
|       | /1              | 2,147,483,648   | 128.0.0.0       |
|       | /2              | 1,073,741,824   | 192.0.0.0       |
|       | /3              | 536,870,912     | 224.0.0.0       |
|       | /4              | 240,435,456     | 240.0.0.0       |
|       | /5              | 134,217,728     | 248.0.0.0       |
|       | /6              | 67,108,864      | 252.0.0.0       |
|       | /7              | 33,554,432      | 254.0.0.0       |
| A     | /8              | 16,777,216      | 255.0.0.0       |
|       | /9              | 8,388,608       | 255.128.0.0     |
|       | /10             | 4,194,304       | 255.192.0.0     |
|       | /11             | 2,097,152       | 255.224.0.0     |
|       | /12             | 1,048,576       | 255.240.0.0     |
|       | /13             | 524,288         | 255.248.0.0     |
|       | /14             | 262,144         | 255.252.0.0     |
|       | /15             | 131,072         | 255.254.0.0     |
| B     | /16             | 65,536          | 255.255.0.0     |
|       | /17             | 32,768          | 255.255.128.0   |
|       | /18             | 16,384          | 255.255.192.0   |
|       | /19             | 8,192           | 255.255.224.0   |
|       | /20             | 4,096           | 255.255.240.0   |
|       | /21             | 2,048           | 255.255.248.0   |
|       | /22             | 1,024           | 255.255.252.0   |
|       | /23             | 512             | 255.255.254.0   |
| C     | /24             | 256             | 255.255.255.0   |
|       | /25             | 128             | 255.255.255.128 |
|       | /26             | 64              | 255.255.255.192 |
|       | /27             | 32              | 255.255.255.224 |
|       | /28             | 16              | 255.255.255.240 |
|       | /29             | 8               | 255.255.255.248 |
|       | /30             | 4               | 255.255.255.252 |
|       | /31             | 2               | 255.255.255.254 |
|       | /32             | 1               | 255.255.255.255 |

## IPv6 CIDR

IPv6 rangeblocks
IPv6 addresses are each 128 bits long. Because each digit in an IPv6 address can have 16 different values (from 0 to 15), each digit represents the overall value of 4 bits (one nibble), with 32 digits total. As with IPv4, CIDR notation describes ranges in terms of a common prefix of bits. For example 2001:db8::/32 means that the range described has the first 32 bits set to the binary digits 00100000000000010000110110101000. Also like IPv4, MediaWiki implements IPv6 rangeblocks using CIDR notation.
pass-through /64 routed fire
login into u4
ip6 static pass-through harold / josh
ip4 NAT port forward

```bash
ping6 -I eno1 2a03:2880:f12f:83:face:b00c::25de
# https://dnschecker.org/ip-location.php?ip=2607:f8b0:4006:809::200e
ping google.com
ip -6 route
::1 dev lo proto kernel metric 256 pref medium
fe80::/64 dev enp0s25 proto kernel metric 1024 pref medium
traceroute6 google.com
traceroute to google.com (2607:f8b0:4009:80b::200e), 30 hops max, 80 byte packets
connect: Network is unreachable

# ping reports-13
ping6 -I enp0s25 fe80::9a90:96ff:fec3:f483
# ping google
ping6 -I enp0s25 200e::2607:f8b0:4006:809

# https://bbs.archlinux.org/viewtopic.php?id=288826
dig -t AAAA google.com

; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> -t AAAA google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 13026
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;google.com.                    IN      AAAA

;; ANSWER SECTION:
google.com.             299     IN      AAAA    2607:f8b0:4009:80b::200e

;; Query time: 39 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 14 13:10:37 EST 2024
;; MSG SIZE  rcvd: 67
dig @2001:4860:4860::8888 -t AAAA google.com
;; UDP setup with 2001:4860:4860::8888#53(2001:4860:4860::8888) for google.com failed: network unreachable.

ip a
should at least provide one globally routable IPv6 address (2000::/3) and one link-local address (fe80::/16).

2: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 18:03:73:1f:84:a4 brd ff:ff:ff:ff:ff:ff
    inet 10.1.0.113/22 brd 10.1.3.255 scope global noprefixroute enp0s25
       valid_lft forever preferred_lft forever
    inet6 fe80::4fa4:f4f6:dc79:6f02/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

ip -6 route
::1 dev lo proto kernel metric 256 pref medium
fe80::/64 dev enp0s25 proto kernel metric 1024 pref medium
# should contain routes for the globally routable IPv6 address space and one default route pointing to the link-local address of your router. Try pinging the last one via the scope of the network adapter (example: "eno1"):

ping -6 fe80::xxxx:xxff:fexx:xxxx%eno1

# ping reports-13
ping6 -I enp0s25 fe80::9a90:96ff:fec3:f483
ping -6 fe80::9a90:96ff:fec3:f483%enp0s25
PING fe80::9a90:96ff:fec3:f483%enp0s25(fe80::9a90:96ff:fec3:f483%enp0s25) 56 data bytes
64 bytes from fe80::9a90:96ff:fec3:f483%enp0s25: icmp_seq=1 ttl=64 time=0.359 ms
ping -6 200e::2607:f8b0:4009:80b%enp0s25
2607:f8b0:4009:80b::200e

drill -t AAAA google.com
;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 21171
;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0 
;; QUESTION SECTION:
;; google.com.  IN      AAAA

;; ANSWER SECTION:
google.com.     1       IN      AAAA    2607:f8b0:4009:814::200e

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:

;; Query time: 1 msec
;; SERVER: 127.0.0.53
;; WHEN: Wed Feb 14 13:34:46 2024
;; MSG SIZE  rcvd: 56
```

Are you sure your ISP provides you with IPv6? My router is also set up for IPv6 (and IPv4) but my ISP only gives IPv4. I would have to ask them to change it if I wanted IPv6.

<https://test-ipv6.com/>
Your IPv4 address on the public Internet appears to be 64.184.36.240
Your Internet Service Provider (ISP) appears to be LIGTEL-COMMUNICATIONS
No IPv6 address detected [more info]
You appear to be able to browse the IPv4 Internet only. You will not be able to reach IPv6-only sites.
To ensure the best Internet performance and connectivity, ask your ISP about native IPv6. [more info]
Your DNS server (possibly run by your ISP) appears to have IPv6 Internet access.

```bash
cat /etc/resolv.conf
nameserver 127.0.0.53
options edns0 trust-ad

look in settings
dns: 10.1.2.69 172.20.88.20

# In newer Linux distributions that use systemd, you can use the systemd-resolve command to check the DNS server.

systemd-resolve --status | grep "DNS Servers"

cat /etc/systemd/resolved.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file, or by creating "drop-ins" in
# the resolved.conf.d/ subdirectory. The latter is generally recommended.
# Defaults can be restored by simply deleting this file and all drop-ins.
#
# Use 'systemd-analyze cat-config systemd/resolved.conf' to display the full config.
#
# See resolved.conf(5) for details.

[Resolve]
# Some examples of DNS servers which may be used for DNS= and FallbackDNS=:
# Cloudflare: 1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
# Google:     8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.google
# Quad9:      9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
#DNS=
#FallbackDNS=
#Domains=
#DNSSEC=no
#DNSOverTLS=no
#MulticastDNS=no
#LLMNR=no
#Cache=no-negative
#CacheFromLocalhost=no
#DNSStubListener=yes
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no

resolvectl status
Global
       Protocols: -LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
resolv.conf mode: stub

Link 2 (enp0s25)
    Current Scopes: DNS
         Protocols: +DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported
Current DNS Server: 10.1.2.69
       DNS Servers: 10.1.2.69 172.20.88.20

Link 3 (mpqemubr0)
Current Scopes: none
     Protocols: -DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported

Link 4 (docker0)
Current Scopes: none
     Protocols: -DefaultRoute +LLMNR -mDNS -DNSOverTLS DNSSEC=no/unsupported

dig AAAA ipv6.google.com    
; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> AAAA ipv6.google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 32391
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;ipv6.google.com.               IN      AAAA

;; ANSWER SECTION:
ipv6.google.com.        299     IN      CNAME   ipv6.l.google.com.
ipv6.l.google.com.      299     IN      AAAA    2607:f8b0:4009:808::200e

;; Query time: 51 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 14 13:52:57 EST 2024
;; MSG SIZE  rcvd: 93 

dig mobexglobal.com     

; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> mobexglobal.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 34338
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;mobexglobal.com.               IN      A

;; ANSWER SECTION:
mobexglobal.com.        6407    IN      A       67.225.228.154

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 14 13:53:52 EST 2024
;; MSG SIZE  rcvd: 60

dig AAAA mobexglobal.com

; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> AAAA mobexglobal.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 1495
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;mobexglobal.com.               IN      AAAA

;; AUTHORITY SECTION:
mobexglobal.com.        599     IN      SOA     ns39.domaincontrol.com. dns.jomax.net. 2023102404 28800 7200 604800 600

;; Query time: 67 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 14 13:55:26 EST 2024
;; MSG SIZE  rcvd: 112

dig linamar.com         

; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> linamar.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41851
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;linamar.com.                   IN      A

;; ANSWER SECTION:
linamar.com.            899     IN      A       50.16.16.211

;; Query time: 63 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 14 13:56:09 EST 2024
;; MSG SIZE  rcvd: 56

dig AAAA linamar.com

; <<>> DiG 9.18.18-0ubuntu0.22.04.2-Ubuntu <<>> AAAA linamar.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 34925
;; flags: qr rd ra; QUERY: 1, ANSWER: 0, AUTHORITY: 1, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;linamar.com.                   IN      AAAA

;; AUTHORITY SECTION:
linamar.com.            900     IN      SOA     ns.golden.net. hostmaster.golden.net. 2023111501 164121 300 604800 21600

;; Query time: 67 msec
;; SERVER: 127.0.0.53#53(127.0.0.53) (UDP)
;; WHEN: Wed Feb 14 13:56:51 EST 2024
;; MSG SIZE  rcvd: 100
```
