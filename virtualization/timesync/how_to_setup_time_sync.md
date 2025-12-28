# **[](https://www.digitalocean.com/community/tutorials/how-to-set-up-time-synchronization-on-ubuntu-20-04)**

Controlling timesyncd with timedatectl
Previously, most network time synchronization was handled by the Network Time Protocol daemon or ntpd. This service connects to a pool of other NTP servers that provide it with constant and accurate time updates.

But now with Ubuntu’s default install, you can use timesyncd instead of ntpd. timesyncd works similarly by connecting to the same time servers, but is llightweight and more closely integrated with systemd on Ubuntu.

You can query the status of timesyncd by running timedatectl with no arguments. You don’t need to use sudo in this case:

```bash
timedatectl
Output

                     Local time: Thu 2021-08-05 11:56:40 EDT
           Universal time: Thu 2021-08-05 15:56:40 UTC
                 RTC time: Thu 2021-08-05 15:56:41
                Time zone: America/New_York (EDT, -0400)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```

This command prints out the local time, universal time (which may be the same as local time, if you didn’t switch from the UTC time zone), and some network time status information. System clock synchronized: yes reflects that the time is successfully synced, and NTP service: active means that timesyncd is up and running.

If your output shows that NTP service isn’t active, turn it on with timedatectl:

```bash
sudo timedatectl set-ntp on
```

After this, run timedatectl again to confirm the network time status. It may take a minute for the sync to happen, but eventually System clock synchronized: will read yes and NTP service: will show as active.

## Switching to ntpd

timesyncd will work in most circumstances. There are instances, however, when an application may be sensitive to any disturbance with time. In this case, ntpd is an alternative network time service you can use. ntpd uses sophisticated techniques to constantly and gradually keep the system time on track.

Before installing ntpd, you need to turn off timesyncd in order to prevent the two services from conflicting with one another. You can do this by disabling network time synchronization with the following command:

```bash
sudo timedatectl set-ntp no
```

Verify that time synchronization is disabled:

timedatectl
Check that your output reads NTP service: inactive. This means timesyncd has stopped. Now you’re ready to install the ntp package with apt.

First, run apt update to refresh your local package index:

sudo apt update
Then, run apt install ntp to install this package:

`sudo apt install ntp`

ntpd will begin automatically after your installation completes. You can verify that everything is working correctly by querying ntpd for status information:

```bash
ntpq -p
Output
           remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================

 0.ubuntu.pool.n .POOL.          16 p    -   64    0    0.000    0.000   0.000
 1.ubuntu.pool.n .POOL.          16 p    -   64    0    0.000    0.000   0.000
 2.ubuntu.pool.n .POOL.          16 p    -   64    0    0.000    0.000   0.000
 3.ubuntu.pool.n .POOL.          16 p    -   64    0    0.000    0.000   0.000
 ntp.ubuntu.com  .POOL.          16 p    -   64    0    0.000    0.000   0.000
+t1.time.bf1.yah 129.6.15.28      2 u   16   64    1   61.766  -20.068   1.964
+puppet.kenyonra 80.72.67.48      3 u   16   64    1    2.622  -18.407   2.407
*ntp3.your.org   .GPS.            1 u   15   64    1   50.303  -17.499   2.708
+time.cloudflare 10.4.1.175       3 u   15   64    1    1.488  -18.295   2.670
+mis.wci.com     216.218.254.202  2 u   15   64    1   21.527  -18.377   2.414
+ipv4.ntp1.rbaum 69.89.207.99     2 u   12   64    1   49.741  -17.897   3.417
+time.cloudflare 10.4.1.175       3 u   15   64    1    1.039  -16.692   3.378
+108.61.73.243   129.6.15.29      2 u   14   64    1   70.060  -16.993   3.363
+ny-time.gofile. 129.6.15.28      2 u   21   64    1   75.349  -18.333   2.763
 golem.canonical 17.253.34.123    2 u   28   64    1  134.482  -21.655   0.000
 ntp3.junkemailf 216.218.254.202  2 u   19   64    1    2.632  -16.330   4.387
 clock.xmission. .XMIS.           1 u   18   64    1   24.927  -16.712   3.415
 alphyn.canonica 142.3.100.2      2 u   26   64    1   73.612  -19.371   0.000
 strongbad.voice 192.5.41.209     2 u   17   64    1   70.766  -18.159   3.481
 chilipepper.can 17.253.34.123    2 u   25   64    1  134.982  -19.848   0.000
 pugot.canonical 145.238.203.14   2 u   28   64    1  135.694  -21.075   0.000
```

ntpq is a query tool for ntpd. The -p flag requests information about the NTP servers (or peers) ntpd is connected to. Your output will be slightly different but will list the default Ubuntu pool servers plus a few others. Remember, it can take a few minutes for ntpd to establish connections.

## Conclusion

In this article, you’ve successfully viewed the system time, changed time zones, worked with Ubuntu’s default timesyncd service, and installed ntpd. If you have advanced timekeeping needs, you can reference the official NTP documentation, and also take a look at the NTP Pool Project, a global group of volunteers providing much of the world’s NTP infrastructure.
