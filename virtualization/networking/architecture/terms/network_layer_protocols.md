# **[Network Layer Protocol](https://www.geeksforgeeks.org/network-layer-protocols/)**

There are various protocols used in the network layer. Each protocol is used for a different task. Below are the protocols used in the network layer:

![](https://media.geeksforgeeks.org/wp-content/uploads/20230906205101/IMG-20230906-WA0005.jpg)

## 4. ICMP

ICMP stands for Internet Control Message Protocol. ICMP is a part of IP protocol suite. ICMP is an error reporting and network diagnostic protocol. Feedback in the network is reported to the designated host. Meanwhile, if any kind of error occur it is then reported to ICMP. ICMP protocol consists of many error reporting and diagnostic messages. ICMP protocol handles various kinds of errors such as time exceeded, redirection, source quench, destination unreachable, parameter problems etc. The messages in ICMP are divided into two types. They are given below:

- Error Message: Error message states about the issues or problems that are faced by the host or routers during processing of IP packet.
- Query Message: Query messages are used by the host in order to get information from a router or another host.

## 5. IGMP

IGMP stands for Internet Group Message Protocol. IGMP is a multicasting communication protocol. It utilizes the resources efficiently while broadcasting the messages and data packets. IGMP is also a protocol used by TCP/IP. Other hosts connected in the network and routers makes use of IGMP for multicasting communication that have IP networks. In many networks multicast routers are used in order to transmit the messages to all the nodes. Multicast routers therefore receives large number of packets that needs to be sent. But to broadcast this packets is difficult as it would increase the overall network load. Therefore IGMP helps the multicast routers by addressing them while broadcasting. As multicast communication consists of more than one senders and receivers the Internet Group Message Protocol is majorly used in various applications such as streaming media, web conference tools, games, etc.

## How Does IGMP Work?

Devices that can support dynamic multicasting and multicast groups can use IGMP.
The host has the ability to join or exit the multicast group using these devices. It is also possible to add and remove customers from the group using these devices.
The host and local multicast router use this communication protocol. Upon creation of a multicast group, the packet’s destination IP address is changed to the multicast group address, which falls inside the class D IP address range.
