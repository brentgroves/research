# **[Configure Linux as a Router (IP Forwarding)](https://www.linode.com/docs/guides/linux-router-and-ip-forwarding/)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Tasks](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

A computer network is a collection of computer systems that can communicate with each other. In order to communicate with a computer that’s on a different network, a system needs a way to connect to that other network. A router is a system that acts as an intermediary between multiple different networks. It receives traffic from one network that is ultimately destined for another. It identifies where a particular packet should be delivered, then forwards that packet over the appropriate network interface.

There are lots of options for off-the-shelf router solutions for both home and enterprise use. These solutions are often preferred for numerous reasons. They are relatively easy to configure, have lots of features, tend to have a user-friendly management interface, and may even come with support options. Under the hood, these routers are stripped-down computers running common operating systems, such as Linux.

Instead of using one of these pre-built solutions, you can create your own using any Linux server, such as an Akamai Cloud Compute Instance. Routing software like iptables provides total control over configuring a router and firewall to suit your individual needs. This guide covers how to set up a Linux system as a basic router, including enabling IP forwarding and configuring network routing.

## Use Cases for a Cloud-based Router

Many workloads benefit from custom routing or port forwarding solutions, including those workloads hosted on cloud platforms like Akamai. For example, it’s common practice for security-minded applications to connect most of their systems together through a private network, like a VLAN. These systems might need access to an outside network, such as other VLANs or the public internet. Instead of giving each system their own interface to the other network, one system on the private network can act as a router. The router is configured with multiple network interfaces: one to the private VLAN and another to the other network. It then forwards packets from one interface to another. This can make monitoring, controlling, and securing traffic much easier, as it can all be done from a single system. Akamai Cloud Compute Instances can be configured with up to three interfaces, each connecting to either the public internet or a private VLAN:

- Connect systems on private VLAN to the public internet.
- Connect systems on two separate private VLANs.
- Forward IPv6 addresses from a /56 routed range.

## Configure a Linux System as a Router

Here are the basic steps needed to configure a Linux system as a router:

Deploy at least two Compute Instances (or other virtual machines) to the same data center. Connect all systems to the same private network, like a VLAN. Designate one system as the router and connect it to the public internet or a different private network.

Enable IP Forwarding on the Compute Instance designated as the router.

Configure the Routing Software on that router instance. This guide covers using nftables, iptables, or Firewalld.

Define the Gateway on each system other than the router. This gateway should point to the router’s IP address on that network.

Continue reading for detailed instructions on each of these steps.

Deploy Compute Instances
To get started, use the Akamai Cloud Compute platform to deploy multiple Compute Instances. These can mimic a basic application that is operating on a private VLAN with a single router. Skip this section if you already have an application deployed and just wish to know how to configure IP forwarding or the router software.

Deploy two or more Compute Instances to the same region and designate one as the router. This guide uses Debian 12, but the instructions are generally applicable to other Linux distributions. On the deployment page, skip the VLAN section for now. See Creating a Compute Instance to learn how to deploy Linode Compute Instances.

Edit each Compute Instance’s configuration profile. See Managing Configuration Profiles for information on viewing and editing configuration profiles.

Router Instance: On the Compute Instance designated as the router, leave eth0 as the public internet and set eth1 as a VLAN. Enter a name for the VLAN and assign it an IP address from whichever subnet range you wish to use. For example, if you wish to use the 10.0.2.0/24 subnet range, assign the IP address 10.0.2.1/24. By convention, the router should be assigned the value of 1 in the last segment.

Other Instance/s: On each Compute Instance other than the router, remove all existing network interfaces. Set eth0 as a VLAN, select the VLAN you just created, and enter another IP address within your desired subnet (e.g. 10.0.2.2/24, 10.0.2.3/24, and so on).

Confirm that Network Helper is enabled and reboot each Compute Instance for the changes to take effect.

Log in to each instance and test the connectivity on each Compute Instance to ensure proper configuration. To do this, you can use SSH, or Lish if utilizing an Akamai Cloud Compute Instance.

Ping the VLAN IPv4 address of another system within the same VLAN:

Router Instance
ping 10.0.2.2

Other Instance/s
ping 10.0.2.1

Each Compute Instance should be able to ping the IP addresses of all other instances within that VLAN.

Ping an IP address or website of a system on the public internet.

All Instances
ping linode.com

This ping should only be successful for the Compute Instance configured as the router.

## Enable IP Forwarding

IP forwarding plays a fundamental role on a router. This is the functionality that allows a router to forward traffic from one network interface to another. When configured along with routing software, it allows a computer on one network to reach a computer on a different network. Forwarding for both IPv4 and IPv6 addresses are controlled within the Linux kernel. The following kernel parameters are used to enable or disable IPv4 and IPv6 forwarding, respectively:

IPv4: net.ipv4.ip_forward or net.ipv4.conf.all.forwarding
IPv6: net.ipv6.conf.all.forwarding
Forwarding is disabled on most Linux systems by default. However, this must be enabled to configure Linux as a router. To enable forwarding, the corresponding parameter should be set to 1. A value of 0 indicates that forwarding is disabled. To update these kernel parameters, edit the /etc/sysctl.conf file as shown in the steps below:

1. On the Linux system you intend to use as a router, determine if IPv4 forwarding is currently enabled or disabled. The command below outputs the value of the given parameter. A value of 1 indicates that the setting is enabled, while 0 indicates it is disabled.

Router Instance

```bash
sudo sysctl net.ipv4.ip_forward
net.ipv4.ip_forward = 0
```

If this parameter returns with a value of 0, it is disabled, and you must continue with the instructions below.

Note

If you intend to configure IPv6 forwarding, check that kernel parameter as well:

