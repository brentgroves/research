# **[How to forward ports](https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables)

## Prerequisites

To follow along with this guide, you will need:

- Two Ubuntu 20.04 servers setup in the same datacenter with private networking enabled. On each of these machines, you will need to set up a non-root user account with sudo privileges. You can learn how to do this with our guide on Ubuntu 20.04 initial server setup guide. Make sure to skip Step 4 of this guide since we will be setting up and configuring the firewall during this tutorial.

- On one of your servers, set up a firewall template with iptables so it can function as your firewall server. You can do this by following our guide on How To Implement a Basic Firewall with Iptables on Ubuntu 20.04. Once completed, your firewall server should have the following ready to use:

## search

iproute2 port forwarding

## references

<https://phoenixnap.com/kb/iptables-port-forwarding>

<https://www.redswitches.com/blog/linux-port-forwarding/>

<https://www.digitalocean.com/community/tutorials/how-to-forward-ports-through-a-linux-gateway-with-iptables>

## libvirt/qemu way

This method also uses iptables to accomplish this task.

**If you would like to make a service that is on a guest behind a NATed virtual network publicly available, you can setup libvirt's "hook" script for qemu to install the necessary iptables rules to forward incoming connections to the host on any given port HP to port GP on the guest GNAME:**

## Install Persistent Firewall Package

```bash
sudo apt update
sudo apt install iptables-persistent
```

## Set up Basic IPv4 Rules

After installing the persistent firewall, edit the firewall server's configuration to set up basic IPv4 rules.

1. Open the rules.v4 file in a text editor to add the rules.

```bash
sudo nano /etc/iptables/rules.v4
```
