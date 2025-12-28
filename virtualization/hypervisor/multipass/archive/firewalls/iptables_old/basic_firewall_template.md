# **[How To Implement a Basic Firewall Template with Iptables on Ubuntu 20.04](https://www.digitalocean.com/community/tutorials/how-to-implement-a-basic-firewall-template-with-iptables-on-ubuntu-20-04)**

## Introduction

Implementing a firewall is an important step in securing your server. A large part of that is deciding on the individual rules and policies that will enforce traffic restrictions to your network. Firewalls like iptables also allow you to have a say about the structural framework in which your rules are applied.

In this guide, you’ll learn how to construct a firewall that can be the basis for more complex rule sets. This firewall will focus primarily on providing reasonable defaults and establishing a framework that encourages extensibility.

## Prerequisites

To complete this tutorial, you will need access to an Ubuntu 20.04 server with a non-root user configured with sudo privileges. You can do this by following all the steps outlined in our Ubuntu 20.04 initial server setup guide, except for Step 4, since we will be setting up the firewall in this tutorial.

Additionally, we recommend reviewing the firewall policies you wish to implement. You can follow **[this guide](https://www.digitalocean.com/community/tutorials/how-to-choose-an-effective-firewall-policy-to-secure-your-servers)** to get a better idea of what to consider.

## Installing the Persistent Firewall Service

Begin by updating the local package cache:

```bash
sudo apt update
# Now install the iptables-persistent package. This allows you to save your rule sets and have them automatically applied at boot:
# iptables-persistent on Ubuntu has netfilter-persistent as a dependency: https://packages.ubuntu.com/bionic/iptables-persistent


sudo apt install iptables-persistent
```

During the installation, you’ll be asked whether you want to save your current rules, select <Yes>. Please note that you’ll be running the netfilter-persistent command to execute the iptables persistent firewall service. Next, you’ll edit the generated rules files.

<!-- iptables-persistent on Ubuntu has netfilter-persistent as a dependency: https://packages.ubuntu.com/bionic/iptables-persistent -->

## A Note About IPv6 in this Guide

Before we get started, we’ll briefly discuss IPv4 vs IPv6. The iptables command only handles IPv4 traffic. For IPv6 traffic, a separate companion tool called ip6tables is used. The rules are stored in separate tables and chains. For the netfilter-persistent command, the IPv4 rules are written to and read from /etc/iptables/rules.v4, and the IPv6 rules are stored in /etc/iptables/rules.v6.

This guide assumes that you are not actively using IPv6 on your server. If your services do not leverage IPv6, it’s safer to block access entirely, as will be demonstrated in this guide.

## Implementing the Basic Firewall Policy (The Quick Way)

For the purpose of getting up and running as quickly as possible, we’ll show you how to edit the rules file directly and copy and paste the finished firewall policy. Afterwards, we will explain the general strategy and how these rules could be implemented using the iptables command instead of modifying the file.

To implement the firewall policy and framework, you’ll edit the /etc/iptables/rules.v4 and /etc/iptables/rules.v6 files. Open the rules.v4 file in your preferred text editor. Here, we’ll use nano:

```bash
sudo nano /etc/iptables/rules.v4
```

Did not see anything in these files maybe I should combine this tutorial with # **[How to Set Up A Firewall Using Iptables on Ubuntu 22.04](https://www.liquidweb.com/kb/set-firewall-using-iptables-ubuntu-16-04/)** another whose first command showed something.

How Can I See Firewall Rules in Ubuntu?
Before making any changes to your firewall, it is best practice to view the existing rule set and understand what ports are already open or closed. To list all firewall rules, run the following command.

```bash
iptables -L

If this is a brand new Ubuntu 16.04 installation, you may see there are no rules defined! Here is an example “empty” output with no rules set:

Chain INPUT (policy ACCEPT)
target     prot opt source               destination
Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
```
