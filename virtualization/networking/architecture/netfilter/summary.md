# **[Firewall](https://help.ubuntu.com/community/Firewall)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

## My Summary

- hypervisors and docker use iptables for NATting.
- iptables-nft are used by default
- docker, libvirt, and multipass all add rules
- if you want to add more rules it's ok but you can't blindly save and restore the ruleset using common tools.
- you may be able to add your rules at system startup with messing thing up by using iptables commands in a shell script.

## Contents

Introduction
Managing the Firewall
iptables
UFW
Guarddog
See Also
External Links

## Introduction

Traffic into or out of a computer is filtered through "ports," which are relatively arbitrary designations appended to traffic packets destined for use by a particular application.

By convention, some ports are routinely used for particular types of applications. For example, port 80 is generally used for insecure web browsing and port 443 is used for secure web browsing.

Traffic to particular applications can be allowed or blocked by "opening" or "closing" (i.e. filtering) the ports designated for a particular type of traffic. If port 80 is "closed," for example, no (insecure) web browsing will be possible. The AntiVirus page might also be of interest.

The Linux kernel includes the **[netfilter subsystem](https://blogs.oracle.com/linux/post/introduction-to-netfilter)**, which is used to manipulate or decide the fate of network traffic headed into or through your computer. All modern Linux firewall solutions use this system for packet filtering.

The kernel's packet filtering system would be of little use to users or administrators without a user interface with which to manage it. This is the purpose of iptables. When a packet reaches your computer, it is handed off to the netfilter subsystem for acceptance, manipulation, or rejection based on the rules supplied to it via iptables. Thus, iptables is all you need to manage your firewall (if you're familiar with it). Many front-ends are available to simplify the task, however.

Users can therefore configure the firewall to allow certain types of network traffic to pass into and out of a system (for instance SSH or web server traffic). This is done by opening and closing TCP and UDP "ports" in the firewall. Additionally, firewalls can be configured to allow or restrict access to specific IP addresses (or IP address ranges).

## Managing the Firewall

## iptables

Iptables is the database of firewall rules and is the actual firewall used in Linux systems. The traditional interface for configuring iptables in Linux systems is the command-line interface terminal. The other utilities in this section simplify the manipulation of the iptables database.

## UFW

UFW (Uncomplicated Firewall) is a front-end for iptables and is particularly well-suited for host-based firewalls. UFW was developed specifically for Ubuntu (but is available in other distributions), and is also configured from the terminal.

Gufw is a graphical front-end to UFW, and is recommended for beginners.

UFW was introduced in Ubuntu 8.04 LTS (Hardy Heron), and is available by default in all Ubuntu installations after 8.04 LTS.

## Guarddog

Guarddog is a front-end for iptables that functions in KDE-based desktops, such as Kubuntu. It has a greater deal of complexity (and flexibility, perhaps).

## See Also

Security

Other:
DynamicFirewall
firewall/ipkungfu
firewall/Linux_UPnP_Internet_Gateway_Device_(linux-idg)
**[Router/Firewall](https://help.ubuntu.com/community/Router/Firewall)**

External Links
<http://en.wikipedia.org/wiki/Firewall>

<http://www.netfilter.org/> - Netfilter and iptables homepage

<http://www.fs-security.com/> - Firestarter homepage

UbuntuFirewall - **[Uncomplicated Firewall homepage](https://wiki.ubuntu.com/UbuntuFirewall)**
