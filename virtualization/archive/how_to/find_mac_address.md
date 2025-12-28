# How to find a mac address

## references

## How to find the **[mac address](https://unix.stackexchange.com/questions/120153/resolving-mac-address-from-ip-address-in-linux)** to remote ip

Resolving MAC Address from IP Address in Linux

I need to write a bash script wherein I have to create a file which holds the details of IP Addresses of the hosts and their mapping with corresponding MAC Addresses.

Is there any possible way with which I can find out the MAC address of any (remote) host when IP address of the host is available?

If you just want to find out the MAC address of a given IP address you can use the command arp to look it up, once you've pinged the system 1 time.

```bash
$ ping skinner -c 1
PING skinner.bubba.net (192.168.1.3) 56(84) bytes of data.
64 bytes from skinner.bubba.net (192.168.1.3): icmp_seq=1 ttl=64 time=3.09 ms

--- skinner.bubba.net ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 3.097/3.097/3.097/0.000 ms

# reports1 load-balancer ip
# ping from reports-alb
ping -c1 10.1.0.8 
PING 10.1.0.8 (10.1.0.8) 56(84) bytes of data.
From 10.1.0.112 icmp_seq=1 Destination Host Unreachable

--- 10.1.0.8 ping statistics ---
1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
```

Now look up in the ARP table:

```bash
$ arp -a
skinner.bubba.net (192.168.1.3) at 00:19:d1:e8:4c:95 [ether] on wlp3s0

## 
$ arp -a
reports13 (10.1.0.112) at 98:90:96:c3:f4:83 [ether] on enp0s25
? (10.1.0.32) at cc:70:ed:1b:4f:c0 [ether] on enp0s25
Super-PLT-7.BUSCHE-CNC.com (10.1.0.170) at 4c:91:7a:64:0f:ad [ether] on enp0s25
reports1.busche-cnc.com (10.1.0.8) at 98:90:96:c3:f4:83 [ether] on enp0s25


```

fing
If you want to sweep the entire LAN for MAC addresses you can use the command line tool fing to do so. It's typically not installed so you'll have to go download it and install it manually.

```bash
sudo fing 10.9.8.0/24

```

Using ip
If you find you don't have the arp or fing commands available, you could use iproute2's command ip neigh to see your system's ARP table instead:

```bash
$ ip neigh
192.168.1.61 dev eth0 lladdr b8:27:eb:87:74:11 REACHABLE
192.168.1.70 dev eth0 lladdr 30:b5:c2:3d:6c:37 STALE
192.168.1.95 dev eth0 lladdr f0:18:98:1d:26:e2 REACHABLE
192.168.1.2 dev eth0 lladdr 14:cc:20:d4:56:2a STALE
192.168.1.10 dev eth0 lladdr 00:22:15:91:c1:2d REACHABLE
```

You can use arp command:

```bash
arp -an
```

But you can only use this command in LAN, if you want to find out the MAC address of any remote host, maybe you must use some tool to capture the packet like tcpdump and parsing the result.

You can use the command

```bash
sudo nmap -sP -PE -PA21,23,80,3389 192.168.1.*
```

nmap: Network exploration tool and security / port scanner. From the manual:

-sP (Skip port scan): This option tells Nmap not to do a port scan after host discovery, and only print out the available hosts that responded to the scan. This is often known as a “ping scan”, but you can also request that traceroute and NSE host scripts be run. This is by default one step more intrusive than the list scan, and can often be used for the same purposes. It allows light reconnaissance of a target network without attracting much attention. Knowing how many hosts are up is more valuable to attackers than the list provided by list scan of every single IP and host name.

-PE; -PP; -PM (ICMP Ping Types): In addition to the unusual TCP, UDP and SCTP host discovery types discussed previously, Nmap can send the standard packets sent by the ubiquitous ping program. Nmap sends an ICMP type 8 (echo request) packet to the target IP addresses, expecting a type 0 (echo reply) in return from available hosts.. Unfortunately for network explorers, many hosts and firewalls now block these packets, rather than responding as required by RFC 1122[2]. For this reason, ICMP-only scans are rarely reliable enough against unknown targets over the Internet. But for system administrators monitoring an internal network, they can be a practical and efficient approach. Use the -PE option to enable this echo request behavior.

-PA port list (TCP ACK Ping): The TCP ACK ping is quite similar to the just-discussed SYN ping. The difference, as you could likely guess, is that the TCP ACK flag is set instead of the SYN flag. Such an ACK packet purports to be acknowledging data over an established TCP connection, but no such connection exists. So remote hosts should always respond with a RST packet, disclosing their existence in the process. The -PA option uses the same default port as the SYN probe (80) and can also take a list of destination ports in the same format. If an unprivileged user tries this, the connect workaround discussed previously is used. This workaround is imperfect because connect is actually sending a SYN packet rather than an ACK.

21,23,80,3389: Ports to search through.

192.168.1.*: Range of IPs. replace with yours.
