# **[tcpdump(1) man page](https://www.tcpdump.org/manpages/tcpdump.1.html)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

![f](https://media.beehiiv.com/cdn-cgi/image/fit=scale-down,format=auto,onerror=redirect,quality=80/uploads/asset/file/9ba5ca1d-95a9-487c-833c-c91fb8cdfc49/ip-header-2021-1024x505.png)

tcpdump prints out a description of the contents of packets on a network interface that match the Boolean expression (see **[pcap-filter(7)](https://www.tcpdump.org/manpages/pcap-filter.7.html)** for the expression syntax); the description is preceded by a time stamp, printed, by default, as hours, minutes, seconds, and fractions of a second since midnight. It can also be run with the -w flag, which causes it to save the packet data to a file for later analysis, and/or with the -r flag, which causes it to read from a saved packet file rather than to read packets from a network interface. It can also be run with the -V flag, which causes it to read a list of saved packet files. In all cases, only packets that match expression will be processed by tcpdump.
