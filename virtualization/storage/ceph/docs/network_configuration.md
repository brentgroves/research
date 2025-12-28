# **[](https://docs.ceph.com/en/latest/rados/configuration/network-config-ref/#ceph-networks)**

Ceph Networks
To configure Ceph networks, you must add a network configuration to the [global] section of the configuration file. Our 5-minute Quick Start provides a trivial Ceph configuration file that assumes one public network with client and server on the same network and subnet. Ceph functions just fine with a public network only. However, Ceph allows you to establish much more specific criteria, including multiple IP network and subnet masks for your public network. You can also establish a separate cluster network to handle OSD heartbeat, object replication and recovery traffic. Don’t confuse the IP addresses you set in your configuration with the public-facing IP addresses network clients may use to access your service. Typical internal IP networks are often 192.168.0.0 or 10.0.0.0.

Tip

If you specify more than one IP address and subnet mask for either the public or the cluster network, the subnets within the network must be capable of routing to each other. Additionally, make sure you include each IP address/subnet in your IP tables and open ports for them as necessary.

Note

Ceph uses CIDR notation for subnets (e.g., 10.0.0.0/24).

When you have configured your networks, you may restart your cluster or restart each daemon. Ceph daemons bind dynamically, so you do not have to restart the entire cluster at once if you change your network configuration.

## Public Network

To configure a public network, add the following option to the [global] section of your Ceph configuration file.

[global]
        # ... elided configuration
        public_network = {public-network/netmask}

## Cluster Network

If you declare a cluster network, OSDs will route heartbeat, object replication and recovery traffic over the cluster network. This may improve performance compared to using a single network. To configure a cluster network, add the following option to the [global] section of your Ceph configuration file.

[global]
        # ... elided configuration
        cluster_network = {cluster-network/netmask}

We prefer that the cluster network is NOT reachable from the public network or the Internet for added security.

## Ceph Daemons

Monitor daemons are each configured to bind to a specific IP address. These addresses are normally configured by your deployment tool. Other components in the Ceph cluster discover the monitors via the mon host configuration option, normally specified in the [global] section of the ceph.conf file.

[global]
    mon_host = 10.0.0.2, 10.0.0.3, 10.0.0.4
The mon_host value can be a list of IP addresses or a name that is looked up via DNS. In the case of a DNS name with multiple A or AAAA records, all records are probed in order to discover a monitor. Once one monitor is reached, all other current monitors are discovered, so the mon host configuration option only needs to be sufficiently up to date such that a client can reach one monitor that is currently online.

The MGR, OSD, and MDS daemons will bind to any available address and do not require any special configuration. However, it is possible to specify a specific IP address for them to bind to with the public addr (and/or, in the case of OSD daemons, the cluster addr) configuration option. For example,

[osd.0]
        public_addr = {host-public-ip-address}
        cluster_addr = {host-cluster-ip-address}

## One NIC OSD in a Two Network Cluster

Generally, we do not recommend deploying an OSD host with a single network interface in a cluster with two networks. However, you may accomplish this by forcing the OSD host to operate on the public network by adding a public_addr entry to the [osd.n] section of the Ceph configuration file, where n refers to the ID of the OSD with one network interface. Additionally, the public network and cluster network must be able to route traffic to each other, which we don’t recommend for security reasons.

## Network Config Settings

Network configuration settings are not required. Ceph assumes a public network with all hosts operating on it unless you specifically configure a cluster network.

## Public Network

The public network configuration allows you specifically define IP addresses and subnets for the public network. You may specifically assign static IP addresses or override public_network settings using the public_addr setting for a specific daemon.

## public_network_interface

Interface name(s) from which to choose an address from a public_network to bind to; public_network must also be specified.

type
:
str

see also
:
public_network

public_network
The IP address and netmask of the public (front-side) network (e.g., 192.168.0.0/24). Set in [global]. You may specify comma- separated subnets. The format of it looks like {ip- address}/{netmask} [, {ip-address}/{netmask}]

type
:
str

public_addr
The IP address for the public (front-side) network. Set for each daemon.

type
:
addr

Cluster Network
The cluster network configuration allows you to declare a cluster network, and specifically define IP addresses and subnets for the cluster network. You may specifically assign static IP addresses or override cluster_network settings using the cluster_addr setting for specific OSD daemons.

cluster_network_interface
Interface name(s) from which to choose an address from a cluster_network to bind to; cluster_network must also be specified.

type
:
str

see also
:
cluster_network

cluster_network
The IP address and netmask of the cluster (back-side) network (e.g., 10.0.0.0/24). Set in [global]. You may specify comma- separated subnets. The format of it looks like {ip- address}/{netmask} [, {ip-address}/{netmask}]

type
:
str

cluster_addr
The IP address for the cluster (back-side) network. Set for each daemon.

type
:
addr

Bind
Bind settings set the default port ranges Ceph OSD and MDS daemons use. The default range is 6800:7568. Ensure that your IP Tables configuration allows you to use the configured port range.

You may also enable Ceph daemons to bind to IPv6 addresses instead of IPv4 addresses.

ms_bind_port_min
The minimum port number to which an OSD or MDS daemon will bind.

type
:
int

default
:
6800

ms_bind_port_max
The maximum port number to which an OSD or MDS daemon will bind.

type
:
int

default
:
7568

ms_bind_ipv4
Enables Ceph daemons to bind to IPv4 addresses.

type
:
bool

default
:
true

see also
:
ms_bind_ipv6

ms_bind_ipv6
Enables Ceph daemons to bind to IPv6 addresses.

type
:
bool

default
:
false

see also
:
ms_bind_ipv4

public_bind_addr
In some dynamic deployments the Ceph MON daemon might bind to an IP address locally that is different from the public_addr advertised to other peers in the network. The environment must ensure that routing rules are set correctly. If public_bind_addr is set the Ceph Monitor daemon will bind to it locally and use public_addr in the monmaps to advertise its address to peers. This behavior is limited to the Monitor daemon.

type
:
addr

TCP
Ceph disables TCP buffering by default.

ms_tcp_nodelay
Ceph enables ms_tcp_nodelay so that each request is sent immediately (no buffering). Disabling Nagle’s algorithm increases network traffic, which can introduce latency. If you experience large numbers of small packets, you may try disabling ms_tcp_nodelay.

type
:
bool

default
:
true

ms_tcp_rcvbuf
The size of the socket buffer on the receiving end of a network connection. Disable by default.

type
:
size

default
:
0B
