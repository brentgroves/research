# **[How to Set Up a Firewall with UFW on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

UFW, or Uncomplicated Firewall, is an interface to iptables that is geared towards simplifying the process of configuring a firewall. While iptables is a solid and flexible tool, it can be difficult for beginners to learn how to use it to properly configure a firewall. If you’re looking to get started securing your network, and you’re not sure which tool to use, UFW may be the right choice for you.

This tutorial will show you how to set up a firewall with UFW on Ubuntu v18.04 and above.

This firewall is enabled on Ubuntu Server 24.04 during install.

```bash
systemctl status ufw
● ufw.service - Uncomplicated firewall
     Loaded: loaded (/usr/lib/systemd/system/ufw.service; enabled; preset: enabled)
     Active: active (exited) since Tue 2025-02-04 16:30:31 UTC; 1h 4min ago
       Docs: man:ufw(8)
    Process: 637 ExecStart=/usr/lib/ufw/ufw-init start quiet (code=exited, status=0/SUCCESS)
   Main PID: 637 (code=exited, status=0/SUCCESS)
        CPU: 9ms

Feb 04 16:30:31 ump1 systemd[1]: Starting ufw.service - Uncomplicated firewall...
Feb 04 16:30:31 ump1 systemd[1]: Finished ufw.service - Uncomplicated firewall.
```