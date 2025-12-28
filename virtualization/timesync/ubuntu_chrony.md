# **[About time synchronisation](https://documentation.ubuntu.com/server/explanation/networking/about-time-synchronisation/)**

Network Time Protocol (NTP) is a networking protocol for synchronising time over a network. Basically, a client requests the current time from a server, and uses it to set its own clock.

Behind this simple description, there is a lot of complexity. There are three tiers of NTP servers; tier one NTP servers are connected to atomic clocks, while tier two and tier three three servers spread the load of actually handling requests across the Internet.

The client software is also a lot more complex than you might expect. It must factor in communication delays and adjust the time in a way that does not upset all the other processes that run on the server. Luckily, all that complexity is hidden from you!

By default, Ubuntu uses **[chrony to synchronise time](https://documentation.ubuntu.com/server/how-to/networking/chrony-client/#chrony-client)**, which is installed by default. See our guides, if you would like to know how to synchronise time with Chrony or use **[chrony to serve NTP](https://documentation.ubuntu.com/server/how-to/networking/serve-ntp-with-chrony/#serve-ntp-with-chrony)**.

Users can optionally use timedatectl and timesyncd.

## How time synchronisation works

Since Ubuntu 25.10, chrony replaces most of systemd-timesyncd but still uses systemd’s timedatectl.

About chrony
chrony replaces not only ntpdate, but also the Simple Network Time Protocol (SNTP) client of timesyncd (formerly ntpd). So, on top of the one-shot action that ntpdate provided on boot and network activation, chrony now regularly checks and keeps your local time in sync. It also stores time updates locally, so that after reboots the time monotonically advances (if applicable).

About timedatectl
If chrony is installed, timedatectl can still be used to configure basic settings, such as setting the timezone. But more complex configuration needs to be set up using the chronyc command. This ensures that no two time-syncing services can conflict with each other.

ntpdate is now considered deprecated in favor of chrony (or timesyncd) and is no longer installed by default. chrony will generally keep your time in sync and can be set up as a time server, timesyncd can help with simpler cases. But if you had one of a few known special ntpdate use cases, consider the following:

If you require a one-shot sync, use: chronyd -q

If you require a one-shot time check (without setting the time), use: chronyd -Q

While use of ntpd is no longer recommended, this also still applies to ntpd being installed to retain any previous behaviour/config that you had through an upgrade. However, it also implies that on an upgrade from a former release, ntp/ntpdate might still be installed and therefore renders the new systemd-based services disabled.
