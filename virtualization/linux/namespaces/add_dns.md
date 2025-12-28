# AI Overview: add dns to network namespace

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\
**[Main](../../../../../README.md)**

AI Overview
Learn more
Linux Networking: Network Namespaces | by Claire Lee | Medium
To configure DNS settings within a network namespace in Linux, you need to create a resolv.conf file within the namespace's directory (/etc/netns/<namespace_name>/resolv.conf) and then use ip netns exec <namespace_name> ip link set <interface> netns <namespace_name> to move the interface into the namespace and ip netns exec <namespace_name> ip addr add <ip_address>/<subnet> dev <interface> to assign an IP address to the interface within the namespace.

## 1. Create the Namespace (if it doesn't exist)

`sudo ip netns add <namespace_name>`

## 2. Create the resolv.conf file within the namespace directory

```bash
# sudo mkdir -p /etc/netns/<namespace_name> 
sudo mkdir -p /etc/netns/netns1
# sudo nano /etc/netns/<namespace_name>/resolv.conf
sudo nano /etc/netns/netns1/resolv.conf
```

Content of /etc/netns/<namespace_name>/resolv.conf: Enter the DNS server IP addresses, one per line. For example:

```bash
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 10.225.50.203 
nameserver 10.224.50.203
```

3. Create a Virtual Ethernet Pair (veth) for communication between the host and the namespace (if needed):
Code

   sudo ip link add <veth_name> type veth peer name <veth_peer_name>
Example: sudo ip link add veth0 type veth peer name veth1
4. Assign the veth interface to the namespace:
Code

   sudo ip link set <veth_peer_name> netns <namespace_name>
Example: sudo ip link set veth1 netns my_namespace
5. Configure the IP address and gateway for the namespace:
Code

   sudo ip netns exec <namespace_name> ip addr add <ip_address>/<subnet> dev <veth_name>
   sudo ip netns exec <namespace_name> ip route add default via <gateway_ip>
Example:
sudo ip netns exec my_namespace ip addr add 192.168.10.10/24 dev veth0
sudo ip netns exec my_namespace ip route add default via 192.168.10.1
6. Bring up the interface within the namespace
Code

   sudo ip netns exec <namespace_name> ip link set dev <veth_name> up
Example: sudo ip netns exec my_namespace ip link set dev veth0 up
7. Verify DNS resolution within the namespace:
Code

   sudo ip netns exec <namespace_name> nslookup <domain_name>
Example: sudo ip netns exec my_namespace nslookup google.com
