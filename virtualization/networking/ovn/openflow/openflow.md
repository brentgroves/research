# **[The basics of SDN and the OpenFlow Network Architecture](https://noviflow.com/the-basics-of-sdn-and-the-openflow-network-architecture/)**

In recent years there has been a tremendous increase in carrier network traffic. To a great extent this has been fuelled by explosive growth in the use of online applications and cloud services by an ever-expanding array of wired and mobile connected devices.  Network operators today need to cope with a vast array of data formats, service types and online devices, and of course they need to do so while ensuring availability, security, quality of service, all without increasing operating and equipment costs.

However, legacy network architectures and their management tools were not designed to cope with such highly elastic demand. This severely limits the operator’s ability to cost-effectively respond to the scale, performance, and user experience requirements of today’s dynamic environments, or to roll out differentiated services.

Software Defined Networking (SDN) has emerged as the industry’s response to meeting these challenges. SDN allows networks to react dynamically to changes in usage patterns and availability of network resources. Network architectures can be instantly adjusted, respond to application and user requests, and services can be introduced far more quickly, easily and at a lower cost.

SDN provides separation between the control plane (controller) and data plane (switch) functions of networks using a protocol that modifies forwarding tables in network switches. This makes it possible to optimize networks on the fly and quickly respond to changes in network usage without the need for manually reconfiguring existing infrastructure or purchasing new hardware. SDN separates the control of network devices from the data they transport, and the switching software from the actual network hardware.

It also provides an entity, the controller, that has a comprehensive view of the entire network and its status, and with which switches (network resources) and applications (network consumers) can communicate in real-time. The controller makes it possible for networks to interact with applications and efficiently reconfigure themselves at need, allowing them to implement multiple logical network topologies on a single common network fabric.

OpenFlow. It is a multivendor standard defined by the Open Networking Foundation (ONF) for implementing SDN in networking equipment. The OpenFlow protocol defines the interface between an **[OpenFlow Controller](https://noviflow.com/controllers-onos-odl-ryu-openkilda/)** and an **[OpenFlow switch](https://noviflow.com/noviware/)**, see Figure 1 below. The OpenFlow protocol allows the OpenFlow Controller to instruct the OpenFlow switch on **[how to handle incoming data packets](https://noviflow.com/the-network-processor-npu-advantage/)**.

The OpenFlow switch may be programmed to:
(1) identify and categorize packets from an ingress port based on a various packet header fields;
(2) Process the packets in various ways, including modifying the header; and,
(3) Drop or push the packets to a particular egress port or to the OpenFlow Controller.

![i1](https://noviflow.com/wp-content/uploads/Image-1.jpg)

Figure 1 – The OpenFlow Protocol. Source: ONF OpenFlow 1.3.0 Switch Specification

The OpenFlow switch may be programmed to:
(1) identify and categorize packets from an ingress port based on a various packet header fields;
(2) Process the packets in various ways, including modifying the header; and,
(3) Drop or push the packets to a particular egress port or to the OpenFlow Controller.

The OpenFlow instructions transmitted from an OpenFlow Controller to an OpenFlow switch are structured as “flows”. Each individual flow contains packet match fields, flow priority, various counters, packet processing instructions, flow timeouts and a cookie. The flows are organized in tables. An incoming packet may be processed by flows in multiple “pipelined” tables before exiting on an egress port. The OpenFlow protocol standard is evolving quickly with release 1.6 as the current revision at the time of this blog being published.

![i2](https://noviflow.com/wp-content/uploads/Image-2-300x262.jpg)

The OpenFlow Network Architecture consists of three layers:
(1) One or more OpenFlow virtual and/or physical switches;
(2) One or two OpenFlow controller(s); and,
(3) One or more OpenFlow application(s). For an illustration, see figure 2 below.

The OpenFlow controller maintains the OpenFlow protocol communications channels to the OpenFlow switches, maintains a local state graph of the OpenFlow switches and exposes a northbound API to the OpenFlow applications. The northbound API may be viewed as an abstraction of the network and allows the OpenFlow applications to read the state of the network and to instruct the network to perform various tasks.

A real world OpenFlow capable network may consist of only OpenFlow switches or a mixture of OpenFlow switches and traditional switches and routers. The latter network type is called an overlay network. Some OpenFlow applications will require only partial deployment of OpenFlow switches whereas others require a network consisting of only OpenFlow switches.

Most of the SDN network fabrics and applications we will discuss in this blog can be introduced as overlays, and multiple applications can be introduced in a staged fashion, with new ones building on the foundations laid by the previous applications.

Yes, Open vSwitch (OVS) uses the OpenFlow protocol. OpenFlow is a key component of Open vSwitch's functionality, enabling it to act as a software-defined networking (SDN) switch. OVS leverages OpenFlow to manage traffic forwarding rules and policies, making it a popular choice for virtualized environments and SDN deployments.

OpenFlow as a Control Protocol:
OpenFlow is a protocol that allows external controllers to program the forwarding behavior of network switches.
OVS as an OpenFlow Switch:
Open vSwitch is a virtual switch that can be controlled by an OpenFlow controller.
Configuration and Management:
OpenFlow enables users to configure and manage Open vSwitch flow tables, which determine how packets are forwarded.
Key OVS Components:
OVS includes tools like ovs-ofctl that interact with the OpenFlow protocol to manage flow entries.
Beyond Basic Switching:
Open vSwitch supports OpenFlow 1.0 and later versions, along with numerous extensions, enabling advanced features like tunneling and group-based forwarding.
Flexibility and Control:
By using OpenFlow, Open vSwitch offers greater flexibility and control over network behavior compared to traditional switches.
