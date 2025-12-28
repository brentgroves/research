# **[tcpdump filter get requests](https://stackoverflow.com/questions/4777042/can-i-use-tcpdump-to-get-http-requests-response-header-and-response-body)**

**[Back to Research List](../../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../../README.md)**

sudo tcpdump -i eth0 -n -s 0 -w odbc_capture.pcap "tcp port 1434"

There are tcpdump filters for HTTP GET & HTTP POST (or for both plus message body):

Run man tcpdump | less -Ip examples to see some examples

Here’s a tcpdump filter for HTTP GET (GET = 0x47, 0x45, 0x54, 0x20):

```bash
sudo tcpdump -s 0 -A 'tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x47455420'
```

Here’s a tcpdump filter for HTTP POST (POST = 0x50, 0x4f, 0x53, 0x54):

```bash
sudo tcpdump -s 0 -A 'tcp dst port 80 and (tcp[((tcp[12:1] & 0xf0) >> 2):4] = 0x504f5354)'
```

Monitor HTTP traffic including request and response headers and message body (source):

```bash
sudo tcpdump -A -s 0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)' -w out.pcap -Z brent
sudo tcpdump -X -s 0 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'
```

For more information on the bit-twiddling in the TCP header see: **[String-Matching Capture Filter Generator (link to Sake Blok's explanation)](http://www.wireshark.org/tools/string-cf.html)**.
