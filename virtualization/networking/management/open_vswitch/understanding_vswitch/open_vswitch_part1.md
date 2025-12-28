# **[Understanding Open vSwitch: Part 1](https://medium.com/@ozcankasal/understanding-open-vswitch-part-1-fd75e32794e4)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../a_status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## referenences

- **[This author series](https://medium.com/@ozcankasal)**
- **[Open VSwitch with KVM](https://docs.openvswitch.org/en/latest/howto/kvm/)**
- **[Open VSwitch tutorial](https://medium.com/@ozcankasal/understanding-open-vswitch-part-1-fd75e32794e4)**
- **[Open VSwitch and Windows](https://docs.openvswitch.org/en/latest/topics/windows/)**
- **[open vswitch and ExtremeXOS](https://documentation.extremenetworks.com/exos_22.1/GUID-29B4C015-BDBC-4D79-8CEF-3BDA3D57E676.shtml)**
- **[open vswitch and docker overlay](https://medium.com/@technbd/multi-hosts-container-networking-a-practical-guide-to-open-vswitch-vxlan-and-docker-overlay-70ec81432092)**

## undue network modifications

```bash
ip a
...
4: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 16:d5:61:24:58:41 brd ff:ff:ff:ff:ff:ff
5: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 36:ba:fd:a3:be:8c brd ff:ff:ff:ff:ff:ff
    inet6 fe80::34ba:fdff:fea3:be8c/64 scope link 
       valid_lft forever preferred_lft forever
6: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 42:c1:70:97:fe:11 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::40c1:70ff:fe97:fe11/64 scope link 
       valid_lft forever preferred_lft forever

# sudo ovs-vsctl add-br br0
sudo ovs-vsctl del-br br0

# notice eth1 and eth2 links were deleted also
ip a                     
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 98:90:96:b8:00:1c brd ff:ff:ff:ff:ff:ff
    altname enp0s25
    inet 10.188.40.125/24 brd 10.188.40.255 scope global noprefixroute eno1
       valid_lft forever preferred_lft forever

sudo ovs-vsctl show
e6f7b63d-5c04-4d4c-91ae-3476179d5956
    ovs_version: "3.3.0"

## delete flow rules

sudo ovs-ofctl del-flows br0 "in_port=eth1"
sudo ovs-ofctl del-flows br0 "in_port=eth2"
sudo ovs-ofctl dump-flows br0
cookie=0x0, duration=128225.574s, table=0, n_packets=1018, n_bytes=130083, priority=0 actions=NORMAL
```

## Open vSwitch

Open vSwitch is a production quality, multilayer, software-based, Ethernet virtual switch. It is designed to enable massive network automation through programmatic extension, while still supporting standard management interfaces and protocols (e.g. NetFlow, IPFIX, sFlow, SPAN, RSPAN, CLI, LACP, 802.1ag). In addition, it is designed
to support distribution across multiple physical servers similar to VMware's vNetwork distributed vswitch or Cisco's Nexus 1000V.

Welcome to the first phase of our Open vSwitch (OVS) journey! This post takes a closer look at a single bridge handling two VLANs, both with a common VLAN tag.

Open vSwitch (OVS) is an open-source, multilayer virtual switch designed to enable efficient networking within virtualized environments. It was initially developed by Nicira Networks and later became a collaborative project within the open-source community. OVS gained prominence due to its flexibility, scalability, and robust features, making it a popular choice for managing network connections in virtualized infrastructures.

The history of OVS dates back to its first release in 2009, and it has since evolved through contributions from a diverse community of developers. Its adoption has been widespread in various virtualization and cloud computing platforms.

One notable integration is with the OVN-Kubernetes plugin. OVN (Open Virtual Network) is a virtual networking subsystem that builds on OVS to provide additional features like logical switches, routers, and security groups. The OVN-Kubernetes plugin leverages OVS and OVN to enhance networking capabilities within Kubernetes clusters. This integration is crucial for orchestrating communication between containers and ensuring efficient networking in dynamic and scalable containerized environments.

The OVN-Kubernetes plugin extends the capabilities of OVS to provide network virtualization services in Kubernetes clusters, allowing for better isolation, scalability, and management of networking resources. This integration is especially significant in the context of containerized applications, where dynamic scaling and efficient networking are essential for the success of platforms like OpenShift and Kubernetes.

Open vSwitch (OVS) operates at the Data Link Layer (Layer 2) of the OSI model, making it a crucial component for managing Ethernet frames within virtualized environments. Here’s an explanation of how OVS operates at the L2 level and how it extends network segments:

## Switching and Forwarding

- OVS functions as a virtual switch, much like a physical Ethernet switch.
- It examines the MAC addresses in incoming Ethernet frames and uses a MAC address table to make forwarding decisions.

The MAC address table is where the switch stores information about the other Ethernet interfaces to which it is connected on a network. The table enables the switch to send outgoing data (Ethernet frames) on the specific port required to reach its destination, instead of broadcasting the data on all ports (flooding).

## MAC Address Learning

- OVS employs MAC address learning to build and maintain a table that maps MAC addresses to specific switch ports.
- When a frame arrives, OVS records the source MAC address and the port through which the frame entered.

## Broadcast and Multicast Handling

OVS handles broadcast and multicast frames, ensuring they are forwarded only to the relevant ports, minimizing unnecessary network traffic.

In networking, broadcast sends data to all devices on a network, while multicast sends data to specific groups of devices, offering a more efficient way to distribute information.

## Bridging and Bridging Domains

OVS creates bridges that act as virtual switches connecting multiple ports. Each bridge represents a bridging domain, allowing devices connected to different ports to be part of the same logical network.

## VLAN Tagging

OVS supports VLAN tagging, allowing the segmentation of a physical network into multiple logical networks (VLANs).
This feature enhances network isolation and security, as traffic from different VLANs does not interfere with each other.

## Tunneling

OVS can be configured to create tunnels between switches, enabling the extension of network segments across different physical locations or virtualized environments.
Common tunneling protocols used with OVS include VXLAN and GRE.

GRE (Generic Routing Encapsulation) is a tunneling protocol that encapsulates network layer protocols within virtual point-to-point links over an IP network, allowing for the transport of packets of one protocol over another.

VXLAN (Virtual Extensible LAN) is a tunneling protocol that encapsulates Layer 2 Ethernet frames in Layer 4 UDP packets, enabling virtualized Layer 2 networks to span physical Layer 3 networks, addressing the scalability limitations of traditional VLANs.

In the context of networking, a fabric edge device is a network device, like a switch or router, that connects wired or wireless endpoints to a Software-Defined Access (SDA) fabric, acting as the entry point for devices into the fabric and providing onboarding and mobility solutions.

Fabric Network: A fabric network is a logical group of devices managed as a single entity, enabling capabilities like virtual networks, user and device groups, and advanced reporting.

Underlay and Overlay: The fabric consists of an underlay (physical layer with switches and routers) and an overlay (virtualized layer for transporting user data).

Yes, OVS (Open vSwitch) is commonly used as part of a network fabric in data centers and cloud environments. OVS acts as a virtual switch, providing the switching and routing functionality within a network fabric, especially in Software-Defined Networking (SDN) setups.

## Lab Setup

## install **[ubuntu servers](https://www.youtube.com/watch?app=desktop&v=ElNalqvVaPw&t=153)**

While installing ubuntu choose bridge network and the physical network adapter. This will allow you to install python.

Make sure you select ssh so you can login from your dev system while you are installing stuff.

```bash
# Don't think you need to install guest additions.
sudo mkdir -p /media/cdrom
sudo mount /dev/cdrom /media/cdrom
sudo apt install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r)
sudo /media/cdrom/VBoxLinuxAdditions.run

# disable cloud.init

# To disable cloud-init, create the empty file /etc/cloud/cloud-init.disabled
touch /etc/cloud/cloud-init.disabled 
ssh brent@172.24.188.72

# install python uv and create
mkdir -p ~/src
cd ~/src/
uv init my-flask-app
uv add flask
touch app.py
vi app.py
```

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
  return "Hello, World from Flask and uv!"

if __name__ == "__main__":
  app.run(host="0.0.0.0")
```

run app

```bash
uv run app.py
```

> python3 -m http.server --bind 192.168.1.20 8443

In this tutorial we will be using an Ubuntu host with Virtualbox installed. First of all, we need to install the necessary packages to use open vswitch.

```bash
sudo apt-get update
sudo apt-get install openvswitch-switch
```

Now we can confirm that open vswitch is up and running with the following command:

```bash
sudo ovs-vsctl show

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

**Note: My installation did not add a default bridge.**

Also we can list the network interfaces to see that ovs has created two interface, “br-int” and “ovs-system”.

```bash
> ip link show

4: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 7a:77:b8:37:bb:e9 brd ff:ff:ff:ff:ff:ff
8: br-int: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 96:bd:cc:37:a8:b8 brd ff:ff:ff:ff:ff:ff
```

Now we will create the components to explore ovs capabilities.

![ovs](https://miro.medium.com/v2/resize:fit:720/format:webp/1*ILxzaEXy-LzqXqHxsXoGlg.png)(())

Create an OVS bridge:

We use the following commands to create an ovs bridge (br0), confirm it and the related network interface (br0).

On my installation the internal bridge, br-int, was never created.

```bash
sudo ovs-vsctl add-br br0
sudo ovs-vsctl show

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
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 98:90:96:b8:00:1c brd ff:ff:ff:ff:ff:ff
    altname enp0s25
3: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b6:40:e3:2a:93:28 brd ff:ff:ff:ff:ff:ff
4: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 16:d5:61:24:58:41 brd ff:ff:ff:ff:ff:ff
```

![il](https://miro.medium.com/v2/resize:fit:720/format:webp/1*ILxzaEXy-LzqXqHxsXoGlg.png)

Now we need two OVS switch port to represent our physical networks. Use the following commands to create ports and add VLAN tags. Here we give “tag=10” to both ports so that the hosts in these interfaces can communicate with default settings.

In Open vSwitch (OVS), a port is essentially a connection point or an interface that allows a bridge to interact with other network elements, including physical network interfaces, VMs, or other bridges. Think of it as a way for traffic to enter or leave the bridge.
Here's a more detailed explanation:

In Open vSwitch (OVS), an "internal port" is a port that exists within the OVS bridge itself, not a physical interface connected to the bridge.

```bash
sudo ovs-vsctl add-port br0 eth1 tag=10 -- set interface eth1 type=internal
sudo ovs-vsctl add-port br0 eth2 tag=10 -- set interface eth2 type=internal
```

Now if we list the OVS components again, we see the details of the ports we created, and we can list the network interfaces to see that two new interfaces have been created. You should set the new interfaces as up (see the commands below).
mdf

```bash
sudo ovs-vsctl show
2754d6a1-4c15-4a41-bb9e-185bd0cf18a1
    Bridge br0
        Port br0
            Interface br0
                type: internal
        Port eth1
            tag: 10
            Interface eth1
                type: internal
        Port eth2
            tag: 10
            Interface eth2
                type: internal
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port br-int
            Interface br-int
                type: internal
    ovs_version: "2.17.7"

sudo ip link set dev eth1 up
sudo ip link set dev eth2 up

tcpdump -i bond0 -nn -e  vlan

ip link show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eno1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP mode DEFAULT group default qlen 1000
    link/ether 98:90:96:b8:00:1c brd ff:ff:ff:ff:ff:ff
    altname enp0s25
3: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether b6:40:e3:2a:93:28 brd ff:ff:ff:ff:ff:ff
4: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 16:d5:61:24:58:41 brd ff:ff:ff:ff:ff:ff
5: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 42:c1:70:97:fe:11 brd ff:ff:ff:ff:ff:ff
6: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/ether 36:ba:fd:a3:be:8c brd ff:ff:ff:ff:ff:ff
```

Now create two virtual machines on Virtualbox. To establish two virtual machines on VirtualBox, employ an Ubuntu Server image for their instantiation. In the network settings, opt for the “Bridged Adapter” configuration and select “Paravirtualized Network (virtio-net)” as the Adapter Type. This specific adapter type, namely virtio-net, facilitates the utilization of advanced features such as VLAN tagging. The selection of “Bridged Adapter” ensures that the virtual machines are connected directly to the host’s physical network, allowing them to operate as individual entities within the broader network infrastructure. This configuration enhances network flexibility and supports the implementation of VLANs for improved network segmentation and management.

![vmware](https://miro.medium.com/v2/resize:fit:720/format:webp/1*G9XvUnIVGm6w9x8HfMsoYA.png)

```bash
Now add ip addresses to the network interfaces in virtual machines (we do not add any ip addresses to network interfaces on the host machine).

# On VM1 (test1)
sudo ip addr add 192.168.1.10/24 dev enp0s3

# On VM2 (test2)
sudo ip addr add 192.168.1.20/24 dev enp0s3
```

Confirm if the new ip numbers are added with the following command. You should see the ip address listed:

```bash
# On VM1 (test1), repeat for VM2
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:4d:b2:f6 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.10/24 brd 192.168.1.255 scope global enp0s3
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe4d:b2f6/64 scope link 
       valid_lft forever preferred_lft forever
```

This completes our setup. Now let’s examine the components and OVS bridge details.

## How it works?

In the absence of an Open vSwitch (OVS) setup, default virtual machine communication on different network interfaces (e.g., eth1 and eth2) is hindered, regardless of the assigned IP addresses. When attempting communication from one virtual machine (e.g., VM1) to another (e.g., VM2), the destination host’s MAC address must be known for proper packet forwarding. OVS bridges address this by maintaining records of MAC addresses associated with the ports they manage.

The command sudo ovs-appctl fdb/show br0 reveals details, including MAC addresses and associated ports, aiding in the identification of VMs.

ovs-appctl is a command-line utility in Open vSwitch (OVS) that allows you to send commands to and receive responses from running OVS daemons. It's used for managing and querying OVS daemons, including ovs-vswitchd and ovs-controller

```bash
sudo ovs-appctl fdb/show br0
 port  VLAN  MAC                Age
    4    10  08:00:27:92:62:0a    0
    3    10  08:00:27:4d:b2:f6    0
```

For instance, “08:00:27:4d:b2:f6” corresponds to VM1 (test1), while “08:00:27:92:62:0a” belongs to VM2 (test2), as confirmed with the “ip a” command on the virtual machines. To facilitate inter-VM communication, OVS bridges employ VLAN tagging on bridge ports, indicating the VLAN tag associated with each port. This enables the bridge to scrutinize destination host MAC addresses and efficiently forward packets based on VLAN information, ensuring accurate communication between virtual machines on the specified VLAN.

## VLAN Tags

Virtual LANs (VLANs) are a networking technology that enables the segmentation of a single physical network into multiple logical networks, providing enhanced network isolation and security. The IEEE 802.1Q standard defines the VLAN tagging protocol, which adds a 4-byte VLAN tag to the Ethernet frame header. This tag includes information such as the VLAN ID, which identifies the specific VLAN to which the frame belongs. VLAN tagging allows network administrators to logically partition a network, isolating broadcast domains and enhancing network scalability. In a data frame, the VLAN tag is inserted into the Ethernet frame between the Source MAC Address and EtherType fields. It plays a crucial role in facilitating the distinction and proper routing of traffic between different VLANs within a network, contributing to efficient network management and improved security by creating distinct broadcast domains within a shared physical infrastructure.

![vlt](https://miro.medium.com/v2/resize:fit:640/format:webp/0*h4T42eLjeMImt7Kx.jpg)

In our case, when a package is received by the OVS bridge, it adds a VLAN tag to the package and forwards to the router, and when router forwards to package to the OVS bridge again, it strips that tag and forward package to the destination port. That’s why this tag is not visible on our VLANs “eth1” and “eth2”. We can confirm that using wireshark or `tcpdump -i eth1 -nn -e  vlan`.

First let’s start a web server on vm2 using python3.

```bash
# install python uv and create
mkdir -p ~/src
cd ~/src/
uv init my-flask-app
cd ~/src/my-flask-app
uv add flask
touch app.py
vi app.py
```

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
  return "Hello, World from Flask and uv!"

if __name__ == "__main__":
  app.run(host="0.0.0.0")
```

run app

```bash
uv run app.py
```

Now we can send a request to vm2 from vm1 using curl command and start watching the traffic using wireshark.

```bash
curl http://192.168.1.10 5000
```

As you can see in the screenshot below, the ethernet frame does not have a 802.1Q field.

![ws](https://miro.medium.com/v2/resize:fit:720/format:webp/1*DdL9lHqy_LKOxkavT6UWcw.png)
In conclusion, we’ve explored the fundamental role of Open vSwitch (OVS) in enabling communication between virtual machines (VMs) on different network interfaces. OVS bridges, with their MAC address learning and VLAN tagging capabilities, enhance network isolation and facilitate efficient packet forwarding. In upcoming posts, we’ll delve deeper into OVS’s capabilities, examining scenarios involving multiple VLANs within a single bridge and controlling flows between them. Additionally, we’ll explore the configuration of two bridges with VLANs sharing the same tag, showcasing OVS’s versatility in managing complex network architectures. Stay tuned for further insights into maximizing the potential of Open vSwitch in virtualized environments.
