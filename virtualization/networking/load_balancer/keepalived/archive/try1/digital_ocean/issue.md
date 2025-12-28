# log entries

```bash
journalctl -xeu keepalived.service
░░ Subject: Unit failed
░░ Defined-By: systemd
░░ Support: <http://www.ubuntu.com/support>
░░
░░ The unit keepalived.service has entered the 'failed' state with result 'protocol'.
Aug 13 23:30:21 micro11 systemd[1]: Failed to start keepalived.service - Keepalive Daemon (LVS and VRRP).
░░ Subject: A start job for unit keepalived.service has failed
░░ Defined-By: systemd
░░ Support: <http://www.ubuntu.com/support>
░░
░░ A start job for unit keepalived.service has finished with a failure.
░░
░░ The job identifier is 657455 and the job result is failed.
```

## is it running

```bash
ps aux | grep keep
root      287327  0.0  0.0  26260  2484 ?        Ss   Aug13   0:00 /snap/keepalived/3093/usr/sbin/keepalived-519
root      287328  0.0  0.0  26260  3252 ?        S    Aug13   0:00 /snap/keepalived/3093/usr/sbin/keepalived-519
brent     305376  0.0  0.0   6544  2048 pts/0    S+   19:25   0:00 grep --color=auto keep

pgrep keep
287327
287328

# kill it
kill [PID] 
```

## check service status

```bash
systemctl status keepalived.service
× keepalived.service - Keepalive Daemon (LVS and VRRP)
     Loaded: loaded (/usr/lib/systemd/system/keepalived.service; enabled; preset: enabled)
     Active: failed (Result: protocol) since Wed 2025-08-13 23:30:21 UTC; 20h ago
       Docs: man:keepalived(8)
             man:keepalived.conf(5)
             man:genhash(1)
             https://keepalived.org
    Process: 300111 ExecStart=/usr/sbin/keepalived --dont-fork $DAEMON_ARGS (code=exited, status=0/SUCCESS)
   Main PID: 300111 (code=exited, status=0/SUCCESS)
        CPU: 10ms

Aug 13 23:30:21 micro11 systemd[1]: Starting keepalived.service - Keepalive Daemon (LVS and VRRP)...
Aug 13 23:30:21 micro11 Keepalived[300111]: Starting Keepalived v2.2.8 (04/04,2023), git commit v2.2.7-154-g292b299e+
```

## check on micro12

```bash
systemctl status keepalived.service
● keepalived.service - Keepalive Daemon (LVS and VRRP)
     Loaded: loaded (/usr/lib/systemd/system/keepalived.service; enabled; preset: enabled)
     Active: active (running) since Wed 2025-08-13 23:13:15 UTC; 20h ago
       Docs: man:keepalived(8)
             man:keepalived.conf(5)
             man:genhash(1)
             https://keepalived.org
   Main PID: 260263 (keepalived)
      Tasks: 2 (limit: 154503)
     Memory: 2.1M (peak: 2.2M)
        CPU: 22ms
     CGroup: /system.slice/keepalived.service
             ├─260263 /usr/sbin/keepalived --dont-fork
             └─260265 /usr/sbin/keepalived --dont-fork

Aug 13 23:13:15 micro12 Keepalived[260263]: Starting Keepalived v2.2.8 (04/04,2023), git commit v2.2.7-154-g292b299e+
Aug 13 23:13:15 micro12 Keepalived[260263]: Running on Linux 6.8.0-63-generic #66-Ubuntu SMP PREEMPT_DYNAMIC Fri Jun 13 20:25:30 UTC 2025 (built for Linux 6.8.0)
Aug 13 23:13:15 micro12 Keepalived[260263]: Command line: '/usr/sbin/keepalived' '--dont-fork'
Aug 13 23:13:15 micro12 Keepalived[260263]: Configuration file /etc/keepalived/keepalived.conf
Aug 13 23:13:15 micro12 Keepalived[260263]: NOTICE: setting config option max_auto_priority should result in better keepalived performance
Aug 13 23:13:15 micro12 Keepalived[260263]: Starting VRRP child process, pid=260265
Aug 13 23:13:15 micro12 Keepalived_vrrp[260265]: (VI_1) entering FAULT state (no IPv4 address for interface)
Aug 13 23:13:15 micro12 Keepalived_vrrp[260265]: (VI_1) entering FAULT state
Aug 13 23:13:15 micro12 Keepalived[260263]: Startup complete
Aug 13 23:13:15 micro12 systemd[1]: Started keepalived.service - Keepalive Daemon (LVS and VRRP).
```

## check config file

```bash
cat /etc/keepalived/keepalived.conf
vrrp_instance VI_1 {
    state BACKUP
    interface eno350
    virtual_router_id 101
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        10.188.50.200
    }
}
```

## solution

```bash
Missing or Incorrect IP Configuration:
Cause: The network interface specified in the keepalived.conf truly lacks an IPv4 address, or the address configured is not valid for that interface.
Solution: Manually assign a static IPv4 address to the interface or ensure it is correctly configured for DHCP.
```

### for keepalived to work does there need to be an ip address already assigned to the vip interface

