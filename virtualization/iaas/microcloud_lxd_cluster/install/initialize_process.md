# **[initialisation process](https://documentation.ubuntu.com/microcloud/stable/microcloud/explanation/initialisation/#explanation-initialisation)**

The **[initialisation process](https://documentation.ubuntu.com/microcloud/stable/microcloud/explanation/initialisation/#explanation-initialisation)** bootstraps the MicroCloud cluster. You run the initialisation on one of the machines, and it configures the required services on all of the machines that have been joined.

See How to initialise MicroCloud for instructions on how to set up MicroCloud.

## Trust establishment session

To allow several instances of MicroCloud joining the final cluster, in both the interactive and non-interactive method each instance is running one half of the trust establishment session to trust the other side.

Each trust establishment session has one initiator and one to many joiners. In case of the interactive mode the side which runs the microcloud init command becomes the initiator. The other side becomes the joiner by running microcloud join. In the non-interactive mode the initiator is being defined either using the initiator or initiator_address configuration key.

## Automatic server detection

If required MicroCloud uses multicast discovery to automatically detect a so called initiator on the network. This method works in physical networks, but it is usually not supported in a cloud environment. Instead you can specify the address of the initiator instead to not require using multicast.

The scan is limited to the local subnet of the network interface you select when choosing an address for MicroCloud’s internal traffic (see Network interface for intra-cluster traffic).

## Bootstrapping process

After you provide the required information to initialise MicroCloud, MicroCloud starts bootstrapping the cluster.

The bootstrapping process consists of the following steps:

- MicroCloud initialises the first server (the one where you run the microcloud init command) and creates the MicroCloud cluster.
- MicroCloud creates the LXD cluster, the OVN cluster, and the Ceph cluster.
- MicroCloud issues join tokens for the other servers that are to be added to the cluster.
- MicroCloud sends the join tokens over the network to the other servers.
- The other servers initialise their services and join the MicroCloud cluster, the OVN cluster, and the Ceph cluster.

This step of forming the cluster can take several minutes, mainly because of the initialisation of MicroCeph and adding disks to the Ceph cluster.

When the cluster is formed, MicroCloud configures LXD. It sets up networking and storage pools and configures the default profile to use the created OVN network and the distributed storage (if available).

After the initialisation is complete, you can look at the LXD configuration to confirm the setup.

user@micro01:~$lxc cluster list
+---------+------------------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
|  NAME   |                 URL                |      ROLES      | ARCHITECTURE | FAILURE DOMAIN | DESCRIPTION | STATE  |      MESSAGE      |
+---------+------------------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro01 | https://[2001:db8:d:100::169]:8443 | database-leader | aarch64      | default        |             | ONLINE | Fully operational |
|         |                                    | database        |              |                |             |        |                   |
+---------+------------------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro02 | https://[2001:db8:d:100::170]:8443 | database        | aarch64      | default        |             | ONLINE | Fully operational |
+---------+------------------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| micro03 | https://[2001:db8:d:100::171]:8443 | database        | aarch64      | default        |             | ONLINE | Fully operational |
+---------+------------------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
user@micro01:~$lxc storage list
+-----------+--------+--------------------------------------------+---------+---------+
|  NAME     | DRIVER |         DESCRIPTION                        | USED BY |  STATE  |
+-----------+--------+--------------------------------------------+---------+---------+
| local     | zfs    | Local storage on ZFS                       | 10      | CREATED |
+-----------+--------+--------------------------------------------+---------+---------+
| remote    | ceph   | Distributed storage on Ceph                | 7       | CREATED |
+-----------+--------+--------------------------------------------+---------+---------+
| remote-fs | cephfs | Distributed file-system storage using Ceph | 7       | CREATED |
+-----------+--------+--------------------------------------------+---------+---------+
user@micro01:~$lxc network list
+----------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
|   NAME   |   TYPE   | MANAGED |      IPV4       |           IPV6            | DESCRIPTION | USED BY |  STATE  |
+----------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| UPLINK   | physical | YES     |                 |                           |             | 2       | CREATED |
+----------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| default  | ovn      | YES     | 10.123.123.1/24 | fd42:1234:1234:1234::1/64 |             | 5       | CREATED |
+----------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| eth0     | physical | NO      |                 |                           |             | 0       |         |
+----------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
| eth0.200 | vlan     | NO      |                 |                           |             | 1       |         |
+----------+----------+---------+-----------------+---------------------------+-------------+---------+---------+
user@micro01:~$lxc profile show default
config: {}
description: ""
devices:
eth0:
  name: eth0
  network: default
  type: nic
root:
  path: /
  pool: remote
  type: disk
name: default
used_by: []
