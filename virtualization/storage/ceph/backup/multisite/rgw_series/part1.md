# **[Ceph Object Storage Multisite Replication Series. Part One](https://ceph.io/en/news/blog/2025/rgw-multisite-replication_part1/)**

![i1](https://ceph.io/en/news/blog/2025/rgw-multisite-replication_part1/images/image1.png)

Ceph Object Storage Multisite Replication Series ¶
Throughout this series of articles, we will provide hands-on examples to help you set up and configure some of the most critical replication features of the Ceph Object Storage solution. This will include the new Object Storage multisite enhancements released in the Reef release.

At a high level, these are the topics we will cover in this series:

- Introduction to Ceph Object Storage Multisite Replication.
- Ceph Object Multisite Architecture & Configuration
- New Performance Improvements in Reef: Replication Sync Fairness
- Load-Balancing RGW services: Deploying the Ceph Ingress Service
- Ceph Object Multisite sync policy
- Ceph Object Storage Archive Zone

In simple terms, RTO is the time it takes to recover, while RPO is the amount of data loss that is acceptable. Both RTO and RPO are critical components of a disaster recovery plan, and they should be carefully considered and set based on the specific needs and requirements of a business.

When discussing Replication, Disaster Recovery, Backup and Restore, we have multiple strategies available that provide us with different SLAs for data and application recovery (RTO / RPO). For instance, synchronous replication provides the lowest RPO, which means zero data loss. Ceph can provide synchronous replication between sites by stretching the Ceph cluster among the data centers. On the other hand, asynchronous replication will assume a non-zero RPO. In Ceph, async multisite replication involves replicating the data to another Ceph cluster. Each Ceph storage modality (object, block, and file) has its own asynchronous replication mechanism. This blog series will cover geo-dispersed object storage multisite asynchronous replication.

![i2](https://ceph.io/en/news/blog/2025/rgw-multisite-replication_part1/images/image1.png)

Introduction to Ceph Object Storage Multisite Replication ¶
Before getting our hands wet with the deployment details, let's begin with a quick overview of what Ceph Object Storage (RGW) provides: enterprise grade, highly mature object geo-replication capabilities. The RGW multisite replication feature facilitates asynchronous object replication across single or multi-zone deployments. Ceph Object Storage operates efficiently over WAN connections using asynchronous replication with eventual consistency.

Ceph Object Storage Multisite Replication provides many benefits for businesses that must store and manage large amounts of data across multiple locations. Here are some of the key benefits of using Ceph Object Storage Multisite Replication:

## Improved Data Availability, Multi-Region ¶

Ceph Object Storage clusters can be geographically dispersed, which improves data availability and reduces the risk of data loss due to hardware failure, natural disasters or other events. There are no network latency requirements as we are doing eventually consistent async replication.

## Active/Active Replication ¶

Replication is Active/Active for data (object) access. Multiple end users can simultaneously read/write from/to their closest RGW (S3) endpoint location. In other words, the replication is bidirectional. This enables users to access data more quickly and reduce downtime.

Notably only the designated master zone in the zone group accepts etadata updates. For example, when creating Users and Buckets, all metadata modifications on non-master zones will be forwarded to the configured master. if the master fails, a manual master zone failover must be triggered.

## Increased Scalability ¶

With multisite replication, businesses can quickly scale their storage infrastructure by adding new sites or clusters. This allows businesses to store and manage large amounts of data without worrying about running out of storage capacity or performance.

## Realm, Zonegroups and Zones ¶

A Ceph Object Storage multisite cluster consists of realms, zonegroups, and zones:

- A realm defines a global namespace across multiple Ceph storage clusters
- Zonegroups can have one or more zones
- Next, we have zones. These are the lowest level of the Ceph multisite configuration, and they’re represented by one or more object gateways within a single Ceph cluster.

As you can see in the following diagram, Ceph Object Storage multisite replication happens at the zone level. We have a single realm called and two zonegroups. The realm global object namespace ensures unique object IDs across zonegroups and zones.

Each bucket is owned by the zone group where it was created, and its object data will only be replicated to other zones in that zonegroup. Any request for data in that bucket sent to other zonegroups will be redirected to the zonegroup where the bucket resides.

![i2](https://ceph.io/en/news/blog/2025/rgw-multisite-replication_part1/images/image2.png)

Within a Ceph Object Storage cluster you can have one or more realms. Each realm is an independent global object namespace, meaning each realm will have its own sets of users, buckets, and objects. For example, you can't have two buckets with the same name within a single realm. In Ceph Object Storage, there is also the concept of tenants to isolate S3 namespaces, but that discussion is out of our scope here. You can find more information on **[this page](https://www.ibm.com/docs/en/storage-ceph/7?topic=management-multi-tenant-namespace)**

The following diagram shows an example where we have two different Realms, thus two independent namespaces. Each realm has its zonegroup and replication zones.

![i3](https://ceph.io/en/news/blog/2025/rgw-multisite-replication_part1/images/image3.png)

Each zone represents a Ceph cluster, and you can have one or more zones in a zonegroup. Multisite replication, when configured, will happen between zones. In this series of blogs, we will configure only two zones in a zone group, but you can configure a larger number of replicated zones in a single zonegroup.

## Ceph Multisite Replication Policy ¶

With the latest 6.1 release, Ceph Object Storage introduces “Multisite Sync Policy” that provides granular bucket-level replication, provides the user with greater flexibility and reduced costs, unlocking and an array of valuable replication features:

Users can enable or disable sync per individual bucket, enabling precise control over replication workflows.

Full-zone replication while opting out to replicate specific buckets

Replicating a single source bucket with multi-destination buckets

Implementing symmetrical and directional data flow configurations per bucket

The following diagram shows an example of the sync policy feature in action.

![i4](https://ceph.io/en/news/blog/2025/rgw-multisite-replication_part1/images/image4.png)

## Ceph Multisite Configuration ¶

Architecture overview ¶
As part of the Quincy release, a new Ceph Manager module called rgw was added to the ceph orchestrator cephadm. The rgw manager module makes the configuration of multisite replication straightforward. This section will show you how to configure Ceph Object Storage multisite replication between two zones (each zone is an independent Ceph Cluster) through the CLI using the new rgw manager module.

NOTE: In Reef and later releases, multisite configuration can also be performed using the Ceph UI/Dashboard. We don’t use the UI in this guide, but if you are interested, you can find more information here.

In our setup, we are going to configure our multisite replication with the following logical layout: we have a realm called multisite, and this realm contains a single zonegroup called multizg. Inside the zonegroup, we have two zones, named zone1 and zone2. Each zone represents a Ceph cluster in a geographically distributed datacenter. The following diagram is a logical representation of our multisite configuration.
