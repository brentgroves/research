# **[UFW Intro](https://help.ubuntu.com/community/UFW)**


**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../../README.md)**

## Question

I want to know more of what ufw is. I'll ask some questions and you can let me know if i'm right or not.

ufw helps us to block connections or allow connections from specific ip address or whatever. I'm curious what happens if ufw is not enabled which means it's INACTIVE. does it mean it allows anything at all? whatever we want?

let's say I enabled ufw, add one rule. if the answer to previous question was (IT ALLOWS ANYTHING If it's inactive) , then if I only have one rule and ufw is active, it means anything else(any kind of my service that listens on some port) is blocked by default and I have to enable it to allow it.

## AnswERT

Yes to your first answer, it inactive so all traffic goes through. Then See this excerpt:

By default, UFW is set to deny all incoming connections and allow all outgoing connections. This means anyone trying to reach your cloud server would not be able to connect, while any application within the server would be able to reach the outside world.

So to answer your question: "That rule will be obeyed or honoured". Let's say the rule is set to allow a particular connection, then based on the default ufw rule to deny incoming connections, only that connection will go through... This ufw default settings is most useful for limiting access on a "need to" basis.

Source: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-with-ufw-on-ubuntu-16-04

## Introduction
For an introduction to firewalls, please see **[Firewall](https://help.ubuntu.com/community/Firewall)**.


## UFW - Uncomplicated Firewall

The default firewall configuration tool for Ubuntu is ufw. Developed to ease iptables firewall configuration, ufw provides a user friendly way to create an IPv4 or IPv6 host-based firewall. By default UFW is disabled.

Gufw is a GUI that is available as a frontend.

## Basic Syntax and Examples

Default rules are fine for the average home user
When you turn UFW on, it uses a default set of rules (profile) that should be fine for the average home user. That's at least the goal of the Ubuntu developers. In short, all 'incoming' is being denied, with some exceptions to make things easier for home users.


## Enable and Disable

Enable UFW
To turn UFW on with the default set of rules:

```bash
sudo ufw enable
```

To check the status of UFW:

```bash
sudo ufw status verbose
```

The output should be like this:

```bash
youruser@yourcomputer:~$ sudo ufw status verbose
Status: inactive

[sudo] password for youruser:
Status: active
Logging: on (low)
Default: deny (incoming), allow (outgoing)
New profiles: skip
youruser@yourcomputer:~$
```

Note that by default, deny is being applied to incoming. There are exceptions, which can be found in the output of this command:

```bash
sudo ufw show raw
IPV4 (raw):
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         


IPV6:
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination         

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
    pkts      bytes target     prot opt in     out     source               destination  ```

You can also read the rules files in /etc/ufw (the files whose names end with .rules).


Disable UFW
To disable ufw use:

```bash
sudo ufw disable
```

## Allow and Deny (specific rules)

Allow

```bash
ls /etc/ufw          
after6.rules  after.init  after.rules  applications.d  before6.rules  before.init  before.rules  sysctl.conf  ufw.conf  user6.rules  user.rule

# sudo ufw allow <port>/<optional: protocol>
# example: To allow incoming tcp and udp packet on port 53
sudo ufw allow 53

# example: To allow incoming tcp packets on port 53
sudo ufw allow 53/tcp

# example: To allow incoming udp packets on port 53
sudo ufw allow 53/udp
```