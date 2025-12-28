# **[](https://documentation.ubuntu.com/lxd/stable-5.21/reference/devices_proxy/#devices-proxy)**

Type: proxy
▶
Watch on YouTube
Note

The proxy device type is supported for both containers (NAT and non-NAT modes) and VMs (NAT mode only). It supports hotplugging for both containers and VMs.

Proxy devices allow you to forward network connections between a host and an instance running on that host.

You can use them to:

Forward traffic from an address on the host to an address inside the instance.

Do the reverse, enabling an address inside the instance to connect through the host.

In NAT mode, proxy devices support TCP and UDP proxying (traffic forwarding). In non-NAT mode, proxy devices can also forward traffic between Unix sockets, which is useful for tasks such as forwarding a GUI or audio traffic from a container to the host system. Additionally, they can proxy traffic across different protocols—for example, forwarding traffic from a TCP listener on the host to a Unix socket inside a container.

The supported connection types are:

tcp <-> tcp

udp <-> udp

unix <-> unix

tcp <-> unix

unix <-> tcp

tcp <-> udp

unix <-> udp

To add a proxy device, use the following command:

lxc config device add <instance_name> <device_name> proxy listen=<type>:<addr>:<port>[-<port>][,<port>] connect=<type>:<addr>:<port> bind=<host/instance_name>

Using a proxy device in NAT mode is very similar to adding a network forward.

The difference is that network forwards are applied on a network level, while a proxy device is added for an instance. In addition, network forwards cannot be used to proxy traffic between different connection types.

NAT mode
The proxy device supports a NAT mode (nat=true), which forwards packets using NAT instead of creating a separate proxy connection.

This mode has the benefit that the client address is maintained without requiring the target destination to support the HAProxy PROXY protocol. This is necessary for passing client addresses in non-NAT mode.

However, NAT mode is only available when the host running the instance also acts as the gateway. This is the typical case when using lxdbr0, for example.

In NAT mode, the supported connection types are:

tcp <-> tcp

udp <-> udp

When configuring a proxy device with nat=true, you must ensure that the target instance has a static IP configured on its NIC device.
