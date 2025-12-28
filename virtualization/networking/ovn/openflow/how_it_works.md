# **[What Is OpenFlow?](https://info.support.huawei.com/info-finder/encyclopedia/en/OpenFlow.html)**

OpenFlow is a network communication protocol used between controllers and forwarders in an SDN architecture. The core idea of SDN is to separate the forwarding plane from the control plane. To achieve this, a communication standard must be built between controllers and forwarders to allow the controllers to directly access and control the forwarding plane of forwarders. OpenFlow introduces the concept of flow table, based on which forwarders forwards data packets. Controllers deploy flow tables on forwarders through OpenFlow interfaces, achieving control on the forwarding plane.

The forwarding plane, also known as the data plane, is the part of a network device (like a router or switch) responsible for forwarding data packets based on instructions from the control plane. It essentially handles the actual transmission of data across the network.
How a Separate Control and Data Plane Would Work – Welcome ...

## Origin and Development of OpenFlow

OpenFlow originated from the Clean Slate Program of Stanford University. This program considered how the Internet could be redesigned with a "clean slate", and aimed to change the network infrastructure that was slightly out of date and difficult to evolve. In 2006, Martin Casado, a student from Stanford University, led a project on network security and management. The project attempted to use a centralized controller to allow network administrators to easily define security control policies based on network flows and to apply these security policies to various network devices, thereby implementing security control over the entire network communication.

Inspired by this project, professor Nick McKeown — the director of the Clean Slate Program — and his team found that if the data forwarding and routing control modules of traditional network devices were separated, a centralized controller could be used to manage and configure various network devices through standard interfaces. This would result in more possibilities for the design, management, and use of network resources, thereby facilitating network innovation and development. Therefore, they put forward the concept of OpenFlow and published a paper entitled "OpenFlow: Enabling Innovation in Campus Networks" in 2008, introducing the principles and application scenarios of OpenFlow in detail for the initial time.

On the basis of OpenFlow, this team further proposed a concept of SDN in 2009, which attracted wide attention of the industry. In 2011, Google, Facebook, Microsoft, and other companies jointly set up the Open Networking Foundation (ONF) — an organization dedicated to promotion and adoption of SDN. The ONF defines OpenFlow as the first standard southbound communication interface between the control and forwarding layers in the SDN architecture, and standardizes OpenFlow.

![i1](https://download.huawei.com/mdl/image/download?uuid=427b16bacba749febcbb53acc8bc8a0a)

OpenFlow in the SDN architecture
Since its first official version 1.0 released at the end of 2009, OpenFlow has evolved from versions 1.1, 1.2, 1.3, to the latest version 1.5. Currently, versions 1.0 and 1.3 of OpenFlow are most widely supported and applied.

![i2](https://download.huawei.com/mdl/image/download?uuid=750d5b84399a4014a2eb79da446f6050)

Evolution and major changes of OpenFlow versions

## How OpenFlow Works

The OpenFlow architecture consists of a controller, OpenFlow switch, and secure channel. The controller controls the network in a centralized manner to implement the functions of the control layer. The OpenFlow switch is responsible for forwarding at the data layer; it exchanges messages with the controller through a secure channel to receive forwarding entries and report its status.

Controller Compatibility:
Extreme switches can work with various OpenFlow controllers, including those from NEC and BigSwitch.
