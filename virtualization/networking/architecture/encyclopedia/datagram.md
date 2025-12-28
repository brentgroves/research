# **[Datagram: The Key to Efficient Network Communication](https://www.zenarmor.com/docs/network-basics/what-is-datagram)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

A datagram is an enclosed, complete communication that is sent through a network, and its arrival, timing, and content are not assured. Datagrams are essential for efficient network communication. They contribute to low latency and real-time data delivery because they are the fundamental units of data transmission. Datagram networks, such as those that use the User Datagram Protocol (UDP), enable connectionless communication by transmitting data in individual datagrams. Datagrams are the fundamental units of information transfer in modern computer networks. They are indispensable for many uses because of their low latency, support for real-time data delivery, and ability to be individually routed. In this article, we will delve into the role datagrams play in networking conversations and how they improve information flow.

The article will discuss the following points under the corresponding headings;

- What is a datagram in networking?
- What are the different types of datagrams?
- What are the differences between datagrams and other packet types?
- How does a datagram work?
- What are the characteristics of a datagram?
- How are Datagrams Fragmented and Reassembled?
- How are Error Handling and Retransmission Managed with Datagrams?
- Which Protocols Use Datagrams?
- How does a TCP datagram compare to a UDP datagram in terms of reliability and ordering?
- What are the Use Cases and Applications of Datagrams?
- What are the advantages and disadvantages of using datagrams compared to other packet types?
- What Security Considerations are Relevant to Datagrams?
- What is the Trade-off between Reliability and Efficiency with Datagrams?
- What is the history of datagrams?

## What is a Datagram in Networking?

A datagram is an enclosed, complete communication that is sent through a network, and its arrival, timing, and content are not assured. It is a unit of data transfer primarily used for wireless communication. Datagram networks, such as those using the User Datagram Protocol (UDP), allow for connectionless communication where data is transmitted via individual datagrams. Each datagram has a header that typically contains the IP addresses of the sender and the recipient, as well as payload sections that store the actual message. Datagram networks are connectionless, meaning there is no pre-established connection between the sender and receiver, and each packet is transmitted independently and treated as a separate entity. Datagrams are the basic units of data transmission in network communication. They allow for individual routing, low latency, and real-time data delivery, which makes them essential for many applications that need fast and reliable data transmission. However, the delivery service offered by datagram networks is unstable, so packets may be misplaced, duplicated, or transmitted out of order.

A datagram isn't a frame. It is a message that is sent over a network by itself. While a frame is a unit of data transmission at the data link layer of the OSI model, a datagram is a packet. It is a self-contained message sent over a network that includes both header information and payload sections as stated above.

## What are the Different Types of Datagrams?

Datagrams are groups of data that are sent through a network separately. Datagram packet switches come in three main types including "store and forward", "fragment free", and "cut through". Here is some details about these main datagram types:

- **Store and forward:** This type of switch, buffers data until the entire packet is received and checked for errors. This prevents corrupted packets from propagating throughout the network but increases switching delays.
- **Fragment-free:** A fragment-free switch removes the majority of error packets, although it does not always stop errors from propagating throughout the network. Compared to store-and-forward mode, it offers quicker switching times and shorter waits.
- **Cut through:** A cut-through switch switches packets at the fastest throughput with the least amount of forwarding time. It does not filter mistakes.

There are two types of datagram protocols: User Datagram Protocol (UDP) and Transmission Control Protocol (TCP). UDP is a datagram protocol that doesn't require a connection and is used for programs that don't need to make sure the message gets to its destination. TCP is a connection-based datagram protocol that is used for applications that need to be sure that data will arrive at its destination.

Depending on the level of reliability and performance needed, different types of datagrams are used for different tasks. For example, UDP is often used for streaming media and file transfers, while TCP is often used for browsing the web and sending email.

## What are the Differences Between Datagrams and Other Packet Types?

Formatted data units known as network packets are transported by packet-switched networks. They consist of control information and user data, with the latter referred to as the payload. Details like both destination and source network addresses, error codes, and sequencing info are all part of the control data. Different types of network packets exist, each serving specific purposes and protocols. Here are some key points about network packet types:

| Packet Type      | Description                                                                                                                                                                                                                          | Advantages                                                                                                                                                           | Disadvantages                                                                                                    |
|------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------|
| IP Packets       | IP packets are fundamental units of data in packet-switched networks. They carry data across the internet and contain control information such as source and destination addresses.                                                  | -Used for transmitting data between machines. -Can be further categorized into different types, including UDP, RAW, and TCP.                                         | - UDP provides an unreliable messaging system. - RAW is similar to UDP. - TCP is a reliable transmission system. |
| Datagram Packets | Datagram packets are a type of packet used in datagram packet switching networks. They are self-contained units of data that do not require a dedicated physical path for transmission.                                              | - Offer flexibility and dynamic decision-making for data transmission. - Self-contained messages that do not require the recipient to try and retrieve dropped data. | - Provide an unreliable delivery service. -Potential network congestion.                                         |
| TCP Segments     | TCP segments are carried within IP packets. TCP segments provide reliable transmission by incorporating features like delivery acknowledgments and retransmission of lost or corrupted data.                                         | - Ensure ordered and error-free delivery of data.- Require the overhead of connection setup and teardown.                                                            | - Require delivery acknowledgments and retransmission mechanisms.                                                |
| Frame Packets    | At the data link layer of the OSI model, packets are referred to as frames. Frames contain control information and user data, similar to network packets. They are responsible for transmitting data between adjacent network nodes. | -Liable for data transmission between adjacent network nodes.                                                                                                        | - Limited to transmitting data between adjacent network nodes.                                                   |
