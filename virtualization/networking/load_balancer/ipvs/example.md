# **[Load balancing with IPVS](https://medium.com/google-cloud/load-balancing-with-ipvs-1c0a48476c4d)**

IP Virtual Server (IPVS) implements L4 Load Balancing directly inside the Linux kernel. I needed to make it work in GCP, thinking this can't be that difficult. And I got some headaches, together with a lot of fun :)

When life is easy
A Cloud environment like GCP is great. Initially it is a bit confusing because networking has other rules, but then you start to love all the abstractions it provides. For instance, implementing L4 Load Balancing is done through one of those services you can configure and mostly forget, it just works™.

Well, true, it may not always be that easy. But there are few occasions when you need to debug by going deeper than just reviewing your configuration. Sometimes I need to resort to tcpdump (that I really enjoy), and this is how this story started. But I didn't imagine how it would end up.

The task at hand, running a L4 Load Balancer. In a cloud environment there are times when you don’t get exactly the service you need. In this case the why is not that important, I will explain it later, but the thing is that I (my customer) decided to use IPVS. It is part of the Linux Virtual Server project, where it runs in a server host as a transport-layer load balancer offering a single VIP to access services of real servers. If you don't know, IPVS is used by the kube-proxy component of Kubernetes.

This can’t be that difficult…

## Give it a try

So I went for it. I deployed a very simple setup with three VMs, I like to start simple when testing. A client machine, the virtual server for IPVS, and a real server (as LVS calls them). Yes, one real server only, not difficult to load balance…

