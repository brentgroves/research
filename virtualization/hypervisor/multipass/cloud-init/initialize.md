# **[How to initialize LXD](https://documentation.ubuntu.com/lxd/en/latest/howto/initialize/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

Before you can create a LXD instance, you must configure and initialize LXD.

## Interactive configuration
Run the following command to start the interactive configuration process:

lxd init

Note

For simple configurations, you can run this command as a normal user. However, some more advanced operations during the initialization process (for example, joining an existing cluster) require root privileges. In this case, run the command with sudo or as root.

The tool asks a series of questions to determine the required configuration. The questions are dynamically adapted to the answers that you give. They cover the following areas:

## Clustering (see Clusters and How to form a cluster)
A cluster combines several LXD servers. The cluster members share the same distributed database and can be managed uniformly using the LXD client (lxc) or the REST API.

The default answer is no, which means clustering is not enabled. If you answer yes, you can either connect to an existing cluster or create one.

## MAAS support (see maas.io and **[MAAS - Setting up LXD for VMs](https://maas.io/docs/how-to-use-lxd-vms)**)
MAAS is an open-source tool that lets you build a data center from bare-metal servers.

The default answer is no, which means MAAS support is not enabled. If you answer yes, you can 