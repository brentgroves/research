# **[Software-Defined Networking (SDN) Definition](https://en.wikipedia.org/wiki/Software-defined_networking#:~:text=Software%2Ddefined%20networking%20(SDN),computing%20than%20to%20traditional%20network)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

## references

- **[Software-Defined Networking (SDN) Definition](https://opennetworking.org/sdn-definition/)**

**What is SDN?** The physical separation of the network control plane from the forwarding plane, and where a control plane controls several devices.

Software-defined networking (SDN) is an approach to network management that uses abstraction to enable dynamic and programmatically efficient network configuration to create grouping and segmentation while improving network performance and monitoring in a manner more akin to cloud computing than to traditional network ...

Software-Defined Networking (SDN) is an emerging architecture that is dynamic, manageable, cost-effective, and adaptable, making it ideal for the high-bandwidth, dynamic nature of today’s applications. This architecture decouples the network control and forwarding functions enabling the network control to become directly programmable and the underlying infrastructure to be abstracted for applications and network services. The OpenFlow® protocol is a foundational element for building SDN solutions. For an in-depth understanding of SDN-based networking and use cases, check out the open source micro-book, **[Software-Defined Networks: A Systems Approach](https://sdn.systemsapproach.org/)**.

## 1.2.1 Disaggregating the Control and Data Planes

The seminal idea behind SDN is that networks have distinct control and data planes, and the separation of these two planes should be codified in an open interface. In the most basic terms, the control plane determines how the network should behave, while the data plane is responsible for implementing that behavior on individual packets. For example, one job of the control plane is to determine the route packets should follow through the network (perhaps by running a routing protocol like BGP, OSPF, or RIP), and the task of forwarding packets along those routes is the job of the data plane, in which switches making forwarding decisions at each hop on a packet-by-packet basis.

In practice, decoupling the control and data planes manifests in parallel but distinct data structures: the control plane maintains a routing table that includes any auxiliary information needed to select the best route at a given point in time (e.g., including alternative paths, their respective costs, and any policy constraints), while the data plane maintains a forwarding table that is optimized for fast packet processing (e.g., determining that any packet arriving on Port i with destination address D should be transmitted out Port j, optionally with a new destination address D’). The routing table is often called the Routing Information Base (RIB) and the forwarding table is often called the Forwarding Information Base (FIB), as depicted in Figure 3.

![rib](https://sdn.systemsapproach.org/_images/Slide24.png)

There is no controversy about the value of decoupling the network control and data planes. It is a well-established practice in networking, where closed/proprietary routers that predate SDN adopted this level of modularity. But the first principle of SDN is that the interface between the control and data planes should be both well-defined and open. This strong level of modularity is often referred to as disaggregation, and it makes it possible for different parties to be responsible for each plane.

In principle then, disaggregation means that a network operator should be able to purchase their control plane from vendor X and their data plane from vendor Y. Although it did not happen immediately, one natural consequence of disaggregation is that the data plane components (i.e., the switches) become commodity packet forwarding devices—commonly referred to as bare-metal switches—with all the intelligence implemented in software and running in the control plane.[2] This is exactly what happened in the computer industry, where microprocessors became commodity. Chapter 4 describes these bare-metal switches in more detail.

[2] By our count, over 15 open-source and proprietary disaggregated control planes are available today.

Disaggregating the control and data planes implies the need for a well-defined forwarding abstraction, that is, a general-purpose way for the control plane to instruct the data plane to forward packets in a particular way. Keeping in mind disaggregation should not restrict how a given switch vendor implements the data plane (e.g., the exact form of its forwarding table or the process by which it forwards packets), this forwarding abstraction should not assume (or favor) one data plane implementation over another.

The original interface supporting disaggregation, called OpenFlow, was introduced in 2008,3 and although it was hugely instrumental in launching the SDN journey, it proved to be only a small part of what defines SDN today. Equating SDN with OpenFlow significantly under-values SDN, but it is an important milestone because it introduced Flow Rules as a simple-but-powerful way to specify forwarding behavior.
