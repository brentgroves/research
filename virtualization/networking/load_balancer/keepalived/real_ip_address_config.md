# how to specify the real ip in keepalived

In Keepalived, the "real IP" refers to the individual, static IP address assigned to each server participating in the high-availability setup. While Keepalived primarily manages a Virtual IP (VIP) that floats between servers, the real IP addresses are crucial for the servers to communicate and for Keepalived to function correctly.
Here's how you specify and manage real IPs in a Keepalived setup:
Assign Static IP Addresses to Each Server:
Before configuring Keepalived, ensure each server in your cluster has a distinct, static IP address configured on its network interface. This is typically done in your operating system's network configuration files (e.g., /etc/network/interfaces on Debian/Ubuntu, or network configuration files in /etc/sysconfig/network-scripts/ on CentOS/RHEL). Keepalived Configuration (keepalived.conf).
Within the keepalived.conf file on each server, you define the VRRP instance. While the real IP addresses are not explicitly defined within the VRRP instance itself, they are implicitly used by Keepalived for communication between the master and backup nodes.
interface: You specify the network interface on which VRRP will operate. This interface must be configured with the server's real IP address.
Code

        interface eth0
unicast_src_ip and unicast_peer (Optional): If you are using unicast VRRP, you specify the source IP for VRRP advertisements (which will be the server's real IP) and the real IP addresses of the other VRRP peers.
Code

        unicast_src_ip 192.168.1.10
        unicast_peer {
            192.168.1.11
            192.168.1.12
        }
Virtual IP Address (VIP).
The virtual_ipaddress block within the vrrp_instance defines the IP address that will be shared and managed by Keepalived. This is the "floating" IP, not the real IP of any individual server.
Code

    virtual_ipaddress {
        192.168.1.100/24 dev eth0
    }
In summary: You don't "specify" the real IP within the Keepalived configuration in the same way you specify the Virtual IP. Instead, the real IP addresses are the underlying network configurations of your servers, and Keepalived leverages these for inter-node communication and for associating the VRRP instance with a specific network interface. The interface, unicast_src_ip, and unicast_peer parameters implicitly rely on these pre-configured real IP addresses.
