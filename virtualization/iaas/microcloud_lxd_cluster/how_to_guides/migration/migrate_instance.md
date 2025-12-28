# **[Migration](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/cluster_manage_instance/#howto-cluster-manage-instance-migrate)**

Check where an instance is located
To check on which member an instance is located, list all instances in the cluster:

```bash
lxc list

# The location column indicates the member on which each instance is running.

Migrate an instance
You can migrate an existing instance to another cluster member. For example, to migrate the instance c1 to the cluster member server1, use the following commands:

lxc stop c1
lxc move c1 --target server1
lxc start c1
See How to migrate LXD instances between servers for more information.

To migrate an instance to a member of a cluster group, use the group name prefixed with @ for the --target flag. For example:

lxc move c1 --target @group1
