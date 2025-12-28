# **[sysctl](https://phoenixnap.com/kb/sysctl)**

Linux administrators use the sysctl command to read or modify kernel parameters at runtime. The option to control and modify networking, I/O operations, and memory management settings in real-time, without performing a reboot, is essential for high-availability systems.

Find out how to use the sysctl command and its options to tweak system performance on the fly.

## Prerequisites

- A user account with root or sudo privileges.
- Access to a command line/terminal window.

Note: Modifying kernel parameters affects system behavior, performance, and security. Always test parameter changes in a controlled environment, like a virtual machine, before applying them to production systems.

## sysctl Command Syntax

Linux kernel parameters are in the proc/sys/ directory. The sysctl command allows admins to make structured changes to these parameters and retain the changes on reboots without interacting with /proc/sys/ files directly.

The sysctl command in Linux has the following syntax:

```sysctl [options] [variable[=value] ...]```

Note: In command-line syntax, square brackets [] typically indicate that a parameter is optional.

- sysctl - The command name.
- [options] - The command accepts optional flags to customize the behavior.
- [variable] - The name of the kernel parameter you want sysctl to read or modify.  Enter a variable without a value to read the current value of the variable only.
- [=value] - If the command contains a variable, you can assign a value to the variable. Entering a value will set the new value for the variable.
- ... - The three full stops mean it's possible to specify multiple variable=value pairs in a single sysctl command.

```bash
sudo ls /proc/sys/                             
abi  debug  dev  fs  kernel  net  user vm
```

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

What is in the nftable config file?

```bash
flush ruleset
table ip filter {
 chain LIBVIRT_INP {
  iifname "virbr0" udp dport 53 counter packets 0 bytes 0 accept
  iifname "virbr0" tcp dport 53 counter packets 0 bytes 0 accept
  iifname "virbr0" udp dport 67 counter packets 0 bytes 0 accept
  iifname "virbr0" tcp dport 67 counter packets 0 bytes 0 accept
 }

 chain INPUT {
  type filter hook input priority filter; policy accept;
  counter packets 114632 bytes 20385937 jump LIBVIRT_INP
 }

 chain LIBVIRT_OUT {
  oifname "virbr0" udp dport 53 counter packets 0 bytes 0 accept
  oifname "virbr0" tcp dport 53 counter packets 0 bytes 0 accept
  oifname "virbr0" udp dport 68 counter packets 0 bytes 0 accept
  oifname "virbr0" tcp dport 68 counter packets 0 bytes 0 accept
 }

 chain OUTPUT {
  type filter hook output priority filter; policy accept;
  counter packets 7390 bytes 944183 jump LIBVIRT_OUT
 }

 chain LIBVIRT_FWO {
  iifname "virbr0" ip saddr 192.168.122.0/24 counter packets 0 bytes 0 accept
  iifname "virbr0" counter packets 0 bytes 0 reject
 }

 chain FORWARD {
  type filter hook forward priority filter; policy accept;
  counter packets 105067 bytes 17237212 jump LIBVIRT_FWX
  counter packets 105067 bytes 17237212 jump LIBVIRT_FWI
  counter packets 105067 bytes 17237212 jump LIBVIRT_FWO
 }

 chain LIBVIRT_FWI {
  oifname "virbr0" ip daddr 192.168.122.0/24 ct state established,related counter packets 0 bytes 0 accept
  oifname "virbr0" counter packets 0 bytes 0 reject
 }

 chain LIBVIRT_FWX {
  iifname "virbr0" oifname "virbr0" counter packets 0 bytes 0 accept
 }
}
table ip nat {
 chain LIBVIRT_PRT {
  ip saddr 192.168.122.0/24 ip daddr 224.0.0.0/24 counter packets 8 bytes 608 return
  ip saddr 192.168.122.0/24 ip daddr 255.255.255.255 counter packets 0 bytes 0 return
  meta l4proto tcp ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 counter packets 0 bytes 0 masquerade to :1024-65535
  meta l4proto udp ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 counter packets 1 bytes 635 masquerade to :1024-65535
  ip saddr 192.168.122.0/24 ip daddr != 192.168.122.0/24 counter packets 0 bytes 0 masquerade
 }

 chain POSTROUTING {
  type nat hook postrouting priority srcnat; policy accept;
  counter packets 9257 bytes 902738 jump LIBVIRT_PRT
 }
}
table ip mangle {
 chain LIBVIRT_PRT {
  oifname "virbr0" udp dport 68 counter packets 0 bytes 0
 }

 chain POSTROUTING {
  type filter hook postrouting priority mangle; policy accept;
  counter packets 112693 bytes 18268840 jump LIBVIRT_PRT
 }
}
table ip6 filter {
 chain LIBVIRT_INP {
 }

 chain INPUT {
  type filter hook input priority filter; policy accept;
  counter packets 56509 bytes 8363701 jump LIBVIRT_INP
 }

 chain LIBVIRT_OUT {
 }

 chain OUTPUT {
  type filter hook output priority filter; policy accept;
  counter packets 522 bytes 64636 jump LIBVIRT_OUT
 }

 chain LIBVIRT_FWO {
 }

 chain FORWARD {
  type filter hook forward priority filter; policy accept;
  counter packets 45054 bytes 7090326 jump LIBVIRT_FWX
  counter packets 45054 bytes 7090326 jump LIBVIRT_FWI
  counter packets 45054 bytes 7090326 jump LIBVIRT_FWO
 }

 chain LIBVIRT_FWI {
 }

 chain LIBVIRT_FWX {
 }
}
table ip6 nat {
 chain LIBVIRT_PRT {
 }

 chain POSTROUTING {
  type nat hook postrouting priority srcnat; policy accept;
  counter packets 574 bytes 75572 jump LIBVIRT_PRT
 }
}
table ip6 mangle {
 chain LIBVIRT_PRT {
 }

 chain POSTROUTING {
  type filter hook postrouting priority mangle; policy accept;
  counter packets 45676 bytes 7183872 jump LIBVIRT_PRT
 }
}
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
table ip test {
 chain input {
  type filter hook input priority 100; policy accept;
 }

 chain output {
  type filter hook output priority 100; policy accept;
 }
}
```

What the wiki has for a basic routing firewall.

```
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
