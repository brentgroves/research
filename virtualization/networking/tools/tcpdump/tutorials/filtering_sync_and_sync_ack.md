# tcpdump filter sync and sycn/ack

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

AI Overview

To filter for SYN packets, you can use tcp[tcpflags] & (tcp-syn) != 0. To filter for SYN-ACK packets, use tcp[tcpflags] & (tcp-syn|tcp-ack) == tcp-syn|tcp-ack. To capture both SYN and SYN-ACK packets, use tcp[tcpflags] & (tcp-syn|tcp-ack) != 0.

## Explanation

tcp[tcpflags]: This refers to the TCP flags field in the TCP header.
& (AND): This operator combines multiple conditions.
(tcp-syn): Represents the SYN flag.
(tcp-ack): Represents the ACK flag.
!= 0: This means that at least one of the flags is set.
== tcp-syn|tcp-ack: This matches packets where both SYN and ACK flags are set.
tcp[tcpflags] == tcp-syn or tcp[tcpflags] == tcp-ack: This captures packets where only SYN or ACK flags are set, not both.

## get requests

```bash
# Capture HTTP GET requests (IPv4): 
tcpdump -s 0 -A 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'
```

## Example

To capture only packets with SYN or ACK flags:
Code

`sudo tcpdump -i enp0s25 -nn "tcp[tcpflags] & (tcp-syn|tcp-ack) != 0"`

```bash

sudo tcpdump -nn "tcp[tcpflags] & (tcp-syn|tcp-ack) != 0"

sudo tcpdump "(tcp[tcpflags] & (tcp-syn|tcp-ack) != 0)"

sudo tcpdump "((ip src or dst host 172.24.188.57))"    # qualifiers stated explicitly

sudo tcpdump "((tcp[tcpflags] & (tcp-syn|tcp-ack) != 0))"

sudo tcpdump "((ip src or dst host 172.24.188.57) and (tcp[tcpflags] & (tcp-syn|tcp-ack) != 0))"     


To capture only packets with both SYN and ACK flags:
Code

tcpdump -i eth0 -nn \"tcp[tcpflags] & (tcp-syn|tcp-ack) == tcp-syn|tcp-ack\"
Important Notes:
Quoting the filter expression is crucial when using it in a shell command.
tcp[tcpflags] refers to the TCP flags, which are located at offset 13 in the TCP header, according to Gist.
