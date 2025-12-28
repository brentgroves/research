# **[Filtering tcpdump: Creating order from chaos](https://www.redhat.com/en/blog/filtering-tcpdump)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

## reference

- **[tcpdump options](https://upskilld.com/learn/using-tcpdump-options-filters-and-examples/)**

In my last article, Troubleshooting with tcpdump, I looked at the tcpdump tool, some basic use cases, and walked through a mock-up of a real-world scenario. Now, I want to dig a bit further. Everyone who uses this tool in a real situation immediately notices how much information (I believe they call this "verbose"...) is presented to the user. One of the best things you can do for yourself is figure out a practical way to filter for the information you need. Let's look at some ways that you can do this.

Common filtering options
The tcpdump tool has several different built-in ways to filter the capture itself. This means that you can narrow down the information that you receive before the capture even begins. This is highly preferable and makes post-capture filtering a much less tedious process. Some of the pre-capture filters you can use are as follows:

To filter by IP address:

`sudo tcpdump host x.x.x.x`

To filter by interface:

`sudo tcpdump -i eth0`

To filter by source:

`sudo tcpdump src x.x.x.x`

To filter by destination:

`sudo tcpdump dst x.x.x.x`

To filter by protocol:

`sudo tcpdump icmp`

This list does not cover each option available but gives you a good starting point. Next, let's look at some of the other ways that we can manipulate the capture.

## Writing captures to a file (pcap)

Due to the nature of troubleshooting, I find it useful to document what I see when capturing with tcpdump. Luckily, tcpdump has an output file format that captures all of the data we see. This format is called a packet capture file, aka PCAP, and is used across various utilities, including network analyzers and tcpdump. Here, we're writing to a PACAP file called output_file by using the -w switch.

```bash
# add -Z user parameter
# tcpdump -i eth0 -n -w out.pcap -C 1 -Z brent
[root@server ~]# tcpdump -i enp0s8 -c100 -nn -w output_file -Z brent
tcpdump: listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
102 packets received by filter
0 packets dropped by kernel
```

## Reading pcap files

You can read PCAP files by using the -r switch. Just a heads up—if you try to read a PCAP file via conventional means (cat, Vim, etc.), you will receive non-readable gibberish. If you want to use those programs to view your output, keep reading.

`tcpdump -r output_file`

## Writing tcpdump to .txt

If you want to use conventional means to read your output file, you need to rerun tcpdump, excluding the -w flag. You can see below that we use the standard output to file format with the file name output.txt.

```bash
[root@server ~]# tcpdump -i enp0s8 -c100 -nn > output.txt
  tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
  listening on enp0s8, link-type EN10MB (Ethernet), capture size 262144 bytes
  100 packets captured
  102 packets received by filter
  0 packets dropped by kernel
```

## Example

Before we go any further, I want to explain the scenario that I have set up for the rest of this article. We have three VMs running on the same network. Both Client 1 and Client 2 will ping the server nonstop. We will capture the ICMP traffic on interface enp0s8 on the Server VM and then filter for packets from each client machine. I realize this is a rather simple exercise, but the principles can be applied to more complex real-world environments.

- Server - 172.25.1.5
- Client 1 - 172.25.1.4
- Client 2 - 172.25.1.7

Next, we look at the two commands used to generate our captures:

Write to PCAP file - `tcpdump -i enp0s8 -c100 -nn -w output_file`
Write to TXT file - `tcpdump -i enp0s8 -c100 -nn > output.txt`

The only notable difference here is the output format. You see that we captured traffic on interface enp0s8 and that we limited the capture to 100 packets with no name or port resolution. Now, let's filter our file to just the traffic from Client 1.

To do this, we use one of two command strings (depending on the file format of our capture):

Filter PCAP output - `tcpdump -r output_file | grep -i 172.25.1.4`

```bash
[root@server ~]# tcpdump -r output_file | grep -i 172.25.1.4
reading from file output_file, link-type EN10MB (Ethernet)
22:01:14.947643 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 109, length 64
22:01:14.947704 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 109, length 64
22:01:16.023097 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 110, length 64
22:01:16.023153 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 110, length 64
22:01:17.081338 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 111, length 64
22:01:17.081386 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 111, length 64
22:01:18.103740 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 112, length 64
22:01:18.103784 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 112, length 64
22:01:19.128568 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 113, length 64
22:01:19.128646 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 113, length 64
22:01:20.129531 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 114, length 64
22:01:20.129577 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 114, length 64
22:01:21.175573 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 115, length 64
22:01:21.175631 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 115, length 64
22:01:22.199852 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 116, length 64
22:01:22.199899 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 116, length 64
22:01:23.231032 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 117, length 64
22:01:23.231083 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 117, length 64
22:01:24.247585 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 118, length 64
22:01:24.247660 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 118, length 64
22:01:25.248875 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 119, length 64
22:01:25.248937 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 119, length 64
22:01:26.295889 IP 172.25.1.4 > server.example.com: ICMP echo request, id 1, seq 120, length 64
22:01:26.295946 IP server.example.com > 172.25.1.4: ICMP echo reply, id 1, seq 120, length 64
22:01:27.255274 ARP, Request who-has server.example.com tell 172.25.1.4, length 46

*Edited for length*
```

or

Filter TXT output - `cat output.txt | grep -i 172.25.1.4`

```bash
[root@server ~]# cat output.txt | grep -i 172.25.1.4
12:03:56.653494 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 342, length 64
12:03:56.653534 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 342, length 64
12:03:57.674036 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 343, length 64
12:03:57.674089 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 343, length 64
12:03:58.701049 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 344, length 64
12:03:58.701107 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 344, length 64
12:03:59.721996 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 345, length 64
12:03:59.722134 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 345, length 64
12:04:00.746748 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 346, length 64
12:04:00.746805 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 346, length 64
12:04:01.774055 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 347, length 64
12:04:01.774130 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 347, length 64
12:04:02.793968 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 348, length 64
12:04:02.794012 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 348, length 64
12:04:03.846026 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 349, length 64
12:04:03.846082 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 349, length 64
12:04:04.918800 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 350, length 64
12:04:04.918850 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 350, length 64
12:04:05.930499 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 351, length 64
12:04:05.930543 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 351, length 64
12:04:06.954222 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 352, length 64
12:04:06.954269 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 352, length 64
12:04:07.990890 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 353, length 64
12:04:07.990937 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 353, length 64
12:04:09.002781 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 354, length 64
12:04:09.002842 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 354, length 64
12:04:10.032385 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 355, length 64
12:04:10.032451 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 355, length 64
12:04:11.055533 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 356, length 64
12:04:11.055583 IP 172.25.1.5 > 172.25.1.4: ICMP echo reply, id 1, seq 356, length 64
12:04:12.074288 IP 172.25.1.4 > 172.25.1.5: ICMP echo request, id 1, seq 357, length 64

*Edited for length*
```

To check for traffic to/from Client 2, we only need to change the IP address in the grep query. This method works for hostnames, port numbers, and any other keyword that you find in the capture file. This particular example shows the power of pre and post-filtering. Pre-filtering occurs when we only capture over a specific interface, and post-filtering happens when we apply a grep query to the capture file.

The takeaway
What I hope to communicate is that tcpdump is an incredibly powerful tool. Still, powerful technologies are often riddled with information that might not apply to your specific need. With some thought and planning, you can pre-filter your capture to narrow down the amount of traffic captured, and then use a smart grep or awk query on the output file to quickly find the traffic interactions that you are looking for. These strategies, when correctly applied, can exponentially quicken troubleshooting efforts. Now, here's to hoping that you don't have to put this to practice anytime soon.
