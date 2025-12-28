# **[](https://www.catchpoint.com/network-admin-guide/ip-multicast)**

Introduction
There are three different methods to deliver IP packets:

- **Unicast:** The packet is sent to a single destination (one to one)
- **Broadcast:** The packet is sent to an entire network (one to all)
- **Multicast:** The packet is sent to a set (group) of hosts that can be on different networks (one to many)

As a side note, there is also the idea of many-to-many communication, where there are multiple sources for the same destination or where a source is also a destination. This type of communication is present in videoconferencing or online gaming applications.

With multicast, only the destinations that explicitly indicated that they want to receive the multicast traffic receive the messages sent. The routing devices' job is to sit between the sources and receivers to determine the correct logical network topology for routing from the unicast and multicast points of view so they can correctly route the traffic.

For example, if you have a video server acting as a multicast source that is broadcasting a live video feed, that stream of traffic can be sent only once by the server in a single stream of packets to a particular multicast address.  The multicast routers in turn will forward those multicast packets to all of the multicast receivers that are registered to that multicast address.

Multicast routing devices replicate the multicast packets from the incoming interface and send copies of them on the outgoing interfaces.

The routing devices must prevent routing loops. It is essential to keep the flow of unwanted traffic at a minimum—a host that does not want to receive multicast traffic should receive zero (or close to zero) multicast messages.

IP Multicast Basics
IP Multicast has its own set of acronyms and terms that apply to routing devices and networks.

IP Multicast has at its core the concept of a group. A multicast group is a set of receivers interested in receiving a particular set of data traffic. The hosts interested in receiving the data flow must join the group using the Internet Group Management Protocol (IGMP).

At a high level, the purpose of the routing device in the IP multicast network is to build a distribution tree that connects receivers to sources. The distribution tree has the source as its root.

From the routing device point of view, the interface leading to the source is the upstream interface. The interface leading to the receivers is the downstream interface (a routing device can have multiple downstream interfaces).

The upstream interface is often called the incoming interface. The downstream interface is called the outgoing interface; as a matter of fact, most vendors use the terms “incoming” and “outgoing” in their CLI outputs.

Multicast uses the Class D IP address range (224.0.0.0 to 239.255.255.255). The source IP address of a multicast packet will always be a unicast IP address, and the destination IP address will be a multicast address.
