# **[](https://documentation.ubuntu.com/lxd/stable-5.21/howto/network_ovn_setup/)**

How to set up OVN with LXD
See the following sections for how to set up a basic OVN network, either as a standalone network or to host a small LXD cluster.

Set up a standalone OVN network
Complete the following steps to create a standalone OVN network that is connected to a managed LXD parent bridge network (for example, lxdbr0) for outbound connectivity.

Install the OVN tools on the local server:

sudo apt install ovn-host ovn-central
Configure the OVN integration bridge:

sudo ovs-vsctl set open_vswitch . \
   external_ids:ovn-remote=unix:/var/run/ovn/ovnsb_db.sock \
   external_ids:ovn-encap-type=geneve \
   external_ids:ovn-encap-ip=127.0.0.1
Create an OVN network:

lxc network set <parent_network> ipv4.dhcp.ranges=<IP_range> ipv4.ovn.ranges=<IP_range>
lxc network create ovntest --type=ovn network=<parent_network>
Create an instance that uses the ovntest network:

lxc init ubuntu:24.04 c1
lxc config device override c1 eth0 network=ovntest
lxc start c1
Run lxc list to show the instance information:

```bash
lxc list
+------+---------+---------------------+----------------------------------------------+-----------+-----------+
| NAME |  STATE  |        IPV4         |                     IPV6                     |   TYPE    | SNAPSHOTS |
+------+---------+---------------------+----------------------------------------------+-----------+-----------+
| c1   | RUNNING | 192.0.2.2 (eth0)    | 2001:db8:cff3:5089:216:3eff:fef0:549f (eth0) | CONTAINER | 0         |
+------+---------+---------------------+----------------------------------------------+-----------+-----------+
```

Set up a LXD cluster on OVN
▶
Watch on YouTube
Complete the following steps to set up a LXD cluster that uses an OVN network.

Just like LXD, the distributed database for OVN must be run on a cluster that consists of an odd number of members. The following instructions use the minimum of three servers, which run both the distributed database for OVN and the OVN controller. In addition, you can add any number of servers to the LXD cluster that run only the OVN controller. See the linked YouTube video for the complete tutorial using four machines.

Complete the following steps on the three machines that you want to run the distributed database for OVN:

Install the OVN tools:

sudo apt install ovn-central ovn-host
Mark the OVN services as enabled to ensure that they are started when the machine boots:

 systemctl enable ovn-central
 systemctl enable ovn-host
Stop OVN for now:

systemctl stop ovn-central
Note down the IP address of the machine:

ip -4 a
Open /etc/default/ovn-central for editing.

Paste in one of the following configurations (replace <server_1>, <server_2> and <server_3> with the IP addresses of the respective machines, and <local> with the IP address of the machine that you are on).

For the first machine:

OVN_CTL_OPTS=" \
     --db-nb-addr=<local> \
     --db-nb-create-insecure-remote=yes \
     --db-sb-addr=<local> \
     --db-sb-create-insecure-remote=yes \
     --db-nb-cluster-local-addr=<local> \
     --db-sb-cluster-local-addr=<local> \
     --ovn-northd-nb-db=tcp:<server_1>:6641,tcp:<server_2>:6641,tcp:<server_3>:6641 \
     --ovn-northd-sb-db=tcp:<server_1>:6642,tcp:<server_2>:6642,tcp:<server_3>:6642"
For the second and third machine:

OVN_CTL_OPTS=" \
      --db-nb-addr=<local> \
     --db-nb-cluster-remote-addr=<server_1> \
     --db-nb-create-insecure-remote=yes \
     --db-sb-addr=<local> \
     --db-sb-cluster-remote-addr=<server_1> \
     --db-sb-create-insecure-remote=yes \
     --db-nb-cluster-local-addr=<local> \
     --db-sb-cluster-local-addr=<local> \
     --ovn-northd-nb-db=tcp:<server_1>:6641,tcp:<server_2>:6641,tcp:<server_3>:6641 \
     --ovn-northd-sb-db=tcp:<server_1>:6642,tcp:<server_2>:6642,tcp:<server_3>:6642"
Start OVN:

