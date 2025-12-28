# **[Highly Available Shared Storage using MicroCeph — Home Lab Part 2](https://medium.com/@mahak.sangwan/highly-available-shared-storage-using-microceph-home-lab-part-2-51a05abbd2fb)**

Heyo! Fellas, in the **[last blog](https://medium.com/@mahak.sangwan/highly-available-docker-swarm-with-keepalived-home-lab-part-1-6211a0c1efb1)** we configured a highly available docker swarm using keepalived and docker. We got to look at how we can utilize floating IPs and VRRP protocol to configure a floating IP which automatically rolls over to the alive nodes of a swarm if the nodes in your swarm starts failing.

In this blog, we will go a step further into our home lab setup and configure a distributed shared storage between out docker swarm nodes using MicroCeph. You can use this shared storage to host your docker compose files and any other files and directories that needs to be shared between your containers running on different nodes.

Important Note: Make sure you have an empty disk attached to your VMs. These disks will be used to store data and create a highly available cluster.

## Introduction

MicroCeph is a lightweight, snap-based deployment of Ceph designed for small-scale and edge environments. It strips away the complexity of a full-blown Ceph cluster setup but still retains the core benefits — high availability, redundancy, and distributed storage. It’s dead simple to get started with, but powerful enough to serve as the backbone of a home lab or small production system.

Under the hood, it gives you block, object, and file storage capabilities backed by Ceph’s battle-tested architecture, all with minimal configuration. In this setup, we’ll use MicroCeph to create a shared, resilient storage layer that seamlessly integrates with our Docker Swarm cluster.

## Installation

Now to install MicroCeph on your system, you should have snap installed. If you’re using ubuntu it’s highly likely that snap is already pre-installed on your system but if not, you can visit their official website for your system specific instructions.

Now that you have snap installed, we will now install MicroCeph. To do that, you just need this little tiny and simple command below and you should be good to go.

`sudo snap install microceph`

The next thing you would wanna do is put the package on hold because it’s best to manually upgrade your MicroCeph installation if needed to avoid unintentional disruptions to your service if a new update is buggy or vulnerable. To hold the package run the below command.

`sudo snap refresh --hold microceph`

Run these two commands on all the swarm nodes or VMs that you need the shared storage on (which is all 5 of them in our case).

## Configuring MicroCeph Cluster

### Initializing the Cluster

Now that we’ve installed MicroCeph on all our cluster nodes and held the package at the specific version so it does not update, we will now start to poke it around and get our cluster setup.

First of all we will initialize/bootstrap our MicroCeph cluster using one of the cluster nodes so login to one of your MicroCeph cluster nodes and run the below command to initialize the MicroCeph cluster.

`sudo microceph cluster bootstrap`

After this, you should have a MicroCeph cluster ready to be configured. To see the current status of the cluster with information about the nodes in your cluster, their roles and how many disks they are contributing, you can run the below command:

`sudo microceph status`

At this point you should only see a single node in your cluster (the current machine) with 0 (zero) disks and some roles assigned to it.

Now before we move on to add more nodes, roles, and disks, I want to explain each role we will deal with today and their significance to the whole setup.

## Node Roles

**mon:** It is the core control node for the whole cluster tracking the state of the whole cluster including the membership and state of the node and the health of the overall cluster. If all the monitor nodes go down, your cluster will become irresponsive so it is very crucial or have multiple monitor nodes (at least 3 but 1 is the bare minimum requirement).

**mgr:** It provides assess to the cluster management APIs and other important modules like dashboard for managing your cluster. A manager nodes is still a very important piece to have but loosing the manager node will not bring down the whole cluster, it can still technically be functional.

**osd:** All the nodes which are contributing a disk or storing data will have this role (object storage daemon). These nodes run the daemon which actually manages the data on your shared disks, that means it will perform all the read/write activities on the disks, handle replication, recovery, backfilling and rebalancing. OSD nodes also talk to the MON and MGR nodes to report their status and metrics like health and other things.

**rgw:** This node will be the RADOS gateway for the cluster, providing S3/Swift-compatible object storage API on behalf of the cluster. If you need a HTTP based object storage solution that is S3 compatible similar to Amazon S3 buckets, you would use this (S3 is not a protocol but an API spec, it is not an “official” spec either but is made and popularized by Amazon with their S3 buckets service).

**mds:** This role is only used when you’re using the CephFS file system. The MDS or metadata server node store the metadata of the CephFS filesystem like filenames, directories, permissions and such. This is only required when you’re using the CephFS.

## Adding More Nodes

Now that we have a bit more understating about the roles we have, let’s add the rest of your nodes to the cluster. To do that you’ll need a join token which can be obtained using the command below (we use different join token for different nodes):

```bash
sudo microceph cluster add <A_NAME_FOR_THE_NODE>

# Example: sudo microceph cluster join swarm_node_2

# TIP: You can just use the hostname for simplicity
```

This token contains all the information you need to join a cluster so now copy the token, login to the next node and run the following command:

`sudo microceph cluster join <TOKEN>`

Repeat these two commands for each node you want to add to the cluster.

## Adding disks to the cluster

Now that we have all the nodes participating in the cluster, we will add the disks to the cluster to be used for storing data. To do this login to each node that has the disk that needs to be shared and run the following commad:

```bash
sudo microceph disk add /dev/XXX --wipe
# Example: sudo microceph disk add /dev/sdb --wipe
```

Repeat this step for each node that has needs to share it’s disk. The OSD role will be assign automatically once you’ve shared the disk using the above command.

## Creating a new Filesystem

Now that we have the actual disks available in the cluster to store the data, it’s now time to initialize a new filesystem which will be used to store data onto the disks. For this example, we will be using CephFS file system.

Note: From here on, we will be using the “ceph” command and not the “microceph” command.

For CephFS, we will need two separate storage pools, one to store the file data and one to store the file metadata like filename, permissions etc. To create these two pools we will use the below command:

```bash
sudo ceph osd pool create cephfs_data 64
sudo ceph osd pool create cephfs_metadata 64

# Syntax: sudo ceph osd pool create <POOL_NAME> <PLACEMENT_GROUPS>
```

Note: Placement groups are internal data structures used my ceph to map objects (data) to storage nodes.

Now that we’ve create the two required storage pools for our filesystem, let’s initialize it using the command below:

```bash
sudo ceph fs new cephfs cephfs_metadata cephfs_data

# Syntax: sudo ceph fs new <NAME_FOR_FS> <METADATA_POOL> <DATA_POOL>

# You can now see your filesystem using the command:

sudo ceph fs ls
```

## Mounting the Filesystem

At this point, our highly available, redundant and distributed storage is ready and waiting to be used for data storage. To mount this storage onto any machine, we will first need to create some credentials that we can use to authenticate ourself to the storage cluster and gain access to the storage.

Using the below command, we can get the client admin token which will later be used to mount the filesystem on our client VMs (which cloud be any machine, inside or outside the cluster).

`sudo ceph auth get-key client.admin`

This will output a token which we can use to mount the storage onto a machine.

Now to mount the ceph storage, we will be using the /etc/fstab file and specifying all our parameters there.

Note: Before doing this, just make a folder somewhere (/mnt/cephfs here as an example) to act as a target for the mount.

Using your favorite text editor open the file /etc/fstab and append the following line in the file:

```bash
# CephFS Shared Storage

<NODE_1_IP>:6789,<NODE_2_IP>:6789,<NODE_X_IP>:6789:/ /mnt/cephfs ceph name=admin,secret=<YOUR_CLIENT_ADMIN_TOKEN>,_netdev 0 0

# Syntax: IP:PORT:/ /path/to/target cephfs name=admin,secret=<TOKEN>,_netdev 0 0

```

Next thing do a sudo mount -a and sudo systemctl daemon-reload to apply all the changes. Now your folder should be mounted and you can verify this by using command df -h .

```bash
df -h
```

## Conclusion

Boom! That’s it folks! We now have a distributed, redundant, and highly available shared storage setup backing our Docker Swarm. With MicroCeph and CephFS, we’ve added another solid piece to our home lab puzzle. Now you can confidently store and share data across your swarm nodes or the whole network without worrying about a single point of failure.

In the next parts, we’ll take things even further to develop our home lab so stay tuned, and don’t be afraid to comment and ask questions. Peac
