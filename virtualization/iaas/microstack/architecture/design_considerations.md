# **[Design considerations](https://canonical-openstack.readthedocs-hosted.com/en/latest/explanation/design-considerations/)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

There are a few design considerations that need to be taken into account before proceeding with Canonical OpenStack deployment. Understanding them and adjusting the design to fit individual requirements helps avoid costly changes at further stages of the project.

## Network architecture

In general, Canonical OpenStack is agnostic to the underlying network architecture. However, the best price-performance can be achieved by using as few tiers as possible. The most typical scenarios include a one-tier architecture and a two-tier architecture (aka Spine-Leaf).

## Network traffic segregation

Canonical OpenStack requires at least two physical networks to function properly:

- **External** – used to provide an inbound (south) access to virtual machines (VMs) running on top of OpenStack through the mechanism of floating IPs, and outbound (north) access from instances to networks outside of OpenStack.

- **Generic** – used for any other purposes (machine provisioning, machine management, providing access to OpenStack APIs, etc.).

Customers can optionally use more physical networks or VLANs to further segregate network traffic when using Canonical MAAS as a **[bare metal provider](https://canonical-openstack.readthedocs-hosted.com/en/latest/explanation/design-considerations/#bare-metal-provider)**. Network traffic isolation with MAAS is handled through the concept of network spaces and **[space mappings](https://canonical-openstack.readthedocs-hosted.com/en/latest/explanation/network-traffic-isolation-with-maas/)**.
