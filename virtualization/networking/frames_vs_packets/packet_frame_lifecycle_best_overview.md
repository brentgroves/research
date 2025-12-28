# **[TCP/IP Five-Layer Software Model Overview](https://developerhelp.microchip.com/xwiki/bin/view/applications/tcp-ip/five-layer-model-and-apps/#:~:text=Network%20Layer%20(Layer%203),based%20on%20their%20IP%20addresses.)**

## does an ip packet contain the transport layer info

No, an IP packet does not directly contain the transport layer information; instead, the network layer (IP) adds its own header with source and destination IP addresses to the data received from the transport layer. The transport layer adds its own header with port numbers to the application data, creating a segment or datagram, and then passes this to the network layer, where the IP packet is formed.

## Here's the layering process

1. **Application Layer:** Creates data for an application (e.g., a web browser sending a request).

2. **Transport Layer:**

- Receives the application data.
- Adds a header containing source and destination port numbers and other information (like sequence numbers for TCP) to create a transport layer segment (e.g., a TCP segment).
- Passes this segment to the network layer.

3. Network Layer (IP Layer):

- Receives the transport layer segment.
- Adds its own header with source and destination IP addresses and other network-specific information to create an IP packet.
- Passes the IP packet to the Data Link layer for transmission.

## TCP/IP Five-Layer Software Model Overview

We need to provide this basic information needed by TCP/IP in a standard format the network can understand. This format is provided by its five-layer software model.

Each layer provides TCP/IP with the basic information it needs to move our data across the network. These layers group functions according to the task that needs to be performed. Every function in this model is targeted to help a specific layer perform its job.

Each layer only communicates with adjacent layers. Software running in a higher layer does not have to know about or perform tasks delegated to lower-layer functions and vice versa. For example, the software you write for your application only needs to know how to request a connection with a remote host using the Transport layer. It doesn’t need to know how bits are encoded before transmission. That’s the Physical layer’s job.

![i1](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/tcpip_5_layers.png?width=600&height=258&rev=1.1)

​You are probably familiar with the seven-layer OSI model. TCP/IP simplifies this model to five layers. OSI stands for Open Systems Interconnect, which is a standard communication systems model. The top four layers of the seven-layer OSI model have been condensed into the top two TCP/IP layers.

## TCP/IP Five-Layer Model

## Application Layer (Layer 5)

As you might have guessed, the Application layer is where applications requiring network communications live. Examples of these applications include email clients (SMTP) and web browsers (HTTP). These applications use the Transport Layer to send requests to connect to remote hosts.

![i2](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/application_layer.png?width=249&height=237&rev=1.1)

## Transport Layer (Layer 4)

Layer 4 is the Transport layer. The transport layer creates virtual Transfer Control Protocol (TCP) or User Datagram Protocol (UDP) connections between network hosts.

This layer sends and receives data (packets) to and from the applications running on its host. The Transport layer assigns port numbers to the processes running in applications on the host and adds a TCP or UDP header to the messages received from the applications detailing the source and destination port numbers.

Note that some of the applications, specifically Telnet, SMTP, and HTTP require TCP as the transport protocol while others use UDP.

![i3](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/transport_layer.png?width=249&height=237&rev=1.1)

Some applications require reliable ordered delivery of packets. The TCP protocol provides this capability. It uses error detection, retransmissions and acknowledgments. This protocol cares about your data.

Other applications don’t care if every packet is received. These applications can take advantage of UDP’s lower overhead to enable faster transmissions.

Typical TCP applications include email and web browsing and typical UDP applications include VoIP and music streaming.

TCP is strictly used for point-to-point or unicast transmissions while UDP can also be used for multicast and broadcast transmissions.

![i4](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/TCP_vs_UDP.jpg?width=422&height=260&rev=1.1)

## TCP and UDP Headers

The header added to messages by the Transport layer includes more than just the source and destination port numbers. Here we are showing all the information included in TCP and UDP headers.

Note how the TCP protocol requires more information and overhead to guarantee data delivery.

![i5](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/TCP_UDP_headers.jpg?width=600&height=336&rev=1.1)

## Network Layer (Layer 3)

Layer 3 is the Network or Internet layer.

When transmitting data (packets), this layer adds a header containing the source and destination IP addresses to the data received from the Transport layer. The packet it creates will then be forwarded to the MAC or Data Link layer.

When receiving data, this layer is used to determine if the packet received by the host contains the host’s IP address. If it does, the data is forwarded up to the Transport layer.

![i6](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/network_layer.png?width=249&height=238&rev=1.1)

​Routers are referred to as “layer 3” devices because they route packets based on their IP addresses.

## TCP/IP IPv4 Packet Header

The Network layer header includes more than just the source and destination IP addresses.

