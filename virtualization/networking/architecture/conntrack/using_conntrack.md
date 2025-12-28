# **[Chapter 5. Using conntrack: the command line interface](https://conntrack-tools.netfilter.org/manual.html#:~:text=conntrack%20provides%20a%20full%20featured,also%20listen%20to%20flow%20events.)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../README.md)**

## reference

- **[ubuntu man page](https://manpages.ubuntu.com/manpages/noble/man8/conntrack.8.html)**

The /proc/net/nf_conntrack interface is very limited as it only allows you to display the existing flows, their state and metadata such the flow mark:

```bash
 # cat /proc/net/nf_conntrack
 tcp      6 431982 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34846 dport=993 packets=169 bytes=14322 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34846 packets=113 bytes=34787 [ASSURED] mark=0 use=1
 tcp      6 431698 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34849 dport=993 packets=244 bytes=18723 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34849 packets=203 bytes=144731 [ASSURED] mark=0 use=1
 ```

You can list the existing flows using the conntrack utility via -L command:

```bash
 conntrack -L
 tcp      6 431982 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34846 dport=993 packets=169 bytes=14322 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34846 packets=113 bytes=34787 [ASSURED] mark=0 use=1
 tcp      6 431698 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34849 dport=993 packets=244 bytes=18723 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34849 packets=203 bytes=144731 [ASSURED] mark=0 use=1
conntrack v1.4.6 (conntrack-tools): 2 flow entries have been shown.
```

The conntrack syntax is similar to iptables.

You can filter out the listing without using grep:

```bash
ssh ubuntu@10.188.50.214
sudo conntrack -L -p tcp --dport 22
tcp      6 431995 ESTABLISHED src=10.188.40.230 dst=10.188.50.214 sport=56764 dport=22 src=10.188.50.214 dst=10.188.40.230 sport=22 dport=56764 [ASSURED] mark=0 use=1
conntrack v1.4.8 (conntrack-tools): 1 flow entries have been shown.

 # conntrack -L -p udp --dport 53
udp      17 6 src=fd42:7277:90ec:a57f:24d8:22ae:50e:5249 dst=fd42:7277:90ec:a57f::1 sport=56533 dport=53 src=fd42:7277:90ec:a57f::1 dst=fd42:7277:90ec:a57f:24d8:22ae:50e:5249 sport=53 dport=56533 mark=0 use=1
udp      17 6 src=10.188.40.230 dst=10.225.50.203 sport=40439 dport=53 src=10.225.50.203 dst=10.188.40.230 sport=53 dport=40439 mark=0 use=1
udp      17 6 src=10.188.40.230 dst=10.225.50.203 sport=32957 dport=53 src=10.225.50.203 dst=10.188.40.230 sport=53 dport=32957 mark=0 use=1
udp      17 6 src=172.25.188.35 dst=8.8.8.8 sport=44543 dport=53 src=8.8.8.8 dst=172.25.188.35 sport=53 dport=44543 mark=0 use=1
udp      17 6 src=fd42:7277:90ec:a57f:24d8:22ae:50e:5249 dst=fd42:7277:90ec:a57f::1 sport=59457 dport=53 src=fd42:7277:90ec:a57f::1 dst=fd42:7277:90ec:a57f:24d8:22ae:50e:5249 sport=53 dport=59457 mark=0 use=1
udp      17 6 src=fd42:7277:90ec:a57f:24d8:22ae:50e:5249 dst=fd42:7277:90ec:a57f::1 sport=59126 dport=53 src=fd42:7277:90ec:a57f::1 dst=fd42:7277:90ec:a57f:24d8:22ae:50e:5249 sport=53 dport=59126 mark=0 use=1
```

You can update the ct mark, extending the previous example:

```bash
 # conntrack -U -p tcp --dport 993 --mark 10
 tcp      6 431982 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34846 dport=993 packets=169 bytes=14322 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34846 packets=113 bytes=34787 [ASSURED] mark=10 use=1
conntrack v1.4.6 (conntrack-tools): 1 flow entries have been updated.
```

In Linux, ct_mark (or connmark) is a 32-bit metadata field used within the connection tracking system (conntrack) to tag network connections, allowing for more granular routing and firewalling decisions based on connection-specific information.

You can also delete entries

```bash
 # conntrack -D -p tcp --dport 993
 tcp      6 431982 ESTABLISHED src=192.168.2.100 dst=123.59.27.117 sport=34846 dport=993 packets=169 bytes=14322 src=123.59.27.117 dst=192.168.2.100 sport=993 dport=34846 packets=113 bytes=34787 [ASSURED] mark=10 use=1
conntrack v1.4.6 (conntrack-tools): 1 flow entries have been deleted.
 ```

This allows you to block TCP traffic if:

You have a stateful rule-set that drops traffic in INVALID state.

You set /proc/sys/net/netfilter/nf_conntrack_tcp_loose to zero.

You can also listen to the connection tracking events:

```bash
 # conntrack -E
     [NEW] udp      17 30 src=192.168.2.100 dst=192.168.2.1 sport=57767 dport=53 [UNREPLIED] src=192.168.2.1 dst=192.168.2.100 sport=53 dport=57767
  [UPDATE] udp      17 29 src=192.168.2.100 dst=192.168.2.1 sport=57767 dport=53 src=192.168.2.1 dst=192.168.2.100 sport=53 dport=57767
     [NEW] tcp      6 120 SYN_SENT src=192.168.2.100 dst=66.102.9.104 sport=33379 dport=80 [UNREPLIED] src=66.102.9.104 dst=192.168.2.100 sport=80 dport=33379
  [UPDATE] tcp      6 60 SYN_RECV src=192.168.2.100 dst=66.102.9.104 sport=33379 dport=80 src=66.102.9.104 dst=192.168.2.100 sport=80 dport=33379
  [UPDATE] tcp      6 432000 ESTABLISHED src=192.168.2.100 dst=66.102.9.104 sport=33379 dport=80 src=66.102.9.104 dst=192.168.2.100 sport=80 dport=33379 [ASSURED]
```

There are many options, including support for XML output, more advanced filters, and so on. Please check the manpage for more information.

## Chapter 6. Setting up conntrackd: the daemon