![i1](https://miro.medium.com/v2/resize:fit:640/format:webp/1*tMeaQ0eXyejaJp_7EJHfgQ.png)

The virtual server had the IP 10.1.0.6, the VIP for the service that I configured. The real server ran a simple python-based HTTP server listening to port 8085 and giving a Hello! message. I usually choose ports like 8085 because if you need to do a packet capture it will not be mixed with other traffic in typical ports like 80 or 443. To test it, the client should be able to reach it.

![i2](https://miro.medium.com/v2/resize:fit:720/format:webp/1*5NNKfH5goYz65TK_hlOzmg.png)

![i2](https://miro.medium.com/v2/resize:fit:720/format:webp/1*cFJeggBG_V7Nfp2RJdr0pg.png)

Then I configured IPVS in the virtual server. First I installed ipvsadm, the tool to configure IPVS in the kernel, and with it I set up a new IPVS service pointing to the real server.

```bash
sudo apt-get install ipvsadm
sudo ipvsadm -A -t 10.1.0.6:8085
sudo ipvsadm -a -t 10.1.0.6:8085 -r 10.1.0.50 -m
```

IPVS supports TCP and UDP, three packet-forwarding methods (DSR, ipip, or masquerading), multiple load balancing or scheduling algorithms, and many other options. Besides using TCP for the test (-t), I was only interested in doing masquerading/NAT (-m) because the other forwarding methods, specially DSR, are less suitable for running in GCP and for my purposes. And for the rest of options I left the defaults. You can find more information in the IPVS man page.

![i2](https://miro.medium.com/v2/resize:fit:720/format:webp/1*AvdK4BLVQm8aU4aDutheVQ.png)

Pretty simple. Time to test if I could reach the real server from the client through the VIP of the virtual server…

![i3](https://miro.medium.com/v2/resize:fit:720/format:webp/1*ezU1_4PlNl1qcKNvShcI6g.png)

## Fail

After two seconds not seeing a response you know something is wrong. Well, no worries, time to use tcpdump.

## What is masquerading really

Dumping packets should tell me what is going on, I thought. Running tcpdump in the three VMs should give you the full story, but I’ll just show you the capture from the virtual server since it was in the middle of the traffic.

![i4](https://miro.medium.com/v2/resize:fit:720/format:webp/1*cOuZBpz3EkNXsP_Js771eg.png)

The virtual server received a packet from 10.1.0.3, the client, destined to 10.1.0.6, the VIP; look also the ports. Then IPVS kicked off and transformed the packet to reach the real server 10.1.0.50 and sent it out on the wire. But hey, what’s that? the source IP address, it is still 10.1.0.3!

I thought I had configured masquerading. For those familiar with iptables, Masquerade is a target similar to SNAT, where the source IP is translated to that of the host forwarding the packet, the virtual server in this case.

Well, it turns out that IPVS doesn’t work that way. IPVS does DNAT, only, which is useful in a model called two-arm load balancing.

![i5](https://miro.medium.com/v2/resize:fit:640/format:webp/1*s8wNZLdDSvljaoV5CiYUwA.png)

With a bit of imagination you can see why it is called two-arm. The load balancer acts as a router with one arm on each network and all the traffic between these networks goes through the load balancer.

Very useful model when you can use it. Avoiding SNAT you preserve the client IP and avoid possible issues with port allocation and exhaustion. But not what I needed, and what I was expecting! IPVS says it forwards using masquerading, for me this is misleading.

So now what?

## Return to the roots

Here is where I started to go deeper and deeper, resorting first to iptables and thinking that would be enough. Long time since I worked in all these topics…

iptables rules
IPVS doesn’t do SNAT so I thought on doing it by hand via iptables. I could use as target either SNAT or MASQUERADE (MAS-QUE-RA-DE, you know?).

`sudo iptables -t nat -A POSTROUTING -s 10.1.0.3 -j MASQUERADE`

mach2 example:

```bash
ptables -t nat -A PREROUTING  -p tcp -d 10.187.40.123 --dport 8080 -j DNAT --to-destination 10.188.50.202:8080

iptables -t nat -A POSTROUTING -p tcp -d 10.188.50.202 --dport 8080 -j SNAT --to-source 10.187.40.123
```

A real scenario would need to consider not just the client IP but the whole range of clients somehow, or the destinations, but for my test was enough. Then sent a request from the client via curl and…

![i5](https://miro.medium.com/v2/resize:fit:720/format:webp/1*FosbrFoDvH4UprRZDh4zvg.png)

Whaaat? Nothing happened, as if there were no SNAT rule at all! Really, wasn’t the rule hit?

![i6](https://miro.medium.com/v2/resize:fit:720/format:webp/1*YJyJXN4mJcyQ0m4f50XYYA.png)

I googled around and found there is an iptables match for IPVS. I don’t like to leave things without understanding them, but I thought it would be a good idea to test this instead.

```bash
sudo iptables -t nat -A POSTROUTING -m ipvs --vaddr 10.1.0.6 -j MASQUERADE
```

Guess what? Same result, or same no-result. The rule was not hit either. However, reading a bit more I found that “CONFIG_IP_VS_NFCT” should be enabled and sysctl var “conntrack” set to 1, whatever that meant.

## Kernel sources and modules

If you have played with compiling the Linux kernel you will have recognized the CONFIG format. Reading the sources I found this:

![i7](https://miro.medium.com/v2/resize:fit:720/format:webp/1*Koh1w_TLuK1Re6v0kw18lA.png)

Oh my God, this is it! Netfilter is the kernel framework for packet filtering that iptables, connection tracking, IPVS and other components rely on. And it seems that without explicitly enabling it IPVS didn’t allow to access this filtering from user space. So I checked it:

![i8](https://miro.medium.com/v2/resize:fit:720/format:webp/1*Z6vTJTIB_PO18SYZAKda3w.png)

```bash
grep CONFIG_IP_VS_NFCT /boot/config-`uname -r`      
CONFIG_IP_VS_NFCT=y
```

Weird, it was enabled and apparently built into the kernel. I dug a bit more:

![i9](https://miro.medium.com/v2/resize:fit:720/format:webp/1*3nvJmqHE1_92SWfBJ90f7g.png)

Oh, I see. What that means is that the code for IP_VS_NFCT is part of the kernel object IP_VS…

![i10](https://miro.medium.com/v2/resize:fit:720/format:webp/1*px7qrplmxNeuWB8OVxwLZg.png)

```bash
grep CONFIG_IP_VS /boot/config-`uname -r` 
CONFIG_IP_VS=m
CONFIG_IP_VS_IPV6=y
# CONFIG_IP_VS_DEBUG is not set
CONFIG_IP_VS_TAB_BITS=12
CONFIG_IP_VS_PROTO_TCP=y
CONFIG_IP_VS_PROTO_UDP=y
CONFIG_IP_VS_PROTO_AH_ESP=y
CONFIG_IP_VS_PROTO_ESP=y
CONFIG_IP_VS_PROTO_AH=y
CONFIG_IP_VS_PROTO_SCTP=y
CONFIG_IP_VS_RR=m
CONFIG_IP_VS_WRR=m
CONFIG_IP_VS_LC=m
CONFIG_IP_VS_WLC=m
CONFIG_IP_VS_FO=m
CONFIG_IP_VS_OVF=m
CONFIG_IP_VS_LBLC=m
CONFIG_IP_VS_LBLCR=m
CONFIG_IP_VS_DH=m
CONFIG_IP_VS_SH=m
CONFIG_IP_VS_MH=m
CONFIG_IP_VS_SED=m
CONFIG_IP_VS_NQ=m
CONFIG_IP_VS_TWOS=m
CONFIG_IP_VS_SH_TAB_BITS=8
CONFIG_IP_VS_MH_TAB_INDEX=12
CONFIG_IP_VS_FTP=m
CONFIG_IP_VS_NFCT=y
CONFIG_IP_VS_PE_SIP=m
```

…that is loaded as a module, not a built-in feature…

![i12](https://miro.medium.com/v2/resize:fit:720/format:webp/1*hl2bHpd_TEt3uLzGuq1GxQ.png)

…but that was also loaded in the running kernel. And if you look carefully you can also see the module xt_ipvs that allows to match IPVS connection properties of a packet configured from user space through iptables, no need to use modprobe. So it seems everything was in place.

But wait, there was one more element, the sysctl var “conntrack”:

![i13](https://miro.medium.com/v2/resize:fit:720/format:webp/1*cqrERW1RcwDvyL91rgA7GA.png)

There it was, under net.ipv4.vs entry, and it was not set! I was lucky because that entry is present only if ipvsadm service is started, though I saw it in the kernel sources too and you also have the kernel documentation:

![i14](https://miro.medium.com/v2/resize:fit:720/format:webp/1*as9wqXxOO_6Bftan44FwRA.png)

**[Linux networking documentation for ipvs-sysctl](https://www.kernel.org/doc/html/v5.10/networking/ipvs-sysctl.html)**
As it states, iptables wouldn’t handle IPVS connections without conntrack set! So I set it, crossed fingers and launched curl again:

![i15](https://miro.medium.com/v2/resize:fit:720/format:webp/1*OTRS9kCFNKi5dy9f_36aCQ.png)

Great, it worked! Hey, not so fast. The SNAT did its job, you can see a TCP SYN packet with the source IP 10.1.0.3 translated to the virtual server IP 10.1.0.6. And the real server sent the corresponding SYN-ACK to the virtual server. However communication got stuck in that phase, no ACK reply from the client. Indeed, it seemed the SYN-ACK was not NAT translated back, how come?

NAT implementation is stateful, if a NATed packet goes out and comes back it is processed to undo the NATing. We can check this via the connection tracking system:

![i16](https://miro.medium.com/v2/resize:fit:720/format:webp/1*EOB2QO6nf0ibers-S-mQlg.png)

OK, so the conntrack system did process the SYN-ACK from 10.1.0.50 to 10.1.0.6 (it changed the connection to SYN_RECV state). So then, what happened to the packet? It was dropped at some point but, how could I find it out?

## Debugging the kernel (yep)

I know, the idea of debugging the kernel sounded like going down a rabbit hole but at this point I was decided to get to the bottom of this. I considered several tools to do kernel tracing: Kgdb, SystemTap, perf (that I even slightly tried), eBPF. But I wanted to keep it simple and stay focused on the problem.

Since I wanted to debug the networking stack monitoring packet drops in the kernel without too much hassle, I used **[Dropwatch](https://github.com/nhorman/dropwatch)**. It is a simple interactive utility exactly for that. Using it requires some packages to be installed:

```bash
sudo apt-get install git libpcap-dev libnl-3-dev libnl-genl-3-dev binutils-dev libreadline6-dev autoconf libtool pkg-config build-essential
```

You will need to clone the repo of the project and compile it:

```bash
git clone <https://github.com/nhorman/dropwatch>
cd dropwatch
./autogen.sh
./configure
make
sudo make install
```

When Dropwatch runs and detects a packet drop, it tells you the raw instruction pointer where it happened, but that's hardly useful. Mapping that instruction pointer to the corresponding function name of the kernel is what I needed, and **[Dropwatch can do](https://linux.die.net/man/1/dropwatch)** that using the kernel's symbols file kallsyms:

`sudo dropwatch -l kas`

I started it to report dropped packets and launched curl in the client machine:

![i16](https://miro.medium.com/v2/resize:fit:720/format:webp/1*OKl_qelMTY-sPIJ8bOX6Pg.png)

Oh, beautiful, what memories! Function symbols and hexadecimal addresses :) This showed that packet drops were happening at **[ip_error](https://elixir.bootlin.com/linux/v5.10/source/net/ipv4/route.c#L939)** function, offset 0x7d. Well, that function is quite short and it was easy to spot the call to kfree_skb, the kernel function that frees socket buffers.

What is more interesting is ip_error is called in the input path, and the reasons to discard a packet. In particular, it called my attention the case host unreachable that increments the **[SNMP counter IpInAddrErrors](https://www.kernel.org/doc/html/latest/networking/snmp_counter.html)**. It deals with the case “The destination IP address is not a local address and IP forwarding is not enabled”. Let’s think on this:

- A reply packet from the real server 10.1.0.50 ➔ 10.1.0.6 is “SNATed” back to 10.1.0.50 ➔ 10.1.0.3
- We would expect that reply packet be handled by IPVS to translate it to the corresponding 10.1.0.6 ➔ 10.1.0.3, but IPVS kicks off in the input path before SNAT
- Now the input path needs to handle a packet destined to 10.1.0.3, not this host 10.1.0.6. It can’t so it drops it

To test my theory I used nstat (netstat is deprecated) while launching curl and observed how the counter was incrementing with every ip_error drop:

![i17](https://miro.medium.com/v2/resize:fit:720/format:webp/1*TWuIwmcpEYh3pjcKHAhL_A.png)

You may wonder, how do I know IPVS kicks off before SNAT? Looking at the **[sources](https://elixir.bootlin.com/linux/v5.10/source/net/netfilter/ipvs/ip_vs_core.c#L2249)**. And also looking there I found the answer I needed:

![i18](https://miro.medium.com/v2/resize:fit:720/format:webp/1*eGDqLwD0Inc8h8U7LxfSQA.png)

IPVS is hooked in several places (Netfilter hooks), including the FORWARD chain. So what I needed is to reach IPVS there to process the reply instead of dropping the packet, and you guessed how: enabling IP forwarding.

## Last step

Enabling IP forwarding usually means a host will act as a router. I didn’t enable it initially because this was not the case, but anyhow it was needed. Note there is a VM setting in GCP, canIpForward, if you really want that VM to behave as a router but again, this was not the point so no need to set it.

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

Finally:

![i20](https://miro.medium.com/v2/resize:fit:720/format:webp/1*5YpOATi_cOFdddQtpisnIg.png)

![i21](https://miro.medium.com/v2/resize:fit:720/format:webp/1*5YpOATi_cOFdddQtpisnIg.png)

![i22](https://miro.medium.com/v2/resize:fit:720/format:webp/1*5YpOATi_cOFdddQtpisnIg.png)

Final remarks
Wow, this was a tough one. Well, before finalizing a few comments:

The LVS project is not only made of IPVS, there are more components to create a highly scalable and available cluster of servers, with features like transport-level and application-level load balancing, and cluster management. I only scratched the surface.
One of those components is Keepalived that provides health checking. If you configure the virtual and real servers through keepalived instead of ipvsadm, the Full NAT solution I explained here will not work. I haven’t investigated why.
Although I only tested TCP, IPVS supports both TCP and UDP. And UDP support was indeed what motivated this. My customer required to load balance TCP and UDP traffic to on-premises servers from clients in GCP. Our Internal TCP/UDP Load Balancing doesn’t support on-premises backends, and the Internal TCP Proxy Load Balancing supports on-premises backends but not UDP.
The setup of the test explained is similar to a one-arm model where load balancer, clients and servers share the same network and Full NAT is needed. However, if you wanted to avoid SNAT or required to preserve the client IP it would be possible to create a two-arm setup with multi-nic load balancers.
In the LVS official page I found (old) news regarding support of Full NAT mode in IPVS starting with Linux kernel 2.6.32. However, I haven't found any code in recent kernels to prove that support nor the way to configure it.
I have to say all in all it has been an interesting experience!

## iptables way

```bash
# iptables -t nat -S
# allow inbound and outbound forwarding
iptables -D FORWARD -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.188.50.202 --dport 8080 -j ACCEPT

iptables -D FORWARD -s 10.188.50.202/32 -p tcp -m tcp --sport 8080 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.188.50.202 --sport 8080 -j ACCEPT

# iptables -t nat -S
# route packets arriving at external IP/port to LAN machine
iptables -t nat -D PREROUTING -d 10.187.40.123/32 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
iptables -t nat -A PREROUTING  -p tcp -d 10.187.40.123 --dport 8080 -j DNAT --to-destination 10.188.50.202:8080

# rewrite packets going to LAN machine (identified by address/port)
# to originate from gateway's internal address
iptables -t nat -D POSTROUTING -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j SNAT --to-source 10.187.40.123
iptables -t nat -A POSTROUTING -p tcp -d 10.188.50.202 --dport 8080 -j SNAT --to-source 10.187.40.123

```