systemctl start ovn-central
On the remaining machines, install only ovn-host and make sure it is enabled:

sudo apt install ovn-host
systemctl enable ovn-host
On all machines, configure Open vSwitch (replace the variables as described above):

sudo ovs-vsctl set open_vswitch . \
   external_ids:ovn-remote=tcp:<server_1>:6642,tcp:<server_2>:6642,tcp:<server_3>:6642 \
   external_ids:ovn-encap-type=geneve \
   external_ids:ovn-encap-ip=<local>
Create a LXD cluster by running lxd init on all machines. On the first machine, create the cluster. Then join the other machines with tokens by running lxc cluster add <machine_name> on the first machine and specifying the token when initializing LXD on the other machine.

On the first machine, create and configure the uplink network:

lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_1>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_2>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_3>
lxc network create UPLINK --type=physical parent=<uplink_interface> --target=<machine_name_4>
lxc network create UPLINK --type=physical \
   ipv4.ovn.ranges=<IP_range> \
   ipv6.ovn.ranges=<IP_range> \
   ipv4.gateway=<gateway> \
   ipv6.gateway=<gateway> \
   dns.nameservers=<name_server>
To determine the required values:

Uplink interface
A high availability OVN cluster requires a shared layer 2 network, so that the active OVN chassis can move between cluster members (which effectively allows the OVN router’s external IP to be reachable from a different host).

Therefore, you must specify either an unmanaged bridge interface or an unused physical interface as the parent for the physical network that is used for OVN uplink. The instructions assume that you are using a manually created unmanaged bridge. See How to configure network bridges for instructions on how to set up this bridge.

Gateway
Run ip -4 route show default and ip -6 route show default.

Name server
Run resolvectl.

IP ranges
Use suitable IP ranges based on the assigned IPs.

Still on the first machine, configure LXD to be able to communicate with the OVN DB cluster. To do so, find the value for ovn-northd-nb-db in /etc/default/ovn-central and provide it to LXD with the following command:

lxc config set network.ovn.northbound_connection <ovn-northd-nb-db>
Note

If you are using a MicroOVN deployment, pass the value of the MicroOVN node IP address you want to target. Prefix the IP address with ssl:, and suffix it with the :6641 port number that corresponds to the OVN central service within MicroOVN.

Finally, create the actual OVN network (on the first machine):

lxc network create my-ovn --type=ovn
To test the OVN network, create some instances and check the network connectivity:

lxc launch ubuntu:24.04 c1 --network my-ovn
lxc launch ubuntu:24.04 c2 --network my-ovn
lxc launch ubuntu:24.04 c3 --network my-ovn
lxc launch ubuntu:24.04 c4 --network my-ovn
lxc list
lxc exec c4 -- bash
ping <IP of c1>
ping <nameserver>
ping6 -n <www.example.com>
Send OVN logs to LXD
Complete the following steps to have the OVN controller send its logs to LXD.

Enable the syslog socket:

lxc config set core.syslog_socket=true
Open /etc/default/ovn-host for editing.

Paste the following configuration:

OVN_CTL_OPTS=" \
       --ovn-controller-log='-vsyslog:info --syslog-method=unix:/var/snap/lxd/common/lxd/syslog.socket'"
Restart the OVN controller:

systemctl restart ovn-controller.service
You can now use lxc monitor to see logs from the OVN controller:

lxc monitor --type=ovn
You can also send the logs to Loki. To do so, add the ovn value to the loki.types configuration key, for example:

lxc config set loki.types=ovn
Tip

You can include logs for OVN northd, OVN north-bound ovsdb-server, and OVN south-bound ovsdb-server as well. To do so, edit /etc/default/ovn-central:

OVN_CTL_OPTS=" \
   --ovn-northd-log='-vsyslog:info --syslog-method=unix:/var/snap/lxd/common/lxd/syslog.socket' \
   --ovn-nb-log='-vsyslog:info --syslog-method=unix:/var/snap/lxd/common/lxd/syslog.socket' \
   --ovn-sb-log='-vsyslog:info --syslog-method=unix:/var/snap/lxd/common/lxd/syslog.socket'"

sudo systemctl restart ovn-central.service
