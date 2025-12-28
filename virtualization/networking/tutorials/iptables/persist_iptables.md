# **[How to save iptables firewall rules permanently on Linux](https://www.cyberciti.biz/faq/how-to-save-iptables-firewall-rules-permanently-on-linux/)**

## note

Many apps update iptables so I will try to avoid using iptables-save and instead recreate my rules only. Example is recreate_rules.sh

## reference

- **[upcloud iptables](https://upcloud.com/resources/tutorials/configure-iptables-ubuntu)**
- **[Configuration and usage](https://wiki.archlinux.org/title/Iptables)**

Iam using Debian / Ubuntu Linux server. How do I save iptables rules permanently on Linux using the CLI added using the **[iptables command](https://www.cyberciti.biz/tips/linux-iptables-examples.html)**? How can I store iptables IPv4 and IPv6 rules permanently on the Debian Linux cloud server?

Linux system administrator and developers use iptables and ip6tables commands to set up, maintain, and inspect the firewall tables of IPv4 and IPv6 packet filter rules in the Linux kernel. Any modification made using these commands is lost when you reboot the Linux server. Hence, we need to store those rules across reboot permanently. This page examples how to save iptables firewall rules permanently either on Ubuntu or Debian Linux server.

## Saving iptables firewall rules permanently on Linux

You need to use the following commands to save iptables firewall rules forever:

1. iptables-save command or ip6tables-save command – Save or dump the contents of IPv4 or IPv6 Table in easily parseable format either to screen or to a specified file.
2. iptables-restore command or ip6tables-restore command – Restore IPv4 or IPv6 firewall rules and tables from a given file under Linux.

## Step 1 – Open the terminal

Open the terminal application and then type the following commands. For remote server login using the ssh command:

```bash
ssh <vivek@server1.cyberciti.biz>
ssh ec2-user@ec2-host-or-ip
```

You must type the following command as root user either using the sudo command or su command.

## Step 2 – Save IPv4 and IPv6 Linux firewall rules

Debian and Ubuntu Linux user type:

```bash
update-alternatives --list iptables
/usr/sbin/iptables-legacy
/usr/sbin/iptables-nft

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

update-alternatives --config iptables     
There are 2 choices for the alternative iptables (providing /usr/sbin/iptables).

  Selection    Path                       Priority   Status
------------------------------------------------------------
* 0            /usr/sbin/iptables-nft      20        auto mode
  1            /usr/sbin/iptables-legacy   10        manual mode
  2            /usr/sbin/iptables-nft      20        manual mode
  
cd /etc
fzf
iptables

ls -alh alternatives/iptables-save
lrwxrwxrwx 1 root root 27 Feb 15 03:12 alternatives/iptables-save -> /usr/sbin/iptables-nft-save

sudo su
cd /etc
fzf
iptables

ls -alh alternatives/iptables-save
lrwxrwxrwx 1 root root 27 Feb 15 03:12 alternatives/iptables-save -> /usr/sbin/iptables-nft-save

# if necessary create iptables directory
sudo mkdir /etc/iptables
touch /etc/iptables/rules.v4 
touch /etc/iptables/rules.v6

sudo su
sudo iptables-save > /etc/iptables/rules.v4

## IPv6 ##
ip6tables-save > /etc/iptables/rules.v6

iptables-save > /etc/iptables/rules.v4
## IPv6 ##
ip6tables-save > /etc/iptables/rules.v6
```
