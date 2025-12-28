# **[connection tracking](https://thermalcircle.de/doku.php?id=blog:linux:connection_tracking_3_state_and_examples)**

To put things into context let's do a short recap of what I already described in detail in the previous articles of this series: The ct system maintains all connections which it is tracking in a central table and each tracked connection is being represented by an instance of struct nf_conn. For each IPv4/IPv6 packet which is traversing the ct hook functions in the Netfilter hooks (the ones with priority -200; see Figure 1), the ct system determines to which tracked connection that packet belongs to and initializes a pointer within the skb data structure of the packet to point to the according instance of struct nf_conn. Thereby it marks/categorizes the packet, so other components like Iptables/Nftables can make decisions based on that. These concepts are often referred to as stateful packet filtering or stateful packet inspection. So far so good.

![](https://thermalcircle.de/lib/exe/fetch.php?w=700&tok=34ce47&media=linux:nf-ct-iptables-hooks-ipv4.png)

Figure 1: Conntrack+Defrag hook functions and Iptables chains registered with IPv4 Netfilter hooks
(click to enlarge)1)

As packets keep flowing, the ct system continuously analyzes each connection to determine its current state. It does that by analyzing OSI layers 3 and 4 (and in certain cases also higher layers) of each packet. This connection state maintained by the ct system is of course not the same as the actual state of a network protocol (like e.g. TCP) in the communication endpoints, as the ct system merely is an observer in the middle and has no access to endpoints or their internal states. However, this state probably is the most essential information produced by the ct system, because it provides the basis for components like Iptables/Nftables to make meaningful “stateful packet filtering” decisions. I guess most people reading this are familiar with the usual syntax of Iptables/Nftables for matching against the state of tracked connections:

