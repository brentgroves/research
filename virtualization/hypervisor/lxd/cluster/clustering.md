# **[How to form a cluster](https://documentation.ubuntu.com/microcloud/latest/lxd/clustering/)**

For MicroCloud users

The MicroCloud setup process forms a LXD cluster. Thus, you do not need to follow the steps on this page. After MicroCloud setup, LXD cluster commands can be used with the MicroCloud cluster. ``

When forming a LXD cluster, you start with a bootstrap server. This bootstrap server can be an existing LXD server or a newly installed one.

After initializing the bootstrap server, you can join additional servers to the cluster. See **[Cluster members](https://documentation.ubuntu.com/microcloud/latest/lxd/explanation/clusters/#clustering-members)** for more information.

You can form the LXD cluster interactively by providing configuration information during the initialization process or by using preseed files that contain the full configuration.

To quickly and automatically set up a basic LXD cluster, you can use **[MicroCloud](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/cluster_form/#use-microcloud)**.

## Configure the cluster interactively

To form your cluster, you must first run lxd init on the bootstrap server. After that, run it on the other servers that you want to join to the cluster.

When forming a cluster interactively, you answer the questions that lxd init prompts you with to configure the cluster.

## Initialize the bootstrap server

To initialize the bootstrap server, run lxd init and answer the questions according to your desired configuration.

You can accept the default values for most questions, but make sure to answer the following questions accordingly:

Would you like to use LXD clustering?

Select yes.

What IP address or DNS name should be used to reach this server?

Make sure to use an IP or DNS address that other servers can reach.

Are you joining an existing cluster?

Select no.

```bash
~$ 
lxd init
Would you like to use LXD clustering? (yes/no) [default=no]: yes
What IP address or DNS name should be used to reach this server? [default=192.0.2.101]:
Are you joining an existing cluster? (yes/no) [default=no]: no
What member name should be used to identify this server in the cluster? [default=server1]:
Do you want to configure a new local storage pool? (yes/no) [default=yes]:
Name of the storage backend to use (btrfs, dir, lvm, zfs) [default=zfs]:
Create a new ZFS pool? (yes/no) [default=yes]:
Would you like to use an existing empty block device (e.g. a disk or partition)? (yes/no) [default=no]:
Size in GiB of the new loop device (1GiB minimum) [default=9GiB]:
Do you want to configure a new remote storage pool? (yes/no) [default=no]:
Would you like to connect to a MAAS server? (yes/no) [default=no]:
Would you like to configure LXD to use an existing bridge or host interface? (yes/no) [default=no]:
Would you like to create a new Fan overlay network? (yes/no) [default=yes]:
What subnet should be used as the Fan underlay? [default=auto]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]:
Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
```
