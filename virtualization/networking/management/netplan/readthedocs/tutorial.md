# **[Tutorial](https://netplan.readthedocs.io/en/stable/tutorial/)**


**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

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

The Netplan tutorial offers guidance for basic use of the utility. It starts with instructions on setting up an environment that allows users to experiment with Netplan and test its features, and continues with running the tool for the first time and checking its configuration. The tutorial also shows the ways available for modifying the configuration in order to enable the user to follow how-to guides that provide procedures for achieving specific goals with Netplan.

Netplan tutorial
Trying Netplan in a virtual machine
Setting up the virtual environment
Running Netplan for the first time
Showing current Netplan configuration
- **[Showing current network configuration](https://netplan.readthedocs.io/en/stable/netplan-tutorial/#showing-current-network-configuration)**
Checking Netplan configuration files
Creating and modifying Netplan configuration
Using netplan set to enable a network interface with DHCP
Editing Netplan YAML files to disable IPv6
Applying new Netplan configuration