![](https://www.imperva.com/learn/wp-content/uploads/sites/13/2020/02/OSI-7-layers.jpg.webp)

4. Transport Layer

The transport layer takes data transferred in the session layer and breaks it into “segments” on the transmitting end. It is responsible for reassembling the segments on the receiving end, turning it back into data that can be used by the session layer. The transport layer carries out flow control, sending data at a rate that matches the connection speed of the receiving device, and error control, checking if data was received incorrectly and if not, requesting it again.

3. Network Layer

The network layer has two main functions. One is breaking up segments into network packets, and reassembling the packets on the receiving end. The other is routing packets by discovering the best path across a physical network. The network layer uses network addresses (typically Internet Protocol addresses) to route packets to a destination node.

2. Data Link Layer

The data link layer establishes and terminates a connection between two physically-connected nodes on a network. It breaks up packets into frames and sends them from source to destination. This layer is composed of two parts—Logical Link Control (LLC), which identifies network protocols, performs error checking and synchronizes frames, and Media Access Control (MAC) which uses MAC addresses to connect devices and define permissions to transmit and receive data.

As packets keep flowing, the ct system continuously analyzes each connection to determine its current state. It does that by analyzing OSI layers 3 and 4 (and in certain cases also higher layers) of each packet. This connection state maintained by the ct system is of course not the same as the actual state of a network protocol (like e.g. TCP) in the communication endpoints, as the ct system merely is an observer in the middle and has no access to endpoints or their internal states. However, this state probably is the most essential information produced by the ct system, because it provides the basis for components like Iptables/Nftables to make meaningful “stateful packet filtering” decisions. I guess most people reading this are familiar with the usual syntax of Iptables/Nftables for matching against the state of tracked connections:

```bash
#Nftables example
ct state established,related
 
#Iptables example
-m conntrack --ctstate ESTABLISHED,RELATED
```

In this article I like to dive a little deeper into this topic, connecting the dots between the implementation – the variables holding the state information within the ct system – , how this implementation behaves, and how things look like from the point of view of Iptables/Nftables and from the command line tool conntrack. Figure 2 gives an overview of the implementation variables involved here. There actually are two variables holding state information, each with slightly different semantics. I'll explain them in detail.

![](https://thermalcircle.de/lib/exe/fetch.php?w=700&tok=0504e3&media=linux:nf-conn-nfct.png)

Figure 2: Network packet after traversing ct main hook function (priority -200), belonging to a tracked connection, status specifying internal connection status, ctinfo specifying connection state, direction of the packet relative to the connection and relation of the packet to the connection.

## Status variable

The variable status, depicted in Figure 2, is an integer member of struct nf_conn and its least significant 16 bits are being used as status and management bits for the tracked connection. Type enum ip_conntrack_status gives each of those bits a name and meaning. The table in Figure 3 below explains this meaning in detail. While some of those bits represent the current status of the tracked connection determined by the ct system based on analyzing observed network packets, others represent internal management settings. The latter bits specify and organize things which shall be done for a tracked connection in specific cases, like NAT, hardware offloading, user-defined timeouts, and so on. Iptables/Nftables: Some of those bits can be directly matched against by using conntrack expressions in Iptables/Nftables rules.

The table in Figure 3 shows the exact syntax to do that for the bits which can be matched. Of course, if your chain is located in the Netfilter Prerouting or Output hook and your rule(s) are using these kind of expressions, then your chain must have a priority > -200, to make sure it is traversed by the network packets AFTER the ct main hook function (see Figure 1). You will probably recognize that the syntax used for those expressions is not the familiar syntax which is used in most common cases when intending to write stateful packet filtering rules. I'll get to that in the next section. Conntrack: When you use userspace tool conntrack with option -L to list the currently tracked connections or doing a cat on the file /proc/net/nf_conntrack to achieve the same thing, then some of the status bits are shown in the resulting output. The table in Figure 3 explains which bits are shown and the syntax used for that.

bit 0: IPS_EXPECTED
Expected connection: When the first packet of a new connection is traversing the ct main hook function, a new tracked connection is created. If this new tracked connection is identified to be an expected connection, then this bit is being set. This can e.g. happen, if you are using the ct helper for the FTP protocol; see FTP extension. The expected connection then usually is an “FTP data” TCP connection, which is related to an already established “FTP command” TCP connection. If this bit is being set, ctinfo is being set to IP_CT_RELATED.

conntrack expressions matching this bit
Nftables ct status expected
Iptables -m conntrack --ctstatus EXPECTED

bit 1: IPS_SEEN_REPLY
Packets have been seen both ways (bit can be set, not unset): This bit is set once the very first packet in reply direction is seen by the ct system.

conntrack expressions matching this bit
Nftables ct status seen_reply
Iptables -m conntrack --ctstatus SEEN_REPLY
bit shown by conntrack command or proc file like this (negated!)
conntrack -L
cat /proc/net/nf_conntrack [UNREPLIED]

<https://thermalcircle.de/doku.php?id=blog:linux:connection_tracking_3_state_and_examples>

![](https://thermalcircle.de/lib/exe/fetch.php?media=linux:nf-ct-nfct-table-established.png)

The ct system sets this for a packet which belongs to an already tracked connection and which meets all of the following criteria:

- packet is not the first one seen for that connection
- packet is flowing in original direction (= same direction as first packet seen for that connection)
- packets have already been seen in both directions for this connection, prior to this packet

conntrack expressions matching this packet
Nftables ct state established
ct state established ct direction original

Iptables -m conntrack --ctstate ESTABLISHED
-m conntrack --ctstate ESTABLISHED --ctdir ORIGINAL

![](https://thermalcircle.de/lib/exe/fetch.php?media=linux:nf-ct-nfct-table-related.png)

The ct system sets this for a packet which is one of these two things:

- The packet is a valid ICMP error message (e.g. type=3 “destination unreachable”, code=0 “network unreachable”) which is related to an already tracked connection. Relative to that connection, it is flowing in original direction. Pointer *p points to that connection.

- The packet is the very first one of a new connection, but this connection is related to an already tracked connection or, in other words, it is an expected connection (see status bit IPS_EXPECTED in Figure 3 above). This e.g. occurs when you use the ct helper for the FTP protocol. This is a very complex topic, which would deserve its own blog article6). Important to note here is, that only the first packet belonging to an expected connection is marked with IP_CT_RELATED. All following packets of that connection are marked with IP_CT_ESTABLISHED or IP_CT_ESTABLISHED_REPLY as with any other tracked connection.

conntrack expressions matching this packet
Nftables ct state related
ct state related ct direction original
Iptables -m conntrack --ctstate RELATED
-m conntrack --ctstate RELATED --ctdir ORIGINAL

The syntax for specifying the chain type when adding a base chain in nftables is type <type>. The possible chain types are filter, route, or nat
