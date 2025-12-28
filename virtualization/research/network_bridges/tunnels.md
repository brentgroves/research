# **[tap vs tunnels](https://www.reddit.com/r/OpenVPN/comments/tj6xtq/eli5_how_do_tap_and_tun_tunnels_work_and_where_is/)

## answer 1

TAP carries ethernet packets. Packets are routed by their destination MAC addresses.

TUN carries IP packets. Packets are routed by their destination mac address.

TAP more resembles an Ethernet network, if you ping a client, first an ip neighbor/arp lookup is done, after which packets are send with the destination mac address.

With TUN, the packet is directly send with the destination IP set, this is quicker but oes not allow advanced tricks typically done with lan like multiple gateways.

It is recommended to use TUN by default, or use TAP when you are extending the same network as your LAN

TUN tunnels have less overhead as you no longer have to include mac addresses in every packet.

## answer 2

Tap can be used to bridge VPN devices to an existing network. The devices on the VPN can exchange broadcast traffic with your LAN, and protocols like IPX/SPX for old games should work.

Sending LAN broadcast traffic and ethernet headers over the VPN is a pointless waste of bandwidth the vast majority of the time, so you use tun unless you're specifically doing something that requires tap.
