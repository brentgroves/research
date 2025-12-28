# **[Why do you need VLAN? ](https://www.utepo.net/article/detail/Why-do-you-need-VLAN.html#:~:text=VLAN%20divides%20different%20users%20into%20workgroups%2C%20and,construction%20and%20maintenance%20more%20convenient%20and%20flexible.&text=VLAN%20provides%20an%20additional%20layer%20of%20security,virtual%20networks%20within%20the%20same%20physical%20infrastructure.)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

The following hooks represent these well-defined points in the networking stack:

- **NF_IP_PRE_ROUTING:** This hook will be triggered by any incoming traffic very soon after entering the network stack. This hook is processed before any routing decisions have been made regarding where to send the packet.
- **NF_IP_LOCAL_IN:** This hook is triggered after an incoming packet has been routed if the packet is destined for the local system.
- **NF_IP_FORWARD:** This hook is triggered after an incoming packet has been routed if the packet is to be forwarded to another host.
- **NF_IP_LOCAL_OUT:** This hook is triggered by any locally created outbound traffic as soon as it hits the network stack.
- **NF_IP_POST_ROUTING:** This hook is triggered by any outgoing or forwarded traffic after routing has taken place and just before being sent out on the wire.

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


VLAN is any broadcast domain that is partitioned and isolated in a computer network at the OSI data link layer. It is a logical overlay network that groups together a subset of devices that share a physical LAN, isolating the traffic for each group.

In this article, we'll discuss the followings.

* Why need VLAN?
* VLAN vs. Subnet
* VLAN Tagging & VLAN ID
* Processing mechanisms on interface type and tag of VLAN
* Application of VLAN
* Protocols related to VLAN
* Problems with VLAN in cloud-based scenarios

## Why need VLAN?

Traditional Ethernet is a data network communication technology based on CSMA/CD (Carrier Sense Multiple Access/Collision Detection) shared communication medium. When the number of hosts is large, it leads to conflicts, broadcast flooding, significant performance degradation, and even network unavailability. Although LAN interconnection through Layer 2 devices can solve the problem of the conflicts, it still cannot isolate broadcast messages and improve network quality.

In this case, VLAN technology emerged. This technology can divide a LAN into multiple logical VLANs, and each VLAN is a broadcast domain. Hosts within a VLAN intercommunicate while cannot communicate with the hosts directly in different VLANs. Thus, broadcast messages are restricted to a VLAN.

