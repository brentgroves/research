# **[Understanding Open vSwitch: Part 3](https://medium.com/@ozcankasal/understanding-open-vswitch-part-3-3c04e03dbda9)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../a_status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## referenences

- **[OVN on Ubuntu](https://documentation.ubuntu.com/lxd/stable-5.0/howto/network_ovn_setup/)**
- **[Open Virtual Network](https://discuss.linuxcontainers.org/t/ovn-high-availability-cluster-tutorial/11033)**
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

In the first part of our Open vSwitch series, we covered the basics, setting up a simple switch with one bridge and two ports sharing a common VLAN tag. In Part 2, we explored OpenFlow rules with a single bridge and two ports, each having different VLAN tags.

Now, in Part 3, we’re taking it a step further. We’ll look into a network setup with two bridges, each having one port with the same VLAN tag. This means extending a VLAN across two bridges at L2 level. To make this work, we’ll introduce patch ports between the bridges, explaining how they enable smooth communication and VLAN extension in this more complex setup.

![i1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*3mOYCBMhT97BDcJQxo68tA.png)

For this part of the series I will use two Open VSwitch bridges and to each will be attached a port with the same vlan tag.

```bash
sudo ovs-vsctl add-br br0
sudo ovs-vsctl add-br br1
sudo ovs-vsctl show

sudo ovs-vsctl add-port br0 eth1 tag=10 -- set interface eth1 type=internal
sudo ovs-vsctl show

e6f7b63d-5c04-4d4c-91ae-3476179d5956
    Bridge br0
        Port eth1
            tag: 10
            Interface eth1
                type: internal
        Port br0
            Interface br0
                type: internal

sudo ovs-vsctl add-port br1 eth2 tag=10 -- set interface eth2 type=internal
...
    Bridge br1
        Port eth2
            tag: 10
            Interface eth2
                type: internal
        Port br1
            Interface br1
                type: internal
    ovs_version: "3.3.0"

ip a
7: ovs-system: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether b6:40:e3:2a:93:28 brd ff:ff:ff:ff:ff:ff
8: br0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 56:a2:c0:a9:74:44 brd ff:ff:ff:ff:ff:ff
9: br1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 46:1e:c3:f1:77:44 brd ff:ff:ff:ff:ff:ff
10: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 42:c1:70:97:fe:11 brd ff:ff:ff:ff:ff:ff
11: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 36:ba:fd:a3:be:8c brd ff:ff:ff:ff:ff:ff
```

We understand that when VLAN tags are identical, the individual bridges can effectively manage packages for the associated ports. However, the question arises: how do we establish the necessary connection between these bridges?

## Patch Ports

Patch ports in Open vSwitch are virtual ports that act as a connection point between two bridges. They enable the flow of traffic between the bridges, allowing for communication and the extension of VLANs across multiple bridges. Patch ports are typically used to interconnect different parts of a network, creating a link between separate bridge domains.

To connect two bridges, you need to create patch ports on each bridge that will serve as the connection points.

```bash
sudo ovs-vsctl add-port br0 patch-br0-br1 -- set interface patch-br0-br1 type=patch options:peer=patch-br1-br0

sudo ovs-vsctl show                                                           e6f7b63d-5c04-4d4c-91ae-3476179d5956
    Bridge br0
        Port patch-br0-br1
            Interface patch-br0-br1
                type: patch
                options: {peer=patch-br1-br0}
                error: "No usable peer 'patch-br1-br0' exists in 'system' datapath."

ovs-vsctl add-port br1 patch-br1-br0 -- set interface patch-br1-br0 type=patch options:peer=patch-br0-br1

sudo ovs-vsctl show
   Bridge br1
        Port eth2
            tag: 10
            Interface eth2
                type: internal
        Port patch-br1-br0
            Interface patch-br1-br0
                type: patch
                options: {peer=patch-br0-br1}
        Port br1
            Interface br1
                type: internal
    ovs_version: "3.3.0"
```

- Patch ports enable the extension of VLANs across bridges. VLAN-tagged traffic can seamlessly traverse from one bridge to another.
- The options:peer parameter in the commands ensures that the patch ports are linked. The value should be set to the name of the patch port on the other bridge.
- Each bridge maintains its own set of rules and configurations, ensuring a level of isolation between different parts of the network.
- Patch ports provide flexibility in designing network topologies. They allow you to connect different segments of your network as needed.

## notice both interfaces are down

```bash
ip a
...
10: eth1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 42:c1:70:97:fe:11 brd ff:ff:ff:ff:ff:ff
11: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 36:ba:fd:a3:be:8c brd ff:ff:ff:ff:ff:ff
sudo ip link set dev eth1 up
sudo ip link set dev eth2 up
ip a
9: br1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 46:1e:c3:f1:77:44 brd ff:ff:ff:ff:ff:ff
10: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 42:c1:70:97:fe:11 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::40c1:70ff:fe97:fe11/64 scope link 
       valid_lft forever preferred_lft forever
11: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 36:ba:fd:a3:be:8c brd ff:ff:ff:ff:ff:ff
    inet6 fe80::34ba:fdff:fea3:be8c/64 scope link 
       valid_lft forever preferred_lft forever
```

## 3 Let’s display the components of our final setup

```bash
> sudo ovs-vsctl show
2754d6a1-4c15-4a41-bb9e-185bd0cf18a1
    Bridge br1
        Port eth2
            tag: 10
            Interface eth2
                type: internal
        Port patch-br1-br0
            Interface patch-br1-br0
                type: patch
                options: {peer=patch-br0-br1}
        Port br1
            Interface br1
                type: internal
    Bridge br0
        Port br0
            Interface br0
                type: internal
        Port patch-br0-br1
            Interface patch-br0-br1
                type: patch
                options: {peer=patch-br1-br0}
        Port eth1
            tag: 10
            Interface eth1
                type: internal
    Bridge br-int
        fail_mode: secure
        datapath_type: system
        Port br-int
            Interface br-int
                type: internal
    ovs_version: "2.17.7"
```

Now let’s test the connection between virtual machines vm1 and vm2 attached to eth1 and eth2 interfaces. As usual, we first start a server using python on vm2

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

Send a request from vm1 to vm2 using curl command.

```bash
> curl -vI --interface enp0s3 <http://192.168.1.20:8443>
- Trying 192.168.1.20:8443...
- Connected to 192.168.1.20 (192.168.1.20) port 8443 (#0)

> HEAD / HTTP/1.1
> Host: 192.168.1.20:8443
> User-Agent: curl/7.81.0
> Accept: */*
>
- Mark bundle as not supporting multiuse
- HTTP 1.0, assume close after body
< HTTP/1.0 200 OK
HTTP/1.0 200 OK
< Server: SimpleHTTP/0.6 Python/3.10.12
Server: SimpleHTTP/0.6 Python/3.10.12
< Date: Sun, 26 Nov 2023 01:06:28 GMT
Date: Sun, 26 Nov 2023 01:06:28 GMT
< Content-type: text/html; charset=utf-8
Content-type: text/html; charset=utf-8
< Content-Length: 626
Content-Length: 626

<
- Closing connection 0
```

## Considerations for Connecting Bridges Across Hosts

In some network setups, the need arises to connect Open vSwitch bridges that reside on different hosts. While our current blog post series focuses on a more confined setup within a single host, it’s important to acknowledge the broader scope of networking scenarios that involve distributed architectures. This section aims to highlight general considerations and approaches for readers who may find themselves in such a distributed environment.

- As bridges on different hosts cannot be directly connected, tunneling solutions become essential. Technologies like VXLAN (Virtual Extensible LAN) are commonly employed to create overlays that span multiple hosts.
- Ensure that Open vSwitch is installed and properly configured on each host. Consistency in versions and configurations is crucial for seamless communication.
- Create VXLAN tunnel interfaces on each host, specifying the remote IP address of the counterpart host. This establishes the underlying connectivity required for inter-host communication.
- Confirm that there is network reachability between the hosts. This includes checking firewalls, routing, and any other factors that might affect communication between the hosts.
- When extending networks across hosts, consider security implications. Implement encryption for tunnel traffic, and ensure that proper firewall rules are in place to protect the communication.

While not covered in detail within this series, understanding the principles of tunneling and distributed network configurations is valuable for those working in larger-scale environments. Always refer to the specific documentation for your networking technology and be mindful of the unique considerations introduced by distributed architectures.

In the next part of our series, we’ll continue exploring additional features and configurations within the scope of our current environment. Stay tuned for more insights into Open vSwitch!

## Challenge for the reader: Handling Different VLAN Tags on the Second Bridge

Now that we’ve extended our exploration to a network setup with two bridges, each hosting a port with the same VLAN tag, it’s time to introduce a challenge that adds a layer of complexity.

Consider the scenario where the second port attached to the second bridge comes with a distinct VLAN tag. In our previous discussions in Part 2, we tackled the intricacies of managing different VLANs within a single bridge. Extending this concept to a multi-bridge environment demands a nuanced understanding of OpenFlow rules. The challenge for you, the reader, is to configure the necessary OpenFlow rules that enable the smooth flow of HTTP traffic between these disparate VLANs. This not only tests your comprehension of VLAN segregation but also emphasizes the importance of crafting specific rules to facilitate the communication of distinct VLAN-tagged traffic.

## What’s next?

In conclusion, as we wrap up our exploration of VLAN extension across bridges in the Open vSwitch environment, we’ve navigated through the fundamentals, intricate OpenFlow rules, and challenges presented by multi-bridge setups. The journey has shed light on the versatility of Open vSwitch in managing network configurations.

Looking ahead, the blog series will take an exciting turn as we venture into the realm of OVN (Open Virtual Network). OVN is a powerful extension to Open vSwitch that addresses the evolving needs of modern networking. With features like native support for overlay networks, logical switching, and routing capabilities, OVN brings a new dimension to software-defined networking. Join us in the upcoming posts as we delve into the intricacies of OVN networks based on Open vSwitch, exploring their significance and the practical applications that make them indispensable in today’s dynamic network landscapes.
