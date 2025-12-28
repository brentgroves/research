# **[networking options](https://docs.tigera.io/calico/latest/networking/determine-best-networking)**

If you want to fully understand the network choices available to you, we recommend you make sure you are familiar with and understand the following concepts. If you would prefer to skip the learning and get straight to the choices and recommendations, you can jump ahead to Networking Options.

## Kubernetes networking basics

The Kubernetes network model defines a “flat” network in which:

- Every pod get its own IP address.
- Pods on any node can communicate with all pods on all other nodes without NAT.

This creates a clean, backwards-compatible model where pods can be treated much like VMs or physical hosts from the perspectives of port allocation, naming, service discovery, load balancing, application configuration, and migration. Network segmentation can be defined using network policies to restrict traffic within these base networking capabilities.

Within this model there’s quite a lot of flexibility for supporting different networking approaches and environments. The details of exactly how the network is implemented depend on the combination of CNI, network, and cloud provider plugins being used.

## CNI plugins

CNI (Container Network Interface) is a standard API which allows different network implementations to plug into Kubernetes. Kubernetes calls the API any time a pod is being created or destroyed. There are two types of CNI plugins:

- **CNI network plugins:** responsible for adding or deleting pods to/from the Kubernetes pod network. This includes creating/deleting each pod’s network interface and connecting/disconnecting it to the rest of the network implementation.
- **CNI IPAM plugins:** responsible for allocating and releasing IP addresses for pods as they are created or deleted. Depending on the plugin, this may include allocating one or more ranges of IP addresses (CIDRs) to each node, or obtaining IP addresses from an underlying public cloud’s network to allocate to pods.
