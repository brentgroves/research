# **[OpenFlow](https://en.wikipedia.org/wiki/OpenFlow#:~:text=OpenFlow%20enables%20network%20controllers%20to,be%20forwarded%20to%20the%20controller.)**

OpenFlow enables network controllers to determine the path of network packets across a network of switches. The controllers are distinct from the switches. This separation of the control from the forwarding allows for more sophisticated traffic management than is feasible using access control lists (ACLs) and routing protocols. Also, OpenFlow allows switches from different vendors — often each with their own proprietary interfaces and scripting languages — to be managed remotely using a single, open protocol. The protocol's inventors consider OpenFlow an enabler of software-defined networking (SDN).

OpenFlow allows remote administration of a layer 3 switch's packet forwarding tables, by adding, modifying and removing packet matching rules and actions. This way, routing decisions can be made periodically or ad hoc by the controller and translated into rules and actions with a configurable lifespan, which are then deployed to a switch's flow table, leaving the actual forwarding of matched packets to the switch at wire speed for the duration of those rules. Packets which are unmatched by the switch can be forwarded to the controller. The controller can then decide to modify existing flow table rules on one or more switches or to deploy new rules, to prevent a structural flow of traffic between switch and controller. It could even decide to forward the traffic itself, provided that it has told the switch to forward entire packets instead of just their header.

The OpenFlow protocol is layered on top of the Transmission Control Protocol (TCP) and prescribes the use of Transport Layer Security (TLS). Controllers should listen on TCP port 6653 for switches that want to set up a connection. Earlier versions of the OpenFlow protocol unofficially used port 6633.[2][3] Some network control plane implementations use the protocol to manage the network forwarding elements.[4] OpenFlow is mainly used between the switch and controller on a secure channel.[5]

The OpenFlow protocol is a key enabler of Software-Defined Networking (SDN), providing a standardized communication interface between the control and forwarding planes of network devices. In traditional network architectures, these planes are tightly integrated within the network devices themselves. However, OpenFlow abstracts and separates them, allowing for centralized control and programmability.

- **Control and Forwarding Planes Separation:** In a traditional network switch or router, the control plane, responsible for making decisions about where to forward traffic, and the forwarding plane, responsible for actually moving the packets based on those decisions, are tightly coupled. OpenFlow breaks this tight integration by introducing a standardized interface.

- **Standardized Communication:** OpenFlow defines a standardized set of protocols and messages that facilitate communication between the centralized controller and the distributed forwarding devices. This communication occurs over a secure channel.
- **Flow-based Forwarding:** OpenFlow operates on the principle of flow-based forwarding. Instead of making individual packet forwarding decisions, network devices make decisions based on predefined flows, which are sets of rules that dictate how specific types of traffic should be handled.
- **Centralized Control:** The OpenFlow controller becomes the brain of the network, making decisions about traffic flows and instructing the forwarding devices (such as switches and routers) on how to handle those flows.
- **Programmability and Flexibility:** OpenFlow’s programmability allows network administrators to define and modify network behavior dynamically. This flexibility is crucial for adapting to changing network conditions, optimizing traffic, and implementing specific policies.
- **Software-Defined Networking (SDN):** OpenFlow is a foundational element of SDN, a network architecture that emphasizes the programmability and automation of network management. SDN enables the creation of intelligent, responsive, and easily manageable networks.
- **Standardization and Vendor Neutrality:** OpenFlow is an open standard, promoting interoperability among networking equipment from different vendors. This standardization reduces vendor lock-in and encourages innovation in network design and management.

Open vSwitch with the OpenFlow protocol provides a powerful set of capabilities through the ovs-ofctl tool. Here's a general list of capabilities that can be achieved using OVS flows with ovs-ofctl:

