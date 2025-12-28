# **[Linux Virtual Server](http://www.linuxvirtualserver.org/whatis.html)**

What is virtual server?
Virtual server is a highly scalable and highly available server built on a cluster of real servers. The architecture of server cluster is fully transparent to end users, and the users interact with the cluster system as if it were only a single high-performance virtual server. Please consider the following figure.

![i1](http://www.linuxvirtualserver.org/VirtualServer.png)

The real servers and the load balancers may be interconnected by either high-speed LAN or by geographically dispersed WAN. The load balancers can dispatch requests to the different servers and make parallel services of the cluster to appear as a virtual service on a single IP address, and request dispatching can use IP load balancing technolgies or application-level load balancing technologies. Scalability of the system is achieved by transparently adding or removing nodes in the cluster. High availability is provided by detecting node or daemon failures and reconfiguring the system appropriately.

Goals
The basic goal of the Linux Virtual Server Project is to:

Build a high-performance and highly available server for Linux using clustering technology, which provides good scalability, reliability and serviceability.

The LVS cluster system is also known as load balancing server cluster.
