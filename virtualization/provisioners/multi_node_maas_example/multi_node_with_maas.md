# **[Multi-node with MAAS](https://discourse.ubuntu.com/t/multi-node-with-maas/43280)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

This tutorial shows how to install a multi-node MicroStack cluster using MAAS as machine provider. It will deploy an OpenStack 2024.1 (Caracal) cloud.

Some steps provide estimated completion times. They are based on an average internet connection.

## Prerequisite knowledge

A MAAS cluster is needed so familiarity with the MAAS 8 machine provisioning system is a necessity. You should also be acquainted with these MAAS concepts:

- **[machine tags](https://maas.io/docs/how-to-use-machine-tags)**
- **[storage tags](https://maas.io/docs/how-to-use-storage-tags)**
- **[network tags](https://maas.io/docs/how-to-use-network-tags)**
- **[Reserved IP Ranges](https://maas.io/docs/how-to-manage-ip-ranges)**

Some knowledge of OpenStack networking will be helpful.

## Hardware requirements

You will need a total of six machines. One to act as a client host and five to make up the MAAS cluster.

## Client

The client machine will act as an administrative host. It does not require significant resources and it need not be dedicated to this task.

All the commands in this tutorial are run on the client.

Important: For environments constrained by a proxy server, the client machine must first be configured accordingly. See section Configure for the proxy at the OS level on the **[Manage a proxied environment](https://discourse.ubuntu.com/t/43946)** page before proceeding.


## MAAS cluster

The MAAS cluster will consist of five machines (the MAAS nodes): one will manage software orchestration, one will manage internal components like clusterd and three will host the actual cloud (the cloud nodes). MAAS needs to be set up in advance.

## Orchestration node

The requirements for the orchestration node are:

- physical or virtual machine
- a dual-core processor
- a minimum of 4 GiB of free memory
- 128 GiB of storage available on the root disk
- one network interface
