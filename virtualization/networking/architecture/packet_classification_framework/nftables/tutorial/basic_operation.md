# **[Basic Operation](https://www.server-world.info/en/note?os=Ubuntu_22.04&p=nftables&f=2)**

The multiple networking levels are abstracted into families on nftables architecture like follows.

| Family | Description                                                                                                                                                                                                                                                                                          |
|--------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ip     | This family processes IPv4 traffic/packets. The legacy [iptables] is the equivalent.                                                                                                                                                                                                                 |
| ip6    | This family processes IPv6 traffic/packets. The legacy [ip6tables] is the equivalent.                                                                                                                                                                                                                |
| inet   | This family processes both IPv4 and IPv6 traffic/packets as dual stack support.                                                                                                                                                                                                                      |
| arp    | This family processes ARP-level traffic, before any L3 handling is done by the kernel. The legacy [arptables] is the equivalent.                                                                                                                                                                     |
| bridge | This family processes traffic/packets traversing bridges. The legacy [ebtables] is the equivalent. However there is no nf_conntrack integration for it.                                                                                                                                              |
| netdev | This family is different from the others in that it is used to create base chains attached to a single network interface. Such base chains see all network traffic on the specified interface, with no assumptions about L2 or L3 protocols. There is no legacy ***tables equivalent to this family. |

**[https://www.auvik.com/franklyit/blog/what-is-an-arp-table/](https://www.auvik.com/franklyit/blog/what-is-an-arp-table/)**

ARP (Address Resolution Protocol) is the protocol that bridges Layer 2 and Layer 3 of the OSI model, which in the typical TCP/IP stack is effectively gluing together the Ethernet and Internet Protocol layers. This critical function allows for the discovery of a devices’ MAC (media access control) address based on its known IP address.

By extension, an ARP table is simply the method for storing the information discovered through ARP. It’s used to record the discovered MAC and IP address pairs of devices connected to a network. Each device that’s connected to a network has its own ARP table, responsible for storing the address pairs that a specific device has communicated with.

ARP is critical network communication, so pairs of MAC and IP addresses don’t need to be discovered (and rediscovered) for every data packet sent. Once a MAC and IP address pair is learned, it’s kept in the ARP table for a specified period of time.  If there’s no record on the ARP table for a specific IP address destination, ARP will need to send out a broadcast message to all devices in that specific subnet to determine what the receiver MAC address should be.

## show ruleset (no filtering rule by default)

There is no filtering rule by default on nftables, so start with creating tables.
⇒ nft add table [family] [table name]

```bash
ssh brent@repsys13
sudo nft list ruleset
Operation not permitted (you must be root)
(base)  ✘ brent@repsys13  ~  sudo nft list ruleset
table inet lxd {
 chain pstrt.mpbr0 {
  type nat hook postrouting priority srcnat; policy accept;
  ip saddr 10.161.38.0/24 ip daddr != 10.161.38.0/24 masquerade
  ip6 saddr fd42:b403:217:3a62::/64 ip6 daddr != fd42:b403:217:3a62::/64 masquerade
 }

 chain fwd.mpbr0 {
  type filter hook forward priority filter; policy accept;
  ip version 4 oifname "mpbr0" accept
  ip version 4 iifname "mpbr0" accept
  ip6 version 6 oifname "mpbr0" accept
  ip6 version 6 iifname "mpbr0" accept
 }

 chain in.mpbr0 {
  type filter hook input priority filter; policy accept;
  iifname "mpbr0" tcp dport 53 accept
  iifname "mpbr0" udp dport 53 accept
  iifname "mpbr0" icmp type { destination-unreachable, time-exceeded, parameter-problem } accept
  iifname "mpbr0" udp dport 67 accept
  iifname "mpbr0" icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-neighbor-solicit, nd-neighbor-advert, mld2-listener-report } accept
  iifname "mpbr0" udp dport 547 accept
 }

 chain out.mpbr0 {
  type filter hook output priority filter; policy accept;
  oifname "mpbr0" tcp sport 53 accept
  oifname "mpbr0" udp sport 53 accept
  oifname "mpbr0" icmp type { destination-unreachable, time-exceeded, parameter-problem } accept
  oifname "mpbr0" udp sport 67 accept
  oifname "mpbr0" icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, echo-request, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, mld2-listener-report } accept
  oifname "mpbr0" udp sport 547 accept
 }
}
table ip filter {
 chain INPUT {
  type filter hook input priority filter; policy accept;
 }
}
```

## flush default rule above and add [firewall01] table in [inet] family

```bash
root@dlp:~# nft flush ruleset
root@dlp:~# nft add table inet firewall01
```

## show tables of [inet] family

```bash
root@dlp:~# nft list tables inet
table inet firewall01
```

## show ruleset

```bash
root@dlp:~# nft list ruleset
table inet firewall01 {
}
```

## to delete a table, run like follows

```bash
root@dlp:~# nft delete table inet firewall0
```
