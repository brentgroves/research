# **[5.6. Port Address Translation (PAT) from Userspace](http://linux-ip.net/html/nat-pat-userspace.html)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\
**[Main](../../../../../../README.md)**

## AI Overview: what is RFC 1918 network

RFC 1918 defines the private IP address ranges (10.0.0.0/8, 172.16.0.0/12, and 192.168.0.0/16) that are reserved for use within private networks and are not routable on the public internet.

## 5.6. Port Address Translation (PAT) from Userspace

Port address translation (hereafter PAT) provides a similar functionality to NAT, but is a more specific tool. PAT forwards requests for a particular IP and port pair to another IP port pair. This feature is commonly used on publicly connected hosts to make an internal service available to a larger network.

PAT will break in strange and wonderful ways if there is an alternate route between the two hosts connected by the port address translation.

PAT has one important benefit over NAT (with the iproute2 tools). Let's assume that you have only five public IP addresses for which you have paid dearly. Additionally, let's assume that you want to run services on standard ports. You had hoped to connect four SMTP servers, two SSH servers and five HTTP servers. If you had wanted to accomplish this with NAT, you'd need more IP space.
