# **[Live migration](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/instances_migrate/#live-migration)**

Live migration means migrating an instance to another server while it is running. This method is supported for virtual machines. For containers, there is limited support.

## Live migration for virtual machines

Virtual machines can be migrated to another server while they are running, thus avoiding any downtime.

For a virtual machine to be eligible for live migration, it must meet the following criteria:

It must have support for stateful migration enabled. To enable this, set migration.stateful to true on the virtual machine. This setting can only be updated when the machine is stopped. Thus, be sure to configure this setting before you need to live-migrate:

```bash
lxc list
+------+---------+---------------------+------------------------------------------------+-----------------+-----------+----------+
| NAME |  STATE  |        IPV4         |                      IPV6                      |      TYPE       | SNAPSHOTS | LOCATION |
+------+---------+---------------------+------------------------------------------------+-----------------+-----------+----------+
| u1   | RUNNING | 10.64.30.2 (eth0)   | fd42:401f:5e9:ab1f:216:3eff:fe26:e339 (eth0)   | CONTAINER       | 0         | micro1   |
+------+---------+---------------------+------------------------------------------------+-----------------+-----------+----------+
| u2   | RUNNING | 10.64.30.3 (eth0)   | fd42:401f:5e9:ab1f:216:3eff:fec1:67ce (eth0)   | CONTAINER       | 0         | micro2   |
+------+---------+---------------------+------------------------------------------------+-----------------+-----------+----------+
| u3   | RUNNING | 10.64.30.4 (enp5s0) | fd42:401f:5e9:ab1f:216:3eff:fea0:b9c4 (enp5s0) | VIRTUAL-MACHINE | 0         | micro3   |
+------+---------+---------------------+------------------------------------------------+-----------------+-----------+----------+
| u4   | RUNNING | 10.212.250.2 (eth0) | fd42:7cce:a88:310a:216:3eff:fedd:63c1 (eth0)   | CONTAINER       | 0         | micro4   |
+------+---------+---------------------+------------------------------------------------+-----------------+-----------+----------+

lxc stop u3
# lxc config set <instance-name> migration.stateful=true
lxc config set u3 migration.stateful=true
lxc config get u3 migration.stateful
true

```

When migration.stateful is enabled in LXD, virtiofs shares are disabled, and files are only shared via the 9P protocol. Consequently, guest OSes lacking 9P support, such as CentOS 8, cannot share files with the host unless stateful migration is disabled. Additionally, the lxd-agent will not function for these guests under these conditions.

When using a local pool, the size.state of the virtual machine’s root disk device must be set to at least the size of the virtual machine’s limits.memory setting.

If you are using a remote storage pool like Ceph RBD to back your instance, you don’t need to set size.state to perform live migration.

The virtual machine must not depend on any resources specific to its current host, such as local storage or a local (non-OVN) bridge network.

## Live migration for containers

For containers, there is limited support for live migration using CRIU. However, because of extensive kernel dependencies, only very basic containers (non-systemd containers without a network device) can be migrated reliably. In most real-world scenarios, you should stop the container, migrate it, then start it again.

If you want to use live migration for containers, you must enable CRIU on both the source and the target server. If you are using the snap, use the following commands to enable CRIU:

snap set lxd criu.enable=true
sudo systemctl reload snap.lxd.daemon
Otherwise, make sure you have CRIU installed on both systems.

To optimize the memory transfer for a container, set the migration.incremental.memory property to true to make use of the pre-copy features in CRIU. With this configuration, LXD instructs CRIU to perform a series of memory dumps for the container. After each dump, LXD sends the memory dump to the specified remote. In an ideal scenario, each memory dump will decrease the delta to the previous memory dump, thereby increasing the percentage of memory that is already synced. When the percentage of synced memory is equal to or greater than the threshold specified via migration.incremental.memory.goal, or the maximum number of allowed iterations specified via migration.incremental.memory.iterations is reached, LXD instructs CRIU to perform a final memory dump and transfers it.

Temporarily migrate all instances from a cluster member
For LXD servers that are members of a cluster, you can use the evacuate and restore operations to temporarily migrate all instances from one cluster member to another. These operations can also live-migrate eligible instances.

For more information, see: **[Evacuate and restore cluster members](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/cluster_manage/#cluster-evacuate-restore)**.
