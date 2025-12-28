# **[Configure the cluster through preseed files](https://documentation.ubuntu.com/microcloud/latest/lxd/howto/cluster_form/#configure-the-cluster-through-preseed-files)**

To form your cluster, you must first run lxd init on the bootstrap server. After that, run it on the other servers that you want to join to the cluster.

Instead of answering the lxd init questions interactively, you can provide the required information through preseed files. You can feed a file to lxd init with the following command:

```bash
cat <preseed-file> | lxd init --preseed
```

You need a different preseed file for every server.

## Initialize the bootstrap server

To enable clustering, the preseed file for the bootstrap server must contain the following fields:
