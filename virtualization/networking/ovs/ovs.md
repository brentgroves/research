# **[Understanding Open vSwitch: Part 1](https://medium.com/@ozcankasal/understanding-open-vswitch-part-1-fd75e32794e4)**

Welcome to the first phase of our Open vSwitch (OVS) journey! This post takes a closer look at a single bridge handling two VLANs, both with a common VLAN tag.

Open vSwitch (OVS) is an open-source, multilayer virtual switch designed to enable efficient networking within virtualized environments. It was initially developed by Nicira Networks and later became a collaborative project within the open-source community. OVS gained prominence due to its flexibility, scalability, and robust features, making it a popular choice for managing network connections in virtualized infrastructures.

The history of OVS dates back to its first release in 2009, and it has since evolved through contributions from a diverse community of developers. Its adoption has been widespread in various virtualization and cloud computing platforms.

One notable integration is with the OVN-Kubernetes plugin. OVN (Open Virtual Network) is a virtual networking subsystem that builds on OVS to provide additional features like logical switches, routers, and security groups. The OVN-Kubernetes plugin leverages OVS and OVN to enhance networking capabilities within Kubernetes clusters. This integration is crucial for orchestrating communication between containers and ensuring efficient networking in dynamic and scalable containerized environments.

The OVN-Kubernetes plugin extends the capabilities of OVS to provide network virtualization services in Kubernetes clusters, allowing for better isolation, scalability, and management of networking resources. This integration is especially significant in the context of containerized applications, where dynamic scaling and efficient networking are essential for the success of platforms like OpenShift and Kubernetes.

Open vSwitch (OVS) operates at the Data Link Layer (Layer 2) of the OSI model, making it a crucial component for managing Ethernet frames within virtualized environments. Here’s an explanation of how OVS operates at the L2 level and how it extends network segments:

Switching and Forwarding:

OVS functions as a virtual switch, much like a physical Ethernet switch.
It examines the MAC addresses in incoming Ethernet frames and uses a MAC address table to make forwarding decisions.

MAC Address Learning:

OVS employs MAC address learning to build and maintain a table that maps MAC addresses to specific switch ports.
When a frame arrives, OVS records the source MAC address and the port through which the frame entered.

Broadcast and Multicast Handling:

OVS handles broadcast and multicast frames, ensuring they are forwarded only to the relevant ports, minimizing unnecessary network traffic.

Bridging and Bridging Domains:

OVS creates bridges that act as virtual switches connecting multiple ports.
Each bridge represents a bridging domain, allowing devices connected to different ports to be part of the same logical network.

## VLAN Tagging

OVS supports VLAN tagging, allowing the segmentation of a physical network into multiple logical networks (VLANs).
This feature enhances network isolation and security, as traffic from different VLANs does not interfere with each other.

Tunneling:

OVS can be configured to create tunnels between switches, enabling the extension of network segments across different physical locations or virtualized environments.
Common tunneling protocols used with OVS include VXLAN and GRE.

## Lab Setup

In this tutorial we will be using an Ubuntu host with Virtualbox installed. First of all, we need to install the necessary packages to use open vswitch.

```bash
sudo apt-get update
sudo apt-get install openvswitch-switch
```

Now we can confirm that open vswitch is up and running with the following command:

```bash
> sudo ovs-vsctl show

2754d6a1-4c15-4a41-bb9e-185bd0cf18a1
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port br-int
            Interface br-int
                type: internal
    ovs_version: "2.17.7"
```

Here we see that OVS has already added a default bridge which is used for internal network of OVS.

Also we can list the network interfaces to see that ovs has created two interface, “br-int” and “ovs-system”.

```bash
> ip link show

4: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 7a:77:b8:37:bb:e9 brd ff:ff:ff:ff:ff:ff
8: br-int: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 96:bd:cc:37:a8:b8 brd ff:ff:ff:ff:ff:ff
```

Now we will create the components to explore ovs capabilities.

![i1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*ILxzaEXy-LzqXqHxsXoGlg.png)

Create an OVS bridge:

We use the following commands to create an ovs bridge (br0), confirm it and the related network interface (br0).

```bash
> sudo ovs-vsctl add-br br0
> sudo ovs-vsctl show

ozcan@lenovo:~$ sudo ovs-vsctl show
2754d6a1-4c15-4a41-bb9e-185bd0cf18a1
    Bridge br0
        Port br0
            Interface br0
                type: internal
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port br-int
            Interface br-int
                type: internal
    ovs_version: "2.17.7"

> ip link show

4: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 7a:77:b8:37:bb:e9 brd ff:ff:ff:ff:ff:ff
8: br-int: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 96:bd:cc:37:a8:b8 brd ff:ff:ff:ff:ff:ff
20: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noqueue state DOWN mode DEFAULT group default qlen 1000
    link/ether 5a:a4:45:af:da:49 brd ff:ff:ff:ff:ff:ff
```

Now we need two OVS switch port to represent our physical networks. Use the following commands to create ports and add VLAN tags. Here we give “tag=10” to both ports so that the hosts in these interfaces can communicate with default settings.

```bash
> sudo ovs-vsctl add-port br0 eth1 tag=10 -- set interface eth1 type=internal
> sudo ovs-vsctl add-port br0 eth2 tag=10 -- set interface eth2 type=internal
```
