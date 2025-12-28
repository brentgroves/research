# **[form cluster](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/cluster_form/)**

## How to form a cluster

For MicroCloud users

The MicroCloud setup process forms a LXD cluster. Thus, you do not need to follow the steps on this page. After MicroCloud setup, LXD cluster commands can be used with the MicroCloud cluster. ``

When forming a LXD cluster, you start with a bootstrap server. This bootstrap server can be an existing LXD server or a newly installed one.

After initializing the bootstrap server, you can join additional servers to the cluster. See **[Cluster members](https://documentation.ubuntu.com/microcloud/latest/lxd/explanation/clusters/#clustering-members)** for more information.

You can form the LXD cluster interactively by providing configuration information during the initialization process or by using preseed files that contain the full configuration.

To quickly and automatically set up a basic LXD cluster, you can use **[MicroCloud](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/cluster_form/#use-microcloud)**.

## Configure the cluster interactively

To form your cluster, you must first run lxd init on the bootstrap server. After that, run it on the other servers that you want to join to the cluster.

When forming a cluster interactively, you answer the questions that lxd init prompts you with to configure the cluster.

Initialize the bootstrap server
To initialize the bootstrap server, run lxd init and answer the questions according to your desired configuration.

You can accept the default values for most questions, but make sure to answer the following questions accordingly:

Would you like to use LXD clustering?

Select yes.

What IP address or DNS name should be used to reach this server?

Make sure to use an IP or DNS address that other servers can reach.

Are you joining an existing cluster?

Select no.

Expand to see a full example for lxd init on the bootstrap server
After the initialization process finishes, your first cluster member should be up and available on your network. You can check this with lxc cluster list.