![i7](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/IPv4_header.jpg?width=600&height=211&rev=1.1)

## Data Link Layer (Layer 2)

Layer 2 is the Data Link layer. This layer uses a Media Access Controller (MAC) to generate the frames that will be transmitted. As the name suggests, the MAC controls the physical transmission media. The wireless transmission media used for Wi-Fi® or 802.11 has different requirements from the wired transmission media used for Ethernet or 802.3, and therefore needs a different MAC and PHY. Note the upper layer software is not aware of or affected by the physical interface.

When transmitting data, this layer adds a header containing the source and destination MAC addresses to the packet received from the Network layer (layer 3). The frame it creates will then be forwarded to the Physical layer.

When receiving data, this layer is used to determine if the frame received by the host contains the host’s MAC address. If it does, the data is forwarded up to the Network layer.

Every host on the network has at least one MAC address. Laptops typically have two, one for the wired LAN and one for the wireless LAN. Home routers also typically have two MACs: one for the local network and one for the Internet.

![i8](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/data_link_layer.png?width=259&height=247&rev=1.1)

​Most switches are referred to as “layer 2” devices because they route frames based on their MAC addresses.

## Ethernet and Wi-Fi® Frame Format

As you probably guessed, the Data Link layer adds more than just the source and destination MAC addresses to the packet. Note that the MAC for Ethernet and Wi-Fi are different and generate different frames.

![i9](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/ethernet_wifi_frames.jpg?width=600&height=347&rev=1.1)

​For more information on Ethernet frames, visit the "Ethernet frame" page.
For more information on Wi-Fi frames, visit the "How 802.11 Wireless Works" page.

## Physical Layer (Layer 1)

Layer 1 is the Physical layer. It sends and receives signals on the physical wire or antenna to transmit the bits found in frames.

There is a PHY found at the end of every network interface (e.g., end of wire or antenna).

![i10](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/physical_layer.png?width=259&height=245&rev=1.1)

A "network PHY" refers to the physical layer component of a network, an electronic circuit or chip that handles the actual transmission and reception of signals over a physical medium like copper wire or fiber optic cable. It bridges the gap between the digital data link layer (MAC layer) and the physical connection, converting digital data into electrical signals for transmission and converting received signals back into digital data.  

## Transmit Data Using Network Layers

Now that we know the primary job of each layer, let’s see how they work together to send and receive data across a TCP/IP network.

This is a simplified view of how the network layers work together to generate frames. Higher layers pass information to lower layers. Each layer adds information called a header to the data being passed to it. This header contains information the layer needs to perform its job. We will start at the Application layer.

![i11](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/tcpip_5_layer_overview.png?width=600&height=354&rev=1.1)

## Data Flow (Transmitting Data)

To send and receive data across a TCP/IP network, data is passed to each lower layer, which will add to the data until the full packet is formed. This is a simplified view of how the network layers work together to generate frames. Higher layers pass information to lower layers. Each layer adds information called a header to the data being passed to it. This header contains information the layer needs to perform its job.

![i12](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/transmit_data.jpg?width=600&height=373&rev=1.1)

- Application Layer
The Application layer generates a message. In this case, the specific application is a web browser requesting a webpage download. This message is then sent to the Transport layer.
- Transport Layer
The Transport layer adds the TCP or UDP header which includes the source and destination port addresses. Additional information like the packet sequence number used for TCP will also be added to the header. The data generated by the transport layer is referred to as a Segment if TCP is used, and is referred to as a Datagram if UDP is used. This segment is then sent to the Network layer.
- Network Layer
The Network layer adds a header including the source and destination IP address to generate a packet. This packet is then sent to the Data Link layer.
- Data Link Layer
The Data Link layer adds a header containing the MAC address information to create a frame. The frame is then sent it to the Physical layer to transmit the bits.

## Data Flow (Receiving Data)

When receiving data, the network layers act as filters.

When the frame is received in the Data Link layer, the destination MAC address is compared with its own. If the data received is not intended for that host, it is immediately discarded. If it matches, the header is stripped and the payload, which in this case is a packet, is forwarded up to the next layer. Here, the Network layer checks if the destination IP address matches its own. If it matches, the header is stripped and the payload is forwarded up to the next layer. Here, the Transport layer checks to determine if there is a process running on the host with a destination port number of 80, which is the case. So, the header is stripped and the message is sent to process number 80 in the Application layer. Process number 80 is a function running in the HTTP server. This completes the message transmission process from one application to another.

![i14](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/data-flow-rx.png?width=600&height=365&rev=1.1)

Terminology Reference

![i15](https://developerhelp.microchip.com/xwiki/bin/download/applications/tcp-ip/five-layer-model-and-apps/WebHome/layer_terminology.jpg?width=600&height=227&rev=1.1)

... more
