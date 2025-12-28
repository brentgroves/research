# **[Routing Tables](http://linux-ip.net/html/routing-tables.html)**

## references

<http://linux-ip.net/html/routing-tables.html>

Linux kernel 2.2 and 2.4 support multiple routing tables [22]. Beyond the two commonly used routing tables (the local and main routing tables), the kernel supports up to 252 additional routing tables.

The multiple routing table system provides a flexible infrastructure on top of which to implement policy routing. By allowing multiple traditional routing tables (keyed primarily to destination address) to be combined with the routing policy database (RPDB) (keyed primarily to source address), the kernel supports a well-known and well-understood interface while simultaneously expanding and extending its routing capabilities. Each routing table still operates in the traditional and expected fashion. Linux simply allows you to choose from a number of routing tables, and to traverse routing tables in a user-definable sequence until a matching route is found.

Any given routing table can contain an arbitrary number of entries, each of which is keyed on the following characteristics (cf. Table 4.1, “Keys used for hash table lookups during route selection”)

- destination address; a network or host address (primary key)
- tos; Type of Service
**[scope](http://linux-ip.net/html/tools-ip-address.html#tb-tools-ip-addr-scope)**
- output interface

Kernels supporting multiple routing tables refer to routing tables by unique integer slots between 0 and 255 [24]. The two routing tables normally employed are table 255, the local routing table, and table 254, the main routing table. For examples of using multiple routing tables, see Chapter 9, Advanced IP Management, in particular, Example 10.1, “Multiple Outbound Internet links, part I; ip route”, Example 10.3, “Multiple Outbound Internet links, part III; ip rule” and Example 10.4, “Multiple Internet links, inbound traffic; using iproute2 only ”. Also be sure to read Section 10.3, “Using the Routing Policy Database and Multiple Routing Tables” and Section 4.9, “Routing Policy Database (RPDB)”.

The ip route and ip rule commands have built in support for the special tables main and local. Any other routing tables can be referred to by number or an administratively maintained mapping file, /etc/iproute2/rt_tables.

The format of this file is extraordinarily simple. Each line represents one mapping of an arbitrary string to an integer. Comments are allowed.

Example 4.6. Typical content of /etc/iproute2/rt_tables

```bash
#
# reserved values
#
255     local      1
254     main       2
253     default    3
0       unspec     4
#
# local
#
1      inr.ruhep   5
```

1 - The local table is a special routing table maintained by the kernel. Users can remove entries from the local routing table at their own risk. Users cannot add entries to the local routing table. The file /etc/iproute2/rt_tables need not exist, as the iproute2 tools have a hard-coded entry for the local table.
2 - The main routing table is the table operated upon by route and, when not otherwise specified, by ip route. The file /etc/iproute2/rt_tables need not exist, as the iproute2 tools have a hard-coded entry for the main table.
3 - The default routing table is another special routing table, but WHY is it special!?!
4 - Operating on the unspec routing table appears to operate on all routing tables simultaneously. Is this true!? What does that imply?
5 - This is an example indicating that table 1 is known by the name inr.ruhep. Any references to table inr.ruhep in an ip rule or ip route will substitue the value 1 for the word inr.ruhep.

The routing table manipulated by the conventional route command is the main routing table. Additionally, the use of both ip address and ifconfig will cause the kernel to alter the local routing table (and usually the main routing table). For further documentation on how to manipulate the other routing tables, see the command description of ip route.

## Routing Table Entries (Routes)

Each routing table can contain an arbitrary number of route entries. Aside from the local routing table, which is maintained by the kernel, and the main routing table which is partially maintained by the kernel, all routing tables are controlled by the administrator or routing software. All routes on a machine can be changed or removed [25].

Each of the following route types is available for use with the ip route command. Each route type causes a particular sort of behaviour, which is identified in the textual description. Compare the route types described below with the rule types available for use in the RPDB.

**unicast**
A unicast route is the most common route in routing tables. This is a typical route to a destination network address, which describes the path to the destination. Even complex routes, such as nexthop routes are considered unicast routes. If no route type is specified on the command line, the route is assumed to be a unicast route.

Example 4.7. unicast route types

```bash
ip route add unicast 192.168.0.0/24 via 192.168.100.5
ip route add default via 193.7.255.1
ip route add unicast default via 206.59.29.193
ip route add 10.40.0.0/16 via 10.72.75.254
```

**broadcast**
This route type is used for link layer devices (such as Ethernet cards) which support the notion of a broadcast address. This route type is used only in the local routing table [26] and is typically handled by the kernel.

Example 4.8. broadcast route types

```bash
ip route add table local broadcast 10.10.20.255 dev eth0 proto kernel scope link src 10.10.20.67
ip route add table local broadcast 192.168.43.31 dev eth4 proto kernel scope link src 192.168.43.14
```

**local**
The kernel will add entries into the local routing table when IP addresses are added to an interface. This means that the IPs are locally hosted IPs [27].

Example 4.9. local route types

```bash
ip route add table local local 10.10.20.64 dev eth0 proto kernel scope host src 10.10.20.67
ip route add table local local 192.168.43.12 dev eth4 proto kernel scope host src 192.168.43.14
```

**nat**
This route entry is added by the kernel in the local routing table, when the user attempts to configure stateless NAT. See Section 5.3, “Stateless NAT with iproute2” for a fuller discussion of network address translation in general. [28].

Example 4.10. nat route types

```bash
ip route add nat 193.7.255.184 via 172.16.82.184
ip route add nat 10.40.0.0/16 via 172.40.0.0
```

## **unreachable**

When a request for a routing decision returns a destination with an unreachable route type, an ICMP unreachable is generated and returned to the source address.

Example 4.11. unreachable route types

```bash
ip route add unreachable 172.16.82.184
ip route add unreachable 192.168.14.0/26
ip route add unreachable 209.10.26.51
```
