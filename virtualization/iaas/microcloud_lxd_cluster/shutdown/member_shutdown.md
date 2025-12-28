# **[How to shut down a MicroCloud cluster member](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/member_shutdown/)**

This guide provides instructions to safely shut down a MicroCloud cluster member. This includes how to deal with LXD instances running on the cluster member, as well as the order in which to shut down and restart the component services.

## Stop or live-migrate all instances on the cluster member

To shut down a machine that is a MicroCloud cluster member, first ensure that it is not hosting any running LXD instances.

You can stop all instances on a cluster member using the command:

```bash
lxc stop --all
```

Alternatively, for instances that can be live-migrated, you can migrate them to another cluster member without stopping them. See: **[How to migrate LXD instances between servers](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/instances_migrate/#howto-instances-migrate)** for more information.
