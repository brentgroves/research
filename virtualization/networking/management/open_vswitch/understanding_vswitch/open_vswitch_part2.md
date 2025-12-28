# **[Understanding Open vSwitch: Part 2](https://medium.com/@ozcankasal/understanding-open-vswitch-part-2-372594d92e78)**

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

Welcome back to the second part of our Open vSwitch (OVS) exploration journey! In Part 1, we delved into the intricacies of configuring a single bridge handling two VLANs, both tagged with a common VLAN ID. Our network setup involved two virtual machines, “test1” and “test2,” connected to OVS ports “eth1” and “eth2,” respectively. The initial VLAN configuration allowed seamless communication between the VMs, demonstrating the efficiency of OVS in managing VLAN-tagged traffic. However, as we venture into Part 2, we encounter a challenge: a modification in the VLAN tag of “eth2” from 10 to 20. This seemingly straightforward alteration disrupts the previously established connectivity, prompting us to unravel the underlying concepts of OVS flows and understand how these changes impact the network dynamics.

Now we know that when “eth1” and “eth2” have a common VLAN ID tag, ovs bridge “br0” knows how to handle the traffic between “eth1” and “eth2”.

![svl](https://miro.medium.com/v2/resize:fit:720/format:webp/1*v52jt-ShSg268k6eEb0_7w.png)

For the second part of the journey, we simply change the VLAN tag of “eth2” from “10” to “20”. To do this, use the command below and check the result.

```bash
# sudo ovs-vsctl set Port eth2 tag=10
sudo ovs-vsctl set Port eth2 tag=20
# ovs-vsctl connects to an ovsdb-server process that maintains an Open vSwitch configuration database.
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
            tag: 20
            Interface eth2
                type: internal
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port br-int
            Interface br-int
                type: internal
    ovs_version: "2.17.7"
```

As in the first blog post, run a web server on vm “test2”.

```bash
# install python uv and create

mkdir -p ~/src
cd ~/src/
uv init my-flask-app
cd my-flask-app
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

Check the connection using “curl” command and confirm that there is no access between virtual machines.

```bash
> curl http://192.168.1.20:5000
*   Trying 192.168.1.20:8443...
* connect to 192.168.1.20 port 8443 after 18383 ms: No route to host
* Closing connection 0
curl: (7) Failed to connect to 192.168.1.20 port 8443 after 18383 ms: No route to host
```

So, what’s the problem now?

- The journey of this request package is like a carefully planned route. Starting from “test1” with an address of 192.168.1.10 and a label (VLAN tag) of 10, it first goes through a place called OVS Bridge “br0.” Here, a door called “eth1” is ready to accept messages labeled with 10. It lets the message pass smoothly.
- But the interesting part comes when the message reaches another door, “eth2,” set up for messages labeled with 20. The message, however, carries a 10 label. This creates a little confusion because there’s no plan (flow) for messages labeled 10 at this door. So, temporarily, the message can’t move forward.

## Magic of OVS Flows and Openflow Protocol

Now, let’s take a peek into the fascinating realm of OVS flows, especially when it comes to communication between different bridges. Think of OVS flows as the choreography that guides messages between bridges, orchestrating a seamless dance in the virtual world using a protocol called the OpenFlow protocol.

When a message travels from one bridge to another, OVS flows act as the coordinators, ensuring a smooth transition. These flows comprise a set of rules that dictate how messages are handled — specifying where they go, how they’re tagged, and what actions to take. This meticulous planning becomes crucial in scenarios like our VLAN-tagged adventure, as it determines how each bridge interprets and passes on messages.

The OpenFlow protocol is a key enabler of Software-Defined Networking (SDN), providing a standardized communication interface between the control and forwarding planes of network devices. In traditional network architectures, these planes are tightly integrated within the network devices themselves. However, OpenFlow abstracts and separates them, allowing for centralized control and programmability.

The network forwarding plane, also known as the data plane, is the part of a network device responsible for actually forwarding network packets from one interface to another, based on instructions from the control plane

- Control and Forwarding Planes Separation: In a traditional network switch or router, the control plane, responsible for making decisions about where to forward traffic, and the forwarding plane, responsible for actually moving the packets based on those decisions, are tightly coupled. OpenFlow breaks this tight integration by introducing a standardized interface.

- Standardized Communication: OpenFlow defines a standardized set of protocols and messages that facilitate communication between the centralized controller and the distributed forwarding devices. This communication occurs over a secure channel.

- Flow-based Forwarding: OpenFlow operates on the principle of flow-based forwarding. Instead of making individual packet forwarding decisions, network devices make decisions based on predefined flows, which are sets of rules that dictate how specific types of traffic should be handled.

- Centralized Control: The OpenFlow controller becomes the brain of the network, making decisions about traffic flows and instructing the forwarding devices (such as switches and routers) on how to handle those flows.

- Programmability and Flexibility: OpenFlow’s programmability allows network administrators to define and modify network behavior dynamically. This flexibility is crucial for adapting to changing network conditions, optimizing traffic, and implementing specific policies.

- Software-Defined Networking (SDN): OpenFlow is a foundational element of SDN, a network architecture that emphasizes the programmability and automation of network management. SDN enables the creation of intelligent, responsive, and easily manageable networks.

- Standardization and Vendor Neutrality: OpenFlow is an open standard, promoting interoperability among networking equipment from different vendors. This standardization reduces vendor lock-in and encourages innovation in network design and management.

Open vSwitch with the OpenFlow protocol provides a powerful set of capabilities through the ovs-ofctl tool. Here's a general list of capabilities that can be achieved using OVS flows with ovs-ofctl:

- Packet Forwarding: Define how packets are forwarded based on criteria like source/destination MAC addresses, IP addresses, VLAN tags, etc.
- VLAN Tagging and Trunking: Set and modify VLAN tags, allowing for the segmentation of traffic into virtual LANs.
- Quality of Service (QoS): Prioritize or rate-limit traffic based on characteristics such as DSCP (Differentiated Services Code Point) values or packet sizes.
- Load Balancing: Distribute traffic across multiple paths or servers, improving resource utilization and balancing the network load.
- Access Control Lists (ACLs): Implement security policies by defining rules to permit or deny traffic based on various packet attributes.
- Mirroring and Monitoring: Mirror selected traffic to a monitoring port for analysis, facilitating network troubleshooting and monitoring.
- Network Tunnels: Set up and manage network tunnels, enabling communication between geographically distributed networks.
- Flow Modification: Dynamically modify existing flows to adapt to changing network conditions or requirements.
- Timeouts and Aging: Set timeouts to automatically remove flows after a certain period, preventing unnecessary resource usage.
- Controller Interaction: Establish communication with external controllers, enabling centralized network management and SDN (Software-Defined Networking) capabilities.

These capabilities showcase the versatility and flexibility that OVS flows, managed through ovs-ofctl, bring to the table in terms of network configuration, optimization, and security.

## Troubleshooting the connection problem

When troubleshooting connection issues between VLANs in Open vSwitch (OVS), the ovs-appctl and ovs-ofctl commands can provide valuable information. Let's go through some commands and their expected outputs to demonstrate the troubleshooting process.

To monitor the statistics for each port on the “br0” bridge, use the following command.

```bash
> sudo ovs-ofctl dump-ports br0
OFPST_PORT reply (xid=0x2): 3 ports
  port  eth2: rx pkts=226, bytes=22287, drop=28, errs=0, frame=0, over=0, crc=0
           tx pkts=443, bytes=60526, drop=0, errs=0, coll=0
  port LOCAL: rx pkts=407, bytes=54695, drop=452, errs=0, frame=0, over=0, crc=0
           tx pkts=37, bytes=4043, drop=0, errs=0, coll=0
  port  eth1: rx pkts=660, bytes=73321, drop=0, errs=0, frame=0, over=0, crc=0
           tx pkts=524, bytes=61979, drop=0, errs=0, coll=0
```

Here we see that packages are dropped at port “eth2” as expected.

To control the flow between ports we need to define flow controls. To see the default rules, we use the following command.

```bash
> sudo ovs-ofctl dump-flows br0

cookie=0x0, duration=126900.984s, table=0, n_packets=1012, n_bytes=129831, priority=0 actions=NORMAL
```

There is only one rule with “priority=0, actions=NORMAL” (other lines are about controller actions, no need to

- Priority: The priority of 0 makes this flow the lowest priority, ensuring it’s a fallback for unmatched packets.
- Actions: NORMAL instructs OVS to process the packet using the default behavior for Ethernet frames. This typically means forwarding the packet based on the destination MAC address without any special treatment.

While this default flow doesn’t explicitly drop packets, it doesn’t include any VLAN-specific actions. As a result, if you have VLAN-tagged packets (for example, coming from “eth1” with VLAN 10 or “eth2” with VLAN 20), they might not be handled correctly for inter-VLAN communication.

To fix our connection problem let’s add two flow rules to provide bidirectional permission between ports “eth1” and “eth2”.

```bash
sudo ovs-ofctl add-flow br0 "in_port=eth1,actions=output:eth2"
sudo ovs-ofctl add-flow br0 "in_port=eth2,actions=output:eth1"
> sudo ovs-ofctl dump-flows br0

 cookie=0x0, duration=18.800s, table=0, n_packets=8, n_bytes=569, in_port=eth1 actions=output:eth2
 cookie=0x0, duration=13.707s, table=0, n_packets=7, n_bytes=1204, in_port=eth2 actions=output:eth1
 cookie=0x0, duration=127232.475s, table=0, n_packets=1018, n_bytes=130083, priority=0 actions=NORMAL
 ```

 These commands manually add flows to the OpenFlow table of the “br0” bridge. The first flow instructs that packets coming in from “eth1” should be forwarded out through “eth2,” and the second flow instructs the opposite, where packets from “eth2” should be forwarded out through “eth1.”

- By adding specific flows for inter-VLAN communication between “eth1” and “eth2,” we have effectively directed traffic between these ports without relying solely on the default behavior.
- These manual flows take precedence over the default flow and ensure that packets between “eth1” and “eth2” are explicitly forwarded, addressing the issue of connection blocking between VLANs.

The flows we added provide explicit instructions for handling traffic between the specified ports, ensuring that VLAN-tagged packets are processed correctly for inter-VLAN communication.

The capabilities of the OpenFlow protocol exceeds the scope of this post, but let’s update the flow rules to allow only ICMP traffic (the protocol when we ping a destination ip).

First we delete the current flow rules

```bash
sudo ovs-ofctl del-flows br0 "in_port=eth1"
sudo ovs-ofctl del-flows br0 "in_port=eth2"
sudo ovs-ofctl dump-flows br0
cookie=0x0, duration=128225.574s, table=0, n_packets=1018, n_bytes=130083, priority=0 actions=NORMAL
 ```

Now try “curl” connection again.

```bash
curl http://192.168.1.20:5000
*   Trying 192.168.1.20:8443...
* connect to 192.168.1.20 port 8443 after 3062 ms: No route to host
* Closing connection 0
curl: (7) Failed to connect to 192.168.1.20 port 8443 after 3062 ms: No route to host
```

As we see from the output, TCP connection is not successful.

When a device on a local network wants to discover the MAC (Media Access Control) address corresponding to a specific IP address, it sends an ARP request. ARP requests are typically encapsulated within IPv4 frames. The ARP packet itself contains the details of the IP address for which the MAC address is being sought. The Ethernet frame has an EtherType field that indicates the type of the payload. In the case of ARP, the EtherType is usually set to 0x0806. But since it is encapsulated in an IPv4 frame we also need to allow EtherType 0x0800 as well, but restrict to nw_proto=1 to mention ICMP protocol in IPv4 frame. So use the following commands.

In OpenFlow and Open vSwitch, "nw_proto" refers to the protocol identifier for the network layer (Layer 3) of a packet, specifically the IP protocol type for IPv4 packets or the IPv6 protocol field. It's used in flow matching to filter and route packets based on the network protocol, such as TCP, UDP, or ICMP.

**[ovs fields](https://www.openvswitch.org/support/dist-docs/ovs-fields.7.txt)**

```bash
sudo ovs-ofctl add-flow br0 "in_port=eth1,dl_type=0x0806,actions=output:eth2"
sudo ovs-ofctl add-flow br0 "in_port=eth1,dl_type=0x0800,nw_proto=1,actions=output:eth2"
sudo ovs-ofctl add-flow br0 "in_port=eth2,dl_type=0x0806,actions=output:eth1"
sudo ovs-ofctl add-flow br0 "in_port=eth2,dl_type=0x0800,nw_proto=1,actions=output:eth1"
sudo ovs-ofctl dump-flows br0
 cookie=0x0, duration=72.739s, table=0, n_packets=2, n_bytes=84, arp,in_port=eth1 actions=output:eth2
 cookie=0x0, duration=64.355s, table=0, n_packets=2, n_bytes=84, arp,in_port=eth2 actions=output:eth1
 cookie=0x0, duration=44.252s, table=0, n_packets=2, n_bytes=196, icmp,in_port=eth1 actions=output:eth2
 cookie=0x0, duration=37.903s, table=0, n_packets=2, n_bytes=196, icmp,in_port=eth2 actions=output:eth1
 cookie=0x0, duration=130317.047s, table=0, n_packets=1364, n_bytes=147447, priority=0 actions=NORMAL
 ```

EtherType is a two-octet field in an Ethernet frame. It is used to indicate which protocol is encapsulated in the payload of the frame and is used at the receiving end by the data link layer to determine how the payload is processed.

In the context of networking, "fabric attached assignments" refers to the process of dynamically mapping VLANs to specific network services (identified by I-SIDs) for devices connected to a fabric network, enabling seamless service extension and automation.

Now try to ping again and confirm that you can send ping requests to both virtual machines. And try to send an http request with curl and see that it is blocked.

Let’s add new flow rules to allow TCP traffic to destination port 5000.

**[syntax](https://www.openvswitch.org/support/dist-docs/ovs-ofctl.8.html)

- dl_type: layer 2 data link
- nw_type: layer 3 network
- nw_proto=6 // what?

```bash

sudo ovs-ofctl add-flow br0 "in_port=eth1,dl_type=0x0800,nw_proto=6,tp_dst=5000,actions=output:eth2"
sudo ovs-ofctl add-flow br0 "in_port=eth2,dl_type=0x0800,nw_proto=6,tp_src=5000,actions=output:eth1"
# this deletion removed everything from br0 except the default
# sudo ovs-ofctl del-flows br0 "tp_src=8443"

sudo ovs-ofctl dump-flows br0 
```

Here we added a rule for eth1 -> eth2 traffic using “nw_proto=6, tp_dst=8443” and a rule for eth2 -> eth1 traffic using “nw_proto=6, tp_src=8443”. Now use curl to test the connection and see that you can successfully get a response. (Do not forget to run python server on test2).

Congratulations! You have successfully configured your initial OpenFlow rules in Open vSwitch to manage network traffic between VLANs. By specifying flows that allow ARP, IPv4, and TCP traffic in both directions between “eth1” and “eth2,” you have created a foundation for controlling communication within your virtual network. These rules enable the exchange of essential networking protocols and pave the way for more advanced configurations based on your specific requirements.

Cheers to your exploration of network virtualization and software-defined networking with Open vSwitch!

Resources
<https://ovs.readthedocs.io/en/latest/faq/openflow.html>
<http://www.openvswitch.org//support/dist-docs/ovs-ofctl.8.html>
<https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml>
<https://randomsecurity.dev/posts/openvswitch-cheat-sheet/>

- **[OpenFlow Matching](http://rlenglet.github.io/openfaucet/match.html#:~:text=If%20the%20L3%20protocol%20is,openfaucet%20import%20ofmatch%20ip_addr%20=%20socket.)**

In the context of OpenFlow and network configuration, nw_proto refers to the IP protocol type (e.g., TCP, UDP, ICMP) when matching packets based on the network layer protocol. It's a decimal number between 0 and 255 used to identify the protocol.

- IP Protocol Type:
When dl_type (the Ethernet type) is set to 0x0800 (IPv4), nw_proto specifies the IP protocol type, such as **6 for TCP**, 17 for UDP, or 1 for ICMP.

Here we added a rule for eth1 -> eth2 traffic using “nw_proto=6, tp_dst=8443” and a rule for eth2 -> eth1 traffic using “nw_proto=6, tp_src=8443”. Now use curl to test the connection and see that you can successfully get a response. (Do not forget to run python server on test2).

Congratulations! You have successfully configured your initial OpenFlow rules in Open vSwitch to manage network traffic between VLANs. By specifying flows that allow ARP, IPv4, and TCP traffic in both directions between “eth1” and “eth2,” you have created a foundation for controlling communication within your virtual network. These rules enable the exchange of essential networking protocols and pave the way for more advanced configurations based on your specific requirements.

Cheers to your exploration of network virtualization and software-defined networking with Open vSwitch!

Resources
<https://ovs.readthedocs.io/en/latest/faq/openflow.html>
<http://www.openvswitch.org//support/dist-docs/ovs-ofctl.8.html>
<https://www.iana.org/assignments/protocol-numbers/protocol-numbers.xhtml>
<https://randomsecurity.dev/posts/openvswitch-cheat-sheet/>
