# **[ovn](https://documentation.ubuntu.com/lxd/latest/reference/ovn-internals/)**

OVN implementation
Open Virtual Networks (OVN) is an open source Software Defined Network (SDN) solution. OVN is designed to be incredibly flexible. This flexibility comes at the cost of complexity. OVN is not prescriptive about how it should be used.

For LXD, the best way to think of OVN is as a toolkit. We need to translate networking concepts in LXD to their OVN analogue and instruct OVN directly, at a low level, what to do.

This document outlines LXD’s approach to OVN in a basic setup. It does not yet cover load-balancers, peering, forwards, zones, or ACLs.

For more detailed documentation on OVN itself, please see:

- **[Overview of OVN and SDNs](https://ubuntu.com/blog/data-centre-networking-what-is-ovn)**.
- **[OVN architectural overview](https://manpages.ubuntu.com/manpages/noble/man7/ovn-architecture.7.html)**.
- **[OVN northbound database schema documentation](https://manpages.ubuntu.com/manpages/noble/en/man5/ovn-nb.5.html)**.
- **[OVN southbound database schema documentation](https://manpages.ubuntu.com/manpages/noble/en/man5/ovn-sb.5.html)**.

## OVN concepts

This section outlines the OVN concepts that we use in LXD. These are usually represented in tables in the OVN northbound database.

## Chassis

A chassis is where traffic physically ingresses into or egresses out of the virtual network. In LXD, there will usually be one chassis per cluster member. If LXD is configured to use OVN networking, then all members can be used as OVN chassis.

Note

If any cluster members have the role ovn-chassis, only those members are represented as chassis in the chassis group table (see below). If no members have the role, all cluster members are added to the chassis group.

## Open vSwitch (OVS) Bridge

OVS bridges are used to connect virtual networks to physical ones and vice-versa. If the LXD daemon invokes OVS APIs, that means changes are being applied on the same host machine.

## For each LXD cluster member there are two OVS bridges

The provider bridge. This is used when connecting the uplink network on the host to the external switch inside each OVN network.

The integration bridge. This is used when connecting instances to the internal switch inside each OVN network.

## Chassis group

A chassis group is an indirection between physical chassis and the virtual networks that use them. Each LXD OVN network has one chassis group. This allows us to, for example, set chassis priority on a per-network basis so that not all ingress/egress is happening on a single cluster member.
