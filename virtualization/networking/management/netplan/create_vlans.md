# **[How To Configure VLAN Tagging In Linux [A Step-by-Step Guide]](https://ostechnix.com/configure-vlan-tagging-in-linux/)**


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


## references

- **[tcpdump for vlans](https://access.redhat.com/solutions/2630851#:~:text=You%20can%20verify%20the%20incoming,To%20capture%20the%20issue%20live.)**

## Configure VLANs in Linux Like a Pro: A Beginner-Friendly Tutorial.

In this detailed tutorial, we are going to learn what VLAN tagging is, its advantages and use cases, and how to configure VLAN tagging in Linux operating system.

Configuring VLAN tagging in Linux involves creating virtual LANs, assigning VLAN IDs, and configuring IP addresses as needed. We will see how to do that in three different ways in the upcoming sections. But before that, let us understand what is VLAN tagging, its advantages and modes.

