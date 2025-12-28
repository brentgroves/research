# **[How to Sync Time in Linux Server using Chrony](<https://www.linuxtechi.com/sync-time-in-linux-server-using-chrony/>)**

By Pradeep Kumar / Last Updated: July 29, 2024 / 4 minutes of reading
In this article, we will demonstrate how to sync time in Linux server using Chrony (NTP Client).

Time plays an important role in Linux servers specially when they are used in banking sector, stock markets and other financial sectors. If we want all our Linux servers should have the correct time, then we must configure some NTP client which will fetch correct time always from remote NTP Servers and if needed makes the required adjustments for syncing the time.

## Install Chrony on Debian / Ubuntu System

To install Chrony on Debian and Ubuntu Systems, run the following apt command,

`sudo apt install chrony -y`

Once the chrony is installed on Linux server then it offers two programs,

chronyc : It is command line interface of chrony
chronyd : It is daemon for chrony which start and enable chrony service across the reboot.
