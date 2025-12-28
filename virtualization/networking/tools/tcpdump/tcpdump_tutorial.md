# **[A tcpdump Tutorial with Examples](https://danielmiessler.com/blog/tcpdump)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![f](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/9ba5ca1d-95a9-487c-833c-c91fb8cdfc49/ip-header-2021-1024x505.png)

tcpdump is the world's premier network analysis tool—combining both power and simplicity into a single command-line interface. This guide will show you how to use it.

tcpdump is a powerful command-line packet analyzer. It allows you to capture and inspect network traffic in real-time. This tool is invaluable for network administrators, security professionals, and anyone who needs to understand network behavior.

In this tutorial, we'll explore 50 practical examples of using tcpdump. These examples will cover a wide range of use cases, from basic traffic capture to advanced filtering and analysis.

Basic Syntax ​
The basic syntax of tcpdump is:

```bash
tcpdump [options] [expression]
options: Modify the behavior of tcpdump, such as specifying the interface to capture on or the output format.
expression: Defines what kind of traffic to capture. This is where you specify hostnames, IP addresses, ports, protocols, and other criteria.
```

## Capturing Traffic on an Interface ​

To capture all traffic on a specific interface, use the -i flag followed by the interface name. For example, to capture traffic on the eth0 interface:

`tcpdump -i eth0`

To see a list of all available interfaces, use the command:

```bash
tcpdump -D
1.eno1 [Up, Running, Connected]
2.any (Pseudo-device that captures on all interfaces) [Up, Running]
3.lo [Up, Running, Loopback]
4.virbr0 [Up, Disconnected]
5.docker0 [Up, Disconnected]
6.bluetooth-monitor (Bluetooth Linux Monitor) [Wireless]
7.nflog (Linux netfilter log (NFLOG) interface) [none]
8.nfqueue (Linux netfilter queue (NFQUEUE) interface) [none]
9.dbus-system (D-Bus system bus) [none]
10.dbus-session (D-Bus session bus) [none]
```

## Capturing Traffic to/from a Specific Host ​

To capture traffic to or from a specific host, use the host keyword followed by the hostname or IP address:

```bash
tcpdump host 192.168.1.100
```

This will capture all traffic to and from the host with the IP address 192.168.1.100.

## Capturing Traffic on a Specific Port ​

To capture traffic on a specific port, use the port keyword followed by the port number:

```bash
tcpdump port 80
```

This will capture all traffic on port 80 (HTTP).

## Combining Filters ​

You can combine filters using and, or, and not operators. For example, to capture all traffic to or from host 192.168.1.100 on port 80, use:

```bash
tcpdump host 192.168.1.100 and port 80
```

To capture traffic from 192.168.1.100 on either port 80 or 443, use:

```bash
tcpdump src host 192.168.1.100 and \( port 80 or port 443 \)
```

## Advanced Filtering ​

### Filtering by Protocol ​

To filter by protocol, use the ip, tcp, udp, or other protocol keywords. For example, to capture only TCP traffic:

`tcpdump tcp`

To capture only UDP traffic:

`tcpdump udp`

## Filtering by Source or Destination ​

To filter by source or destination host or port, use the src or dst keywords:

```bash
tcpdump src host 192.168.1.100
```

This will capture all traffic from the host 192.168.1.100.

```bash
tcpdump dst port 443
```

This will capture all traffic destined for port 443.

## Filtering by Network ​

To capture traffic within a specific network, use the net keyword:

```bash
tcpdump net 192.168.1.0/24
```

This will capture all traffic within the 192.168.1.0/24 network.

## Saving Captured Traffic to a File ​

To save captured traffic to a file, use the -w flag followed by the filename:

```bash
tcpdump -w capture.pcap -i eth0
```

This will save all captured traffic on the eth0 interface to the file capture.pcap.

You can later analyze this file using tcpdump or another packet analyzer like Wireshark.

## Reading Captured Traffic from a File ​

To read captured traffic from a file, use the -r flag followed by the filename:

```bash
tcpdump -r capture.pcap
```

This will read and display the traffic from the file capture.pcap.

## Verbosity ​

You can control the verbosity of tcpdump output using the -v, -vv, or -vvv flags.

-v: Verbose output.
-vv: More verbose output.
-vvv: Most verbose output.

For example:

```bash
tcpdump -vv -i eth0
```

##

<!-- tcpdump -i eth0 -n 'dst host <server_ip> and src host <your_ip> and tcp and src port <server_port> and dst port <your_port>' -->

tcpdump -n 'dst host 10.188.50.254'
tcpdump -n 'src host 10.188.40.252'

tcpdump -n 'src host 10.188.40.252 and dst host 10.188.50.254'

tcpdump -n 'dst host 10.181.197.249'
