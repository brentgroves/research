# **[Ceph Storage Cluster](https://docs.ceph.com/en/reef/rados/)**

The Ceph Storage Cluster is the foundation for all Ceph deployments. Based upon RADOS, Ceph Storage Clusters consist of several types of daemons:

a Ceph OSD Daemon (OSD) stores data as objects on a storage node

a Ceph Monitor (MON) maintains a master copy of the cluster map.

a Ceph Manager manager daemon

A Ceph Storage Cluster might contain thousands of storage nodes. A minimal system has at least one Ceph Monitor and two Ceph OSD Daemons for data replication.

The Ceph File System, Ceph Object Storage and Ceph Block Devices read data from and write data to the Ceph Storage Cluster.

Ceph Storage Clusters have a few required settings, but most configuration settings have default values. A typical deployment uses a deployment tool to define a cluster and bootstrap a monitor. See **[Cephadm](https://docs.ceph.com/en/reef/cephadm/#cephadm)** for details.
