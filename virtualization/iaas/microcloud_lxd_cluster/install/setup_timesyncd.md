# **[How to Set Up Time Synchronization on Ubuntu 24.04](https://greenhost.cloud/how-to-set-up-time-synchronization-on-ubuntu-24-04/#:~:text=In%20our%20increasingly%20interconnected%20world,already%20running%20on%20your%20system.)**

## reference

- **[timesyncd](https://documentation.ubuntu.com/server/how-to/networking/timedatectl-and-timesyncd/)**
- **[issue](https://askubuntu.com/questions/1048907/setting-multiple-ntp-servers-in-etc-systemd-timesyncd-conf)**

In our increasingly interconnected world, maintaining accurate time on your servers is crucial for a range of applications, from logging to security protocols. If you’re running an Ubuntu 24.04 system, you may be wondering about the best way to synchronize your system clock to ensure it’s always accurate. In this post, we’ll guide you through the simple process of setting up time synchronization on your Ubuntu 24.04 machine.

## Understanding Time Synchronization

Time synchronization ensures that your server’s clock is aligned with accurate time sources. This is particularly important for servers that involve multiple transactions, data logging, or operations that rely on precise timing. For example, databases, cloud services, and communication between servers all benefit from synchronized time.

Ubuntu uses the systemd suite, which includes systemd-timesyncd, a simple time synchronization service. This service is the default method for time synchronization on systems using systemd.

## Step-by-Step Guide to Setting Up Time Synchronization

## Step 1: Check if systemd-timesyncd is Active

Before configuring time synchronization, you should check whether systemd-timesyncd is already running on your system. Open your terminal and type:

```bash
systemctl status systemd-timesyncd
● systemd-timesyncd.service - Network Time Synchronization
     Loaded: loaded (/usr/lib/systemd/system/systemd-timesyncd.service; enabled; preset: enabled)
     Active: active (running) since Mon 2025-07-14 23:46:17 UTC; 20h ago
       Docs: man:systemd-timesyncd.service(8)
   Main PID: 1336 (systemd-timesyn)
     Status: "Idle."
      Tasks: 2 (limit: 154503)
     Memory: 1.7M (peak: 2.2M)
        CPU: 459ms
     CGroup: /system.slice/systemd-timesyncd.service
             └─1336 /usr/lib/systemd/systemd-timesyncd

Jul 15 18:24:00 micro11 systemd-timesyncd[1336]: Timed out waiting for reply from 91.189.91.157:123 (ntp.ubuntu.com).
Jul 15 18:24:10 micro11 systemd-timesyncd[1336]: Timed out waiting for reply from 185.125.190.57:123 (ntp.ubuntu.com).
Jul 15 18:58:29 micro11 systemd-timesyncd[1336]: Timed out waiting for reply from 185.125.190.57:123 (ntp.ubuntu.com).
Jul 15 18:58:39 micro11 systemd-timesyncd[1336]: Timed out waiting for reply from 185.125.190.58:123 (ntp.ubuntu.com).
Jul 15 18:58:49 micro11 systemd-timesyncd[1336]: Timed out waiting for reply from 91.189.91.157:123 (ntp.ubuntu.com).
```

If the service is active and running, you’ll see output indicating its status. If it’s not running, you can start the service with:

`sudo systemctl start systemd-timesyncd`

To ensure it starts automatically on boot, use:

`sudo systemctl enable systemd-timesyncd`

### is ntp syncronized

```bash
timedatectl
               Local time: Tue 2025-07-15 20:15:21 UTC
           Universal time: Tue 2025-07-15 20:15:21 UTC
                 RTC time: Tue 2025-07-15 20:15:22
                Time zone: Etc/UTC (UTC, +0000)
System clock synchronized: no
              NTP service: active
          RTC in local TZ: no
```

## Step 2: Configure systemd-timesyncd

Next, you may want to configure your time synchronization settings. The configuration file for systemd-timesyncd is located at /etc/systemd/timesyncd.conf. Open this file in your favorite text editor:

```bash
sudo vi /etc/systemd/timesyncd.conf
```

In this file, you can specify the NTP servers you want to use. By default, Ubuntu will use its own servers, but you can add more by modifying the line that starts with NTP=. For example:

`NTP=2.ubuntu.pool.ntp.org 1.ubuntu.pool.ntp.org`

### linamar ntp server list

```bash
NTP=10.225.50.203 10.224.50.203
FallbackNTP=10.254.0.204
```

You can also specify additional parameters if needed, such as FallbackNTP= for backup servers or RootDistanceMaxSec= to set a maximum distance in seconds.

After making your changes, save and exit the editor (in Nano, press CTRL + O, then CTRL + X).

Use `systemd-analyze cat-config systemd/timesyncd.conf` to display the full config.

## Step 3: Restart the Service

To apply your changes, you’ll need to restart the systemd-timesyncd service:

```bash
sudo systemctl restart systemd-timesyncd
systemctl status systemd-timesyncd
Warning: The unit file, source configuration file or drop-ins of systemd-timesyncd.service changed on disk. Run 'systemctl daemon-reload' to reload units.

```

## Step 4: Verify Time Synchronization

To check that your time synchronization is working correctly, you can use:

```bash
timedatectl
               Local time: Tue 2025-07-15 20:33:22 UTC
           Universal time: Tue 2025-07-15 20:33:22 UTC
                 RTC time: Tue 2025-07-15 20:33:22
                Time zone: Etc/UTC (UTC, +0000)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

This command will give you a summary of your current time settings, including whether NTP synchronization is active. Look for NTP synchronized: yes to confirm that your system is synchronizing its time effectively.

## Step 5: Monitor the Synchronization

It’s good practice to monitor the synchronization occasionally. You can see a list of NTP peers and their status with:

## does ntpsec disable timesyncd

Yes, installing ntpsec will generally disable systemd-timesyncd. When ntpsec (or ntpd or chrony) is installed and configured, it typically takes over time synchronization duties, causing systemd-timesyncd to be disabled to avoid conflicts.

DONT DO THIS

```bash
apt remove ntpsec
Warning: The unit file, source configuration file or drop-ins of ntpsec-rotate-stats.timer changed on disk. Run 'systemctl daemon-reload' to reload units.
Warning: The unit file, source configuration file or drop-ins of ntpsec-systemd-netif.path changed on disk. Run 'systemctl daemon-reload' to reload units.
Warning: The unit file, source configuration file or drop-ins of ntpsec.service changed on disk. Run 'systemctl daemon-reload' to reload units.
Processing triggers for man-db (2.12.0-4build2) ...

ntpq -p
```

Conclusion
Setting up time synchronization on your Ubuntu 24.04 server is a straightforward process that can help ensure system reliability and accuracy. By leveraging systemd-timesyncd, you can maintain consistent time across your system, which is essential for various applications and services.

By following the steps outlined above, you’ll be able to configure, verify, and monitor your time synchronization settings to keep your server running optimally. If you have any experiences or tips regarding time synchronization, feel free to share them in the comments below!

For more articles about optimizing your server environment, stay tuned to the Greenhost.cloud blog!

```bash
ssh brent@micro12
# /etc/systemd/timesyncd.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file (or a copy of it placed in
# /etc/ if the original file is shipped in /usr/), or by creating "drop-ins" in
# the /etc/systemd/timesyncd.conf.d/ directory. The latter is generally
# recommended. Defaults can be restored by simply deleting the main
# configuration file and all drop-ins located in /etc/.
#
# Use 'systemd-analyze cat-config systemd/timesyncd.conf' to display the full config.
#
# See timesyncd.conf(5) for details.

[Time]
#NTP=
#FallbackNTP=ntp.ubuntu.com
#RootDistanceMaxSec=5
#PollIntervalMinSec=32
#PollIntervalMaxSec=2048
#ConnectionRetrySec=30
#SaveIntervalSec=60
```