**[VRRP stays in FAULT state after adding a same IP address as VIP on physical interface #2219](https://github.com/acassen/keepalived/issues/2219)**

I am in a Qemu virtual machine and compiled the newest keepalived version.
I started keepalived with a VIP 192.168.1.1/24 and the physical interface has no IP addresses yet.
It is normal for VRRP entering FAULT state as no IPv4 address is configured on the interface.

Then, I add 192.168.1.1/24 (same as the VIP) on the physical interface, VRRP is still in FAULT state.

However, either if I add another IP address different than the VIP or before starting keepalived, configure the interface with a IP address (whatever the address) , VRRP works successfully.

To Reproduce

No IP address on the physical interface
Start keepalived with the configuration file and VRRP should be in FAULT state
Add same IP address as VIP on the physical interface: `ip a a 192.168.1.1/24 dev ens4`

## Expected behavior

The transition from FAULT state to BACKUP then from BACKUP state to MASTER state.

Keepalived version

Keepalived v2.2.7 (10/13,2022), git commit v2.2.7-111-gefef3596

Distro (please complete the following information):

Name: Ubuntu
Version: 20.04
Architecture: x86_64
Details of any containerisation or hosted service (e.g. AWS)
Qemu virtual machine

Configuration file:

```ini
global_defs
{
  router_id router
  enable_script_security
  script_user root
  dynamic_interfaces
  vrrp_startup_delay 0
  disable_local_igmp
}

vrrp_instance vrrp {
  version 2
  state BACKUP
  interface ens4

  use_vmac vrrp

  virtual_ipaddress {
    192.168.1.1/24
  }

  track_file {
  }

  garp_master_delay 5

  virtual_router_id 12

  priority 100
  advert_int 1.0

  preempt_delay 0
  notify_deleted
}
```

```bash
Oct 27 14:21:41 ubuntu2004 Keepalived[8087]: Starting Keepalived v2.2.7 (10/13,2022), git commit v2.2.7-111-gefef3596

Oct 27 14:21:41 ubuntu2004 Keepalived[8087]: WARNING - keepalived was built for newer Linux 5.4.203, running on Linux>

Oct 27 14:21:41 ubuntu2004 Keepalived[8087]: Command line: 'keepalived' '-D'

Oct 27 14:21:41 ubuntu2004 Keepalived[8087]: Opening file '/etc/keepalived/keepalived.conf'.

Oct 27 14:21:41 ubuntu2004 Keepalived[8087]: Configuration file /etc/keepalived/keepalived.conf

Oct 27 14:21:41 ubuntu2004 Keepalived[8087]: (Line 7) WARNING - number '0' outside range [0.001000, 4294.967295]

Oct 27 14:21:41 ubuntu2004 Keepalived[8087]: (Line 7) vrrp_startup_delay '0' is invalid

Oct 27 14:21:41 ubuntu2004 Keepalived[8088]: NOTICE: setting config option max_auto_priority should result in better >

Oct 27 14:21:41 ubuntu2004 Keepalived[8088]: Starting VRRP child process, pid=8089

Oct 27 14:21:41 ubuntu2004 Keepalived_vrrp[8089]: Registering Kernel netlink reflector

Oct 27 14:21:41 ubuntu2004 Keepalived_vrrp[8089]: Registering Kernel netlink command channel

Oct 27 14:21:41 ubuntu2004 Keepalived_vrrp[8089]: (vrrp): Success creating VMAC interface vrrp

Oct 27 14:21:41 ubuntu2004 networkd-dispatcher[458]: WARNING:Unknown index 10 seen, reloading interface list

Oct 27 14:21:41 ubuntu2004 Keepalived_vrrp[8089]: NOTICE: setting sysctl net.ipv4.conf.all.rp_filter from 2 to 0

Oct 27 14:21:41 ubuntu2004 systemd-networkd[398]: vrrp: Link UP

Oct 27 14:21:41 ubuntu2004 systemd-networkd[398]: vrrp: Gained carrier

Oct 27 14:21:41 ubuntu2004 Keepalived_vrrp[8089]: (vrrp) entering FAULT state (no IPv4 address for interface)

Oct 27 14:21:41 ubuntu2004 Keepalived_vrrp[8089]: (vrrp) entering FAULT state

Oct 27 14:21:41 ubuntu2004 systemd-udevd[8090]: ethtool: autonegotiation is unset or enabled, the speed and duplex ar>

Oct 27 14:21:41 ubuntu2004 Keepalived_vrrp[8089]: Registering gratuitous ARP shared channel

Oct 27 14:21:41 ubuntu2004 systemd-udevd[8090]: Using default interface naming scheme 'v245'.

Oct 27 14:21:41 ubuntu2004 Keepalived[8088]: Startup complete
```

Additional context
It seems that keepalived won't catch the IP assignment when the IP is the same as VIP. I wonder if it is intentional.

Activity
lsang6WIND
lsang6WIND commented on Oct 28, 2022
lsang6WIND
on Oct 28, 2022 · edited by lsang6WIND
Author
In keepalived_netlink.c: ignore_address_if_ours_or_link_local checks if vrrp owns the new IP address added on the interface, that is the reason why VRRP won't change the state.

I suppose that leaves the question, why does ignore_address_if_ours_or_link_local() ignore a VIP when added?

If the VRRP instance had been in master state and subsequently transitioned to backup because a higher priority instance appeared, then since 192.168.1.1 is a VIP and the priority is not 255, the address would be deleted when the VRRP instance transitioned to backup, and it would never be able to become master again. This clearly is an unstable situation, and therefore cannot be allowed.

I suppose that leaves the question, why does ignore_address_if_ours_or_link_local() ignore a VIP when added?

If the VRRP instance had been in master state and subsequently transitioned to backup because a higher priority instance appeared, then since 192.168.1.1 is a VIP and the priority is not 255, the address would be deleted when the VRRP instance transitioned to backup, and it would never be able to become master again. This clearly is an unstable situation, and therefore cannot be allowed.
