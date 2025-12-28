# **[](https://documentation.ubuntu.com/lxd/stable-5.21/howto/network_bgp/)**

How to configure LXD as a BGP server
Note

The BGP server feature is available for the Bridge network and the Physical network. These network types are often used as the uplink network for an OVN network, and you must configure the BGP peers on the uplink network. See **[Configure BGP peers for OVN networks](https://documentation.ubuntu.com/lxd/stable-5.21/howto/network_bgp/#network-bgp-ovn)** for instructions.

▶
Watch on YouTube

Configure BGP peers for OVN networks
If you run an OVN network with an uplink network (physical or bridge), the uplink network is the one that holds the list of allowed subnets and the BGP configuration. Therefore, you must configure BGP peers on the uplink network that contain the information that is required to connect to the BGP server.

Set the following configuration options on the uplink network:

bgp.peers.<name>.address - the peer address to be used by the downstream networks

bgp.peers.<name>.asn - the ASN for the local server

bgp.peers.<name>.password - an optional password for the peer session

bgp.peers.<name>.holdtime - an optional hold time for the peer session (in seconds)

Once the uplink network is configured, downstream OVN networks will get their external subnets and addresses announced over BGP. The next-hop is set to the address of the OVN router on the uplink network.
