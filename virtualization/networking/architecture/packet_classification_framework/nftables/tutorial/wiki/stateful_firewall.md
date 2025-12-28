# **[stateful firewall](https://en.wikipedia.org/wiki/Stateful_firewall)**

In computing, a stateful firewall is a network-based firewall that individually tracks sessions of network connections traversing it. Stateful packet inspection, also referred to as dynamic packet filtering,[1] is a security feature often used in non-commercial and business networks.

A stateful firewall keeps track of the state of network connections, such as TCP streams, UDP datagrams, and ICMP messages, and can apply labels such as LISTEN, ESTABLISHED, or CLOSING.[2] State table entries are created for TCP streams or UDP datagrams that are allowed to communicate through the firewall in accordance with the configured security policy. Once in the table, all RELATED packets of a stored session are streamlined, taking fewer CPU cycles than standard inspection. Related packets are also permitted to return through the firewall even if no rule is configured to allow communications from that host. If no traffic is seen for a specified time (time-out implementation dependent), the connection is removed from the state table. This can lead to applications experiencing unexpected disconnects or half-open TCP connections. Applications can be written to send keepalive messages[3] periodically to prevent a firewall from dropping the connection during periods of no activity or for applications which by design have long periods of silence.

The method of maintaining a session's state depends on the transport protocol being used. TCP is a connection-oriented protocol[4] and sessions are established with a three-way handshake using SYN packets and ended by sending a FIN notification.[5] The firewall can use these unique connection identifiers to know when to remove a session from the state table without waiting for a timeout. UDP is a connectionless protocol,[4] which means it does not send unique connection-related identifiers while communicating. Because of that, a session will only be removed from the state table after the configured time-out. UDP hole punching is a technology that leverages this trait to allow for dynamically setting up data tunnels over the internet.[6] ICMP messages are distinct from TCP and UDP and communicate control information of the network itself. A well-known example of this is the ping utility.[7] ICMP responses will be allowed back through the firewall. In some scenarios, UDP communication can use ICMP to provide information about the state of the session so ICMP responses related to a UDP session will also be allowed back through.

## Stateful inspection firewall advantages

- Monitors the entire session for the state of the connection, while also checking IP addresses and payloads for more thorough security
- Offers a high degree of control over what content is let in or out of the network
- Does not need to open numerous ports to allow traffic in or out
- Delivers substantive logging capabilities

## Stateful inspection firewall disadvantages

- Resource-intensive and interferes with the speed of network communications
- More expensive than other firewall options
- Doesn't provide authentication capabilities to validate traffic sources are not spoofed
- Doesn't work with asymmetric routing (opposite directions use different paths)
- Can lead to unexpected disconnections or half-open connections if connections are idle for longer than the time-out
