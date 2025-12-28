# **[Setting multiple NTP servers in /etc/systemd/timesyncd.conf](https://askubuntu.com/questions/1048907/setting-multiple-ntp-servers-in-etc-systemd-timesyncd-conf)**

Asked 7 years ago
Modified 1 year, 1 month ago
Viewed 48k times
9

The man page for timesyncd.conf(5) indicates that the setting for NTP is a space-separated list of NTP server host names or IP addresses.

We have two internal NTP servers in our network, both on the same subnet (10.10.10 0/24). On an Ubuntu 18.04 server, if I set NTP to NTP="10.10.10.100 10.10.10.101", timesyncd will not synchronize with those time servers. If I just set NTP to one of them (NTP=10.10.10.100 or NFS=10.10.10.101), time is synchronized as expected.

Is anyone else seeing the same behavior? Or is this a bug that should be (or has been) submitted?

Addendum: Instead of one line, I tried using multiple "NTP=" lines. Instead of:

NTP="10.10.10.100 10.10.10.101"
I changed it to:

NTP=10.10.10.100
NTP=10.10.10.101

Did you try without the quotes, i.e. `NTP=10.10.10.100 10.10.10.101` ? After all, it's mentioned nowhere that quotes should be used... –
NovHak
 CommentedJan 22, 2020 at 17:43
Can confirm, did not work with double quotes. Does work without. –
PolyTekPatrick
 CommentedJan 25, 2021 at 18:04
