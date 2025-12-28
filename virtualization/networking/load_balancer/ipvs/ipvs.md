# **[](https://en.wikipedia.org/wiki/IP_Virtual_Server)**

IPVS (IP Virtual Server) implements transport-layer load balancing, usually called Layer 4 LAN switching, as part of the Linux kernel. It's configured via the user-space utility ipvsadm(8) tool.

IPVS is incorporated into the Linux Virtual Server (LVS), where it runs on a host and acts as a load balancer in front of a cluster of real servers. IPVS can direct requests for TCP- and UDP-based services to the real servers, and make services of the real servers appear as virtual services on a single IP address. IPVS is built on top of Netfilter.[1]

IPVS is merged into versions 2.4.x and newer of the Linux kernel mainline.[1]

IPVS
IPVS (IP Virtual Server) implements transport-layer load balancing inside the Linux kernel, so called Layer-4 switching. IPVS running on a host acts as a load balancer at the front of a cluster of real servers, it can direct requests for TCP/UDP based services to the real servers, and makes services of the real servers to appear as a virtual service on a single IP address.

The IP Virtual Server Netfilter module for kernel 2.6
Status: The ipvs 1.2.1 is the latest stable version, it is in the official kernel 2.6.10 released on December 24, 2004.

IPv6 support for IPVS was included in the Linux kernel 2.6.28-rc3 on November 2, 2008. See the wiki page of IPv6 load balancing for the status of IPv6 support.

Go to <http://kernel.org/> to get a clean copy of kernel 2.6.10 or later, and download the ipvsadm utility at <https://www.kernel.org/pub/linux/utils/kernel/ipvsadm/> to administer the IP Virtual Server inside the Linux kernel. See the article Compiling ipvsadm on different Linux distributions at wiki.

Your testings, comments and bug report/fixes are very welcome. The ChangeLog is available here.

ipvsadm-1.26-1.src.rpm (for kernel 2.6.28-rc3 or later) - February 8, 2011
ipvsadm-1.26.tar.gz (for kernel 2.6.28-rc3 or later) - February 8, 2011

ipvsadm-1.25-1.src.rpm (for kernel 2.6.28-rc3 or later) - November 5, 2008
ipvsadm-1.25.tar.gz (for kernel 2.6.28-rc3 or later) - November 5, 2008
ipvsadm-1.24-6.src.rpm (for kernel between 2.6.10 and 2.6.27.4) - December 10, 2005
ipvsadm-1.24-5.src.rpm (for 1.2.0 or later) - October 27, 2004
ipvsadm-1.24-4.src.rpm (for 1.1.8 or later) - January 10, 2004
ipvsadm-1.24-3.src.rpm (for 1.1.8 or later) - December 20, 2003
ipvsadm-1.24.tar.gz - December 10, 2005
