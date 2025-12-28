# **[arping](http://linux-ip.net/html/tools-arping.html)**

## B.2. arping

An almost unknown command (mostly because it is not frequently necessary), the arping utility performs an action similar to ping, but at the Ethernet layer. Where ping tests the reachability of an IP address, arping reports the reachability and round-trip time of an IP address hosted on the local network.

There are several modes of operation for this utility. Under normal operation, arping displays the Ethernet and IP address of the target as well as the time elapsed between the arp request and the arp reply.

Example B.4. Displaying reachability of an IP on the local Ethernet with arping

```bash
[root@masq-gw]# arping -I eth0 -c 2 192.168.100.17
ARPING 192.168.100.17 from 192.168.100.254 eth0
Unicast reply from 192.168.100.17 [00:80:C8:E8:4B:8E]  8.419ms
Unicast reply from 192.168.100.17 [00:80:C8:E8:4B:8E]  2.095ms
Sent 2 probes (1 broadcast(s))
Received 2 response(s)
```

Other options to the arping utility include the ability to send a broadcast arp using the -U option and the ability to send a gratuitous reply using the -A option. A kernel with support for non-local bind can be used with arping for the nefarious purpose of wreaking havoc on an otherwise properly configured Ethernet. By performing gratuitous arp and broadcasting incorrect arp information, arp tables in poorly designed IP stacks can become **quite confused.**

arping can detect if an IP address is currently in use on an Ethernet. Called duplicate address detection, this use of arping is increasingly common in networking scripts.

For a practical example, let's assume a laptop named dietrich is normally connected to a home network with the same IP address as tristan of our main office network. In the boot scripts, dietrich might make good use of arping by testing reachability of the IP it wants to use before bringing up the IP layer.

Example B.5. Duplicate Address Detection with arping

```bash
[root@dietrich]# arping -D -q -I eth0 -c 2 192.168.99.35
[root@dietrich]# echo $?
1
[root@dietrich]# arping -D -q -I eth0 -c 2 192.168.99.36
[root@dietrich]# echo $?
0
arping -D -q -I enp0s25 -c 2 172.20.3.21
echo $?
0

Interface: enp0s25, type: EN10MB, MAC: 18:03:73:1f:84:a4, IPv4: 10.1.0.113
Starting arp-scan 1.9.7 with 1 hosts (https://github.com/royhills/arp-scan)

3 packets received by filter, 0 packets dropped by kernel
Ending arp-scan 1.9.7: 1 hosts scanned in 1.776 seconds (0.56 hosts/sec). 0 responded
```

First, dietrich tests reachability of its preferred IP (192.168.99.35). Because the IP address is in use by tristan, dietrich receives a response. Any response by a device on the Ethernet indicating that an IP address is in use will cause the arping command to exit with a non-zero exit code (specifically, exit code 1).

Note, that the Ethernet device must already be in an UP state (see Section B.3, “ip link”). If the Ethernet device has not been brought up, the arping utility will exit with a non-zero exit code (specifically, exit code 2).
