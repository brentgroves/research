# **[Setting Up Port Forwarding Using iptables](https://contabo.com/blog/linux-port-forwarding-with-iptables/)**

This is a basic example of forwarding packets from one IP to another using a single network interface.

## references

- **[Stack](https://unix.stackexchange.com/questions/76300/iptables-port-to-another-ip-port-from-the-inside)**

## cleanup

- **[delete rules](./delete_rules.md)**
- **[delete namespace](./delete_namespace.md)**

To forward a port, you must understand and manipulate the PREROUTING chain of the nat table. Here is a straightforward example to forward traffic from port 8080 on research21's IP, 10.187.40.123 to port 8080 on a remote machine with IP 10.188.50.202:

```bash
sudo su

# before rule changes
iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT

# iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
iptables -t nat -A PREROUTING -p tcp -s 10.187.40.123 --dport 8080 -j DNAT --to-destination 10.188.50.202:8080

# after prerouting
iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -s 10.187.40.123/32 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080

# iptables -t nat -A PREROUTING -s 192.168.1.10 -j DNAT --to-destination 192.168.1.20
# iptables -t nat -A PREROUTING -i enp0s25 -p tcp --dport 8080 -j DNAT --to 10.188.50.202

# after prerouting
iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
```

Next, ensure the iptables FORWARD chain allows the forwarded traffic:

```bash
sudo su
iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT

iptables -A FORWARD -p tcp -d 10.188.50.202 --dport 8080 -j ACCEPT

# verify rule was added. If we change the default FORWARD rule to DROP we can still forward packets to 10.188.50.202/32.

iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j ACCEPT
```

## SNAT Rule (Optional)

SNAT Rule (Optional): If you need to redirect outgoing traffic from the new IP address back to the original IP, you can use a SNAT (Source Network Address Translation) rule in the POSTROUTING chain:

```bash
# iptables -t nat -A POSTROUTING -s <new_ip> -j SNAT --to-source <original_ip>
iptables -t nat -A POSTROUTING -s 10.188.50.202 -j SNAT --to-source 10.187.40.123

iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -s 10.187.40.123/32 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
-A POSTROUTING -s 10.188.50.202/32 -j SNAT --to-source 10.187.40.123

```

- Replace <new_ip> with the IP address you want to redirect traffic from.
- Replace <original_ip> with the IP address you want the outgoing traffic to appear to be from.

```bash
# iptables -t nat -A  PREROUTING -d 8.8.8.8 -j DNAT --to-destination 192.168.0.10
iptables -t nat -A PREROUTING -p tcp -d 10.187.40.123 --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
# iptables -t nat -A POSTROUTING -s 192.168.0.10 -j SNAT --to-source 8.8.8.8
iptables -t nat -A POSTROUTING -s 10.188.50.202 -j SNAT --to-source 10.187.40.123

```

Finally, apply a masquerade rule to allow proper routing of the responses:

```bash
sudo su

# before masquerade rule is applied
iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080

iptables -t nat -A POSTROUTING -j MASQUERADE
# iptables -t nat -A POSTROUTING -s 10.188.50.0/24 -j MASQUERADE

# after masquerade rule is applied
iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
-A POSTROUTING -j MASQUERADE

# iptables -t nat -D POSTROUTING -s 10.188.50.0/24 -o enp0s25 -j MASQUERADE > /dev/null 2>&1

```

## Plan

Attempting to help facilitate this question I put this diagram together. Please feel free to update if it's incorrect or misrepresenting what you're looking for.

```text
                                 iptables
                                     |                   .---------------.
    .-,(  ),-.                       v               port 80             |
 .-(          )-.        port 8080________               |               |
(    internet    )------------>[_...**...°]------------->|      NAS      |
 '-(          ).-'     10.32.25.2    ^   10.32.25.1      |               |
     '-.( ).-'                       |                   |               |
                                     |                   '---------------'
                                     |
                                     |
                                   __  _
                                  [**]|=|
                                  /::/|_|
```

## answer

I finally found how-to. First, I had to add -i eth1 to my "outside" rule (eth1 is my WAN connection). I also needed to add two others rules. Here in the end what I came with :

```bash
# before rule changes
iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT

iptables -t nat -A PREROUTING -i enp0s25 -p tcp --dport 8080 -j DNAT --to 10.188.50.202

# after prerouting
iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A PREROUTING -i enp0s25 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202

# iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to 10.32.25.2:80
iptables -t nat -A POSTROUTING -p tcp -d 10.32.25.2 --dport 80 -j MASQUERADE


```

The first rule restricts the preroute only if it's arriving on interface eth1. The second rule is more general as it applies to all interfaces. Beware loops! –
tudor -Reinstate Monica-
 CommentedMay 1, 2015 at 5:05
This will work as shown IF the FORWARD table is set to ACCEPT by default. If you have a default DROP FORWARD section, you need to add a rule to allow packets to flow; something like iptables -A FORWARD -p tcp --dport 8080 -j ACCEPT. –
berto
 CommentedJul 18, 2022 at 15:41

## we are using iptables-nft

```bash
# iptables is actually iptables-nft
update-alternatives --display iptables
iptables - auto mode
  link best version is /usr/sbin/iptables-nft
  link currently points to /usr/sbin/iptables-nft
  link iptables is /usr/sbin/iptables
  slave iptables-restore is /usr/sbin/iptables-restore
  slave iptables-save is /usr/sbin/iptables-save
/usr/sbin/iptables-legacy - priority 10
  slave iptables-restore: /usr/sbin/iptables-legacy-restore
  slave iptables-save: /usr/sbin/iptables-legacy-save
/usr/sbin/iptables-nft - priority 20
  slave iptables-restore: /usr/sbin/iptables-nft-restore
  slave iptables-save: /usr/sbin/iptables-nft-save
sudo tcpdump -i enp0s25 'dst 8.8.8.8 and src 10.187.40.123'

```

## enable port forwarding

I don't know if you need this for NATting on the same interface.

To enable packet routing on a Linux system, you need to configure the kernel to forward packets destined for other networks. This typically involves enabling IP forwarding and setting up routing tables with appropriate routes

Temporarily Enable IP Forwarding:

```bash
cat /proc/sys/net/ipv4/ip_forward
0

# (temporarily enables forwarding)
echo 1 > /proc/sys/net/ipv4/ip_forward
# or
sudo sysctl -w net.ipv4.ip_forward=1 

# verify
cat /proc/sys/net/ipv4/ip_forward
1

```

## AI Overview: how to sysctl to make routing permanent

Make it persistent (recommended):

Edit the /etc/sysctl.conf file and add or modify the line net.ipv4.ip_forward=1
Apply the changes with sudo sysctl -p

```bash
sudo sed -i 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sudo sysctl -p
The -p option, followed by a filename (e.g., /etc/sysctl.conf), instructs sysctl to read and apply the kernel parameter settings defined in a file.
```

Then run the same command, but replace the -p flag with--system:

```bash
# --system
              # Load settings from all system configuration files. See the SYSTEM FILE PRECEDENCE section below.
sudo sysctl --system
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

We see that the default is ACCEPT, so we'll change that to DROP:

<!-- I left it as accept for this experiment. -->

```bash
iptables -P FORWARD DROP
# iptables -P FORWARD ACCEPT
# iptables -L FORWARD
Chain FORWARD (policy DROP)
target     prot opt source               destination
#
```

OK, now we want to make some changes to the nat iptable so that we have routing. Let's see what we have first:

```bash
# From isdev in Albion using vlan 40
iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination
```

## enable masquerading for Avilla subnet 10.188.50.0/24

So, firstly, we'll enable masquerading from the 10.188.50.0/24 network onto our main ethernet interface enp0s25:

In iptables, **[masquerading](../../../masquerading/masquerading.md)**, a form of SNAT (Source Network Address Translation), allows multiple internal network devices to share a single external IP address, effectively hiding their private IPs behind the router's public IP.

```bash
# from isdev at albion office on vlan 40 through enx803f5d090eb3
ip a              
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host noprefixroute 
       valid_lft forever preferred_lft forever
2: enp0s25: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 18:03:73:1f:84:a4 brd ff:ff:ff:ff:ff:ff
    inet 10.187.40.123/24 brd 10.187.40.255 scope global dynamic noprefixroute enp0s25
       valid_lft 51365sec preferred_lft 51365sec
    inet6 fe80::6fd5:28c2:e3ca:d7fd/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

# nat: This table is consulted when a packet that creates a new connection is encountered. It consists of three built-ins: PREROUTING (for altering packets as soon as they come in), OUTPUT (for altering locally-generated packets before routing), and POSTROUTING (for altering packets as they are about to go out).
```

The idea is to apply the same rules as we did to forward packets to namespaces to forward packets to a web service on a different host. We are doing this backwards starting with the postrouting rule.

```bash
iptables -t nat -A POSTROUTING -s 10.188.50.0/24 -o enp0s25 -j MASQUERADE

# -t nat: Specifies the NAT table. 
# -A POSTROUTING: Appends a rule to the POSTROUTING chain. 
# -o eth0: Specifies the outgoing interface (e.g., eth0). 
# -j MASQUERADE: Sets the target to MASQUERADE. 
# -m is for matching module name and not string. By using a particular module you get certain options to match. See the cpu module example above. With the -m tcp the module tcp is loaded. The tcp module allows certain options: --dport, --sport, --tcp-flags, --syn, --tcp-option to use in iptables rules
 # -S shows you how to type in the table rule
iptables -t nat -S
iptables -t nat -L
Chain PREROUTING (policy ACCEPT)
target     prot opt source               destination         

Chain INPUT (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain POSTROUTING (policy ACCEPT)
target     prot opt source               destination         
MASQUERADE  all  --  10.188.50.0/24       anywhere     

# list rules by specification
# Purpose: The -S option is used to show the current iptables rules in a format that is easy to read and understand, and that can be used to recreate the rules if needed.
# iptables-legacy -t nat -S only microk8s uses these older tables.

sudo iptables -t nat -S
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A POSTROUTING -s 10.188.50.0/24 -o enp0s25 -j MASQUERADE

```

In the FORWARD chain, you’ll accept new connections destined for port 8080 that are coming from Albion's VLAN 40 to Avilla VLAN 50. New connections are identified by the conntrack extension and will specifically be represented by a TCP SYN packet as in the following:

```bash
# advanced https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables
iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 8080 -j DNAT --to 10.32.25.2:80
iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to 10.32.25.2:80
iptables -t nat -A POSTROUTING -p tcp -d 10.32.25.2 --dport 80 -j MASQUERADE

iptables -A FORWARD -i enp0s25 -o 10.188.50.202 -p tcp --syn --dport 8080 -m conntrack --ctstate NEW -j ACCEPT
# verify

sudo iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -i enp0s25 -o 10.188.50.202 -p tcp -m tcp --dport 8080 --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j ACCEPT
# notice -m was changed from conntrack to tcp
```

This will let the first packet, meant to establish a connection, through the firewall. You’ll also need to allow any subsequent traffic in both directions that results from that connection. To allow ESTABLISHED and RELATED traffic between your public and private interfaces, run the following commands. First for your public interface:

```bash
sudo iptables -A FORWARD -i enp0s25 -o 10.188.50.202 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# -t nat: Specifies the NAT table. 
# -A POSTROUTING: Appends a rule to the POSTROUTING chain. 
# -o eth0: Specifies the outgoing interface (e.g., eth0). 
# -j MASQUERADE: Sets the target to MASQUERADE. 
# -m is for matching module name and not string. By using a particular module you get certain options to match. See the cpu module example above. With the -m tcp the module tcp is loaded. The tcp module allows certain options: --dport, --sport, --tcp-flags, --syn, --tcp-option to use in iptables rules

sudo iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT
-A FORWARD -i enp0s25 -o 10.188.50.202 -p tcp -m tcp --dport 8080 --tcp-flags FIN,SYN,RST,ACK SYN -m conntrack --ctstate NEW -j ACCEPT
-A FORWARD -i enp0s25 -o 10.188.50.202 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i enp0s25 -o 10.188.50.202 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
```
