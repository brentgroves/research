# **[Showing current network configuration](https://netplan.readthedocs.io/en/stable/netplan-tutorial/#showing-current-network-configuration)**


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

Netplan 0.106 introduced the netplan status command. The command displays the current network configuration of the system. Try it by running:

```bash
netplan status --all
# You should see an output similar to the one below:

     Online state: online
    DNS Addresses: 127.0.0.53 (stub)
       DNS Search: lxd

●  1: lo ethernet UNKNOWN/UP (unmanaged)
      MAC Address: 00:00:00:00:00:00
        Addresses: 127.0.0.1/8
                   ::1/128
           Routes: ::1 metric 256

●  2: enp5s0 ethernet UP (networkd: enp5s0)
      MAC Address: 00:16:3e:13:ae:10 (Red Hat, Inc.)
        Addresses: 10.86.126.221/24 (dhcp)
                   fd42:bc43:e20e:8cf7:216:3eff:fe13:ae10/64
                   fe80::216:3eff:fe13:ae10/64 (link)
    DNS Addresses: 10.86.126.1
                   fe80::216:3eff:feab:beb9
       DNS Search: lxd
           Routes: default via 10.86.126.1 from 10.86.126.221 metric 100 (dhcp)
                   10.86.126.0/24 from 10.86.126.221 metric 100 (link)
                   10.86.126.1 from 10.86.126.221 metric 100 (dhcp, link)
                   fd42:bc43:e20e:8cf7::/64 metric 100 (ra)
                   fe80::/64 metric 256
                   default via fe80::216:3eff:feab:beb9 metric 100 (ra)

●  3: enp6s0 ethernet DOWN (unmanaged)
      MAC Address: 00:16:3e:0c:97:8a (Red Hat, Inc.)
```