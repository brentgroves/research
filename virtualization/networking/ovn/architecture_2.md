# **[Architecture](https://www.ovn.org/en/architecture/)**

OVN, the Open Virtual Network, is a system to support logical network abstraction in virtual machine and container environments. OVN complements the existing capabilities of OVS to add native support for logical network abstractions, such as logical L2 and L3 overlays and security groups. Services such as DHCP are also desirable features. Just like OVS, OVN’s design goal is to have a production-quality implementation that can operate at significant scale.

In network architecture, an underlay network refers to the physical infrastructure (hardware, cables, routers, etc.) that provides the basic connectivity for data transmission. An overlay network, on the other hand, is a virtual network built on top of the underlay, using software to create logical connections and manage traffic flow. Essentially, the underlay is the foundation, while the overlay is a layer of abstraction that provides flexibility and control.

A physical network comprises physical wires, switches, and routers. A virtual network extends a physical network into a hypervisor or container platform, bridging VMs or containers into the physical network. An OVN logical network is a network implemented in software that is insulated from physical (and thus virtual) networks by tunnels or other encapsulations. This allows IP and other address spaces used in logical networks to overlap with those used on physical networks without causing conflicts. Logical network topologies can be arranged without regard for the topologies of the physical networks on which they run. Thus, VMs that are part of a logical network can migrate from one physical machine to another without network disruption.

The encapsulation layer prevents VMs and containers connected to a logical network from communicating with nodes on physical networks. For clustering VMs and containers, this can be acceptable or even desirable, but in many cases VMs and containers do need connectivity to physical networks. OVN provides multiple forms of gateways for this purpose.

An OVN deployment consists of several components:

- **Cloud Management System (CMS):** integrates OVN into a physical network by managing the OVN logical network elements and connecting the OVN logical network infrastructure to physical network elements. Exmaples include OpenStack Neutron’s ml2/ovn plugin and the ovn-kubernetes project.
- **OVN Databases:** stores data representing the OVN logical and physical networks.
- **Hypervisors:** run Open vSwitch and translate the OVN logical network into OpenFlow on a physical or virtual machine.
- **Gateways:** extends a tunnel-based OVN logical network into a physical network by forwarding packets between tunnels and the physical network infrastructure.

                                         CMS
                                          |
                                          |
                              +-----------|-----------+
                              |           |           |
                              |     OVN/CMS Plugin    |
                              |           |           |
                              |           |           |
                              |   OVN Northbound DB   |
                              |           |           |
                              |           |           |
                              |       ovn-northd      |
                              |           |           |
                              +-----------|-----------+
                                          |
                                          |
                                +-------------------+
                                | OVN Southbound DB |
                                +-------------------+
                                          |
                                          |
                       +------------------+------------------+
                       |                  |                  |
         HV 1          |                  |    HV n          |
       +---------------|---------------+  .  +---------------|---------------+
       |               |               |  .  |               |               |
       |        ovn-controller         |  .  |        ovn-controller         |
       |         |          |          |  .  |         |          |          |
       |         |          |          |     |         |          |          |
       |  ovs-vswitchd   ovsdb-server  |     |  ovs-vswitchd   ovsdb-server  |
       |                               |     |                               |
       +-------------------------------+     +-------------------------------+
