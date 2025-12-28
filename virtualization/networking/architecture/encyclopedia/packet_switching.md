# **[Packet Switching](https://networkencyclopedia.com/packet-switching/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![ps](https://networkencyclopedia.com/wp-content/uploads/2019/10/packet-switching.png)

A packet-switched network is a computer network that breaks data into packets and sends them through switches to their destination. This method of data transmission is also known as connectionless networking.

## How it works

- Data is broken into packets, each containing a header and payload
- Packets are sent through a series of switches, or nodes, using a store-and-forward process
- The switches route the packets to their destination
- The data files are reassembled at the destination

## Benefits

- Packet switching is efficient and allows multiple users to share the network
- It makes communication digital, which can reduce errors

## Characteristics

- Packet-switched networks are characterized by variable delay, loss, and the possibility of packets arriving out of order
- They are commonly used for the internet and local area networks (LANs)
- They typically use the Transmission Control Protocol/Internet Protocol (TCP/IP) protocol suite or the Open Systems Interconnection (OSI) layer

## **[What is Packet Switching?](https://networkencyclopedia.com/packet-switching/)**

Packet Switching is the process by which a networking or telecommunications device accepts a packet and switches it to a telecommunications device that will take it closer to its destination. This process allows data to be sent over the telecommunications network in short bursts or “packets” that contain sequence numbers so that they can be reassembled at the destination.

## Packet Switching

Wide area network (WAN) devices called switches route packets from one point on a packet-switched network to another. Data within the same communication session might be routed over several different paths, depending on factors such as traffic congestion and switch availability.

Packet switching is the transmission method used for most computer networks because the data transported by these networks is fundamentally bursty in character and can tolerate latency (due to lost or dropped packets). In other words, the transmission bandwidth needed varies greatly in time, from relatively low traffic because of background services such as name resolution services, to periods of high bandwidth usage during activities such as file transfer. This contrasts with voice or video communication, in which a steady stream of information must be transmitted in order to maintain transmission quality and in which latency must remain minimized to preserve intelligibility.

The Internet is a prime example of a packet-switched network based on the **[TCP/IP protocol suite](https://networkencyclopedia.com/tcp-ip/)**. A series of routers located at various points on the Internet’s backbone forward each packet received on the basis of destination address until the packet reaches its ultimate destination. TCP/IP is considered a connectionless packet-switching service because **[Transmission Control Protocol (TCP)](https://networkencyclopedia.com/transmission-control-protocol-tcp/)** connections are not kept open after data transmission is complete.

X.25 public data networks are another form of packet-switching service, in which packets (or more properly, frames) formatted with the **[High-level Data Link Control (HDLC) protocol](https://networkencyclopedia.com/high-level-data-link-control-hdlc/)** are routed between different X.25 end stations using packet switches maintained by **[X.25](https://networkencyclopedia.com/x-25/)** service providers. Unlike TCP/IP, X.25 is considered a connection-oriented packet-switching protocol because it is possible to establish **[permanent virtual circuits (PVCs)](https://networkencyclopedia.com/permanent-virtual-circuit-pvc/)** that keep the logical connection open even when no data is being sent. However, X.25 can be configured for connectionless communication by using **[switched virtual circuits (SVCs)](https://networkencyclopedia.com/switched-virtual-circuit-svc/)**. An X.25 packet-switched network typically has a higher and more predictable latency (about 0.6 seconds between end stations) than a TCP/IP internetwork. This is primarily because X.25 packet switches use a store-and-forward mechanism to buffer data for transmission bursts, which introduces additional latency in communication. In addition, X.25 uses error checking between each node on the transmission path, while TCP/IP uses only end-to-end error checking.

Frame relay (also called fast packet switching) is another connection-oriented packet-switching service that gives better performance than X.25. It does this by switching packets immediately instead of using the store-and-forward mechanism of X.25 networks. Frame relay also eliminates flow control and error checking to speed up transmission. This is possible because frame relay networks use modern digital telephone lines, which are intrinsically much more reliable than the older analog phone lines on which much of the X.25 public network still depends. Frame relay supports only connection-oriented PVCs for its underlying switching architecture.

Finally, **[Asynchronous Transfer Mode (ATM)](https://networkencyclopedia.com/asynchronous-transfer-mode-atm/)** is another packet-switching service in which small fixed-length packets called cells are switched between points on a network.

## Difference between Packet Switching and Circuit Switching

Packet switching is different from circuit switching, in which switches are configured in a fixed state for the duration of the session so that the route the data takes is fixed. A network that is circuit-switched requires a dedicated switched communication path for each communication even if its full bandwidth is not being used. In packet switching, bandwidth can be used when available for more efficient transmission. Circuit switching is generally used in telephone systems, while packet switching is used for computer networks. Digital cellular phone services are generally also circuit-switched, but Personal Communications Services (PCS) cellular systems are gradually being migrated to packet-switched networks for greater efficiency in data transmission.
