# **[Synchronise time using timedatectl and timesyncd](https://documentation.ubuntu.com/server/how-to/networking/timedatectl-and-timesyncd/)**

Ubuntu can use timedatectl and timesyncd for synchronising time, which can be installed as follows. systemd-timesyncd used to be part of the default installation, but was replaced by chrony since Ubuntu 25.10. You can optionally use chrony as a Network Time Security (NTS) client or to serve the Network Time Protocol.

`sudo apt-mark auto chrony && apt install systemd-timesyncd`
In this guide, we will show you how to configure these services.

Note

If chrony is installed, timedatectl steps back to let chrony handle timekeeping. This ensures that no two time-syncing services will be in conflict.

## Check status of timedatectl

The current status of time and time configuration via timedatectl and timesyncd can be checked with the timedatectl status command, which will produce output like this:

```bash
timedatectl status
               Local time: Thu 2025-07-17 21:56:18 UTC
           Universal time: Thu 2025-07-17 21:56:18 UTC
                 RTC time: Thu 2025-07-17 21:56:19
                Time zone: Etc/UTC (UTC, +0000)
System clock synchronized: no
              NTP service: n/a
          RTC in local TZ: no
```

If chrony is running, it will automatically switch to:

[...]
 systemd-timesyncd.service active: no

## Configure timedatectl

By using timedatectl, an admin can control the timezone, how the system clock should relate to the hwclock and whether permanent synchronisation should be enabled. See man timedatectl for more details.

## Check status of timesyncd

timesyncd itself is a normal service, so you can check its status in more detail using:

`systemctl status systemd-timesyncd`

The output produced will look something like this:

      systemd-timesyncd.service - Network Time Synchronization
       Loaded: loaded (/lib/systemd/system/systemd-timesyncd.service; enabled; vendor preset: enabled)
       Active: active (running) since Fri 2018-02-23 08:55:46 UTC; 10s ago
         Docs: man:systemd-timesyncd.service(8)
     Main PID: 3744 (systemd-timesyn)
       Status: "Synchronized to time server 91.189.89.198:123 (ntp.ubuntu.com)."
        Tasks: 2 (limit: 4915)
       CGroup: /system.slice/systemd-timesyncd.service
               |-3744 /lib/systemd/systemd-timesyncd
    
    Feb 23 08:55:46 bionic-test systemd[1]: Starting Network Time Synchronization...
    Feb 23 08:55:46 bionic-test systemd[1]: Started Network Time Synchronization.
    Feb 23 08:55:46 bionic-test systemd-timesyncd[3744]: Synchronized to time server 91.189.89.198:123 (ntp.ubuntu.com).
Configure timesyncd
The server from which to fetch time for timedatectl and timesyncd can be specified in /etc/systemd/timesyncd.conf. Additional config files can be stored in /etc/systemd/timesyncd.conf.d/. The entries for NTP= and FallbackNTP= are space-separated lists. See man timesyncd.conf for more details.
