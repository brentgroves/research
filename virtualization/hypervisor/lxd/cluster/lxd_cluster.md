# **[](https://documentation.ubuntu.com/lxd/stable-4.0/clustering/)**

## **[storage](https://www.youtube.com/watch?v=xhKfez-p7gg&t=340s)**

<https://bobcares.com/blog/lxd-create-storage-pool/#:~:text=LXD%20makes%20creating%20storage%20pools,LVM%20Storage%20Pool>

Clustering
LXD can be run in clustering mode, where any number of LXD servers share the same distributed database and can be managed uniformly using the lxc client or the REST API.

Note that this feature was introduced as part of the API extension “clustering”.

## Forming a cluster

First you need to choose a bootstrap LXD node. It can be an existing LXD server or a brand new one. Then you need to initialize the **bootstrap node** and join further nodes to the cluster. This can be done interactively or with a preseed file.

Note that all further nodes joining the cluster must have identical configuration to the bootstrap node, in terms of storage pools and networks. The only configuration that can be node-specific are the source and size keys for storage pools and the bridge.external_interfaces key for networks.

It is strongly recommended that the number of nodes in the cluster be at least three, so the cluster can survive the loss of at least one node and still be able to establish quorum for its distributed state (which is kept in a SQLite database replicated using the Raft algorithm). If the number of nodes is less than three, then only one node in the cluster will store the SQLite database. When the third node joins the cluster, both the second and third nodes will receive a replica of the database.

## Interactively

Run lxd init and answer yes to the very first question (“Would you like to use LXD clustering?”). Then choose a name for identifying the node, and an IP or DNS address that other nodes can use to connect to it, and answer no to the question about whether you’re joining an existing cluster. Finally, optionally create a storage pool and a network bridge. At this point your first cluster node should be up and available on your network.

You can now join further nodes to the cluster. Note however that these nodes should be brand new LXD servers, or alternatively you should clear their contents before joining, since any existing data on them will be lost.

There are two ways to add a member to an existing cluster; using the trust password or using a join token. A join token for a new member is generated in advance on the existing cluster using the command:

```bash
lxc cluster add <new member name>
```

This will return a single-use join token which can then be used in the join token question stage of lxd init. The join token contains the addresses of the existing online members, as well as a single-use secret and the fingerprint of the cluster certificate. This reduces the amount of questions you have to answer during lxd init as the join token can be used to answer these questions automatically.

## Do all nodes have to be on the same subnet

No, LXD cluster nodes do not need to be on the same subnet, but they do need to be on the same L2 broadcast network (LAN) for internal communication, especially for the default fan network. While LXD can manage clusters with members on different subnets, it requires a specific setup to handle the internal networking for containers, typically involving the Open vSwitch (OVN) overlay which creates its own virtual L2 networks across the cluster, avoiding the need for nodes to share a subnet.

## Per-server configuration

As mentioned previously, LXD cluster members are generally assumed to be identical systems.

However to accommodate things like slightly different disk ordering or network interface naming, LXD records some settings as being server-specific. When such settings are present in a cluster, any new server being added will have to provide a value for it.

This is most often done through the interactive lxd init which will ask the user for the value for a number of configuration keys related to storage or networks.

Those typically cover:

- Source device for a storage pool (leaving empty would create a loop)
- Name for a ZFS zpool (defaults to the name of the LXD pool)
- External interfaces for a bridged network (empty would add none)
- Name of the parent network device for managed physical or macvlan networks (must be set)

It’s possible to lookup the questions ahead of time (useful for scripting) by querying the /1.0/cluster API endpoint. This can be done through lxc query /1.0/cluster or through other API clients.

## Preseed

Create a preseed file for the bootstrap node with the configuration you want, for example:

```yaml
config:
  core.trust_password: sekret
  core.https_address: 10.55.60.171:8443
  images.auto_update_interval: 15
storage_pools:
- name: default
  driver: dir
networks:
- name: lxdbr0
  type: bridge
  config:
    ipv4.address: 192.168.100.14/24
    ipv6.address: none
profiles:
- name: default
  devices:
    root:
      path: /
      pool: default
      type: disk
    eth0:
      name: eth0
      nictype: bridged
      parent: lxdbr0
      type: nic
cluster:
  server_name: node1
  enabled: true
```

Then run cat <preseed-file> | lxd init --preseed and your first node should be bootstrapped.

Now create a bootstrap file for another node. You only need to fill in the cluster section with data and config values that are specific to the joining node.

Be sure to include the address and certificate of the target bootstrap node. To create a YAML-compatible entry for the cluster_certificate key you can use a command like sed ':a;N;$!ba;s/\n/\n\n/g' /var/lib/lxd/cluster.crt (or sed ':a;N;$!ba;s/\n/\n\n/g' /var/snap/lxd/common/lxd/cluster.crt for snap users), which you have to run on the bootstrap node. cluster_certificate_path key (which should contain valid path to cluster certificate) can be used instead of cluster_certificate key.

For example:

```yaml
cluster:
  enabled: true
  server_name: node2
  server_address: 10.55.60.155:8443
  cluster_address: 10.55.60.171:8443
  cluster_certificate: "-----BEGIN CERTIFICATE-----

opyQ1VRpAg2sV2C4W8irbNqeUsTeZZxhLqp4vNOXXBBrSqUCdPu1JXADV0kavg1l

2sXYoMobyV3K+RaJgsr1OiHjacGiGCQT3YyNGGY/n5zgT/8xI0Dquvja0bNkaf6f

...

-----END CERTIFICATE-----
"
  cluster_password: sekret
  member_config:

- entity: storage-pool
    name: default
    key: source
    value: ""
```

When joining a cluster using a cluster join token, the following fields can be omitted:

- server_name
- cluster_address
- cluster_certificate
- cluster_password

And instead the full token be passed through the cluster_token field.

## Managing a cluster

Once your cluster is formed you can see a list of its nodes and their status by running lxc cluster list. More detailed information about an individual node is available with lxc cluster show <node name>.
