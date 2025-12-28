# **[](https://www.digitalocean.com/community/questions/navigating-high-availability-with-keepalived)**

What is Keepalived?

Keepalived is an open-source software that provides high availability by using the Virtual Router Redundancy Protocol (VRRP) for Linux systems. Its primary use is to ensure service availability by routing network traffic to a backup server if the primary server fails.

Part 1: Unpacking the Architecture and Theory
The Mechanics of VRRP:

The Virtual Router Redundancy Protocol (VRRP) is at the heart of keepalived. This protocol facilitates the creation of a virtual router, an abstracted set of machines that appear as a single entity to other network participants. This abstraction ensures uninterrupted service even if one of the participants (or nodes) becomes unavailable.

The VRRP setup includes:

Master: The primary node that handles traffic routed to the Virtual IP Address (VIP).
Backup(s): One or more nodes ready to take over should the Master fail.

Keepalived’s Dual Roles:

High Availability: As highlighted before, keepalived is most known for this. By constantly checking the health of nodes, it quickly responds to failures, transitioning the VIP from a failed Master to a Backup.

Load Balancing: Via integration with the Linux Virtual Server (LVS), keepalived can also distribute inbound traffic to optimize resource utilization and maximize throughput.

## Part 2: ### Installation and Basic Configuration of Keepalived for High Availability

Update Your System: Before installing any new software, it’s a good practice to update the system packages.

`sudo apt update && sudo apt upgrade -y`

Use the package manager to install keepalived.

`sudo apt install keepalived -y`

Now, let’s delve into the basic configuration.

Define the VRRP Instance: Let’s set up a basic VRRP instance. This example assumes you are setting up the master server. For backup servers, adjust the state and priority fields.

```ini
vrrp_instance VI_1 {
    interface eth0                 # Change to your active network interface, e.g., ens33
    state MASTER
    virtual_router_id 51          # A unique number [1-255] for this VRRP instance
    priority 100                  # 100 for master, 50 for backup
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass mysecretpass   # A password for authentication, should be the same on all servers
    }
    virtual_ipaddress {
        192.168.1.10             # The virtual IP address shared between master and backup
    }
}
```

Enable and start your keepalived service

```bash
sudo systemctl status keepalived
keepalived.service - Keepalive Daemon (LVS and VRRP)
     Loaded: loaded (/usr/lib/systemd/system/keepalived.service; enabled; preset: enabled)
     Active: failed (Result: protocol) since Wed 2025-08-13 23:30:21 UTC; 19h ago
       Docs: man:keepalived(8)
             man:keepalived.conf(5)
             man:genhash(1)
             https://keepalived.org
    Process: 300111 ExecStart=/usr/sbin/keepalived --dont-fork $DAEMON_ARGS (code=exited, status=0/SUCCESS)
   Main PID: 300111 (code=exited, status=0/SUCCESS)
        CPU: 10ms

Aug 13 23:30:21 micro11 systemd[1]: Starting keepalived.service - Keepalive Daemon (LVS and VRRP)...
Aug 13 23:30:21 micro11 Keepalived[300111]: Starting Keepalived v2.2.8 (04/04,2023), git commit v2.2.7-154-g292b299e+

sudo systemctl start keepalived
sudo systemctl enable keepalived
```
