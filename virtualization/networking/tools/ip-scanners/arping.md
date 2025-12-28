# **[So how can you issue ARP-requests on your own?](https://networkengineering.stackexchange.com/questions/19947/how-to-send-an-arp-request-manually)**

By using what we know from above we can make your computer do so:

delete your ARP table (sudo arp -ad on Mac OS X)
contact other computers on your local network (eg ping 192.168.2.2).

The underlying network stack will check if it knows the MAC address (which it does not) and issue an ARP-request.

There is no need to have a complete arp table already before you actually need it when communicating with other hosts, but if you explicitly want to have it you could ping all hosts in your network:

```bash
for i in {1..254}; do ping -c 1 192.168.2.$i > /dev/null &; done
```

This command

- pings every host in your network (192.168.2.{1..254})
- once (-c 1)
- and outputs the results to /dev/null
- You should have all active hosts on your network in your arp table afterwards.

## Using tools

You could also use **[arping](https://github.com/ThomasHabets/arping)** to issue ARP-requests for IP-addresses from your command line.

If your need is to reproduce the same (getting same packet again), capture the packet into a file using tcpdump (at the receiving end) and replay the captured packets using tcpreplay tool (at the sending end).

While capturing packet(s) using tcpdump, use the "-w " option to save packet(s) into a file. The captured packet(s) in the file can be replayed using tcpreply.

## **[arping](https://github.com/ThomasHabets/arping)**

The arping utility sends ARP and/or ICMP requests to the specified host and displays the replies. The host may be specified by its hostname, its IP address, or ...

Arping is a util to find out if a specific IP address on the LAN is 'taken'
and what MAC address owns it. Sure, you *could* just use 'ping' to find out if
it's taken and even if the computer blocks ping (and everything else) you still
get an entry in your ARP cache. But what if you aren't on a routable net? Or
the host blocks ping (all ICMP even)? Then you're screwed. Or you use arping.

## install

Command 'arping' not found, but can be installed with:
sudo apt install iputils-arping  # version 3:20211215-1, or
sudo apt install arping          # version 2.22-1

## usage

```bash
arping [-AbDfhqUV] [-c count] [-w deadline] [-i interval] [-s source] [-I interface] {destination}

OPTIONS
       -A
           The same as -U, but ARP REPLY packets used instead of ARP REQUEST.

       -b
           Send only MAC level broadcasts. Normally arping starts from sending broadcast, and
           switch to unicast after reply received.

       -c count
           Stop after sending count ARP REQUEST packets. With deadline option, instead wait for
           count ARP REPLY packets, or until the timeout expires.

       -D
           Duplicate address detection mode (DAD). See RFC2131, 4.4.1. Returns 0, if DAD
           succeeded i.e. no replies are received.

       -f
           Finish after the first reply confirming that target is alive.

       -I interface
           Name of network device where to send ARP REQUEST packets.

       -h
           Print help page and exit.

       -q
           Quiet output. Nothing is displayed.

       -s source
           IP source address to use in ARP packets. If this option is absent, source address is:

               • In DAD mode (with option -D) set to 0.0.0.0.

               • In Unsolicited ARP mode (with options -U or -A) set to destination.

               • Otherwise, it is calculated from routing tables.

       -U
           Unsolicited ARP mode to update neighbours' ARP caches. No replies are expected.

       -V
           Print version of the program and exit.

       -w deadline
           Specify a timeout, in seconds, before arping exits regardless of how many packets have
           been sent or received. In this case arping does not stop after count packet are sent,
           it waits either for deadline expire or until count probes are answered.

       -i interval
           Specify an interval, in seconds, between packets.

```
