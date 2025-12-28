# **[Sunbeam OpenStack OPS Charm Anatomy](https://opendev.org/openstack/sunbeam-charms/src/branch/main/ops-sunbeam/doc/concepts.rst)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

## Overview

Sunbeam OpenStack is designed to help with writing charms that use the Charmed Operator Framework and are deployed on Kubernetes. For the rest of this document when a charm is referred to it is implied that it is a Charmed Operator framework charm on Kubernetes.

In general a charm interacts with relations, renders configuration files and manages services. Sunbeam Ops gives a charm a consistent way of doing this by implementing Container handlers and Relation handlers.
