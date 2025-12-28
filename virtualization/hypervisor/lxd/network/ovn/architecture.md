# **[OVN architecture and fundamentals](https://ubuntu.com/blog/data-centre-networking-what-is-ovn)**

OVN is a distributed system composed of several components. They are detailed from top to bottom in the figure below:

- The OVN northbound database (NB) keeps an intermediate representation of the network configuration received from the CMS through the OVN integration API. Its database schema directly supports the same networking concepts as the CMS, such as logical switches and routers, and access control lists (ACLs).
- A translation service, ovn-northd, converts the logical network configuration stored in the NB into logical data path flows.
- The OVN southbound database (SB) stores these logical data path flows in its logical network (LN) tables. Its physical network (PN) tables contain reachability information discovered by an agent running on each transport node. The Binding tables link the logical network components’ locations to the physical network.
- The agent running on each transport node is ovn-controller. It connects to the SB to discover the global OVN configuration and status from its LN and populates the PN and Binding tables with local information.
- Each transport node also hosts an Open vSwitch bridge dedicated to OVN’s use, called the integration bridge. The ovn-controller connects to the local ovs-vswitchd, as an OpenFlow controller, to control the network traffic and to the local ovsdb-server to monitor and control OVS configuration.

More details on OVN components can be found at this **[link](http://manpages.ubuntu.com/manpages/noble/man7/ovn-architecture.7.html?_gl=1*1r1obw3*_gcl_au*MTcwMzEzOTMxMC4xNzUzMTIxNDg4)**.

![i4](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,c_fill,w_1600/https%3A%2F%2Fubuntu.com%2Fwp-content%2Fuploads%2Fd5c3%2Fimage.png)

OVN conveniently uses ovsdb-server as its database without introducing any new dependencies.  

Each instance of ovn-controller is always working with a consistent snapshot of the database. It maintains an update-driven connection to the database. If connectivity is interrupted, ovn-controller will catch back up to the latest consistent snapshot of the relevant database contents and process them.

## Configuration data flow

In the OVN design, network configuration flows southbound, from the CMS to each of the transport nodes. The CMS is responsible for presenting the administrators with the configuration user interface. Any change done through it is communicated to the NB via the API and then the lower-level details are determined and passed along to the SB by ovn-northd, which also updates the desired configuration version number. In turn, the SB changes are communicated to the ovn-controller agents running on the transport nodes. The agents then update the VMs, containers and Open vSwitch configuration.

## Status information flow

Conversely, to gather status, information flows northbound from the transport nodes to the CMS. Each ovn-controller agent running on a transport node updates its configuration version number in the SB to reflect that a requested configuration change has been committed. Ovn-northd monitors the configuration version number of each transport node in the SB and copies the minimum value into the NB to reflect the progress of changes. Any NB observer, including the CMS, can therefore find out when all participating transport node configurations have been updated.

## OVN and Canonical products

OVN can serve as the SDN of several CMS, including OpenStack, LXD and Kubernetes. Canonical bundles it with Charmed OpenStack, Sunbeam, and MicroCloud, simplifying their deployment and initial configuration. Moreover, Canonical Kubernetes can also leverage OVN, thus providing a familiar architecture and command-line interface, by complementing it with CNI (Container Network Interface, the CNCF specifications for containers connectivity) plugins that implement OVN, such as KubeOVN or OVN-Kubernetes. The latter benefits from all the hardware acceleration and offloading capabilities and is maintained by the OVN organisation itself.

While it is theoretically possible for multiple CMS to share a single distributed OVN database, it should be avoided. This is because each CMS has a unique, potentially incompatible, view of their network requirements. With each of them directly writing their network configuration details in a single network model without any arbitration layer, the end result will be inconsistencies and unwanted overlaps. Instead, each OVN deployment must be kept dedicated to its respective CMS. Consistent routing information sharing and policing between them can be reached using industry standard routing protocols, such as the Internet Border Gateway Protocol (BGP). In fact, the best practice is increasingly to leverage BGP as the data-centre underlay, thus benefiting from the reliability, scalability and security attributes of the “routing protocol of the Internet”. But that will be the topic of another future blog post…

Summary
Canonical OVN provides easy to use, reliable and predictable software-defined networking. This SDN abstracts the details of the data centre network infrastructure and seamlessly interconnects your workloads regardless of the underlying CMS. With built-in support for secure tenant isolation and enhanced performance through hardware acceleration and offloading, it’s a cornerstone of Canonical’s networking vision. Stay tuned for future content, including  insightful white papers which will examine OVN internals and operations in more detail. We’ll cover topics such as how to run OVN on NVIDIA Bluefield DPUs and how to use these to apply and manage distributed security controls.
