# **[Control plane vs. data plane: use cases](https://www.splunk.com/en_us/blog/learn/control-plane-vs-data-plane.html#:~:text=and%20cloud%20computing.-,Software%2Ddefined%20networking%20(SDN),inputs%20from%20the%20control%20plane.)**

## references

- **[Control plane vs. data plane: use cases](https://www.splunk.com/en_us/blog/learn/control-plane-vs-data-plane.html#:~:text=and%20cloud%20computing.-,Software%2Ddefined%20networking%20(SDN),inputs%20from%20the%20control%20plane.)**

- **[data plane](https://www.techtarget.com/searchnetworking/definition/data-plane-DP#:~:text=The%20stoplights%20at%20the%20intersection,where%20packets%20will%20be%20transported.)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

## **[data plane](https://www.techtarget.com/searchnetworking/definition/data-plane-DP#:~:text=The%20stoplights%20at%20the%20intersection,where%20packets%20will%20be%20transported.)**

## What is the data plane?

The data plane -- sometimes known as the user plane, forwarding plane, carrier plane or bearer plane -- is the part of a network that carries user traffic. The data plane, the control plane and the management plane are the three basic components of a telecommunications architecture.

In networking, a plane is not a physical component, but an intangible idea that helps conceptualize traffic flows through a network. It refers to a part of the physical network architecture -- or an area of operations -- where certain activities and processes take place.

### Control plane vs. data plane

The control plane is the network component that carries information about the network and programs actions for the data plane. It defines the **[network topology](https://www.techtarget.com/searchnetworking/definition/network-topology)** and controls all activities related to traffic routing and **[packet](https://www.techtarget.com/searchnetworking/definition/packet)** forwarding.

This plane is also where **[routing tables](https://www.techtarget.com/searchnetworking/definition/routing-table)** are created by routers -- after processing the packets and using various protocols such as **[Open Shortest Path First (OSPF)](https://www.techtarget.com/searchnetworking/definition/OSPF-Open-Shortest-Path-First)**, **[Border Gateway Protocol (BGP)](https://www.techtarget.com/searchnetworking/definition/BGP-Border-Gateway-Protocol)** or Intermediate System to Intermediate System -- and where **[quality of service](https://www.techtarget.com/searchunifiedcommunications/definition/QoS-Quality-of-Service)** and **[virtual LAN](https://www.techtarget.com/searchnetworking/definition/virtual-LAN)** are implemented. The routing table provides path details for the data packets. The router will refer to these details to determine where the packet should go. The control panel makes all routing decisions.

Once the control plane determines how and to which ports packets should be forwarded, the data plane refers to the logic and actually forwards the packets. This is why it is also known as the **forwarding plane**. Thus, the network layer handles all traffic and moves packets from source to destination based on the actions and logic programmed and supplied to it by the **control plane**.

After sourcing the traffic, the data plane sends it on to other network-supported devices. Routers then forward the packets downstream to their appropriate destinations. All data plane packets go through routers, and the traffic is tightly controlled to protect the network from malicious **[network traffic](https://www.techtarget.com/searchnetworking/definition/network-traffic)**.

In any network, both the data plane and control plane are required in order to move traffic. The data plane cannot function without the control plane because it requires the logic created by the control plane to determine where traffic should go. In contrast, the control plane works independently and doesn't depend on the data plane to determine how and where packets will be transported.

### Data plane vs. management plane

The management plane is the area where the network's operations are configured, managed and monitored. It can be considered a subset of the control plane, although it has its own distinct functions, particularly related to configuration and monitoring. Also, the management plane uses protocols such as **[Simple Network Management Protocol](https://www.techtarget.com/searchnetworking/definition/SNMP)**, Secure Shell and Telnet for its configuration and management tasks, whereas the control plane uses protocols such as OSPF and BGP to allow network devices to exchange information.

The **[control plane](https://www.techtarget.com/searchnetworking/definition/control-plane-CP)** and management plane serve the data plane, which bears the traffic that the network is designed to carry. The data plane enables data transfer to and from clients, handling multiple conversations through multiple protocols, and manages conversations with remote peers. In addition, it dictates application behavior and executes everything from service-level agreements and policies to retries and keepalives to ensure network links are available and other scaling or behavior triggers. Data plane traffic travels through routers, rather than to or from them.

The management plane is where devices and tools such as switches, routers, command-line interfaces and shells are configured. Their performance is also monitored in the management plane. This plane defines the traffic that will be used to manage and monitor the various network elements. It also ensures the network operates efficiently and securely, blocks unauthorized access, prevents traffic compromise and makes software updates as required.

Both the control and management planes can be considered the high-level planes of a network architecture due to their higher-level functions and also because they operate at a higher layer of the Open Systems Interconnection, or OSI, model. The data plane is considered a low-level plane since it is mainly responsible for forwarding data packets rather than managing and optimizing the network's operations.

## **[Control plane vs data plane: use cases](https://www.splunk.com/en_us/blog/learn/control-plane-vs-data-plane.html#:~:text=and%20cloud%20computing.-,Software%2Ddefined%20networking%20(SDN),inputs%20from%20the%20control%20plane.)**

Besides larger enterprise networks, control and data planes can be found in SDNs and cloud computing.

## Software-defined networking (SDN)

A SDN consists of control, data, and management planes. The control plane performs forwarding decisions and other functions, like quality of service (QoS). In contrast, the data plane is the network that switches or forwards devices handling the data packets and taking inputs from the control plane.

## Cloud computing

In cloud computing, the control plane is the layer that handles tasks like creating and distributing routing policies. For instance, in Amazon Web Services (AWS), the control plane supplies administrative APIs for CRUD operations. A few examples of control plane tasks include creating S3 buckets and launching EC2 instances.

Amazon Elastic Compute Cloud (Amazon EC2) provides on-demand, scalable computing capacity in the Amazon Web Services (AWS) Cloud. Using Amazon EC2 reduces hardware costs so you can develop and deploy applications faster. You can use Amazon EC2 to launch as many or as few virtual servers as you need, configure security and networking, and manage storage. You can add capacity (scale up) to handle compute-heavy tasks, such as monthly or yearly processes, or spikes in website traffic. When usage decreases, you can reduce capacity (scale down) again.

An EC2 instance is a virtual server in the AWS Cloud. When you launch an EC2 instance, the instance type that you specify determines the hardware available to your instance. Each instance type offers a different balance of compute, memory, network, and storage resources. For more information, see the Amazon EC2 Instance Types Guide.

The data plane provides the core functionalities of AWS services, such as creating S3 objects, executing EC2 instances, and performing EBS read and write operations.

**Amazon Elastic Block Store (EBS)**\
A block storage service that allows users to store data on volumes that are attached to Amazon Elastic Compute Cloud (EC2) instances. EBS volumes can be used like a local hard drive, and can be formatted with a file system, host operating systems, and applications. EBS volumes can be backed up with snapshots, which are point-in-time copies of the volume that can be used to restore new volumes.

## AI Overview

In software-defined networking (SDN), the data plane is the network that forwards data packets based on instructions from the control plane. The data plane is responsible for carrying user traffic and applying actions to packets based on rules programmed in routing tables.
