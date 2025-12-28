# **[](https://documentation.ubuntu.com/lxd/stable-5.21/howto/network_forwards/)**

How to configure network forwards
Note

Network forwards are available for the OVN network and the Bridge network.

▶
Watch on YouTube
Network forwards allow an external IP address (or specific ports on it) to be forwarded to an internal IP address (or specific ports on it) in the network that the forward belongs to.

This feature can be useful if you have limited external IP addresses and want to share a single external address between multiple instances. In this case, you have two options:

Forward all traffic from the external address to the internal address of one instance. This method makes it easy to move the traffic destined for the external address to another instance by simply reconfiguring the network forward.

Forward traffic from different port numbers of the external address to different instances (and optionally different ports on those instances). This method allows to “share” your external IP address and expose more than one instance at a time.

Tip

Network forwards are very similar to using a **[proxy device](https://documentation.ubuntu.com/lxd/stable-5.21/reference/devices_proxy/#devices-proxy)** in NAT mode.

The difference is that network forwards are applied on a network level, while a proxy device is added for an instance. In addition, proxy devices can be used to proxy traffic between different connection types (for example, TCP and Unix sockets).
