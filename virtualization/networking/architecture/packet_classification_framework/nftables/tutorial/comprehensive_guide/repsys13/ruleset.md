# repsys13 ruleset

```bash
nft –a list ruleset
table inet lxd { # handle 5
 chain pstrt.mpbr0 { # handle 1
  type nat hook postrouting priority srcnat; policy accept;
  ip saddr 10.161.38.0/24 ip daddr != 10.161.38.0/24 masquerade # handle 2
  ip6 saddr fd42:b403:217:3a62::/64 ip6 daddr != fd42:b403:217:3a62::/64 masquerade # handle 3
 }

 chain fwd.mpbr0 { # handle 4
  type filter hook forward priority filter; policy accept;
  ip version 4 oifname "mpbr0" accept # handle 5
  ip version 4 iifname "mpbr0" accept # handle 6
  ip6 version 6 oifname "mpbr0" accept # handle 7
  ip6 version 6 iifname "mpbr0" accept # handle 8
 }

 chain in.mpbr0 { # handle 9
  type filter hook input priority filter; policy accept;
  iifname "mpbr0" tcp dport 53 accept # handle 11
  iifname "mpbr0" udp dport 53 accept # handle 12
  iifname "mpbr0" icmp type { destination-unreachable, time-exceeded, parameter-problem } accept # handle 14
  iifname "mpbr0" udp dport 67 accept # handle 15
  iifname "mpbr0" icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, nd-router-solicit, nd-neighbor-solicit, nd-neighbor-advert, mld2-listener-report } accept # handle 17
  iifname "mpbr0" udp dport 547 accept # handle 18
 }

 chain out.mpbr0 { # handle 10
  type filter hook output priority filter; policy accept;
  oifname "mpbr0" tcp sport 53 accept # handle 19
  oifname "mpbr0" udp sport 53 accept # handle 20
  oifname "mpbr0" icmp type { destination-unreachable, time-exceeded, parameter-problem } accept # handle 22
  oifname "mpbr0" udp sport 67 accept # handle 23
  oifname "mpbr0" icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem, echo-request, nd-router-advert, nd-neighbor-solicit, nd-neighbor-advert, mld2-listener-report } accept # handle 25
  oifname "mpbr0" udp sport 547 accept # handle 26
 }
}
table ip filter { # handle 6
 chain LIBVIRT_INP { # handle 1
  iifname "virbr0" meta l4proto udp udp dport 53 counter packets 0 bytes 0 accept # handle 19
  iifname "virbr0" meta l4proto tcp tcp dport 53 counter packets 0 bytes 0 accept # handle 18
  iifname "virbr0" meta l4proto udp udp dport 67 counter packets 0 bytes 0 accept # handle 15
  iifname "virbr0" meta l4proto tcp tcp dport 67 counter packets 0 bytes 0 accept # handle 14
 }

 chain INPUT { # handle 2
  type filter hook input priority filter; policy accept;
  counter packets 7405235 bytes 2301059896 jump LIBVIRT_INP # handle 3
 }

 chain LIBVIRT_OUT { # handle 4
  oifname "virbr0" meta l4proto udp udp dport 53 counter packets 0 bytes 0 accept # handle 21
  oifname "virbr0" meta l4proto tcp tcp dport 53 counter packets 0 bytes 0 accept # handle 20
  oifname "virbr0" meta l4proto udp udp dport 68 counter packets 0 bytes 0 accept # handle 17
  oifname "virbr0" meta l4proto tcp tcp dport 68 counter packets 0 bytes 0 accept # handle 16
 }

 chain OUTPUT { # handle 5
  type filter hook output priority filter; policy accept;
  counter packets 447095 bytes 36354389 jump LIBVIRT_OUT # handle 6
 }

 chain LIBVIRT_FWO { # handle 7
  iifname "virbr0" ip saddr 192.168.122.0/24 counter packets 0 bytes 0 accept # handle 25
  iifname "virbr0" counter packets 0 bytes 0 reject # handle 22
 }

 chain FORWARD { # handle 8
  type filter hook forward priority filter; policy accept;
  counter packets 14318563 bytes 1624105767 jump LIBVIRT_FWX # handle 13
  counter packets 14318563 bytes 1624105767 jump LIBVIRT_FWI # handle 11
  counter packets 14318563 bytes 1624105767 jump LIBVIRT_FWO # handle 9
 }

 chain LIBVIRT_FWI { # handle 10
  oifname "virbr0" ip daddr 192.168.122.0/24 ct state related,established counter packets 0 bytes 0 accept # handle 26
  oifname "virbr0" counter packets 0 bytes 0 reject # handle 23
 }

 chain LIBVIRT_FWX { # handle 12
  iifname "virbr0" oifname "virbr0" counter packets 0 bytes 0 accept # handle 24
 }
}
table ip nat { # handle 7
 chain LIBVIRT_PRT { # handle 1
  ip saddr 192.168.122.0/24 ip daddr 224.0.0.0/24 counter packets 169 bytes 21013 return # handle 8
  ip saddr 192.168.122.0/24 ip daddr 255.255.255.255 counter packets 0 bytes 0 return # handle 7
  meta l4proto tcp ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 counter packets 0 bytes 0 masquerade to :1024-65535  # handle 6
  meta l4proto udp ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 counter packets 1 bytes 635 masquerade to :1024-65535  # handle 5
  ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 counter packets 0 bytes 0 masquerade  # handle 4
 }

 chain POSTROUTING { # handle 2
  type nat hook postrouting priority srcnat; policy accept;
  counter packets 1372336 bytes 115498744 jump LIBVIRT_PRT # handle 3
 }
}
table ip mangle { # handle 8
 chain LIBVIRT_PRT { # handle 1
  oifname "virbr0" meta l4proto udp udp dport 68 counter packets 0 bytes 0 # CHECKSUM fill # handle 4
 }

 chain POSTROUTING { # handle 2
  type filter hook postrouting priority mangle; policy accept;
  counter packets 14772452 bytes 1662355205 jump LIBVIRT_PRT # handle 3
 }
}
table ip6 filter { # handle 9
 chain LIBVIRT_INP { # handle 1
 }

 chain INPUT { # handle 2
  type filter hook input priority filter; policy accept;
  counter packets 4848294 bytes 542035655 jump LIBVIRT_INP # handle 3
 }

 chain LIBVIRT_OUT { # handle 4
 }

 chain OUTPUT { # handle 5
  type filter hook output priority filter; policy accept;
  counter packets 20968 bytes 3139207 jump LIBVIRT_OUT # handle 6
 }

 chain LIBVIRT_FWO { # handle 7
 }

 chain FORWARD { # handle 8
  type filter hook forward priority filter; policy accept;
  counter packets 5958249 bytes 731911878 jump LIBVIRT_FWX # handle 13
  counter packets 5958249 bytes 731911878 jump LIBVIRT_FWI # handle 11
  counter packets 5958251 bytes 731911990 jump LIBVIRT_FWO # handle 9
 }

 chain LIBVIRT_FWI { # handle 10
 }

 chain LIBVIRT_FWX { # handle 12
 }
}
table ip6 nat { # handle 10
 chain LIBVIRT_PRT { # handle 1
 }

 chain POSTROUTING { # handle 2
  type nat hook postrouting priority srcnat; policy accept;
  counter packets 129514 bytes 16865531 jump LIBVIRT_PRT # handle 3
 }
}
table ip6 mangle { # handle 11
 chain LIBVIRT_PRT { # handle 1
 }

 chain POSTROUTING { # handle 2
  type filter hook postrouting priority mangle; policy accept;
  counter packets 5982294 bytes 736626050 jump LIBVIRT_PRT # handle 3
 }
}

```
