# **[Simple source policy routing](https://tldp.org/HOWTO/Adv-Routing-HOWTO/lartc.rpdb.simple.html)**

## references

<http://linux-ip.net/html/routing-tables.html>

## source policy routing

Let's take a real example once again, I have 2 (actually 3, about time I returned them) cable modems, connected to a Linux NAT ('masquerading') router. People living here pay me to use the Internet. Suppose one of my house mates only visits hotmail and wants to pay less. This is fine with me, but they'll end up using the low-end cable modem.

The 'fast' cable modem is known as 212.64.94.251 and is a PPP link to 212.64.94.1. The 'slow' cable modem is known by various ip addresses, 212.64.78.148 in this example and is a link to 195.96.98.253.

The local table:

```bash
[ahu@home ahu]$ ip route list table local
broadcast 127.255.255.255 dev lo  proto kernel  scope link  src 127.0.0.1 
local 10.0.0.1 dev eth0  proto kernel  scope host  src 10.0.0.1 
broadcast 10.0.0.0 dev eth0  proto kernel  scope link  src 10.0.0.1 
local 212.64.94.251 dev ppp0  proto kernel  scope host  src 212.64.94.251 
broadcast 10.255.255.255 dev eth0  proto kernel  scope link  src 10.0.0.1 
broadcast 127.0.0.0 dev lo  proto kernel  scope link  src 127.0.0.1 
local 212.64.78.148 dev ppp2  proto kernel  scope host  src 212.64.78.148 
local 127.0.0.1 dev lo  proto kernel  scope host  src 127.0.0.1 
local 127.0.0.0/8 dev lo  proto kernel  scope host  src 127.0.0.1 
```

Lots of obvious things, but things that need to be specified somewhere. Well, here they are. The default table is empty.

Let's view the 'main' table:

```bash
[ahu@home ahu]$ ip route list table main
195.96.98.253 dev ppp2  proto kernel  scope link  src 212.64.78.148
212.64.94.1 dev ppp0  proto kernel  scope link  src 212.64.94.251
10.0.0.0/8 dev eth0  proto kernel  scope link  src 10.0.0.1
127.0.0.0/8 dev lo  scope link
default via 212.64.94.1 dev ppp0
```

We now generate a new rule which we call 'John', for our hypothetical house mate. Although we can work with pure numbers, it's far easier if we add our tables to /etc/iproute2/rt_tables.

**[Example 4.6. Typical content of /etc/iproute2/rt_tables](http://linux-ip.net/html/routing-tables.html)**

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

```bash
# echo 200 John >> /etc/iproute2/rt_tables
# ip rule add from 10.0.0.10 table John
# ip rule ls

0: from all lookup local
32765: from 10.0.0.10 lookup John
32766: from all lookup main
32767: from all lookup default
```

Now all that is left is to generate John's table, and flush the route cache:

```bash
# ip route add default via 195.96.98.253 dev ppp2 table John
# ip route flush cache
```

And we are done. It is left as an exercise for the reader to implement this in ip-up.
