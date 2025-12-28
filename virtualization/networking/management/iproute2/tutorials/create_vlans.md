# **[How to create VLANs in Linux? ](https://www.baeldung.com/linux/vlans-create)**


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


In this tutorial, we’ll look at various commands for creating and setting up VLANs in both Debian and RedHat systems. We need an established network connection on the local network interface for VLANs to work, and it’s possible to create and configure VLANs in Linux systems.

2. VLAN
We can set up VLANs on multiple interfaces depending on our network requirements. VLANs allow us to separate various network devices into logical groups that can communicate as if they’re on the same network, regardless of their actual physical location on the broadcast LAN.

Once a VLAN is set up, there are two types of packets: tagged and untagged (regular packets). When packets are tagged, the tags are associated with a VLAN identifier.

We should note that not all drivers support VLAN. Also, when using VLANs the header is enlarged from 14 to 18 bytes(VLAN id and priority). 


## references

- **[tcpdump for vlans](https://access.redhat.com/solutions/2630851#:~:text=You%20can%20verify%20the%20incoming,To%20capture%20the%20issue%20live.)**
