# **[How To Forward Ports through a Linux Gateway with Iptables](https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables)**

NAT, or network address translation, is a general term for mangling packets in order to redirect them to an alternative address. Usually, this is used to allow traffic to transcend network boundaries. A host that implements NAT typically has access to two or more networks and is configured to route traffic between them.

Port forwarding is the process of forwarding requests for a specific port to another host, network, or port. As this process modifies the destination of the packet in-flight, it is considered a type of NAT operation.

In this tutorial, we’ll demonstrate how to use iptables to forward ports to hosts behind a firewall by using NAT techniques. This is useful if you’ve configured a private network, but still want to allow certain traffic inside through a designated gateway machine.

## Prerequisites

To follow along with this guide, you will need:

- Two Ubuntu 20.04 servers setup in the same datacenter with private networking enabled. On each of these machines, you will need to set up a non-root user account with sudo privileges. You can learn how to do this with our guide on Ubuntu 20.04 initial server setup guide. Make sure to skip Step 4 of this guide since we will be setting up and configuring the firewall during this tutorial.
- On one of your servers, set up a firewall template with iptables so it can function as your firewall server. You can do this by following our guide on How To Implement a Basic Firewall with Iptables on Ubuntu 20.04. Once completed, your firewall server should have the following ready to use:
- iptables-persistent installed
- Saved the default rule set into /etc/iptables/rules.v4
- An understanding of how to add or adjust rules by editing the rule file or by using the iptables command

The server in which you set up your firewall template will serve as the firewall and router for your private network. For demonstration purposes, the second host will be configured with a web server that is only accessible using its private interface. You’ll be configuring the firewall machine to forward requests received on its public interface to the web server, which it will reach on its private interface.

## Host Details

Before you begin, you need to know what interfaces and addresses are being used by both of your servers.

## Finding Your Network Details

To get the details of your own systems, begin by finding your network interfaces. You can find the interfaces on your machines and the addresses associated with them by running the following:

```bash
ip -4 addr show scope global
Sample Output
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 203.0.113.1/18 brd 45.55.191.255 scope global eth0
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    inet 10.0.0.1/16 brd 10.132.255.255 scope global eth1
       valid_lft forever preferred_lft forever
```

The highlighted output shows two interfaces (eth0 and eth1) and the addresses assigned to each (203.0.113.1 and 10.0.0.1 respectively). To find out which of these interfaces is your public interface, run this command:

```bash
ip route show | grep default

default via 111.111.111.111 dev eth0
```

The interface information from this output (eth0 in this example) will be the interface connected to your default gateway. This is almost certainly your public interface.

Find these values on each of your machines and use them to follow along with the rest of this guide.

## Sample Data Used in this Guide

To make things clearer, we’ll be using the following empty address and interface assignments throughout this tutorial. Please substitute your own values for the ones listed in the following:

Web server network details:

```yaml
Public IP Address: 203.0.113.1
Private IP Address: 10.0.0.1
Public Interface: eth0
Private Interface: eth1
Firewall network details:

Public IP Address: 203.0.113.2
Private IP Address: 10.0.0.2
Public Interface: eth0
Private Interface: eth1
```

Setting Up the Web Server
Begin connecting to your web server host and by logging in with your sudo user.

Installing Nginx
The first step is to install Nginx on your web server host and lock it down so that it only listens to its private interface. This will ensure that your web server will only be available if you correctly set up port forwarding.

Begin by updating the local package cache:

sudo apt update
Next, use apt to download and install the software:

sudo apt install nginx
Restricting Nginx to the Private Network
After Nginx is installed, open up the default server block configuration file to ensure that it only listens to the private interface. Open the file using your preferred text editor. Here we’ll use nano:

sudo nano /etc/nginx/sites-enabled/default
Inside, find the listen directive. It should be listed twice in a row towards the top of the configuration:

/etc/nginx/sites-enabled/default
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    . . .
}
At the first listen directive, add your web server’s private IP address and a colon before the 80 to tell Nginx to only listen on the private interface. We’re only demonstrating IPv4 forwarding in this guide, so you can remove the second listen directive, which is configured for IPv6.

