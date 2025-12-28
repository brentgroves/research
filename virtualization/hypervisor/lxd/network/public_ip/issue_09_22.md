# in microcloud ovn network only insance on one node can access the internet

AI Overview
In a MicroCloud OVN network, only one node can access the internet because OVN uses a single, active virtual router at any given time for external (north-south) traffic. All internet-bound traffic from instances within the cluster is routed through this single node.

This is a key part of OVN's design for high availability, as it ensures connectivity can fail over to a different node if the active one goes down. However, it can also be a source of confusion if not understood properly.

How MicroCloud OVN handles internet access
Active router: OVN designates one node in the cluster as the active chassis for a virtual router. That router is the single egress point for all traffic from OVN-based networks to the external internet.

Layer 2 network requirement: For failover to work correctly, all uplink interfaces on your cluster nodes must be connected to the same Layer 2 network. This allows OVN to reassign the virtual router's IP address to a different node using ARP/NDP if the active node fails.

Distinct interfaces: When you configure MicroCloud, you must select two distinct types of network interfaces:
Internal traffic: An interface used for internal cluster communication (OVN east-west traffic, Ceph, etc.). This interface must be multicast-compatible.
Uplink/External traffic: An interface used for external internet access (OVN north-south traffic). This interface must be unused or a bridge, as MicroCloud will assign IPs to it automatically.

## which host in a lxd cluster is running the uplink

In a clustered LXD environment with Open Virtual Network (OVN), the "uplink" is a network configuration rather than a fixed process running on a single host. For any given OVN network, one of the LXD cluster members acts as the active gateway chassis at a time, providing the ingress and egress point to the physical network.
The gateway chassis for an OVN network is chosen automatically through a priority system. If one cluster member fails, the member with the next highest priority automatically takes over as the active gateway. This provides high availability and fault tolerance for your OVN-based networks.
How to find the active uplink host
To find the current active gateway chassis (the host providing the uplink) for a specific OVN network, you can inspect the network's configuration.
List your OVN networks. From any member of the LXD cluster, run lxc network list. The output will show all networks and their types. OVN networks will be listed as type ovn.
Inspect the specific OVN network. For the OVN network you are interested in, run lxc network get <network_name> volatile.network.ovn.chassis.
This command will return the name of the cluster member that is currently acting as the OVN gateway chassis for that network.

```bash
lxc network list
# lxc network get <network_name> volatile.network.ovn.chassis
lxc network get default volatile.network.ovn.chassis
https://documentation.ubuntu.com/lxd/latest/howto/network_ovn_setup/