![vl](https://www.utepo.net/include/upload/kind/image/20230703/VLAN1.png)

## VLAN has the following advantages

- Restrict broadcast domains
- Broadcast domains are restricted to a single VLAN, saving bandwidth and increasing network processing capability.
- Enhance networking security
- Messages in different VLANs are isolated during transmission, i.e., users in one VLAN cannot communicate directly with users in other VLANs.
- Ensure networking reliability
- Failures are restricted to one VLAN, which can not affect the operation of other VLANs.
- High flexibility
- VLAN divides different users into workgroups, and users in the same workgroup do not have to be limited to a fixed physical range, making network construction and maintenance more convenient and flexible.

## VLAN vs. Subnet

- Subnet and VLAN are two important concepts to understand when it comes to networking.
- The subnet is a way of breaking up a larger-scale network into smaller, more scalable, and secure networks.
- VLAN provides an additional layer of security by creating virtual networks within the same physical infrastructure.
- Both two technologies can be used to segment traffic, enhance performance, and increase the overall security of your network. While subnet also helps to reduce the number of IP addresses needed for a particular network.

|             | VLAN                                                                                                                                       | Subnet                                                                                                     |
|-------------|--------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------|
| Difference  | Partition of the Layer 2 network.                                                                                                          | Partition of the Layer 3 network                                                                           |
|             | After the route interworking is implemented based on the configured VLANIF interface, users in different VLANs can only access each other. | As long as the network is interoperable through routing, users in different subnets can access each other. |
|             | It can divide into 4094 VLANs, and the number of devices in the VLAN is not limited.                                                       | The number of segments divided affects the maximum number of devices in each subnet.                       |
| Correlation | It can divide multiple segments within the same VLAN.                                                                                      | It can divide multiple VLANs within the same subnet                                                        |

## VLAN Tag & VLAN ID

![vt](https://www.utepo.net/include/upload/kind/image/20230703/VLAN2.png)

A piece of contained information must be in the VLAN tags to ensure the Ethernet switch identifies messages from different VLANs. And the IEEE 802.1Q is the protocol that adds a carried 4-byte VLAN tag in an Ethernet data frame between its Source/Destination MAC address and Length/Type fields.

![et](https://www.utepo.net/include/upload/kind/image/20230703/VLAN3.png)

The VID in the data frame identifies the VLAN to which the frame belongs, and this frame can only be transmitted within its VLAN. The VID represents the VLAN ID, which takes values from 0 to 4095. Since 0 and 4095 are protocol reserved values, the valid range for the VLAN ID is 1 to 4094.



The data frames processed internally by the switch are tagged with VLAN tags, while some of the devices connected to the switch (e.g., hosts and servers) will only send and receive legacy Ethernet data frames without VLAN tags. That means if you want to access these devices, it requires the ability to recognize legacy Ethernet data frames on interfaces of the switches. At the same time, the interfaces should support adding or deleting VLAN tags when frames are sent and received. What VLAN tag is added is determined by the default VLAN (Port Default VLAN ID (PVID)) on the interface.

## Processing mechanisms on interface type and tag of VLAN

In a network, users in the same VLAN may connect to different switches, and there might be more than one VLAN across the network switches. Realizing the communication between those users requires the interfaces of switches to recognize and send data frames of multiple VLANs. Generally, it accommodates different connections and networking depending on the connected devices, the processing of sent and received data frames, and current multiple VLAN interface types.



There are three common definition of VLAN interface types, including: Access, Trunk and Hybrid.

## Access Interface

The access interface is generally used to connect with user terminals (such as user hosts and servers) that cannot identify VLAN tags or when it is not necessary to identify between different VLAN members.

In a VLAN-switched network, Ethernet data frames take two forms, untagged and tagged.

The untagged frame is the raw frame without a 4-byte VLAN tag. In most cases, the access interface can only send and receive untagged frames and can only add a unique VLAN tag to untagged frames. Since the Ethernet switch only handles tagged frames internally, the access interface adds a VLAN Tag to the received data frames, namely configuring the default VLAN. Once the default VLAN is configured, it will add the access interface to the VLAN. Nevertheless, if the VID and PVID are the same in the tagged frame, the access interface can also receive and handle it. And the access interface strips the tag before sending the tagged frame.

## Trunk Interface

Trunk interfaces are used to connect switches, routers, APs, and voice terminals that can send and receive both tagged and untagged frames. The trunk interfaces allow tagged frames from multiple VLANs to pass and send untagged frames belonging to the default VLAN. The trunk interface would mark the received untagged frames with the tag related to the default VLAN(Native VLAN).

## Hybrid Interface

The Hybrid interface can be used to connect both user terminals (e.g., user hosts, servers) and network devices (e.g., Hubs) that are not Tag-aware, as well as switches, routers, and voice terminals, APs that can send and receive both Tagged and Untagged frames. It can be configured to allow frames from certain VLANs with Tag (i.e., no Tag stripping) and frames from certain VLANs without Tag (i.e., Tag stripping) as needed.

It must use hybrid interfaces in some applications. For example, in the flexible QinQ, messages from multiple VLANs in the service provider's network need to be stripped of their outer VLAN Tag before entering the subscriber's network. And the trunk interface cannot complete this function because the Trunk interface can only allow messages from the interface's default VLAN to pass without the VLAN Tag.

## references

- **[tcpdump for vlans](https://access.redhat.com/solutions/2630851#:~:text=You%20can%20verify%20the%20incoming,To%20capture%20the%20issue%20live.)**
