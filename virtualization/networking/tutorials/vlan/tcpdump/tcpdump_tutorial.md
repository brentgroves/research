# **[A tcpdump Tutorial with Examples](https://danielmiessler.com/blog/tcpdump)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../../README.md)**

![f](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/9ba5ca1d-95a9-487c-833c-c91fb8cdfc49/ip-header-2021-1024x505.png)

tcpdump is the world's premier network analysis tool—combining both power and simplicity into a single command-line interface. This guide will show you how to use it.

tcpdump is a powerful command-line packet analyzer. It allows you to capture and inspect network traffic in real-time. This tool is invaluable for network administrators, security professionals, and anyone who needs to understand network behavior.

In this tutorial, we'll explore 50 practical examples of using tcpdump. These examples will cover a wide range of use cases, from basic traffic capture to advanced filtering and analysis.

Basic Syntax ​
The basic syntax of tcpdump is:

tcpdump [options] [expression]
1
options: Modify the behavior of tcpdump, such as specifying the interface to capture on or the output format.
expression: Defines what kind of traffic to capture. This is where you specify hostnames, IP addresses, ports, protocols, and other criteria.
