# **[Conntrack tales - one thousand and one flows](https://blog.cloudflare.com/conntrack-tales-one-thousand-and-one-flows/)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../README.md)**

![c](https://cf-assets.www.cloudflare.com/zkvhlag99gkb/1exWkAQcRhm4LLeCXaTweQ/7fab121cabbc032119e44f2030f06b66/conntrack-tales-one-thousand-and-one-flows.png)

At Cloudflare we develop new products at a great pace. Their needs often challenge the architectural assumptions we made in the past. For example, years ago we decided to avoid using Linux's "conntrack" - stateful firewall facility. This brought great benefits - it simplified our iptables firewall setup, sped up the system a bit and made the inbound packet path easier to understand.

But eventually our needs changed. One of our new products had a reasonable need for it. But we weren't confident - can we just enable conntrack and move on? How does it actually work? I volunteered to help the team understand the dark corners of the "conntrack" subsystem.

## What is conntrack?

"Conntrack" is a part of Linux network stack, specifically part of the firewall subsystem. To put that into perspective: early firewalls were entirely stateless. They could express only basic logic, like: allow SYN packets to port 80 and 443, and block everything else.

The stateless design gave some basic network security, but was quickly deemed insufficient. You see, there are certain things that can't be expressed in a stateless way. The canonical example is assessment of ACK packets - it's impossible to say if an ACK packet is legitimate or part of a port scanning attempt, without tracking the connection state.

To fill such gaps all the operating systems implemented connection tracking inside their firewalls. This tracking is usually implemented as a big table, with at least 6 columns: protocol (usually TCP or UDP), source IP, source port, destination IP, destination port and connection state. On Linux this subsystem is called "conntrack" and is often enabled by default. Here's how the table looks on my laptop inspected with "conntrack -L" command:

![ct](https://cf-assets.www.cloudflare.com/zkvhlag99gkb/57PxFTDUBFZqODrE5OrOul/a9d34a54bf247021ba000b15119461bc/image5-2.png)

The obvious question is how large this state tracking table can be. This setting is under "/proc/sys/net/nf_conntrack_max":

```bash
cat /proc/sys/net/nf_conntrack_max
262144
```

This is a global setting, but the limit is per container. On my system each container, or "network namespace", can have up to 256K conntrack entries.

What exactly happens when the number of concurrent connections exceeds the conntrack limit?

## Testing conntrack is hard

In past testing conntrack was hard - it required complex hardware or vm setup. Fortunately, these days we can use modern "user namespace" facilities which do permission magic, allowing an unprivileged user to feel like root. Using the tool "unshare" it's possible to create an isolated environment where we can precisely control the packets going through and experiment with iptables and conntrack without threatening the health of our host system. With appropriate parameters it's possible to create and manage a networking namespace, including access to namespaced iptables and conntrack, from an unprivileged user.

## This script is the heart of our test

```bash
# Enable tun interface
ip tuntap add name tun0 mode tun
ip link set tun0 up
ip addr add 192.0.2.1 peer 192.0.2.2 dev tun0
ip route add 0.0.0.0/0 via 192.0.2.2 dev tun0

# Refer to conntrack at least once to ensure it's enabled
iptables -t raw -A PREROUTING -j CT
# Create a counter in mangle table
iptables -t mangle -A PREROUTING
# Make sure reverse traffic doesn't affect conntrack state
iptables -t raw -A OUTPUT -p tcp --sport 80 -j DROP

tcpdump -ni any -B 16384 -ttt &
...
./venv/bin/python3 send_syn.py

conntrack -L
# Show iptables counters
iptables -nvx -t raw -L PREROUTING
iptables -nvx -t mangle -L PREROUTING
```

This bash script is shortened for readability. See the full version **[here](https://github.com/cloudflare/cloudflare-blog/blob/master/2020-04-conntrack-syn/test-1.bash)**. The accompanying "send_syn.py" is just sending 10 SYN packets over "tun0" interface. **[Here is the source](https://github.com/cloudflare/cloudflare-blog/blob/master/2020-04-conntrack-syn/send_syn.py)** but allow me to paste it here - showing off "scapy" is always fun:

```python
tun = TunTapInterface("tun0", mode_tun=True)
tun.open()

for i in range(10000,10000+10):
    ip=IP(src="198.18.0.2", dst="192.0.2.1")
    tcp=TCP(sport=i, dport=80, flags="S")
    send(ip/tcp, verbose=False, inter=0.01, socket=tun)
```

The bash script above contains a couple of gems. Let's walk through them.

First, please note that we can't just inject packets into the loopback interface using SOCK_RAW sockets. The Linux networking stack is a complex beast. The semantics of sending packets over a **[SOCK_RAW](http://man7.org/linux/man-pages/man7/raw.7.html)** are different then delivering a packet over a real interface. We'll discuss this later, but for now, to avoid triggering unexpected behaviour, we will deliver packets over a tun/tap device which better emulates a real interface.

Then we need to make sure the conntrack is active in the network namespace we wish to use for testing. Traditionally, just loading the kernel module would have done that, but in the brave new world of containers and network namespaces, a method had to be found to allow conntrack to be active in some and inactive in other containers. Hence this is tied to usage - rules referencing conntrack must exist in the namespace's iptables for conntrack to be active inside the container.

As a side note, **[containers triggering host to load kernel modules](https://lwn.net/Articles/740455/)** is an **[interesting subject](https://github.com/weaveworks/go-odp/blob/6b0aa22550d9325eb8f43418185859e13dc0de1d/odp/dpif.go#L67-L90)**.

After the "-t raw -A PREROUTING" rule, which we added "-t mangle -A PREROUTING" rule, but notice - it doesn't have any action! This syntax is allowed by iptables and it is pretty useful to get iptables to report rule counters. We'll need these counters soon. A careful reader might suggest looking at "policy" counters in iptables to achieve our goal. Sadly, "policy" counters (increased for each packet entering a chain), work only if there is at least one rule inside it.

The rest of the steps are self-explanatory. We set up "tcpdump" in the background, send 10 SYN packets to 127.0.0.1:80 using the "scapy" Python library. Then we print the conntrack table and iptables counters.

Let's run this script in action. Remember to run it under networking namespace as fake root with "unshare -Ur -n":

![i](https://cf-assets.www.cloudflare.com/zkvhlag99gkb/4xUiZXoGQrhYU3Lugqbx97/9db644c8c56f944445fc7ebb559d6d95/image6.png)

This is all nice. First we see a "tcpdump" listing showing 10 SYN packets. Then we see the conntrack table state, showing 10 created flows. Finally, we see iptables counters in two rules we created, each showing 10 packets processed.
