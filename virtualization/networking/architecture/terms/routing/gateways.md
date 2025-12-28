# **[Gateways](https://www.geeksforgeeks.org/introduction-of-gateways/)**

## **[default gateways](https://en.wikipedia.org/wiki/Default_gateway)**

A gateway is a network node that serves as an access point to another network, often involving not only a change of addressing, but also a different networking technology. More narrowly defined, a router merely forwards packets between networks with different network prefixes. The networking software stack of each computer contains a routing table that specifies which interface is used for transmission and which router on the network is responsible for forwarding to a specific set of addresses. If none of these forwarding rules is appropriate for a given destination address, the default gateway is chosen as the router of last resort. The default gateway can be specified by the route command to configure the node's routing table and default route.

In a home or small office environment, the default gateway is a device, such as a DSL router or cable router, that connects the local network to the Internet. It serves as the default gateway for all network devices.

Enterprise network systems may require many internal network segments. A device wishing to communicate with a host on the public Internet, for example, forwards the packet to the default gateway for its network segment. This router also has a default route configured to a device on an adjacent network, one hop closer to the public network.

These below are the types of Gateway on the basis of functionality of Gateway:

- **Network Gateway:** The most popular kind of gateway, known as a network gateway acts as an interface between two disparate networks using distinct protocols. Anytime the word gateway is used without a type designation, it refers to a network gateway.
- **Cloud Storage Gateway:** A network node or server known as a cloud storage gateway translates storage requests made using various cloud storage service API calls, such as SOAP (Simple Object Access Protocol) or REST (Representational State Transfer). Data communication is made simpler since it makes it easier to integrate private cloud storage into applications without first moving those programmes to a public cloud.
- **Internet-To-Orbit Gateway (I2O):** Project HERMES and Global Educational Network for Satellite Operations (GENSO) are two well-known I2O gateways that connect devices on the Internet to satellites and spacecraft orbiting the earth.
- **IoT Gateway:** Before delivering sensor data to the cloud network, IoT gateways assimilate it from Internet of Things (IoT) devices in the field and translate between sensor protocols. They link user applications, cloud networks, and IoT devices.
- **VoIP Trunk Gateway:** By using a VoIP (voice over Internet Protocol) network, it makes data transmission between POTS (plain old telephone service) devices like landlines and fax machines easier.

## How Gateways Work?

- The gateway receives data from devices within the network.
- After receiving data the gateway intercept and analyze data packets, which include analyzing packet header, payload etc.
- Based on the analysis of the data packets, the gateway calculate an appropriate destination address of data packet. It then routes the data packets to their destination address.
- In some cases, the gateway might also want to transform the format of the obtained data to ensure compatibility at the receiver.
- Once the data packets have been analyzed, routed, and converted, then the gateway sends the last packets to their respective destinations address inside the network.

## What do you mean by Gateway in Networking?

In networking, a gateway is a device that allows communication between gadgets and specific networks.

A gateway serves as a bridge, translator, and transmitter of data traffic, ensuring that data flows easily from one network to another.

Suppose your home network and the Internet are two separate cities. Your gateway is the passport that allows you to go back and forth through these cities quickly.

## What Is a Gateway IP Address?

A gateway IP is a unique numerical label assigned to a device within a network, serving as a bridge to transmit traffic between the device and external networks, such as the Internet.

This IP address has a set of characteristics that distinguish your devices in the network.

## Network Checkpoint

A gateway IP connects the local network to external networks. It serves as a virtual checkpoint through which data packets enter or exit for communication to other devices on the Internet.

## Routing Hub

Gateway IP takes on the function of a routing hub inside the network. Data that traverses between the inner network and the Internet is directed through this IP address, which determines the most efficient route for transmission.

## Single Point of Contact

In many cases, a gateway IP address serves as the single point of contact for outside networks to access devices within the local network, effectively managing traffic and ensuring it reaches the appropriate destination.

## What are the Types of Gateway IP Addresses

There are two types of gateway IPs: Default and Specific device gateway. Let’s discover more about them in the below section:

## Default Gateways

A default gateway is a common and most essential in networking. It’s the gateway through which devices inside a local network communicate to external networks.

The primary function of the default gateway is to ensure all site traffic securely transmits to its destination.

## Specific Device Gateways

Specific gateways facilitate communication with private devices or servers inside a network.

Unlike the default gateway that charges for all outgoing traffic, specific device gateways are used for unique purposes.

For instance, you can access a devoted server, like a web server or an email server; these gateways route information from that server to specific devices in your network.
