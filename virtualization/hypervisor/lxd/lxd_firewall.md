# **[How to configure your firewall](https://documentation.ubuntu.com/lxd/en/latest/howto/network_bridge_firewalld/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## reference

- **[gentoo](https://wiki.gentoo.org/wiki/Nftables/Examples)**


Linux firewalls are based on netfilter. LXD uses the same subsystem, which can lead to connectivity issues.

If you run a firewall on your system, you might need to configure it to allow network traffic between the managed LXD bridge and the host. Otherwise, some network functionality (DHCP, DNS and external network access) might not work as expected.

You might also see conflicts between the rules defined by your firewall (or another application) and the firewall rules that LXD adds. For example, your firewall might erase LXD rules if it is started after the LXD daemon, which might interrupt network connectivity to the instance.

## xtables vs. nftables
There are different userspace commands to add rules to netfilter: xtables (iptables for IPv4 and ip6tables for IPv6) and nftables.

xtables provides an ordered list of rules, which might cause issues if multiple systems add and remove entries from the list. nftables adds the ability to separate rules into namespaces, which helps to separate rules from different applications. However, if a packet is blocked in one namespace, it is not possible for another namespace to allow it. Therefore, rules in one namespace can still affect rules in another namespace, and firewall applications can still impact LXD network functionality.

If your system supports and uses nftables, LXD detects this and switches to nftables mode. In this mode, LXD adds its rules into the nftables, using its own nftables namespace.

## Use LXD’s firewall

By default, managed LXD bridges add firewall rules to ensure full functionality. If you do not run another firewall on your system, you can let LXD manage its firewall rules.

To enable or disable this behavior, use the ipv4.firewall or ipv6.firewall configuration options.

## Use another firewall

Firewall rules added by other applications might interfere with the firewall rules that LXD adds. Therefore, if you use another firewall, you should disable LXD’s firewall rules. You must also configure your firewall to allow network traffic between the instances and the LXD bridge, so that the LXD instances can access the DHCP and DNS server that LXD runs on the host.

See the following sections for instructions on how to disable LXD’s firewall rules and how to properly configure firewalld and UFW, respectively.

## Disable LXD’s firewall rules

Run the following commands to prevent LXD from setting firewall rules for a specific network bridge (for example, lxdbr0):

```bash
lxc network set <network_bridge> ipv6.firewall false
lxc network set <network_bridge> ipv4.firewall false
```

firewalld: Add the bridge to the trusted zone
To allow traffic to and from the LXD bridge in firewalld, add the bridge interface to the trusted zone. To do this permanently (so that it persists after a reboot), run the following commands:

```bash
sudo firewall-cmd --zone=trusted --change-interface=<network_bridge> --permanent
sudo firewall-cmd --reload
```

For example:

```bash
sudo firewall-cmd --zone=trusted --change-interface=lxdbr0 --permanent
sudo firewall-cmd --reload
```

Warning

The commands given above show a simple example configuration. Depending on your use case, you might need more advanced rules and the example configuration might inadvertently introduce a security risk.

## UFW: Add rules for the bridge

If UFW has a rule to drop all unrecognized traffic, it blocks the traffic to and from the LXD bridge. In this case, you must add rules to allow traffic to and from the bridge, as well as allowing traffic forwarded to it.

To do so, run the following commands:

```bash
sudo ufw allow in on <network_bridge>
sudo ufw route allow in on <network_bridge>
sudo ufw route allow out on <network_bridge>
```

For example:

```bash
sudo ufw allow in on lxdbr0
sudo ufw route allow in on lxdbr0
sudo ufw route allow out on lxdbr0
```

Warning

The commands given above show a simple example configuration. Depending on your use case, you might need more advanced rules and the example configuration might inadvertently introduce a security risk.

Here’s an example for more restrictive firewall rules that limit access from the guests to the host to only DHCP and DNS and allow all outbound connections:

```bash
# allow the guest to get an IP from the LXD host
sudo ufw allow in on lxdbr0 to any port 67 proto udp
sudo ufw allow in on lxdbr0 to any port 547 proto udp

# allow the guest to resolve host names from the LXD host
sudo ufw allow in on lxdbr0 to any port 53

# allow the guest to have access to outbound connections
CIDR4="$(lxc network get lxdbr0 ipv4.address | sed 's|\.[0-9]\+/|.0/|')"
CIDR6="$(lxc network get lxdbr0 ipv6.address | sed 's|:[0-9]\+/|:/|')"
sudo ufw route allow in on lxdbr0 from "${CIDR4}"
sudo ufw route allow in on lxdbr0 from "${CIDR6}"
```

## Prevent connectivity issues with LXD and Docker

Running LXD and Docker on the same host can cause connectivity issues. A common reason for these issues is that Docker sets the global FORWARD policy to drop, which prevents LXD from forwarding traffic and thus causes the instances to lose network connectivity. See Docker on a router for detailed information.

There are different ways of working around this problem:

## Uninstall Docker

The easiest way to prevent such issues is to uninstall Docker from the system that runs LXD and restart the system. You can run Docker inside a LXD container or virtual machine instead.

See Running Docker inside of a LXD container for detailed information.

## Enable IPv4 forwarding

If uninstalling Docker is not an option, enabling IPv4 forwarding before the Docker service starts will prevent Docker from modifying the global FORWARD policy. LXD bridge networks enable this setting normally. However, if LXD starts after Docker, then Docker will already have modified the global FORWARD policy.

Warning

Enabling IPv4 forwarding can cause your Docker container ports to be reachable from any machine on your local network. Depending on your environment, this might be undesirable. See local network container access issue for more information.

To enable IPv4 forwarding before Docker starts, ensure that the following sysctl setting is enabled:

`net.ipv4.conf.all.forwarding=1`

Sysctl is a tool that allows users to read and change the attributes of a system kernel. It is available in some Unix-like operating systems, including Linux and Mac OS X. 

Important

You must make this setting persistent across host reboots.

One way of doing this is to add a file to the /etc/sysctl.d/ directory using the following commands:

```bash
echo "net.ipv4.conf.all.forwarding=1" > /etc/sysctl.d/99-forwarding.conf
systemctl restart systemd-sysctl
```

Allow egress network traffic flows
If you do not want the Docker container ports to be potentially reachable from any machine on your local network, you can apply a more complex solution provided by Docker.

Use the following commands to explicitly allow egress network traffic flows from your LXD managed bridge interface:

iptables  -I DOCKER-USER -i <network_bridge> -j ACCEPT
ip6tables -I DOCKER-USER -i <network_bridge> -j ACCEPT
iptables  -I DOCKER-USER -o <network_bridge> -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -I DOCKER-USER -o <network_bridge> -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
For example, if your LXD managed bridge is called lxdbr0, you can allow egress traffic to flow using the following commands:

iptables  -I DOCKER-USER -i lxdbr0 -j ACCEPT
ip6tables -I DOCKER-USER -i lxdbr0 -j ACCEPT
iptables  -I DOCKER-USER -o lxdbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
ip6tables -I DOCKER-USER -o lxdbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
Important

You must make these firewall rules persistent across host reboots. How to do this depends on your Linux distribution.