Next, modify the listen directives as follows:

/etc/nginx/sites-enabled/default
server {
    listen 10.0.0.1:80 default_server;

    . . .
}
Save and close the file when you are finished. If you used nano, you can do this by pressing CTRL + X, then Y, and ENTER.

Now test the file for syntax errors:

sudo nginx -t
Output
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
If there are no errors in the output, restart Nginx to enable the new configuration:

sudo systemctl restart nginx

## Verifying the Network Restriction

At this point, it’s useful to verify the level of access you have to your web server.

From your firewall server, try to access your web server from the private interface with the following command:

`curl --connect-timeout 5 10.0.0.1`

If successful, your output will result in the following message:

```html
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
. . .
```

If you try to use the public interface, you’ll receive a message that says it cannot connect:

```bash
curl --connect-timeout 5 203.0.113.1
Output
curl: (7) Failed to connect to 203.0.113.1 port 80: Connection refused
```

These results are expected.

## Configuring the Firewall to Forward Port 80

Now you will work on implementing port forwarding on your firewall machine.

## Enabling Forwarding in the Kernel

The first thing you need to do is enable traffic forwarding at the kernel level. By default, most systems have forwarding turned off.

To turn port forwarding on for this session only, run the following:

`echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward`
1
To turn port forwarding on permanently, you will have to edit the /etc/sysctl.conf file. You can do this by opening the file with sudo privileges:

`sudo nano /etc/sysctl.conf`

Inside the file, find and uncomment the line that reads as follows:

/etc/sysctl.conf
net.ipv4.ip_forward=1

Save and close the file when you are finished.

Then apply the settings in this file. First run the following command:

`sudo sysctl -p`

net.ipv4.ip_forward = 1

Then run the same command, but replace the -p flag with--system:

```bash
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

`sudo iptables -P FORWARD DROP`

At this point, you’ve allowed certain traffic between your public and private interfaces to proceed through your firewall. However, you haven’t configured the rules that will actually tell iptables how to translate and direct the traffic.

## Adding the NAT Rules to Direct Packets Correctly

Next, you will add the rules that will tell iptables how to route your traffic. You need to perform two separate operations in order for iptables to correctly alter the packets so that clients can communicate with the web server.

The first operation, called DNAT, will take place in the PREROUTING chain of the nat table. DNAT is an operation that alters a packet’s destination address in order to enable it to correctly route as it passes between networks. The clients on the public network will be connecting to your firewall server and will have no knowledge of your private network topology. Therefore, you need to alter the destination address of each packet so that when it is sent out on your private network, it knows how to correctly reach your web server.

Since you’re only configuring port forwarding and not performing NAT on every packet that hits your firewall, you’ll want to match port 80 on your rule. You will match packets aimed at port 80 to your web server’s private IP address (10.0.0.1 in the following example):

```bash
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination 10.0.0.1
```

This process takes care of half of the picture. The packet should get routed correctly to your web server. However, right now, the packet will still have the client’s original address as the source address. The server will attempt to send the reply directly to that address, which will make it impossible to establish a legitimate TCP connection.

To configure proper routing, you also need to modify the packet’s source address as it leaves the firewall en route to the web server. You need to modify the source address to your firewall server’s private IP address (10.0.0.2 in the following example). The reply will then be sent back to the firewall, which can then forward it back to the client as expected.

To enable this functionality, add a rule to the POSTROUTING chain of the nat table, which is evaluated right before packets are sent out on the network. You’ll match the packets destined for your web server by IP address and port:

```bash
sudo iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 80 -d 10.0.0.1 -j SNAT --to-source 10.0.0.2

iptables -t nat -A PREROUTING -i eth1 -p tcp --dport 8080 -j DNAT --to 10.32.25.2:80
iptables -t nat -A POSTROUTING -p tcp -d 10.32.25.2 --dport 80 -j MASQUERADE
```
