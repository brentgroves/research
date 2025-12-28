# **[](https://documentation.ubuntu.com/lxd/stable-5.21/howto/cluster_groups/)**

How to set up cluster groups
▶
Watch on YouTube
Cluster members can be assigned to Cluster groups. By default, all cluster members belong to the default group.

To create a cluster group, use the lxc cluster group create command. For example:

lxc cluster group create gpu
To assign a cluster member to one or more groups, use the lxc cluster group assign command. This command removes the specified cluster member from all the cluster groups it currently is a member of and then adds it to the specified group or groups.

For example, to assign server1 to only the gpu group, use the following command:

lxc cluster group assign server1 gpu
To assign server1 to the gpu group and also keep it in the default group, use the following command:

lxc cluster group assign server1 default,gpu
To add a cluster member to a specific group without removing it from other groups, use the lxc cluster group add command.

For example, to add server1 to the gpu group and also keep it in the default group, use the following command:

lxc cluster group add server1 gpu
