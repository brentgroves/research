# **[Network traffic isolation with MAAS](https://canonical-openstack.readthedocs-hosted.com/en/latest/explanation/network-traffic-isolation-with-maas/)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../../`a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

Canonical OpenStack, in MAAS mode, supports network traffic isolation in a multi-network environment, where each of these cloud networks is coupled with specific cloud activity. It does this through the integration of Juju network spaces.

## Note

A Juju object that abstracts away the OSI Layer 3 network concepts. A space is created on a backing cloud (e.g. MAAS) to represent one or more subnets. The purpose of a space is to allow for user-defined network traffic segmentation.

Traffic isolation is implemented at the discretion of the cloud architect, where the degree of isolation is dependent upon the number of subnets used. That is, no isolation results from using a sole subnet with a single space. Conversely, maximum isolation can be arrived at with unique subnet-space pairings. The subnet:space mappings are done within MAAS.

To finish, spaces are mapped to the cloud network names supported by Sunbeam. The space:network mappings are done at the Sunbeam level. In the case of an environment consisting of a sole subnet, each cloud network will be mapped to the same space.

## Note 2

The **[Install Canonical OpenStack using Canonical MAAS page](https://canonical-openstack.readthedocs-hosted.com/en/latest/how-to/install/install-canonical-openstack-using-canonical-maas/)** shows how to use Canonical OpenStack with MAAS.
