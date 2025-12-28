# **[Overview of OVN and SDNs](https://ubuntu.com/blog/data-centre-networking-what-is-ovn)**

What is OVN?
Open Virtual Network (OVN), together with Open vSwitch (OVS), is a software defined, hardware accelerated, network solution (SDN). It provides an abstraction for many important virtual network elements, and operates at the layers below the CMS, making it a platform-agnostic integration point.

In this article, we will take a close look at OVN, an important part of Canonical’s networking strategy. We’ll explain the gap that OVN fills, its key features and strengths—especially how it benefits from specialised hardware—and its overall architecture. We will also cover how Canonical integrates OVN with the rest of its portfolio.

## Motivation

Ever since the limits of physical reality shifted CPU manufacturer competition from clock speed to core count in the mid-2000s, the industry has been hard at work figuring out how to best harness this novel form of increase in CPU performance.

![i1](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,c_fill,w_1600/https%3A%2F%2Fubuntu.com%2Fwp-content%2Fuploads%2Fbf2f%2F50-years-processor-trend.png)

Figure 1. Microprocessor performance trend data demonstrating plateau in single-thread performance and frequency (Source: Karl Rupp, Microprocessor Trend Data, 2022, CC BY 4.0).

Around the same time frame, public cloud entered the market and hardware-assisted virtualisation technologies appeared in off-the-shelf hardware.

Fast-forward to today and you will find that the phone, laptop or workstation you’re reading this article on has a CPU with a number of cores that require advanced process management to fully utilise them.

The most prevalent technique for software to harness the power of multicore CPUs remains horizontal scaling, which is implemented by running multiple copies of a software component, typically encapsulated in containers and virtual machines (VMs), across one or more physical machines.

With that in mind, it becomes clear that the endpoint of the network is no longer a physical piece of equipment: rather it is the hundreds of VMs and thousands of containers running on the physical equipment, each of which has individual network service and policy requirements.

But how do you effectively manage network service and policy for thousands of entities across one or more physical machines?  This is where OVN comes into play.

Managing the numerous containers and VMs running on every machine requires management software such as Kubernetes, LXD/MicroCloud and OpenStack.  Collectively referred to as “Cloud Management Software (CMS)”, what these solutions have in common is that they can delegate implementation of the networking for containers and VMs to OVN.

## OVN features

OVN makes use of OVS, a production quality multilayer switch platform that opens the forwarding functions to programmatic extension and control, which provides further integration down to hardware acceleration through its support for multiple data path providers and flow APIs. This includes at the  kernel level with SwitchDev / TC, and in the userspace with eBPF XDP and DPDK rte_flow.

SwitchDev/TC refers to the integration of the Linux TC (Traffic Control) subsystem with the Switchdev device driver model for hardware offloading of network packet processing in modern Ethernet controllers. Switchdev allows the Linux kernel's data path functions to be moved to the network card's embedded switch (eSwitch), while TC, specifically the TC-Flower classifier, provides the framework to match packet flows and apply actions, offloading these rules to hardware for enhanced performance.

Hardware accelerated data path features include:

Access Control Lists (ACLs)
Layer 2 Switching
Layer 3 Routing, including policy-based and ECMP routing
Layer 4 Load Balancing
NAT
GENEVE and VxLAN encapsulation

Geneve is a network encapsulation protocol created by the IETF in order to unify the efforts made by other initiatives like VXLAN and NVGRE

Distributed control plane features include:

ARP/ND
Bidirectional Forwarding Detection (BFD)
Control Plane Protection (CoPP)
DHCP
Instance DNS resolution
IPv6 Prefix Delegation
IPv6 RA
MAC Learning

## OVN hardware acceleration

With the expanding amount of data each entity has to store and process, the demand on the network grows relentlessly. 100, 200 and 400 Gbps ports are commonplace. 800 Gbps ports are just around the corner, and within a few years we will see 1.6Tbps ports being deployed in every data centre. Concomitantly, the number of CPU cores we can fit in a single server is steadily increasing (see previous figure) to withstand the growing number of virtual machines and containers.

This poses considerable challenges to  server networking capabilities, which can be solved by hardware acceleration.

To get a grasp of this scaling issue, let’s first have a look at how the time window to process packets in the CPU closes according to the bit rate. The theoretical time that is available to process a complete standard Ethernet frame of 1500 bytes is governed by an inverse linear relationship, using the formula:

t
processing
=

S
R
=

1500
×
8
R
=

12000
R
 , where S is the size of the Ethernet frame in bits and R is the data rate in bits per second.

This theoretical time available to process each standard Ethernet frame can be compared to a single core clock speed and CPU load for each frame. According to Raumer, Daniel, et al., the total number of CPU cycles required to process each frame is quite stable with the packet size, and they find a value of 2203 for standard Ethernet Frame.

![i1](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,c_fill,w_1380/https%3A%2F%2Fubuntu.com%2Fwp-content%2Fuploads%2F2d48%2Fimage.png)

We can thus derive the maximum number of nanoseconds between packets that is available for a given processor frequency, using the formula, which is again governed by an inverse linear relationship:

t
available
=

C
f
=

2203
f
 , where C is the number of required CPU cycles and f is the core frequency in GHz.

Considering both relations, keeping in mind the plateau around 4 GHz for processor frequency, the authors found 40Gbps is the practical maximum to process packets fully in software using a single, fully dedicated core. Even with the latest processors having dozens of cores, servers cannot handle processing wirespeed traffic at the highest available network port speeds. There are ongoing efforts to further optimise network processing in software, such as DPDK and AF_XDP, but there is no hope that it can scale as fast as the port speed.  

![i3](https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,c_fill,w_1653/https%3A%2F%2Fubuntu.com%2Fwp-content%2Fuploads%2Fcd48%2FTime-available-for-packet-processing.png)

With this development in mind, one of the most important values OVN/OVS provide is a data path implementation that can be fully accelerated by the NIC, enabling packets to appear directly in the virtual machine or container endpoint.This allows precious CPU time to be spent on your applications.

Hardware acceleration for the data path features (mentioned in the above third paragraph of the “What is OVN?” section)  is in use in production environments today, supported hardware includes NVIDIA ConnectX-6 Dx.

## OVN hardware offload

Taking hardware acceleration one step further, it is also possible to offload the control plane software onto dedicated infrastructure or data processing units (IPU and DPU, respectively), embodied in the latest generation of smart NICs, such as NVIDIA Bluefield, Intel IPU E2100 or AMD Pensando Elba. In addition to the associated performance improvement, the relinquishment of precious CPU cycles to focus on business workloads also provides administrators with the capability to completely isolate the control of the network from the hosted workloads. This, in turn, simplifies integration and increases security. OVN running on the smart NICs can manage routing of the highest complexity and scale, with each individual workload only seeing their own simple routing table.
