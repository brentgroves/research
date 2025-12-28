# **[Network Speed Testing](https://www.baeldung.com/linux/network-speed-testing)**

**[Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Research List](../../../../research/research_list.md)**\
**[Back Main](../../../../../README.md)**

## Testing Network Speed Between Two Linux Servers

Efficient data transfer between Linux servers is an important aspect of maintaining a responsive network infrastructure. The speed at which data can be transmitted between servers directly impacts the overall performance of applications and services. For example, features like TCP traffic control can affect the data exchange speeds.

In this tutorial, we’ll explore various tools and methodologies designed to measure the efficiency of data transfer. The goal is to equip users and administrators with the knowledge needed to effectively test network speed between Linux servers.

Notably, if we have a firewall running on the servers, we need to ensure that connections are allowed on the port used. Importantly, we focus solely on working with IP for network testing, and we don’t cover other networking protocols or configurations.

## Using iperf

iperf is a tool for measuring the maximum TCP and UDP bandwidth performance over IP. Hence, it helps to identify the network’s throughput capacity by generating traffic and measuring the data transfer rates between systems.

## 2.1. Installing iperf

First, let’s install iperf via apt-get and sudo:

```bash
sudo apt-get install iperf
```

Once it’s installed, we can start the test.

## TCP Bandwidth Testing

iperf provides a measure of the maximum TCP bandwidth performance.

First, on one of the servers, we set it up as the server by running iperf in server mode:

```bash
# ssh to Avilla desktop
iperf -s
```

Here, we used -s for initiating iperf in server mode to be ready for accepting incoming connections.

At this point, on the other server, let’s run iperf in client mode:

```bash
iperf -c 172.20.88.64
```

## trace route

```bash
traceroute reports-avi  
traceroute to reports-avi (172.20.88.64), 30 hops max, 60 byte packets
 1  _gateway (10.1.1.205)  0.768 ms  0.686 ms  0.652 ms
 2  reports-avi (172.20.88.64)  29.900 ms  29.867 ms  29.835 ms

 10.1.1.205 Albion firewall connected to ligtel
 Going over vpn to avilla Firewall 172.20.88.1
 Firewall 172.20.88.1 connected to comcast (maybe why connection from Albion to Avilla is slow)
 Firewall 10.188.250.? Ligtel located in Avilla connect
 Even now good speed 
 From Avilla ping 10.187.10.12 switch in albion  1 to 2 ms
 10.187.50.125-140 server vlan 
 187 albion
 188 avilla
 185 southfield
 50 - server
 48 - desktop/laptom
 30 - printer

 ligtel at linamar
```
