# **[tracepath](https://www.geeksforgeeks.org/linux-unix/tracepath-command-in-linux-with-examples/)**

The tracepath command is a network diagnostic tool used to trace the path packets take to a destination host, similar to traceroute. It also automatically discovers the Maximum Transmission Unit (MTU) along that path. Unlike traceroute, tracepath typically does not require root privileges and uses UDP probes with incrementing TTL values to determine the route.
Here's a more detailed explanation:
Key Features:
Path Discovery:
tracepath sends out a series of packets with increasing TTL (Time to Live) values, allowing it to identify each hop (router) along the path to the destination.
**MTU Discovery:** It also determines the largest packet size (MTU) that can be transmitted at each hop without being fragmented, which is crucial for network performance.
UDP Probes:

The "best" MTU (Maximum Transmission Unit) size depends on the network environment. For standard Ethernet, the default is usually 1500 bytes. However, if you're using a VPN, you might need to lower it to around 1400 bytes to accommodate overhead. Jumbo frames, often used in data centers, can go up to 9000 bytes.

tracepath primarily uses UDP packets with incrementing destination port numbers (e.g., 33434, 33435, etc.) to probe the path.
No Root Privileges (Usually):
Unlike some traceroute implementations, tracepath usually doesn't require root privileges, as it doesn't need to manipulate raw network packets directly.
Simpler Output:
The output of tracepath is generally more straightforward than traceroute, focusing on hop-by-hop information and MTU values.
How it works:
The command sends a UDP packet with a low TTL (e.g., 1).
The first router along the path receives the packet and, because the TTL is expired, sends back an ICMP "time exceeded" error message.
tracepath records the IP address of that router and the round-trip time (RTT) for the packet.
It then increases the TTL and repeats the process, continuing until the destination is reached or a maximum hop limit is reached.
At each hop, tracepath also attempts to discover the MTU by sending packets with different sizes and observing whether they are fragmented.
Example Usage:
Code

tracepath google.com
This command will trace the path to google.com and display the hop-by-hop information and MTU values.
Key Differences from Traceroute:
Root Privileges:
Traceroute often requires root privileges, especially when using ICMP or TCP probes, while tracepath generally does not.
Probing Protocols:
traceroute can use ICMP, TCP, or UDP, while tracepath primarily uses UDP with incrementing port numbers.
MTU Discovery:
tracepath is designed for MTU discovery, while traceroute may not always include this functionality.
Output Complexity:
tracepath generally provides a simpler output focused on the path and MTU, while traceroute can offer more detailed information.
