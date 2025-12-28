# **[Configuring the Firewall to Forward Port 80](https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\
**[Main](../../../../../../README.md)**

## AI Overview: what is RFC 1918 network

RFC 1918 defines the private IP address ranges (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16) that are reserved for use within private networks and are not routable on the public internet.

## Enabling Forwarding in the Kernel

The first thing you need to do is enable traffic forwarding at the kernel level. By default, most systems have forwarding turned off.

To turn port forwarding on for this session only, run the following:

```bash
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
Output
1
```

To turn port forwarding on permanently, you will have to edit the /etc/sysctl.conf file. You can do this by opening the file with sudo privileges:

```bash
sudo nano /etc/sysctl.conf
```

Inside the file, find and uncomment the line that reads as follows:

```bash
/etc/sysctl.conf
net.ipv4.ip_forward=1
```

Save and close the file when you are finished.

Then apply the settings in this file. First run the following command:

```bash
sudo sysctl -p
Output
net.ipv4.ip_forward = 1
````

Then run the same command, but replace the -p flag with--system:

```bash
sudo sysctl --system

Output
. . .
* Applying /usr/lib/sysctl.d/50-pid-max.conf ...
kernel.pid_max = 4194304
* Applying /etc/sysctl.d/99-cloudimg-ipv6.conf ...
net.ipv6.conf.all.use_tempaddr = 0
net.ipv6.conf.default.use_tempaddr = 0
* Applying /etc/sysctl.d/99-sysctl.conf ...
net.ipv4.ip_forward = 1
* Applying /usr/lib/sysctl.d/protect-links.conf ...
fs.protected_fifos = 1
fs.protected_hardlinks = 1
fs.protected_regular = 2
fs.protected_symlinks = 1
* Applying /etc/sysctl.conf ...
net.ipv4.ip_forward = 1
```

## Adding Forwarding Rules to the Basic Firewall

Next, you will configure your firewall so that traffic flowing into your public interface (eth0) on port 80 will be forwarded to your private interface (eth1).

The firewall you configured in the prerequisite tutorial has your FORWARD chain set to DROP traffic by default. You need to add rules that will allow you to forward connections to your web server. For security’s sake, you’ll lock this down fairly tightly so that only the connections you wish to forward are allowed.

In the FORWARD chain, you’ll accept new connections destined for port 80 that are coming from your public interface and traveling to your private interface. New connections are identified by the conntrack extension and will specifically be represented by a TCP SYN packet as in the following:

```bash
sudo iptables -A FORWARD -i eth0 -o eth1 -p tcp --syn --dport 80 -m conntrack --ctstate NEW -j ACCEPT
```

This will let the first packet, meant to establish a connection, through the firewall. You’ll also need to allow any subsequent traffic in both directions that results from that connection. To allow ESTABLISHED and RELATED traffic between your public and private interfaces, run the following commands. First for your public interface:

```bash
sudo iptables -A FORWARD -i eth0 -o eth1 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

Then for your private interface:

```bash
sudo iptables -A FORWARD -i eth1 -o eth0 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

Double check that your policy on the FORWARD chain is set to DROP:

In iptables, "-P" sets the default policy for a built-in chain (like INPUT, OUTPUT, or FORWARD) to either ACCEPT or DROP.

```bash
sudo iptables -P FORWARD DROP
```

At this point, you’ve allowed certain traffic between your public and private interfaces to proceed through your firewall. However, you haven’t configured the rules that will actually tell iptables how to translate and direct the traffic.

## Adding the NAT Rules to Direct Packets Correctly

Next, you will add the rules that will tell iptables how to route your traffic. You need to perform two separate operations in order for iptables to correctly alter the packets so that clients can communicate with the web server.

The first operation, called DNAT, will take place in the PREROUTING chain of the nat table. DNAT is an operation that alters a packet’s destination address in order to enable it to correctly route as it passes between networks. The clients on the public network will be connecting to your firewall server and will have no knowledge of your private network topology. Therefore, you need to alter the destination address of each packet so that when it is sent out on your private network, it knows how to correctly reach your web server.

Since you’re only configuring port forwarding and not performing NAT on every packet that hits your firewall, you’ll want to match port 80 on your rule. You will match packets aimed at port 80 to your web server’s private IP address (10.0.0.1 in the following example):

```bash
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1
# if different port is used
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1:8080

```

This process takes care of half of the picture. The packet should get routed correctly to your web server. However, right now, the packet will still have the client’s original address as the source address. The server will attempt to send the reply directly to that address, which will make it impossible to establish a legitimate TCP connection.

On DigitalOcean, packets leaving a Droplet with a different source address will actually be dropped by the hypervisor, so your packets at this stage will never even make it to the web server (which will be fixed by implementing SNAT momentarily). This is an anti-spoofing measure put in place to prevent attacks where large amounts of data are requested to be sent to a victim’s computer by `faking the source address` in the request. To learn more, read this response in our community.

To configure proper routing, you also need to **modify the packet’s source address as it leaves the firewall en route to the web server**. You need to modify the source address to your firewall server’s **private IP address (10.0.0.2 in the following example)**. The reply will then be sent back to the firewall, which can then forward it back to the client as expected.

To enable this functionality, add a rule to the POSTROUTING chain of the nat table, which is evaluated right before packets are sent out on the network. You’ll match the packets destined for your web server by IP address and port:

```bash
sudo iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 80 -d 10.0.0.1 -j SNAT --to-source 10.0.0.2
```

If you use masquerading instead of snat then

```bash
iptables -t nat -A POSTROUTING -s 192.168.0.0/255.255.255.0 -o ens5 -j MASQUERADE

# -t nat: Specifies the NAT table. 
# -A POSTROUTING: Appends a rule to the POSTROUTING chain. 
# -o eth0: Specifies the outgoing interface (e.g., eth0). 
# -j MASQUERADE: Sets the target to MASQUERADE. 
```
