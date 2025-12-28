# **[LXD Clusters: A Primer](https://ubuntu.com/blog/lxd-clusters-a-primer)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

LXD ( [lɛks'di:] 🔈) is a modern, secure and powerful system container and virtual machine manager. It provides a unified experience for running and managing full Linux systems inside containers or virtual machines.

Since its inception, LXD has been striving to offer a fresh and intuitive user experience for machine containers. LXD instances can be managed over the network through a REST API and a single command line tool. For large scale LXD deployments, OpenStack has been the standard approach: using Nova LXD, lightweight containers replace traditional hypervisors like KVM, enabling bare metal performance and very high workload density. Of course OpenStack itself offers a very wide spectrum of functionality, and it demands resources and expertise. So today, if you are looking for a simple and comprehensive way to manage LXD across multiple hosts, without adopting an Infrastructure as a Service platform, you are in for a treat.

LXD 3.0 introduces native support for LXD clusters. Effectively, LXD now crosses server and VM boundaries, enabling the management of instances uniformly using the lxc client or the REST API. In order to achieve high availability for its control plane, LXD implements fault tolerance for the shared state utilizing the Raft algorithm. Clustering allows us to combine LXD with low level components, like heterogenous bare-metal and virtualized compute resources, shared scale-out storage pools and overlay networking, building specialized infrastructure on demand. Whether optimizing for an edge environment, an HPC cluster or lightweight public cloud abstraction, clustering plays a key role. Let’s quickly design and build a small cluster and see how it works.

There are three main dimensions we need to consider for our LXD cluster:

- The number of compute node
- The type and quantity of available storage
- The container networking.

A minimalistic cluster necessitates at least three host nodes. We may choose to use bare-metal servers or virtual machines as hosts. In the latter case, it would be beneficial for the VMs to reside on three different hypervisors for better fault tolerance. For storage, LXD has a powerful driver back-end enabling it to manage multiple storage pools both host-local (zfs, lvm, dir, btrfs) and shared (ceph). VXLAN-based overlay networking as well as “flat” bridged/macvlan networks with native VLAN segmentation are supported. It’s important to note that the decisions for storage and networking affect all nodes joining the cluster and thus need to be homogenous.

For this walkthrough, we are using MAAS 2.3.1 and we are carving out 3 VMs from KVM Pods with two local storage volumes, (1) 8GB for the root filesystem (2) 6GB for the LXD storage pool. We configure each VM with a bridged interface (br0) and “Auto assign” IP mode.