- **Packet Forwarding:** Define how packets are forwarded based on criteria like source/destination MAC addresses, IP addresses, VLAN tags, etc.
- **VLAN Tagging and Trunking:** Set and modify VLAN tags, allowing for the segmentation of traffic into virtual LANs.
- **Quality of Service (QoS):** Prioritize or rate-limit traffic based on characteristics such as DSCP (Differentiated Services Code Point) values or packet sizes.
- **Load Balancing:** Distribute traffic across multiple paths or servers, improving resource utilization and balancing the network load.
- **Access Control Lists (ACLs):** Implement security policies by defining rules to permit or deny traffic based on various packet attributes.
- **Mirroring and Monitoring:** Mirror selected traffic to a monitoring port for analysis, facilitating network troubleshooting and monitoring.
- **Network Tunnels:** Set up and manage network tunnels, enabling communication between geographically distributed networks.
- **Flow Modification:** Dynamically modify existing flows to adapt to changing network conditions or requirements.
- **Timeouts and Aging:** Set timeouts to automatically remove flows after a certain period, preventing unnecessary resource usage.
- **Controller Interaction:** Establish communication with external controllers, enabling centralized network management and SDN (Software-Defined Networking) capabilities.

These capabilities showcase the versatility and flexibility that OVS flows, managed through ovs-ofctl, bring to the table in terms of network configuration, optimization, and security.

## Troubleshooting the connection problem

When troubleshooting connection issues between VLANs in Open vSwitch (OVS), the ovs-appctl and ovs-ofctl commands can provide valuable information. Let's go through some commands and their expected outputs to demonstrate the troubleshooting process.

To monitor the statistics for each port on the “br0” bridge, use the following command.

```bash
sudo ovs-ofctl dump-ports br0
OFPST_PORT reply (xid=0x2): 3 ports
  port  eth1: rx pkts=238, bytes=43287, drop=19, errs=0, frame=0, over=0, crc=0
           tx pkts=378, bytes=88396, drop=19, errs=0, coll=0
  port LOCAL: rx pkts=0, bytes=0, drop=0, errs=0, frame=0, over=0, crc=0
           tx pkts=0, bytes=0, drop=0, errs=0, coll=0
  port  eth2: rx pkts=236, bytes=47127, drop=0, errs=0, frame=0, over=0, crc=0
           tx pkts=368, bytes=83865, drop=0, errs=0, coll=0
```

Here we see that packages are dropped at port “eth1” as expected.

To control the flow between ports we need to define flow controls. To see the default rules, we use the following command.

```bash
sudo ovs-ofctl dump-flows br0

cookie=0x0, duration=126900.984s, table=0, n_packets=1012, n_bytes=129831, priority=0 actions=NORMAL
```

There is only one rule with “priority=0, actions=NORMAL” (other lines are about controller actions, no need to

- **Priority:** The priority of 0 makes this flow the lowest priority, ensuring it’s a fallback for unmatched packets.
- **Actions:** NORMAL instructs OVS to process the packet using the default behavior for Ethernet frames. This typically means forwarding the packet based on the destination MAC address without any special treatment.

While this default flow doesn’t explicitly drop packets, it doesn’t include any VLAN-specific actions. As a result, if you have VLAN-tagged packets (for example, coming from “eth1” with VLAN 10 or “eth2” with VLAN 20), they might not be handled correctly for inter-VLAN communication.

To fix our connection problem let’s add two flow rules to provide bidirectional permission between ports “eth1” and “eth2”.

```bash
sudo ovs-ofctl add-flow br0 "in_port=eth1,actions=output:eth2"
sudo ovs-ofctl add-flow br0 "in_port=eth2,actions=output:eth1"
sudo ovs-ofctl dump-flows br0

 cookie=0x0, duration=18.800s, table=0, n_packets=8, n_bytes=569, in_port=eth1 actions=output:eth2
 cookie=0x0, duration=13.707s, table=0, n_packets=7, n_bytes=1204, in_port=eth2 actions=output:eth1
 cookie=0x0, duration=127232.475s, table=0, n_packets=1018, n_bytes=130083, priority=0 actions=NORMAL
```
