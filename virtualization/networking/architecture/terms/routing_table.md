# routing tables

## references

<https://ubuntu.com/core/docs/networkmanager/routing-tables>
<https://www.techtarget.com/searchnetworking/definition/routing-table>

## What is a routing table?

A routing table is a set of rules, often viewed in table format, that's used to determine where data packets traveling over an Internet Protocol (IP) network will be directed. This table is usually stored inside the Random Access Memory of forwarding devices, such as routers and network switches.

In computer networking, each routing table is unique and acts as an address map for networks. It stores the source and destination IP addresses of the routing devices in the form of prefixes along with the default gateway addresses and corresponding routing information.

Routing tables are typically updated dynamically through network routing protocols. But sometimes network administrators might add static entries manually.

## Routing table entries

Each routing table might contain different entries and information, such as IPv4 or IPv6 address classes. But the primary fields of all routing tables stay the same.

The following are the main entries of a routing table:

- **Destination**: This is the IP address of the packet's final destination.
- **Subnet mask**: Also known as the netmask, this is a 32-bit network address that identifies whether a host belongs to the local or remote network. To enhance routing efficiency and reduce the size of the broadcast domain, administrators can apply a custom subnet mask through the process of subnetting, which can divide a network into two or smaller connected networks.
- **Gateway**: This is the next hop, or the neighboring device's IP address to which the packet is forwarded.
- **Interface:** Routers typically use Ethernet interfaces to connect to other devices on the same network, such as eth0 or eth1, and serial interfaces to connect to outside wide area networks (WANs). The routing table lists the inbound network interface, also known as the outgoing interface, that the device should use when forwarding the packet to the next hop.

A **serial network interface** is a serial port that acts as a network interface. They can be used to connect two routers back-to-back but are most commonly used to connect to either a modem or a DSU

## What Is CSU/DSU (Channel Service Unit/Data Service Unit)?

A **CSU/DSU** is a digital-interface device used to connect data terminal equipment, such as a router, to a digital circuit, such as a Digital Signal 1 T1 line. The CSU/DSU implements two different functions.

- **Metric:** This entry assigns a value to each available route to a specific network. The value ensures that the router can choose the most effective path. In some cases, the metric is the number of routers that a data packet must cross before it gets to the destination address. If multiple routes exist to the same destination network, the path with the lowest metric is given precedence.

- **Routes:** This includes directly attached subnets, indirect subnets that aren't attached to the device but can be accessed through one or more hops, and default routes to use for certain types of traffic or when information is lacking.

![](https://cdn.ttgtmedia.com/rms/onlineimages/routing_table-f.jpg)

## How does a routing table work?

The main purpose of a routing table is to help routers make effective routing decisions. Whenever a packet is sent through a router to be forwarded to a host on another network, the router consults the routing table to find the IP address of the destination device and the best path to reach it. The packet is then directed to a neighboring router -- or the next hop listed in the table -- until it reaches its final destination.

## Routing Tables

This section describes the way to setup routing table as well as it explains the logic used to prioritize interfaces.

The routing table is stored in the kernel which merely acts upon it. The route itself is set by the user-space tools. There is no preference as any tool created for this reason will do. It can be either a DHCP client, ip command or route command.

It is important to understand that NetworkManager changes the routing table whenever it creates a new connection.

Routing table acts as a junction and is there to show where the different network subnets will be routed to. An example of a routing table is shown below.

```bash
ip route \
    default via 10.0.0.1 dev wlp3s0 proto static metric 600 \
    10.0.0.0/24 dev wlp3s0 proto kernel scope link src 10.0.0.73 metric 600 \
    10.0.1.0/24 dev lxcbr0 proto kernel scope link src 10.0.1.1 \
    169.254.0.0/16 dev docker0 scope link metric 1000 linkdown \
    172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 linkdown \
    192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown

# On reports-alb
ip route
default via 10.1.1.205 dev enp0s25 proto static metric 100 
10.1.0.0/22 dev enp0s25 proto kernel scope link src 10.1.0.113 metric 100 
10.154.222.0/24 dev mpqemubr0 proto kernel scope link src 10.154.222.1 linkdown 
169.254.0.0/16 dev enp0s25 scope link metric 1000 
172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 
172.18.0.0/16 dev br-860dc0d9b54b proto kernel scope link src 172.18.0.1 linkdown 
172.19.0.0/16 dev br-b543cc541f49 proto kernel scope link src 172.19.0.1 linkdown 
172.21.0.0/16 dev br-924b3db7b366 proto kernel scope link src 172.21.0.1 linkdown 
172.23.0.0/16 dev br-ef440bd353e1 proto kernel scope link src 172.23.0.1 linkdown 

# Ping docker gateway
ping 172.17.0.1                           
PING 172.17.0.1 (172.17.0.1) 56(84) bytes of data.
64 bytes from 172.17.0.1: icmp_seq=1 ttl=64 time=0.092 ms
64 bytes from 172.17.0.1: icmp_seq=2 ttl=64 time=0.074 ms
64 bytes from 172.17.0.1: icmp_seq=3 ttl=64 time=0.081 ms
```

The first column is the subnet with the “default” being a wildcard for everything else. The “via” fragment points to the <Gateway> however when it is missing it indicates that that network is connected directly and instead it describes a source address.

The metric field/column translates to the number of hops required to reach the destination and is used to determine which route shall be preferred when there are more than one route available for a specific destination. Since this value is related to the concept of distance, the lower it’s value is the better.

The metric value can be set manually however when NetworkManager creates a connection the following defaults are applied:

Ethernet is preferred over WiFi
WiFi is preferred over WWAN

## Editing the routing tables

The routing table can be added or modified using the standard ip command which is available on Ubuntu Core. You can find more information on its man page.

Separately it is possible to modify routing information per single connection using the nmcli tool. The parameters such as: gateway, routes and metrics can be modified.

The following options are responsible:

```bash
ipv4.gateway:
ipv4.routes: 
ipv4.route-metric:

ipv6.gateway:
ipv6.routes:
ipv6.route-metric:
```

These options can be modified in a following way:

```bash
nmcli connection modify <name> +ipv4.routes <destination> ipv4.gateway <gateway>
nmcli connection modify <name> ipv4.route-metric <metric>
```

Where <name> is the connection name. You can obtain it by listing available connections on the system:

```bash
nmcli c show
NAME                UUID                                  TYPE      DEVICE          
Wired connection 1  c031620b-0f27-3dea-9352-8b45b7a8b2ea  ethernet  enp0s25         
docker0             1541b88a-099c-41cd-9753-594e21cadc53  bridge    docker0         
br-860dc0d9b54b     539f5bb9-b2a3-45eb-a261-8319a330c552  bridge    br-860dc0d9b54b 
br-924b3db7b366     a3ea08ba-c29d-481c-8eaf-1c9e50f015bc  bridge    br-924b3db7b366 
br-b543cc541f49     a7da20df-b3cb-47e0-a756-ba5af0072cc3  bridge    br-b543cc541f49 
br-ef440bd353e1     224bd1e4-eb3c-4ed3-bf0a-28331bddc1e5  bridge    br-ef440bd353e1 
mpqemubr0           dd1949f2-3d31-418c-88ba-b16b27cc893d  bridge    mpqemubr0         
```

- <destination> is the destination network provided as a static IP address, subnet or “default”.
- <gateway> is the new gateway information. is the new metric information.

Note that this kind of changes can be made separately for each connection thus it is possible to provide a fine grained control over how the packets directed to different networks are routed.

It is also important to understand that bringing up and down connections with different values set for these options is in fact changing the routing table.
