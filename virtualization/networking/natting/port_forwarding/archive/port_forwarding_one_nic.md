# **[Linux Port Forwarding with iptables](https://contabo.com/blog/linux-port-forwarding-with-iptables/)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

In networking, a **packet** is the basic unit of data transmitted over a network, typically at the network layer (Layer 3 of the OSI model). A **frame**, on the other hand, encapsulates a packet and other information for transmission across a specific network technology at the data link layer (Layer 2 of the OSI model). Think of **it like putting a letter (the packet) into an envelope (the frame)** for mailing.

![iptfc1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*OIoNQkH4RTSm-eY2lUMBcQ.jpeg)**

| Tables↓/Chains→               | PREROUTING | INPUT | FORWARD | OUTPUT | POSTROUTING |
|-------------------------------|------------|-------|---------|--------|-------------|
| (routing decision)            |            |       |         | ✓      |             |
| raw                           | ✓          |       |         | ✓      |             |
| (connection tracking enabled) | ✓          |       |         | ✓      |             |
| mangle                        | ✓          | ✓     | ✓       | ✓      | ✓           |
| nat (DNAT)                    | ✓          |       |         | ✓      |             |
| (routing decision)            | ✓          |       |         | ✓      |             |
| filter                        |            | ✓     | ✓       | ✓      |             |
| security                      |            | ✓     | ✓       | ✓      |             |
| nat (SNAT)                    |            | ✓     |         |        | ✓           |

- Incoming packets destined for the local system: PREROUTING -> INPUT
- Incoming packets destined to another host: PREROUTING -> FORWARD -> POSTROUTING
- Locally generated packets: OUTPUT -> POSTROUTING

![ipt](https://stuffphilwrites.com/wp-content/uploads/2024/05/FW-IDS-iptables-Flowchart-v2024-05-22-768x978.png)**

## **[Architecture](https://www.digitalocean.com/community/tutorials/a-deep-dive-into-iptables-and-netfilter-architecture)**

Port forwarding is a network operation that directs traffic to a specific address and port number from one network node to another. Typically used in packet-filtering frameworks like iptables on Linux systems, port forwarding allows external devices to access services on private networks. It is a pivotal technique for system administrators who manage network security and accessibility, especially in environments where specific services need to be exposed securely.

iptables, a robust user-space utility program, enables the configuration of the Linux kernel’s IPv4 and IPv6 packet filtering rules. Though iptables might seem daunting at first due to its comprehensive command set and options, understanding its basics is key to leveraging its powerful capabilities. By mastering iptables, administrators can redirect, forward, and manage network traffic efficiently, ensuring that services are both accessible and secure. This introduction sets the stage for a deeper exploration of iptables and the intricate process of port forwarding.

## Understanding iptables Basics

iptables serves as the backbone for network traffic control in Linux environments, offering a flexible framework for managing network packet filtering and NAT. One use case of iptables on Linux could be port forwarding This functionality is critical for administrators aiming to secure their networks and control traffic flow. This section is about the basics of iptables, including its syntax, usage, chains, rules, and the role of NAT.

## iptables Syntax and Usage

The syntax of iptables revolves around rules that determine how to treat packets. Users can add, modify, or delete these rules, organizing them into chains. A basic iptables command structure looks like this:

`iptables [-t table] command [match] [target/jump]`

The -t option specifies the table (e.g., filter, nat), which is not needed for default filter table rules. The command can add (-A), delete (-D), or list (-L) rules among other actions. Match criteria specify which packets the rule applies to, and target/jump defines what to do with matched packets.

## Explanation of iptables Chains and Rules

Iptables categorizes rules into predefined chains (INPUT, OUTPUT, and FORWARD) that correspond to the packet’s lifecycle: as it enters, leaves, or gets forwarded through the system. Administrators can append custom chains for more granular control. Rules within these chains can filter packets by source and destination IP, port numbers, protocol type, and more.
The decision (e.g., ACCEPT, DROP, REJECT) made on a packet depends on matching it against these rules sequentially.

## Overview of NAT (Network Address Translation) in iptables

NAT plays an important role in how iptables manipulates the packet’s source or destination addresses, allowing for scenarios like masquerading a whole network behind a single IP address or redirecting traffic from one IP/port to another. The nat table within iptables specifically serves this purpose, with chains like PREROUTING, POSTROUTING, and OUTPUT handling different stages of packet processing. NAT is essential for port forwarding, as it enables the redirection of incoming traffic to the intended internal service.

## Setting Up Port Forwarding Using iptables

To forward a port, you must understand and manipulate the PREROUTING chain of the nat table. Here is a straightforward example to forward traffic from port 80 on your public IP to port 8080 on a local machine with IP 192.168.1.2:

```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j DNAT --to-destination 192.168.1.2:8080
```

Next, ensure the iptables FORWARD chain allows the forwarded traffic:

```bash
sudo iptables -A FORWARD -p tcp -d 192.168.1.2 --dport 8080 -j ACCEPT
```

Finally, apply a masquerade rule to allow proper routing of the responses:

```bash
sudo iptables -t nat -A POSTROUTING -j MASQUERADE
```

## iptables PREROUTING Chain Explained

The PREROUTING chain is responsible for decisions about incoming packets before they hit any network interface. In the context of port forwarding, we utilize this chain to redirect the packet to a new destination, effectively forwarding the port before delivering the packet to its original destination address.

## How to Forward Specific Ports to Internal IP Addresses

For example, to forward SSH traffic (port 22) to a server at 192.168.1.3, the command would look like this:

```bash
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j DNAT --to-destination 192.168.1.3:22
```

This command reroutes all incoming SSH connections to the specified internal IP address, seamlessly integrating external access with internal resources.

Configuring port forwarding with iptables enables administrators to enhance their network’s functionality and security. Understanding and applying the concepts of the PREROUTING chain and DNAT allows for precise control over how traffic is directed within your network, ensuring services are accessible yet secure.
