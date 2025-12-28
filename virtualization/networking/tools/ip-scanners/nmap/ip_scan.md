## **[nmap port scanning](https://nmap.org/book/port-scanning-tutorial.html)**

## references

- **[port scanning](https://nmap.org/book/port-scanning.html)**
- **[in-use ip address scan](https://www.techrepublic.com/article/how-to-scan-for-ip-addresses-on-your-network-with-linux/)**
- **[Inside Nmap](https://pentest-tools.com/blog/nmap-port-scanner)**

## install

```bash
sudo snap install nmap
sudo apt-get install nmap -y
```

## In-Use IP addresses

```bash
nmap -sP 10.1.0.0/22
nmap -sP 192.168.1/24

nmap -sP 172.20.88.0/24
nmap -sP 172.20.88.0/22
Starting Nmap 7.80 ( https://nmap.org ) at 2024-11-04 15:44 EST
Nmap scan report for 172.20.89.60
Host is up (0.035s latency).
Nmap scan report for 172.20.89.84
Host is up (0.035s latency).
Nmap scan report for 172.20.89.86
Host is up (0.035s latency).
Nmap scan report for 172.20.89.101
Host is up (0.030s latency).
Nmap done: 256 IP addresses (4 hosts up) scanned in 14.95 seconds

Nmap scan report for 172.20.88.100
Host is up (0.030s latency).
Nmap scan report for 172.20.89.60
Host is up (0.029s latency).
Nmap scan report for 172.20.89.84
Host is up (0.034s latency).
Nmap scan report for 172.20.89.86
Host is up (0.035s latency).
Nmap scan report for 172.20.89.101
Host is up (0.036s latency).
Nmap scan report for 172.20.91.1
Host is up (0.034s latency).
Nmap scan report for 172.20.91.2
Host is up (0.030s latency).
Nmap scan report for 172.20.91.3
Host is up (0.029s latency).
Nmap scan report for 172.20.91.17
Host is up (0.030s latency).
Nmap scan report for 172.20.91.24
Host is up (0.039s latency).
Nmap scan report for 172.20.91.35
Host is up (0.059s latency).
Nmap done: 1024 IP addresses (23 hosts up) scanned in 6.61 seconds
```

## timestamp requests

A live host will send back a reply, signalling its presence on the network. Using the -PP option, Nmap will send ICMP timestamp requests (type 13), expecting ICMP timestamp replies (type 14) in return. If a type 14 ICMP packet is received, then Nmap assumes the host is alive.

```bash
sudo nmap -PP 172.20.89.60
sudo nmap -PP repsys13

[sudo] password for brent: 
Starting Nmap 7.80 ( https://nmap.org ) at 2024-06-08 17:57 EDT
Nmap scan report for repsys13 (10.1.0.135)
Host is up (0.00014s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE
21/tcp   open  ftp
22/tcp   open  ssh
3389/tcp open  ms-wbt-server
MAC Address: B8:CA:3A:6A:35:98 (Dell)

Nmap done: 1 IP address (1 host up) scanned in 0.26 seconds

```

## Summary port command

```bash
nmap -sT -Pn repsys13
Starting Nmap 7.80 ( https://nmap.org ) at 2024-06-08 17:35 EDT
Nmap scan report for repsys13 (10.1.0.135)
Host is up (0.00039s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE
21/tcp   open  ftp
22/tcp   open  ssh
3389/tcp open  ms-wbt-server

Nmap done: 1 IP address (1 host up) scanned in 0.22 seconds
```

## in use ports

Once the installation completes, you are ready to scan your LAN with nmap. To find out what addresses are in use, issue the command:

nmap -sP 192.168.1.0/24
nmap -sP 172.20.88.0/22
nmap -sP 10.1.0.0/22
nmap 172.20.88.115
<https://172.20.88.115-118>

Note: You will need to alter the IP address scheme to match yours.

The output of the command (Figure B), will show you each address found on your LAN.

sudo nmap -vv -sS -O -n 172.20.88.0/22

While this simple command is often all that is needed, advanced users often go much further. In Example 4.3, the scan is modified with four options. -p0- asks Nmap to scan every possible TCP port, -v asks Nmap to be verbose about it, -A enables aggressive tests such as remote OS detection, service/version detection, and the Nmap Scripting Engine (NSE). Finally, -T4 enables a more aggressive timing policy to speed up the scan.

nmap p0- -v -A -T4 172.20.88.115

## locate dhcp server

sudo nmap --script broadcast-dhcp-discover -e enp0s25
Starting Nmap 7.80 ( <https://nmap.org> ) at 2024-03-06 12:31 EST
Pre-scan script results:
| broadcast-dhcp-discover:
|   Response 1 of 1:
|     IP Offered: 10.1.2.127
|     DHCP Message Type: DHCPOFFER
|     Subnet Mask: 255.255.252.0
|     Renewal Time Value: 0s
|     Rebinding Time Value: 0s
|     IP Address Lease Time: 1s
|     Server Identifier: 10.1.2.69
|     Router: 10.1.1.205
|     Domain Name Server: 10.1.2.69, 10.1.2.70, 172.20.0.39
|     Domain Name: BUSCHE-CNC.COM\x00
|_    TFTP Server Name: mgavi-srv-wds.busche-cnc.com\x00
WARNING: No targets were specified, so 0 hosts scanned.
Nmap done: 0 IP addresses (0 hosts up) scanned in 0.77 seconds
