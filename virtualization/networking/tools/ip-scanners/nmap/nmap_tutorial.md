# **[Inside Nmap, the world’s most famous port scanner](https://pentest-tools.com/blog/nmap-port-scanner)**

Network administrators and penetration testers use port scanning to discover open communication channels on computer systems. For an attacker, this is the first step to get info about the target’s network and identify a potential way in, since services running on an open port could be vulnerable to attacks.

Multiple tools can produce good results, but some port scanners are better for a particular task than others. Our focus is on Nmap (Network Mapper), by far the most popular tool for network discovery and port scanning. Some of its features include Host Discovery, Port Scan, Service and OS fingerprinting, and Basic Vulnerability detection. There is also a graphical version known as Zenmap, which offers easy access to scanning options and network mapping diagrams.

In this article, we will describe how Nmap can help you to:

Discover live hosts on a network

Scan for open ports

Discover services

Test for vulnerabilities

## 1. Nmap host discovery

By default, Nmap uses requests to identify a live IP. In the older version of the tool, the option for ping sweep was -sP; in the newer version, it is -sn. To discover available hosts, the following packets are sent (as seen in the below screen capture below from Wireshark packet analyzer):

ICMP echo request

A TCP SYN packet to port 443

A TCP ACK packet to port 80

An ICMP timestamp request
