# **[](https://documentation.ubuntu.com/lxd/latest/howto/instances_manage/)**

How to manage instances
When listing the existing instances, you can see their type, status, and location (if applicable). You can filter the instances and display only the ones that you are interested in.

Enter the following command to list all instances:

`lxc list`

You can filter the instances that are displayed, for example, by type, status or the cluster member where the instance is located:

```bash
lxc list type=container
lxc list status=running
lxc list location=server1
```

You can also filter by name. To list several instances, use a regular expression for the name. For example:

`lxc list ubuntu.*`

Enter lxc list --help to see all filter options.

## Show information about an instance

Enter the following command to show detailed information about an instance:

`lxc info <instance_name>`

Add --show-log to the command to show the latest log lines for the instance:

`lxc info <instance_name> --show-log`

## Start an instance

Enter the following command to start an instance:

`lxc start <instance_name>`

You will get an error if the instance does not exist or if it is running already.

To immediately attach to the console when starting, pass the --console flag. For example:

`lxc start <instance_name> --console`

See **[How to access the console](https://documentation.ubuntu.com/lxd/latest/howto/instances_console/#instances-console)** for more information.

Prevent accidental start of instances
To protect a specific instance from being started, set **[security.protection.start](https://documentation.ubuntu.com/lxd/latest/reference/instance_options/#instance-security:security.protection.start)** to true for the instance. See **[How to configure instances](https://documentation.ubuntu.com/lxd/latest/howto/instances_configure/#instances-configure)** for instructions.

## Stop an instance

Enter the following command to stop an instance:

`lxc stop <instance_name>`

You will get an error if the instance does not exist or if it is not running.

## Delete an instance

If you don’t need an instance anymore, you can remove it. The instance must be stopped before you can delete it.

Enter the following command to delete an instance:

`lxc delete <instance_name>`

Caution

This command permanently deletes the instance and all its snapshots.

Prevent accidental deletion of instances
There are different ways to prevent accidental deletion of instances:

To protect a specific instance from being deleted, set security.protection.delete to true for the instance. See How to configure instances for instructions.

In the CLI client, you can create an alias to be prompted for approval every time you use the lxc delete command:

`lxc alias add delete "delete -i"`

## Rebuild an instance

If you want to wipe and re-initialize the root disk of your instance but keep the instance configuration, you can rebuild the instance.

Rebuilding is only possible for instances that do not have any snapshots.

Stop your instance before rebuilding it.

Enter the following command to rebuild the instance with a different image:

`lxc rebuild <image_name> <instance_name>`

Enter the following command to rebuild the instance with an empty root disk:

`lxc rebuild <instance_name> --empty`

For more information about the rebuild command, see **[lxc rebuild --help](https://documentation.ubuntu.com/lxd/latest/reference/manpages/lxc/rebuild/#lxc-rebuild-md)**.
