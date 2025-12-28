# **[OpenFlow Protocol Overview](https://exatel.pl/en/knowledge/blog/articles/openflow-protocol-overview/)**

## reference

- **[ITU-T Y.3300](https://store.accuristech.com/asa/standards/itu-t-y-3300?product_id=2829252&srsltid=AfmBOorJTv7Di1r58x_YygzwiKn4QDtamc0JMim2sRDL8tMJRZ5XxHQs)

## ITU-T Y.3300 [ Active ]

Framework of software-defined networking

Full Description
This Recommendation describes the framework of software-defined networking (SDN) by providing:

– definitions,
– objectives,
– high-level capabilities,
– requirements, and
– high-level architecture
of the fundamentals of SDN.

In addition, Appendix I describes areas for further consideration in SDN standardization.

## OpenFlow

OpenFlow is one of the most popular SDN (Software-Defined Networking) protocols. It enables remote control of the OpenFlow switch data layer and managing QoS mechanisms. The first section of the article briefly introduces the layered network model and a reference SDN network model. Next, I will present the OpenFlow protocol used for SDN-OF (OpenFlow) switch communication. Finally, I will discuss the OpenFlow switch logical structure.

## Layered network model

A layered network model diagram is shown in Figure 1. It consists of 3 layers:

- control layer,
- management layer,
- data layer.

![f1](https://exatel.pl/app/uploads/sites/3/2020/10/Rys.1-Warstwowy-model-sieci-1_k-eng.jpg)**

The data layer implements packet processing and forwards them between network devices. The control layer is responsible for determining traffic flow rules applied within the data layer. The management layer implements configuration functionalities, failure detection and repair, status and resource load monitoring, as well as control access to network elements. It should be noted that all components executing the functionalities of both the data and control layers are subject to management.

## SDN network reference model

An SDN network reference model was shown in the ITU Y.3300 presentation and distinguishes between three SDN network layers:

- SDN Application layer,
- SDN Controller layer,
- Network Resource layer.

The aforementioned layers are managed by a multi-tier management function. Figure 2 shows the above layers and their primary functions.

![i1](https://exatel.pl/app/uploads/sites/3/2020/10/Rys.2-Model-referencyjny-sieci-SDN.-Na-podstawie-ITU-Y.3300-K-eng.jpg)

The SDN Application layer is responsible for executing business functionalities (e.g., network services such as L2VPN or L3VPN). It utilizes the programming interface made available by the SDN controller through which SDN apps can control network traffic and manage device resources. This interface is based on an abstract network model. The SDN controller layer enables SDN network orchestration functions. It is responsible for managing device resources and setting up transport connections at the request of an SDN application. It ensures SDN application and SDN control logics independence through introducing an abstract network model and network mechanisms. This model is converted into messages compatible with a given equipment type, upon establishing communication with a given device. The controller and device communicate via the SDN controller – hardware resources interface. This interface controls and manages a network device and can be executed by any number of communication protocols. The main functionality implemented within the network resources layer is processing and forwarding packets in accordance with flow rules installed by the SDN controller.

In summary, the primary feature of SDN techniques is transferring traffic flow logics to a logically central network element called an SDN controller. The controller has information on the configuration and status of all SDN devices, and a much higher computing power relative to a network device, which enables it to make better routing decisions. Furthermore, owing to functional simplification, SDN switches are potentially cheaper devices, which increases the business-wise attractiveness of an SDN network.

## OpenFlow protocol

The main feature of the OpenFlow protocol is enabling an SDN controller to control the OpenFlow switch. It establishes control layer functionalities and some management layer functionalities within a layered network model. It perfectly fits the SDN network reference model shown in the ITU Y.3300 presentation[1] by implementing the network resource control interface. Figure 3 shows a network built of OpenFlow switches, together with the SDN controller managing them.

![i2](https://exatel.pl/app/uploads/sites/3/2020/10/Rys.3-Siec-SDN-wykorzystujaca-Openflow-1_K-eng.jpg)

## OpenFlow protocol capabilities

The OpenFlow protocol enables:

- installation/deletion/modification of OF rules,
- installation/deletion/modification of OF groups,
- downloading statistics regarding OF rules, OF tables and OF ports,
- configuration of the meter mechanism implementing the network traffic flow policing function,
- downloading basic information of the OpenFlow switch.
- The OpenFlow protocol operating model coincides with the SDN network reference model presented in the previous chapter, and the OpenFlow protocol itself implements the SDN controller – network resources interface, since it enables logical central control over OF switches.

## OpenFlow switch control principles

An OpenFlow switch is controlled through installing OF rules in the format shown in Figure 4. A rule consists of a traffic flow definition (Match Fields), which determines the criteria to be satisfied by a frame, in order to be assigned to a given rule. The traffic flow definition is a list of structure-related entries {field/metadate name, mask, value}. Examples of such entries are:

- {IP_DST, 255.255.255.0, 45.3.233.0},
- {MAC_DST, FF:FF:FF:00:00:00, A2:A3:A4:00:00:00},
- {TCP_SRC, 0xCC00, 0}.

![i3](https://exatel.pl/app/uploads/sites/3/2020/10/Rys.4-Regula-Openflow.png)

Figure 4 – OpenFlow Rule

A priority defines rule assignment sequence, should a given frame match the multiple rule definition.

Counters store information on the number of bytes, data frames and rule lifetime.

Instructions control the traffic by directing to successive datapath structure elements (the term datapath will be discussed in the following chapter) and executing actions that modify packet headers. Table 1 lists the instructions with descriptions, in the order of their execution when processing the OpenFlow rule.

Timeout fields contain counters defining when a rule is to be deleted. A rule can be removed after a certain inactivity period and after a specified time since installation. It can also be installed permanently.

The cookie field value acts as a rule identifier that can be used during modification, deletion or downloading rule statistics.

Flags determine how the rules are managed.
