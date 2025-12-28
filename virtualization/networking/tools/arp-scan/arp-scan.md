# **[arp-scan](https://github.com/royhills/arp-scan/wiki/arp-scan-User-Guide)**

## references

- **[github](https://github.com/royhills/arp-scan)**

About
arp-scan is a network scanning tool that uses the ARP protocol to discover and fingerprint IPv4 hosts on the local network. It is available for Linux, BSD, macOS and Solaris under the GPLv3 licence.

This is README.md for arp-scan version 1.10.1-git.

## Introduction to arp-scan

arp-scan is a command-line tool for IPv4 host discovery and fingerprinting. It sends ARP requests for the specified hosts and displays the responses received. arp-scan allows you to:

- Send ARP packets to any number of destination hosts, using a configurable output bandwidth or packet rate, permitting efficient scanning of large address ranges.
- Construct the outgoing ARP packet in a flexible way. arp-scan gives control of all of the fields in the ARP packet, the fields in the Ethernet frame header and any padding data after the ARP packet.
- Decode and display any returned packets. arp-scan will decode and display any received ARP packets and lookup the vendor using the MAC address.
- Fingerprint IP hosts using the arp-fingerprint tool.

## Using arp-scan for system discovery

arp-scan can be used to discover IPv4 hosts on the local Ethernet or wireless network, including hosts that block IP traffic.

Scanning the local network with --localnet

The simplest way to scan the local network is with arp-scan --localnet. This will scan all IPv4 addresses within the network defined by the interface IP address and netmask (network and broadcast addresses included). For example:

```bash
$ arp-scan --localnet
Interface: eth0, type: EN10MB, MAC: 50:65:f3:f0:70:a4, IPv4: 192.168.1.104
Target list from interface network 192.168.1.0 netmask 255.255.255.0
Starting arp-scan 1.10.1 with 256 hosts (https://github.com/royhills/arp-scan)
192.168.1.68    00:0c:29:67:b9:12       VMware, Inc.
192.168.1.69    00:0c:29:f7:56:b6       VMware, Inc.
...
```

arp-scan will use the first available network interface by default. This can be changed with the --interface (-I) option. The example below shows an ISP router:

```bash
# arp-scan -I enp0s25 -l 
$ arp-scan --localnet -I eth1
Interface: eth1, type: EN10MB, MAC: 50:65:f3:f0:70:a5, IPv4: 10.0.1.82
Target list from interface network 10.0.1.80 netmask 255.255.255.252
Starting arp-scan 1.10.1 with 4 hosts (https://github.com/royhills/arp-scan)
10.0.1.81    04:5e:a4:90:ae:40       SHENZHEN NETIS TECHNOLOGY CO.,LTD

1 packets received by filter, 0 packets dropped by kernel
Ending arp-scan 1.10.1: 4 hosts scanned in 1.555 seconds (2.57 hosts/sec). 1 responded
```

## Specifying the Target IP Addresses

You can specify the target IP addresses instead of using --localnet. The following target specifications are supported:

A single IP address, e.g. 192.168.1.1 or hostname. Use the --numeric (-n) option to prevent DNS resolution of target hostnames.
A network in CIDR format, e.g. 192.168.1.0/24 (includes network and broadcast addresses).
A network in <network>:<netmask> format, e.g. 192.168.1.0:255.255.255.0 (includes network and broadcast addresses).
An inclusive range in <start>-<end> format, e.g. 192.168.1.3-192.168.1.27

The targets can be specified in two ways:

As command line arguments, e.g. arp-scan 192.168.1.1 192.168.1.2 192.168.1.3 or arp-scan 192.168.1.0/24
Use the --file (-f) option to read from the specified file. One target specification per line. Use - for standard input. e.g. echo 192.168.1.0/24 | arp-scan -f -
For example here is a scan of the 16 addresses in 10.133.170.16/28:

```bash
arp-scan -I enp0s25 172.20.3.21
Interface: enp0s25, type: EN10MB, MAC: 18:03:73:1f:84:a4, IPv4: 10.1.0.113
Starting arp-scan 1.9.7 with 1 hosts (https://github.com/royhills/arp-scan)

35 packets received by filter, 0 packets dropped by kernel
Ending arp-scan 1.9.7: 1 hosts scanned in 1.907 seconds (0.52 hosts/sec). 0 responded

arp-scan -I enp0s25 172.20.3.0-172.20.3.255
Interface: enp0s25, type: EN10MB, MAC: 18:03:73:1f:84:a4, IPv4: 10.1.0.113
Starting arp-scan 1.9.7 with 256 hosts (https://github.com/royhills/arp-scan)

8 packets received by filter, 0 packets dropped by kernel
Ending arp-scan 1.9.7: 256 hosts scanned in 2.106 seconds (121.56 hosts/sec). 0 responded

arp-scan -I enp0s25 172.20.0.0-172.20.3.255

sudo arp-scan -I enp0s25 10.1.97.30
Interface: enp0s25, type: EN10MB, MAC: 18:03:73:1f:84:a4, IPv4: 10.1.0.113
Starting arp-scan 1.9.7 with 1 hosts (https://github.com/royhills/arp-scan)

1 packets received by filter, 0 packets dropped by kernel
Ending arp-scan 1.9.7: 1 hosts scanned in 1.493 seconds (0.67 hosts/sec). 0 responded

ping alb-ehs-01.busche-cnc.com

PING alb-ehs-01.busche-cnc.com (10.1.97.30) 56(84) bytes of data.
64 bytes from 10.1.97.30 (10.1.97.30): icmp_seq=1 ttl=127 time=11.5 ms
64 bytes from 10.1.97.30 (10.1.97.30): icmp_seq=2 ttl=127 time=7.45 ms

traceroute alb-ehs-01.busche-cnc.com 
traceroute to alb-ehs-01.busche-cnc.com (10.1.97.30), 30 hops max, 60 byte packets
 1  _gateway (10.1.1.205)  0.698 ms  0.648 ms  0.614 ms

nmap -n -sn -PR --send-eth 10.1.97.30
 Starting Nmap 7.80 ( https://nmap.org ) at 2024-08-21 16:45 EDT
Note: Host seems down. If it is really up, but blocking our ping probes, try -Pn
Nmap done: 1 IP address (0 hosts up) scanned in 3.14 seconds

nmap -n -sn -Pn --send-eth 10.1.97.30
Starting Nmap 7.80 ( https://nmap.org ) at 2024-08-21 16:47 EDT
Nmap scan report for 10.1.97.30
Host is up.
Nmap done: 1 IP address (1 host up) scanned in 0.00 seconds

nmap -sT 10.1.97.30

nmap -Pn -sT 10.1.97.30
Starting Nmap 7.80 ( https://nmap.org ) at 2024-08-21 16:49 EDT
Nmap scan report for 10.1.97.30
Host is up (0.0086s latency).
Not shown: 996 filtered ports
PORT     STATE SERVICE
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
3389/tcp open  ms-wbt-server

nmap -n -sn -PnR --send-eth 10.1.97.30

```
