# **[](https://tecadmin.net/setup-ip-failover-on-ubuntu-with-keepalived/)**

## reference

- **[docs](https://keepalived.readthedocs.io/en/latest/configuration_synopsis.html)**
- **[arch](https://wiki.archlinux.org/title/Keepalived)**
- **[configuring](https://louwrentius.com/configuring-attacking-and-securing-vrrp-on-linux.html)**
- **[keepalived](https://www.youtube.com/watch?v=hPfk0qd4xEY&t=9s)**
- **[haproxy with keepalived](https://www.youtube.com/watch?v=EdjR6BcUe7g)**

<https://kifarunix.com/how-to-install-keepalived-on-ubuntu-24-04/>

How to Setup IP Failover with KeepAlived on Ubuntu & Debian

Keepalived is used for IP failover between two servers. Its facilities for load balancing and high-availability to Linux-based infrastructures. It worked on VRRP (Virtual Router Redundancy Protocol) protocol. In this tutorial, we have configured IP failover between two Linux systems running as a load balancer for load balancing and high-availability infrastructures.

You may also intrested in our tutorial **[How to Setup HAProxy on Ubuntu & Linuxmint](https://tecadmin.net/how-to-setup-haproxy-load-balancing-on-ubuntu-linuxmint/)**.

Network Scenario:

Network Scenario:

  1. LB1 Server: 192.168.10.111 (eth0)
  2. LB2 Server: 192.168.10.112 (eth0)
  3. Virtual IP: 192.168.10.121

```yaml
micro11: 10.188.50.201
micro12: 10.188.50.202
micro13: 10.188.50.203
virtual ip: 10.188.50.200 
```

```bash
nmap -sP 10.188.50.0/24
Nmap done: 256 IP addresses (21 hosts up) scanned in 3.11 seconds

```

![i1](https://tecadmin.net/wp-content/uploads/2013/03/keepalived-vrrp-network.png)

I hope you get a better understanding of the setup with the above structure. Let’s move to the configuration IP failover setup between LB1 and LB2 servers.

## Step 1 – Install Required Packages

First of all, Use the following command to install required packages to configure Keepalived on the server.

```bash
sudo apt-get update
sudo apt-get install linux-headers-$(uname -r)
```

## Step 2 – Install Keepalived

Keepalived packages are available under default apt repositories. So just use a command to install it on both servers.

```bash
keepalived
Command 'keepalived' not found, but can be installed with:
snap install keepalived  # version 2.3.4, or
apt  install keepalived  # version 1:2.2.8-1
See 'snap info keepalived' for additional versions.

sudo snap install keepalived --classic
sudo apt-get install keepalived
```

System-wide configuration and data:
For system-wide configuration data, particularly for daemons or snaps running with root privileges, the data is typically found under /var/snap/<snap-name>/.

## Step 3 – Setup Keepalived on LB1

Now create or edit Keepalived configuration /etc/keepalived/keepalived.conf file on LB1 and add the following settings. Update all red highlighted values with your network and system configuration.

```bash
root@micro11:~# ls /var/snap/keepalived/current
root@micro11:~# ls /var/snap/keepalived/common
/var/snap/keepalived/
```

## **[config files](https://snapcraft.io/docs/data-locations)

```bash
/home/brent/snap/<snap name>/common
# nothing here
ls /root/snap/
aws-cli  keepalived  lxd  microceph  microcloud  microovn

# found it
ls /etc/keepalived/
keepalived.conf

ll /etc/keepalived/keepalived.conf
-rw-r--r-- 1 root root 0 Aug 12 22:16 /etc/keepalived/keepalived.conf

sudo vi /etc/keepalived/keepalived.conf

```

```bash
! Configuration File for keepalived

global_defs {
   notification_email {
     <sysadmin@mydomain.com>
     <support@mydomain.com>
   }
   notification_email_from <lb1@mydomain.com>
   smtp_server localhost
   smtp_connect_timeout 30
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 101
    priority 101
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.10.121
    }
}
```

1. Priority value will be higher on Master server, It doesn’t matter what you used in state. If your state is MASTER but your priority is lower than the router with BACKUP, you will lose the MASTER state.
2. virtual_router_id should be same on both LB1 and LB2 servers.
3. By default single vrrp_instance support up to 20 virtual_ipaddress. In order to add more addresses you need to add more vrrp_instance

## Step 4 – Setup KeepAlived on LB2

Also, create or edit Keepalived configuration file /etc/keepalived/keepalived.conf on LB2 and add the following configuration. While making changes in the LB2 configuration file, make sure to set priority values to lower than LB1. For example below configuration is showing 100 priority value than LB1 has it 101.

```bash
vim /etc/keepalived/keepalived.conf

! Configuration File for keepalived

global_defs {
   notification_email {
     sysadmin@mydomain.com
     support@mydomain.com
   }
   notification_email_from lb2@mydomain.com
   smtp_server localhost
   smtp_connect_timeout 30
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 101
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.10.121
    }
}
```

1. Priority value will be higher on Master server, It doesn’t matter what you used in state. If your state is MASTER but your priority is lower than the router with BACKUP, you will lose the MASTER state.
2. virtual_router_id should be same on both LB1 and LB2 servers.
3. By default single vrrp_instance support up to 20 virtual_ipaddress. In order to add more addresses you need to add more vrrp_instance

## NOTE

Maybe I should configure VIP to eno150 instead?

## Step 5 – Start KeepAlived Service

Start keepalived service using the following command and also configure to autostart on system boot.

```bash
sudo snap stop keepalived
sudo snap run keepalived
sudo snap restart keepalived
sudo snap start --enable [service_name]
snap services
Service                          Startup   Current   Notes
keepalived.daemon                enabled   inactive  -
```

## Step 6 – Check Virtual IPs

By default virtual IP will be assigned to the master server, In the case of master gets down, it will automatically assign to the slave server. Use the following command to show assigned virtual IP on the interface.

```bash
ip addr show eno350
```
