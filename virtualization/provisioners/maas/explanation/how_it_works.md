# **[How it works](https://maas.io/how-it-works)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**


MAAS has a tiered architecture with a central postgres database backing a ‘Region Controller (regiond)’ that deals with operator requests. Distributed Rack Controllers (rackd) provide high-bandwidth services to multiple racks. The controller itself is stateless and horizontally scalable, presenting only a REST API.

Rack Controller (rackd) provides DHCP, IPMI, PXE, TFTP and other local services. They cache large items like operating system install images at the rack level for performance but maintain no exclusive state other than credentials to talk to the controller.

![rc](https://assets.ubuntu.com/v1/b03d95a1-maas.io-how-it-works.svg)

## High availability in MAAS

MAAS is a mission critical service, providing infrastructure coordination upon which HPC and cloud infrastructures depend. High availability in the region controller is achieved at the database level. The region controller will automatically switch gateways to ensure high availability of services to network segments in the event of a rackd failure.

![ha](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_964,h_342/https://assets.ubuntu.com/v1/d788fae0-maas.io-high-availability.svg)

Rackds are not in the primary data path, they are not routers or otherwise involved in the flow of data traffic, this diagram shows only the role that MAAS Rackds play in providing local services to racks, and the way in which they can cover for one another in the event of a failure.

MAAS can scale from a small set of servers to many racks of hardware in a datacentre. High-bandwidth activities (such as the initial operating system installation) are handled by the distributed gateways enabling massively parallel deployments.

## Protocols

MAAS uses standard server BMC and NIC services such as IPMI and PXE to control the machines in your data centre. For converged infrastructure, MAAS talks to the chassis controller of the rack or hyperscale chassis such as Intel RSD, Cisco UCS or HP Moonshot. Custom plugins extend MAAS for alternative BMC protocols.

Initial machine inventory and commissioning is done from an ephemeral Ubuntu image that works across all major servers from all major vendors. It is possible to add custom scripts for firmware updates and reporting.

What is a baseboard management controller (BMC)?

A baseboard management controller (BMC) is a specialized service processor that remotely monitors the physical state of a host system.

IPMI (Intelligent Platform Management Interface) is a set of standardized specifications for hardware-based platform management systems that makes it possible to control and monitor servers centrally.

What is Intel Rack Scale Design and how does it work?

Intel Rack Scale Design is a blueprint for using software-defined technologies to build a hyperscale composable-disaggregated infrastructure 

## Physical availability zones

In keeping with the notion of a ‘physical cloud’ MAAS lets you designate machines as belonging to a particular availability zone. It is typical to group sets of machines by rack or room or building into an availability zone based on common points of failure. The natural boundaries of a zone depend largely on the scale of deployment and the design of physical interconnects in the data centre.

Nevertheless the effect is to be able to a scale-out service across multiple failure domains very easily, just as you would expect on a public cloud. Higher-level infrastructure offerings like OpenStack or Mesos can present that information to their API clients as well, enabling very straightforward deployment of sophisticated solutions from metal to container.

The MAAS API allows for discovery of the zones in the region. Chef, Puppet, Ansible and Juju can transparently spread services across the available zones.

Users can also specifically request machines in particular AZs.

There is no forced correlation between a machine location in a particular rack and the zone in which MAAS will present it, nor is there a forced correlation between network segment and rack. In larger deployments it is common for traffic to be routed between zones, in smaller deployments the switches are often trunked allowing subnets to span zones.

By convention, users are entitled to assume that all zones in a region are connected with very high bandwidth that is not metered, enabling them to use all zones equally and spread deployments across as many zones as they choose for availability purposes.

## The node lifecycle
Each machine (“node”) managed by MAAS goes through a lifecycle — from its enlistment or onboarding to MAAS, through commissioning when we inventory and can setup firmware or other hardware-specific elements, then allocation to a user and deployment, and finally they are released back to the pool or retired altogether.

