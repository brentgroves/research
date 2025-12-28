# **[](https://developers.redhat.com/blog/2018/10/22/introduction-to-linux-interfaces-for-virtual-networking#veth)**

VETH
The VETH (virtual Ethernet) device is a local Ethernet tunnel. Devices are created in pairs, as shown in the diagram below.

Packets transmitted on one device in the pair are immediately received on the other device. When either device is down, the link state of the pair is down.

![i1](https://developers.redhat.com/blog/wp-content/uploads/2018/10/veth.png)

Use a VETH configuration when namespaces need to communicate to the main host namespace or between each other.

Here's how to set up a VETH configuration:

```bash
ip netns add net1
ip netns add net2
ip link add veth1 netns net1 type veth peer name veth2 netns net2
```

This creates two namespaces, net1 and net2, and a pair of VETH devices, and it assigns veth1 to namespace net1 and veth2 to namespace net2. These two namespaces are connected with this VETH pair. Assign a pair of IP addresses, and you can ping and communicate between the two namespaces.
