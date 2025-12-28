# **[Basic Routing Firewall](https://wiki.gentoo.org/wiki/Nftables/Examples#Basic_routing_firewall)**

## Basic routing firewall

The following is an example of nftables rules for a basic IPv4 firewall that:

- Only allows packets from LAN to the firewall machine
- Only allows packets
  - From LAN to WAN
  - From WAN to LAN for connections established by LAN.

For forwarding between WAN and LAN to work, it needs to be enabled with:

```bash
# check current value
sudo sysctl net.ipv4.ip_forward
[sudo] password for brent: 
net.ipv4.ip_forward = 1

# The -w option enables users to modify an existing kernel parameter value. The following command sets the swappiness value to 30:
# https://phoenixnap.com/kb/sysctl
sudo sysctl -w net.ipv4.ip_forward = 1
```

```bash
#!/sbin/nft -f

flush ruleset

table ip filter {
 # allow all packets sent by the firewall machine itself
 chain output {
  type filter hook output priority 100; policy accept;
 }

 # allow LAN to firewall, disallow WAN to firewall
 chain input {
  type filter hook input priority 0; policy accept;
  iifname "lan0" accept
  iifname "wan0" drop
 }

 # allow packets from LAN to WAN, and WAN to LAN if LAN initiated the connection
 chain forward {
  type filter hook forward priority 0; policy drop;
  iifname "lan0" oifname "wan0" accept
  iifname "wan0" oifname "lan0" ct state related,established accept
 }
}
```

<https://thermalcircle.de/doku.php?id=blog:linux:connection_tracking_3_state_and_examples>

![](https://thermalcircle.de/lib/exe/fetch.php?media=linux:nf-ct-nfct-table-established.png)

The ct system sets this for a packet which belongs to an already tracked connection and which meets all of the following criteria:

- packet is not the first one seen for that connection
- packet is flowing in original direction (= same direction as first packet seen for that connection)
- packets have already been seen in both directions for this connection, prior to this packet

conntrack expressions matching this packet
Nftables ct state established
ct state established ct direction original

Iptables -m conntrack --ctstate ESTABLISHED
-m conntrack --ctstate ESTABLISHED --ctdir ORIGINAL

![](https://thermalcircle.de/lib/exe/fetch.php?media=linux:nf-ct-nfct-table-related.png)

The ct system sets this for a packet which is one of these two things:

- The packet is a valid ICMP error message (e.g. type=3 “destination unreachable”, code=0 “network unreachable”) which is related to an already tracked connection. Relative to that connection, it is flowing in original direction. Pointer *p points to that connection.

- The packet is the very first one of a new connection, but this connection is related to an already tracked connection or, in other words, it is an expected connection (see status bit IPS_EXPECTED in Figure 3 above). This e.g. occurs when you use the ct helper for the FTP protocol. This is a very complex topic, which would deserve its own blog article6). Important to note here is, that only the first packet belonging to an expected connection is marked with IP_CT_RELATED. All following packets of that connection are marked with IP_CT_ESTABLISHED or IP_CT_ESTABLISHED_REPLY as with any other tracked connection.

conntrack expressions matching this packet
Nftables ct state related
ct state related ct direction original
Iptables -m conntrack --ctstate RELATED
-m conntrack --ctstate RELATED --ctdir ORIGINAL

The syntax for specifying the chain type when adding a base chain in nftables is type <type>. The possible chain types are filter, route, or nat

## Adding base chains

Base chains are those that are registered into the Netfilter hooks, i.e. these chains see packets flowing through your Linux TCP/IP stack.

The syntax to add a base chain is:

```bash
% nft add chain [<family>] <table_name> <chain_name> { type <type> hook <hook> priority <value> \; [policy <policy> \;] [comment \"text comment\" \;] }
```

The following example shows how to add a new base chain input to the foo table (which must have been previously created):

```bash
% nft 'add chain ip foo input { type filter hook input priority 0 ; }'
```

## Basic NAT

The following is an example of nftables rules for setting up basic Network Address Translation (NAT) using masquerade. If you have a static IP, it would be slightly faster to use source nat (SNAT) instead of masquerade. This way the router would replace the source with a predefined IP, instead of looking up the outgoing IP for every packet.

 Note
masquerade is available in kernel 3.18 and up. When using NAT on kernels before 4.18, be sure to unload or disable iptables NAT, as it will take precedence over nftables NAT.

/etc/nftables/nftables_nat

```bash
#!/sbin/nft -f

flush ruleset

table ip nat {
 chain prerouting {
  type nat hook prerouting priority 0; policy accept;
 }

 # for all packets to WAN, after routing, replace source address with primary IP of WAN interface
 chain postrouting {
  type nat hook postrouting priority 100; policy accept;
  oifname "wan0" masquerade
 }
}
```