`sudo sysctl net.ipv6.conf.all.forwarding`

Open the /etc/sysctl.conf file using a command-line text editor with sudo permissions such as nano:

Router Instance

`sudo vi /etc/sysctl.conf`

Find the line corresponding with the type of forwarding you wish to enable, uncomment it, and set the value to 1. Alternatively, you can add the following lines anywhere in the file.

File: /etc/sysctl.conf

```bash
# Uncomment the next line to enable packet forwarding for IPv4
net.ipv4.ip_forward=1

# Uncomment the next line to enable packet forwarding for IPv6
#  Enabling this option disables Stateless Address Autoconfiguration
#  based on Router Advertisements for this host
net.ipv6.conf.all.forwarding=1
```

When done, press CTRL+X, followed by Y then Enter to save the file and exit nano.

Once the changes are saved, run the following command (or reboot the machine) to apply them:

Router Instance

```bash
sudo sysctl -p
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1

```

## Configure the Routing Software

Linux network utilities like nftables, iptables, and Firewalld can serve as both a firewall and as a router. This section covers how to configure each of these tools to function as a basic router. You can, alternatively, opt for a commercial routing application.

1. On the Linux system you intend to use as a router, review the existing network rules. On a fresh Linux installation, there may not be any preconfigured rules. If there are, look for any rules that might interfere with your intended configuration. Consult a system administrator or the network utility documentation linked below to help determine.

```bash
sudo iptables -S
# Warning: iptables-legacy tables present, use iptables-legacy to see them
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT

# Refer to the iptables documentation for clarification on any extant rules.

# If necessary, flush your existing rules and configure iptables to allow all traffic:

# Router Instance
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
```

2. Configure the utility to allow port forwarding. This is the default setting for many systems.

accept everything:

```bash
sudo iptables -A FORWARD -j ACCEPT
```

accept ip and port example:

```bash
# allow inbound and outbound forwarding
iptables -D FORWARD -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j ACCEPT
iptables -A FORWARD -p tcp -d 10.188.50.202 --dport 8080 -j ACCEPT
iptables -D FORWARD -s 10.188.50.202/32 -p tcp -m tcp --sport 8080 -j ACCEPT
iptables -A FORWARD -p tcp -s 10.188.50.202 --sport 8080 -j ACCEPT

```

3. Configure NAT (network address translation) within the utility. This modifies the IP address details in network packets, allowing all systems on the private network to share the same public IP address of the router. Replace 10.0.2.0/24 in the following command with the subnet of your private VLAN.

```bash
# sudo iptables -t nat -s 10.0.2.0/24 -A POSTROUTING -j MASQUERADE
sudo iptables -t nat -s 192.168.2.0/24 -A POSTROUTING -j MASQUERADE

sudo iptables -t nat -s 192.168.2.0/24 -A POSTROUTING -j MASQUERADE

```

Note
Alternatively, you can forgo specifying a subnet and allow NAT over all traffic using the command below:

Router Instance

```bash
sudo iptables -t nat -A POSTROUTING -j MASQUERADE

sudo iptables -t nat -S
# Warning: iptables-legacy tables present, use iptables-legacy to see them
-P PREROUTING ACCEPT
-P INPUT ACCEPT
-P OUTPUT ACCEPT
-P POSTROUTING ACCEPT
-A POSTROUTING -j MASQUERADE

```

The SNAT target requires you to give it an IP address to apply to all the outgoing packets. The MASQUERADE target lets you give it an interface, and whatever address is on that interface is the address that is applied to all the outgoing packets. In addition, with SNAT, the kernel's connection tracking keeps track of all the connections when the interface is taken down and brought back up; the same is not true for the MASQUERADE target.

Good documents include the **[HOWTOs on the Netfilter](http://www.netfilter.org/documentation/index.html#documentation-howto)** site and the **[iptables man page](http://linux.die.net/man/8/iptables)**.

SNAT/DNAT example:

```bash
# iptables -t nat -S
# route packets arriving at external IP/port to LAN machine
iptables -t nat -D PREROUTING -d 10.187.40.123/32 -p tcp -m tcp --dport 8080 -j DNAT --to-destination 10.188.50.202:8080
iptables -t nat -A PREROUTING  -p tcp -d 10.187.40.123 --dport 8080 -j DNAT --to-destination 10.188.50.202:8080

# rewrite packets going to LAN machine (identified by address/port)
# to originate from gateway's internal address
iptables -t nat -D POSTROUTING -d 10.188.50.202/32 -p tcp -m tcp --dport 8080 -j SNAT --to-source 10.187.40.123
iptables -t nat -A POSTROUTING -p tcp -d 10.188.50.202 --dport 8080 -j SNAT --to-source 10.187.40.123
```

4. Add route to machines needing to get to private network.

```yaml
network:
  version: 2
  ethernets:
    default:
      match:
        macaddress: "52:54:00:3c:6d:95"
      dhcp-identifier: "mac"
      dhcp4: true
    extra0:
      addresses:
      - 10.188.50.213/24
      nameservers:
         addresses:
         - 10.225.50.203
         - 10.224.50.203
      routes:
      - to: 10.188.40.0/24
        via: 10.188.50.254
      - to: 10.188.42.0/24
        via: 10.188.50.254
      - to: 172.20.88.10.188.40.0/24
        via: 10.188.50.254
      - to: 10.188.73.0/24
        via: 10.188.220.254

      match:
        macaddress: "52:54:00:27:91:55"
      optional: true
```

5. Make the configurations persistent.

Make a systemd service that recreates all rules at boot time so you don't interfere with a hypervisor or container system trying to add it's own ruleset.
