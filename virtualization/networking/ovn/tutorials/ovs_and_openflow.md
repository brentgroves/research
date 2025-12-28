# **[OpenvSwitch and OpenFlow: What Are They, What’s Their Relationship?](https://medium.com/@fiberoptics/openvswitch-and-openflow-what-are-they-whats-their-relationship-d0ccd39b9a5c)**

As software defined networking (SDN) becomes popular in high-bandwidth and dynamic applications (for example, cloud computing), related terms such as OpenvSwitch and OpenFlow are talked a lot by IT technicians. Though they have been introduced for a while, OpenvSwitch and OpenFlow still confuse people in some aspects. And the most frequently asked question is what’s the relationship and difference between OpenvSwitch and OpenFlow. Here we will cover these topics on what is OpenvSwitch, what is OpenFlow, and OpenvSwitch vs OpenFlow.

## OpenvSwitch vs OpenFlow: OpenFlow Tutorial

Traditionally, networking hardwares from different vendors often have special configuration and management systems, which limits the interacting between routers and switches from different manufacturers. To solve this, OpenFlow is created as an open programmable network protocol for configuring and managing Gigabit network switches from various vendors. It enables us to offload the control plane of all the switches to a central controller and lets a central software define the behavior of the network. Thus network administrators can use OpenFlow software to manage and control traffic flow among different branded switching equipments.

![i1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*WdNl1dPK6nwhH4CRfjCE_Q.png)

## How Does OpenFlow Work?

OpenFlow generally consists of three components: OpenFlow controller, OpenFlow protocol and a chain of flow tables set up on the OpenFlow switch (as shown above). The OpenFlow protocol is like a media for the controller talking securely with OpenFlow switch. The OpenFlow controller can set rules about the data-forwarding behaviors of each forwarding device through the OpenFlow protocol. Flow tables installed on the switch often stores a collection of flow entries. So when a data packet arrives at the OpenFlow switch, the switch will search for matched flow entries in the flow tables and executes corresponding actions. If no match is found, an inquiry event will sent to the OpenFlow controller which then responds with a new flow entry for handling that queued packet.

## OpenvSwitch vs OpenFlow: OpenvSwitch Tutorial

OpenvSwitch, sometimes abbreviated as OVS, is an open-source OpenFlow switch that works as a virtual switch in the virtualized environments such as KVM. It also used as a multilayer software for interconnecting virtual devices in the same host or between different hosts. Currently, OpenvSwitch can run on any Linux-based virtualization platform, which includes: KVM, VirtualBox, Xen, Xen Cloud Platform, XenServer.

![i1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*iMqpjoveBQ2S6dpNdShpPw.jpeg)

OpenvSwitch has eight core elements: ovs-vswitchd, Linux kernel module, ovsdb-server, ovs-dpctl, ovs-vsctl, ovs-appctl, ovs-ofctl, and ovs-pki. Ovs-vswitchd is a daemon that implements the switch. Linux kernel module is for flow-based switching. Ovsdb-server is a lightweight database server. Ovs-dpctl is a tool for configuring the switch kernel module. Ovs-vsctl is a utility for querying and updating the configuration of ovs-vswitchd. Ovs-appctl is a utility that sends commands to running Open vSwitch daemons. Ovs-ofctl is a utility for controlling the OpenFlow features of OVS. Ovs-pki is a utility for creating and managing the public-key infrastructure.

OpenvSwitch vs OpenFlow: What’s Their Relationship?

OpenvSwitch and OpenFlow are both used for SDN application. OpenFlow is one of the first SDN standards. OpenvSwitch is an OpenStack SDN component. As to their relationship, OpenvSwitch is one of the most popular implementations of OpenFlow. Apart from OpenFlow, OpenvSwitch also supports other switch management protocols such as OVSDB (Open vSwitch Database Management Protocol).
