# **[What is GRE?](https://www.cloudflare.com/learning/network-layer/what-is-gre-tunneling/)**

Generic Routing Encapsulation, or GRE, is a protocol for encapsulating data packets that use one routing protocol inside the packets of another protocol. "Encapsulating" means wrapping one data packet within another data packet, like putting a box inside another box. GRE is one way to set up a direct point-to-point connection across a network, for the purpose of simplifying connections between separate networks. It works with a variety of network layer protocols.

![i1](https://www.cloudflare.com/resources/images/slt3lc6tev37/5fGvytPGVkGJIcTVlrYeTN/b5cb26482aaa089fef405b7df0578cdb/encapsulated_packet.png)

GRE enables the usage of protocols that are not normally supported by a network, because the packets are wrapped within other packets that do use supported protocols. To understand how this works, think about the difference between a car and a ferry. A car travels over roads on land, while a ferry travels over water. A car cannot normally travel on water — however, a car can be loaded onto a ferry in order to do so.

In this analogy, the type of terrain is like the network that supports certain routing protocols, and the vehicles are like data packets. GRE is a way to load one type of packet within another type of packet so that the first packet can cross a network it could not normally cross, just as one type of vehicle (the car) is loaded onto another type of vehicle (the ferry) to cross terrain that it otherwise could not.

For instance, suppose a company needs to set up a connection between the local area networks (LANs) in their two different offices. Both LANs use the latest version of the Internet Protocol, IPv6. But in order to get from one office network to another, traffic must pass through a network managed by a third party — which is somewhat outdated and only supports the older IPv4 protocol.

With GRE, the company could send traffic through this network by encapsulating IPv6 packets within IPv4 packets. Referring back to the analogy, the IPv6 packets are the car, the IPv4 packets are the ferry, and the third-party network is the water.

What does GRE tunneling mean?
Encapsulating packets within other packets is called "tunneling." GRE tunnels are usually configured between two routers, with each router acting like one end of the tunnel. The routers are set up to send and receive GRE packets directly to each other. Any routers in between those two routers will not open the encapsulated packets; they only reference the headers surrounding the encapsulated packets in order to forward them.

To understand why this is called "tunneling," we can change the analogy slightly. If a car needs to pass from Point A on one side of a mountain to Point B on the other side, the most efficient way is to simply go through the mountain. However, ordinary cars are not capable of going straight through solid rock. As a result, the car has to drive all the way around the mountain to get from Point A to Point B.

But imagine that a tunnel was created through the mountain. Now, the car can drive straight from Point A to Point B, which is much faster, and which it could not do without the tunnel.

Now, think of Point A as a networked device, Point B as another networked device, the mountain as the network in between the two devices, and the car as the data packets that need to go from Point A to Point B. Imagine this network does not support the kind of data packets that the devices at Points A and B need to exchange. Like a car trying to go through a mountain, the data packets cannot pass through and may need to take a much longer way around via additional networks.

But GRE creates a virtual "tunnel" through the "mountain" network in order to allow the data packets to pass through. Just as a tunnel creates a way for cars to go straight through land, GRE (and other tunneling protocols) creates a way for data packets to go through a network that does not support them.

## What goes in a GRE header?

All data sent over a network is broken up into smaller pieces called packets, and all packets have two parts: the payload and the header. The payload is the packet’s actual contents, the data being sent. The header has information about where the packet comes from and what group of packets it belongs to. Each network protocol attaches a header to each packet.

GRE adds two headers to each packet: the GRE header, which is 4 bytes long, and an IP header, which is 20 bytes long. The GRE header indicates the protocol type used by the encapsulated packet. The IP header encapsulates the original packet's header and payload. This means that a GRE packet usually has two IP headers: one for the original packet, and one added by the GRE protocol. Only the routers at each end of the GRE tunnel will reference the original, non-GRE IP header.

How does the use of GRE impact MTU and MSS requirements?
MTU and MSS are measurements that limit how large data packets traveling over a network can be, just like a weight limit for automobiles crossing a bridge. MTU measures the total size of a packet, including headers; MSS measures the payload only. Packets that exceed MTU are fragmented, or broken up into smaller pieces, so that they can fit through the network.

Like any protocol, using GRE adds a few bytes to the size of data packets. This must be factored into the MSS and MTU settings for packets. If the MTU is 1,500 bytes and the MSS is 1,460 bytes (to account for the size of the necessary IP and **[TCP headers](https://www.cloudflare.com/learning/ddos/glossary/tcp-ip/)**), the addition of GRE 24-byte headers will cause the packets to exceed the MTU:

1,460 bytes [payload] + 20 bytes [TCP header] + 20 bytes [IP header] + 24 bytes [GRE header + IP header] = 1,524 bytes

As a result, the packets will be fragmented. Fragmentation slows down packet delivery times and increases how much compute power is used, because packets that exceed the MTU must be broken down and then reassembled.

This can be avoided by reducing the MSS to accommodate the GRE headers. If the MSS is set to 1,436 instead of 1,460, the GRE headers will be accounted for and the packets will not exceed the MTU of 1,500:

1,436 bytes [payload] + 20 bytes [TCP header] + 20 bytes [IP header] + 24 bytes [GRE header + IP header] = 1,500 bytes

While fragmentation is avoided, the result is that payloads are slightly smaller, meaning it will take extra packets to deliver data. For instance, if the goal is to deliver 150,000 bytes of content (or about 150 kB), and if the MTU is set to 1,500 and no other layer 3 protocols are used, compare how many packets are necessary when GRE is used versus when it is not used:

- Without GRE, MSS 1,460: 103 packets
- With GRE, MSS 1,436: 105 packets

The extra two packets add milliseconds of delay to the data transfer. However, the usage of GRE may allow these packets to take faster network paths than they could otherwise take, which can make up for the lost time.

## How is GRE used in DDoS attacks?

In a **[distributed denial-of-service](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-attack/)** (DDoS) attack, an attacker attempts to overwhelm a targeted server or network with junk network traffic — somewhat like bombarding a restaurant with fake delivery orders until it cannot provide service to legitimate customers.

GRE can be used to carry out DDoS attacks, just like any networking protocol. One of the largest DDoS attacks on record occurred in September 2016. It was directed against a security researcher's website and was carried out using the Mirai botnet. The website was overwhelmed with packets that used the GRE protocol.

Unlike some other protocols, the source for GRE packets cannot be faked or spoofed. (See our articles on SYN floods and DNS amplification attacks for examples of protocols for which this is not the case.) To carry out a large GRE DDoS attack, the attacker must control a large amount of real computing devices in a **[botnet](https://www.cloudflare.com/learning/ddos/what-is-a-ddos-botnet/)**.

## How does Cloudflare protect against GRE DDoS attacks?

Cloudflare protects against network layer DDoS attacks of all kinds, including attacks using GRE. Cloudflare Magic Transit protects on-premise, cloud, and hybrid networks by extending the Cloudflare global network's DDoS mitigation capabilities to network infrastructure. Any attack network traffic is filtered out without slowing down legitimate traffic.

## How does Cloudflare use GRE tunneling?

In order for Magic Transit to protect and accelerate customers' network traffic, the Cloudflare network has to be securely connected to customers' internal networks. For this purpose, GRE tunneling is extremely useful. Via GRE tunneling, Magic Transit is able to connect directly to Cloudflare customers' networks securely over the public Internet.

Magic Transit is built on the Cloudflare Anycast network. This means that any Cloudflare server can serve as the endpoint for a GRE tunnel using a single IP address, eliminating single points of failure for GRE tunnel connections (Cloudflare also uses this approach to connect Magic WAN customers). To learn more about how Magic Transit works, see our Magic Transit product page.
