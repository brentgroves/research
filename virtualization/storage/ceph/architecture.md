# **[Architecture](https://docs.ceph.com/en/reef/architecture/)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../a_status/detailed_status.md)**\
**[Back to Main](../../../../../README.md)**

## reference

**[theguyswhomadeit](https://www.youtube.com/watch?v=SDQsIcpJpaU)**

Ceph uniquely delivers object, block, and file storage in one unified system. Ceph is highly reliable, easy to manage, and free. The power of Ceph can transform your company’s IT infrastructure and your ability to manage vast amounts of data. Ceph delivers extraordinary scalability–thousands of clients accessing petabytes to exabytes of data. A Ceph Node leverages commodity hardware and intelligent daemons, and a Ceph Storage Cluster accommodates large numbers of nodes, which communicate with each other to replicate and redistribute data dynamically.

![a](https://docs.ceph.com/en/reef/_images/stack.png)

## The Ceph Storage Cluster

Ceph provides an infinitely scalable **[Ceph Storage Cluster](https://docs.ceph.com/en/reef/glossary/#term-Ceph-Storage-Cluster)** based upon RADOS, a reliable, distributed storage service that uses the intelligence in each of its nodes to secure the data it stores and to provide that data to clients. See Sage Weil’s **[“The RADOS Object Store”](https://ceph.io/en/news/blog/2009/the-rados-distributed-object-store/)** blog post for a brief explanation of RADOS and see **[RADOS - A Scalable, Reliable Storage Service for Petabyte-scale Storage Clusters](https://ceph.io/assets/pdfs/weil-rados-pdsw07.pdf)** for an exhaustive explanation of **[RADOS](https://docs.ceph.com/en/reef/glossary/#term-RADOS)**.

A Ceph Storage Cluster consists of multiple types of daemons:

- **[Ceph Monitor](https://docs.ceph.com/en/reef/glossary/#term-Ceph-Monitor)**
- **[Ceph Ceph Object Storage Daemon, OSD Daemon](https://docs.ceph.com/en/reef/glossary/#term-Ceph-OSD-Daemon)**
- **[Ceph Manager](https://docs.ceph.com/en/reef/glossary/#term-Ceph-Manager)**
- **[Ceph Metadata Server](https://docs.ceph.com/en/reef/glossary/#term-Ceph-Metadata-Server)**

Ceph Monitors maintain the master copy of the cluster map, which they provide to Ceph clients. The existence of multiple monitors in the Ceph cluster ensures availability if one of the monitor daemons or its host fails.

A Ceph OSD Daemon checks its own state and the state of other OSDs and reports back to monitors.

A Ceph Manager serves as an endpoint for monitoring, orchestration, and plug-in modules.

A Ceph Metadata Server (MDS) manages file metadata when CephFS is used to provide file services.

Storage cluster clients and Ceph OSD Daemons use the CRUSH algorithm to compute information about the location of data. Use of the CRUSH algoritm means that clients and OSDs are not bottlenecked by a central lookup table. Ceph’s high-level features include a native interface to the Ceph Storage Cluster via librados, and a number of service interfaces built on top of librados.

## Storing Data

The Ceph Storage Cluster receives data from Ceph Clients--whether it comes through a Ceph Block Device, Ceph Object Storage, the Ceph File System, or a custom implementation that you create by using librados. The data received by the Ceph Storage Cluster is stored as RADOS objects. Each object is stored on an Object Storage Device (this is also called an “OSD”). Ceph OSDs control read, write, and replication operations on storage drives. The default BlueStore back end stores objects in a monolithic, database-like fashion.

![osd](https://docs.ceph.com/en/reef/_images/ditaa-e01d23327b5f34ba68b18dbe5923c7617eeab3a2.png)

Ceph OSD Daemons store data as objects in a flat namespace. This means that objects are not stored in a hierarchy of directories. An object has an identifier, binary data, and metadata consisting of name/value pairs. Ceph Clients determine the semantics of the object data. For example, CephFS uses metadata to store file attributes such as the file owner, the created date, and the last modified date.

![o](https://docs.ceph.com/en/reef/_images/ditaa-b363b88681891164d307a947109a7d196e259dc8.png)

An object ID is unique across the entire cluster, not just the local filesystem.

## Scalability and High Availability

In traditional architectures, clients talk to a centralized component. This centralized component might be a gateway, a broker, an API, or a facade. A centralized component of this kind acts as a single point of entry to a complex subsystem. Architectures that rely upon such a centralized component have a single point of failure and incur limits to performance and scalability. If the centralized component goes down, the whole system becomes unavailable.

Facade is usually a simplified layer hiding complexities of the system. So an Aggregator API Or an Orchestrating API qualifies as API Facade.

Ceph eliminates this centralized component. This enables clients to interact with Ceph OSDs directly. Ceph OSDs create object replicas on other Ceph Nodes to ensure data safety and high availability. Ceph also uses a cluster of monitors to ensure high availability. To eliminate centralization, Ceph uses an algorithm called CRUSH.

## CRUSH Introduction

Ceph Clients and Ceph OSD Daemons both use the CRUSH algorithm to compute information about object location instead of relying upon a central lookup table. CRUSH provides a better data management mechanism than do older approaches, and CRUSH enables massive scale by distributing the work to all the OSD daemons in the cluster and all the clients that communicate with them. CRUSH uses intelligent data replication to ensure resiliency, which is better suited to hyper-scale storage. The following sections provide additional details on how CRUSH works. For an in-depth, academic discussion of CRUSH, see **[CRUSH - Controlled, Scalable, Decentralized Placement of Replicated Data](https://ceph.io/assets/pdfs/weil-crush-sc06.pdf)**.

## Cluster Map

In order for a Ceph cluster to function properly, Ceph Clients and Ceph OSDs must have current information about the cluster’s topology. Current information is stored in the “Cluster Map”, which is in fact a collection of five maps. The five maps that constitute the cluster map are:

1. The Monitor Map: Contains the cluster fsid, the position, the name, the address, and the TCP port of each monitor. The monitor map specifies the current epoch, the time of the monitor map’s creation, and the time of the monitor map’s last modification. To view a monitor map, run ceph mon dump.

2. The OSD Map: Contains the cluster fsid, the time of the OSD map’s creation, the time of the OSD map’s last modification, a list of pools, a list of replica sizes, a list of PG numbers, and a list of OSDs and their statuses (for example, up, in). To view an OSD map, run ceph osd dump.

3. The PG Map: Contains the PG version, its time stamp, the last OSD map epoch, the full ratios, and the details of each placement group. This includes the PG ID, the Up Set, the Acting Set, the state of the PG (for example, active + clean), and data usage statistics for each pool.

4. The CRUSH Map: Contains a list of storage devices, the failure domain hierarchy (for example, device, host, rack, row, room), and rules for traversing the hierarchy when storing data. To view a CRUSH map, run ceph osd getcrushmap -o {filename} and then decompile it by running crushtool -d {comp-crushmap-filename} -o {decomp-crushmap-filename}. Use a text editor or cat to view the decompiled map.

5. The MDS Map: Contains the current MDS map epoch, when the map was created, and the last time it changed. It also contains the pool for storing metadata, a list of metadata servers, and which metadata servers are up and in. To view an MDS map, execute ceph fs dump.

Each map maintains a history of changes to its operating state. Ceph Monitors maintain a master copy of the cluster map. This master copy includes the cluster members, the state of the cluster, changes to the cluster, and information recording the overall health of the Ceph Storage Cluster.

## High Availability Monitors

A Ceph Client must contact a Ceph Monitor and obtain a current copy of the cluster map in order to read data from or to write data to the Ceph cluster.

It is possible for a Ceph cluster to function properly with only a single monitor, but a Ceph cluster that has only a single monitor has a single point of failure: if the monitor goes down, Ceph clients will be unable to read data from or write data to the cluster.

Ceph leverages a cluster of monitors in order to increase reliability and fault tolerance. When a cluster of monitors is used, however, one or more of the monitors in the cluster can fall behind due to latency or other faults. Ceph mitigates these negative effects by requiring multiple monitor instances to agree about the state of the cluster. To establish consensus among the monitors regarding the state of the cluster, Ceph uses the Paxos algorithm and a majority of monitors (for example, one in a cluster that contains only one monitor, two in a cluster that contains three monitors, three in a cluster that contains five monitors, four in a cluster that contains six monitors, and so on).

See the **[Monitor Config Reference](https://docs.ceph.com/en/reef/rados/configuration/mon-config-ref)** for more detail on configuring monitors.

## High Availability Authentication

The cephx authentication system is used by Ceph to authenticate users and daemons and to protect against man-in-the-middle attacks.

The cephx protocol does not address data encryption in transport (for example, SSL/TLS) or encryption at rest.

cephx uses shared secret keys for authentication. This means that both the client and the monitor cluster keep a copy of the client’s secret key.

The cephx protocol makes it possible for each party to prove to the other that it has a copy of the key without revealing it. This provides mutual authentication and allows the cluster to confirm (1) that the user has the secret key and (2) that the user can be confident that the cluster has a copy of the secret key.

As stated in **[Scalability and High Availability](https://docs.ceph.com/en/reef/architecture/#arch-scalability-and-high-availability)**, Ceph does not have any centralized interface between clients and the Ceph object store. By avoiding such a centralized interface, Ceph avoids the bottlenecks that attend such centralized interfaces. However, this means that clients must interact directly with OSDs. Direct interactions between Ceph clients and OSDs require authenticated connections. The cephx authentication system establishes and sustains these authenticated connections.

The cephx protocol operates in a manner similar to **[Kerberos](https://en.wikipedia.org/wiki/Kerberos_(protocol))**.

Kerberos (/ˈkɜːrbərɒs/) is a computer-network authentication protocol that works on the basis of tickets to allow nodes communicating over a non-secure network to prove their identity to one another in a secure manner. Its designers aimed it primarily at a client–server model, and it provides mutual authentication—both the user and the server verify each other's identity. Kerberos protocol messages are protected against eavesdropping and replay attacks.

A user invokes a Ceph client to contact a monitor. Unlike Kerberos, each monitor can authenticate users and distribute keys, which means that there is no single point of failure and no bottleneck when using cephx. The monitor returns an authentication data structure that is similar to a Kerberos ticket. This authentication data structure contains a session key for use in obtaining Ceph services. The session key is itself encrypted with the user’s permanent secret key, which means that only the user can request services from the Ceph Monitors. The client then uses the session key to request services from the monitors, and the monitors provide the client with a ticket that authenticates the client against the OSDs that actually handle data. Ceph Monitors and OSDs share a secret, which means that the clients can use the ticket provided by the monitors to authenticate against any OSD or metadata server in the cluster.

Like Kerberos tickets, cephx tickets expire. An attacker cannot use an expired ticket or session key that has been obtained surreptitiously. This form of authentication prevents attackers who have access to the communications medium from creating bogus messages under another user’s identity and prevents attackers from altering another user’s legitimate messages, as long as the user’s secret key is not divulged before it expires.

An administrator must set up users before using cephx. In the following diagram, the client.admin user invokes ceph auth get-or-create-key from the command line to generate a username and secret key. Ceph’s auth subsystem generates the username and key, stores a copy on the monitor(s), and transmits the user’s secret back to the client.admin user. This means that the client and the monitor share a secret key.

The client.admin user must provide the user ID and secret key to the user in a secure manner.

![cf](https://docs.ceph.com/en/reef/_images/ditaa-98e822f6a4f486de7dc55635f9fb80d356ad931f.png)

Here is how a client authenticates with a monitor. The client passes the user name to the monitor. The monitor generates a session key that is encrypted with the secret key associated with the username. The monitor transmits the encrypted ticket to the client. The client uses the shared secret key to decrypt the payload. The session key identifies the user, and this act of identification will last for the duration of the session. The client requests a ticket for the user, and the ticket is signed with the session key. The monitor generates a ticket and uses the user’s secret key to encrypt it. The encrypted ticket is transmitted to the client. The client decrypts the ticket and uses it to sign requests to OSDs and to metadata servers in the cluster.

![f2](https://docs.ceph.com/en/reef/_images/ditaa-22b3096a0b880cfcdc7995b8d870653c71bd5244.png)

The cephx protocol authenticates ongoing communications between the clients and Ceph daemons. After initial authentication, each message sent between a client and a daemon is signed using a ticket that can be verified by monitors, OSDs, and metadata daemons. This ticket is verified by using the secret shared between the client and the daemon.

![f3](https://docs.ceph.com/en/reef/_images/ditaa-3a51d20eaaf90e1071e7dc84ea1fd784896d4b99.png)

In the context of Ceph, "MDS" refers to the Metadata Server daemon (ceph-mds) that manages the file system namespace and coordinates access to the shared Object Storage Daemon (OSD) cluster within the Ceph distributed file system (CephFS).

This authentication protects only the connections between Ceph clients and Ceph daemons. The authentication is not extended beyond the Ceph client. If a user accesses the Ceph client from a remote host, cephx authentication will not be applied to the connection between the user’s host and the client host.

See **[Cephx Config Guide](https://docs.ceph.com/en/reef/rados/configuration/auth-config-ref)** for more on configuration details.

See **[User Management](https://docs.ceph.com/en/reef/rados/operations/user-management)** for more on user management.

See A **[Detailed Description of the Cephx Authentication Protocol](https://docs.ceph.com/en/reef/dev/cephx_protocol/#cephx-2012-peter)** for more on the distinction between authorization and authentication and for a step-by-step explanation of the setup of cephx tickets and session keys.

## Smart Daemons Enable Hyperscale

A feature of many storage clusters is a centralized interface that keeps track of the nodes that clients are permitted to access. Such centralized architectures provide services to clients by means of a double dispatch. At the petabyte-to-exabyte scale, such double dispatches are a significant bottleneck.

Ceph obviates this bottleneck: Ceph’s OSD Daemons AND Ceph clients are cluster-aware. Like Ceph clients, each Ceph OSD Daemon is aware of other Ceph OSD Daemons in the cluster. This enables Ceph OSD Daemons to interact directly with other Ceph OSD Daemons and to interact directly with Ceph Monitors. Being cluster-aware makes it possible for Ceph clients to interact directly with Ceph OSD Daemons.

Because Ceph clients, Ceph monitors, and Ceph OSD daemons interact with one another directly, Ceph OSD daemons can make use of the aggregate CPU and RAM resources of the nodes in the Ceph cluster. This means that a Ceph cluster can easily perform tasks that a cluster with a centralized interface would struggle to perform. The ability of Ceph nodes to make use of the computing power of the greater cluster provides several benefits:

1. OSDs Service Clients Directly: Network devices can support only a limited number of concurrent connections. Because Ceph clients contact Ceph OSD daemons directly without first connecting to a central interface, Ceph enjoys improved perfomance and increased system capacity relative to storage redundancy strategies that include a central interface. Ceph clients maintain sessions only when needed, and maintain those sessions with only particular Ceph OSD daemons, not with a centralized interface.
2. OSD Membership and Status: When Ceph OSD Daemons join a cluster, they report their status. At the lowest level, the Ceph OSD Daemon status is up or down: this reflects whether the Ceph OSD daemon is running and able to service Ceph Client requests. If a Ceph OSD Daemon is down and in the Ceph Storage Cluster, this status may indicate the failure of the Ceph OSD Daemon. If a Ceph OSD Daemon is not running because it has crashed, the Ceph OSD Daemon cannot notify the Ceph Monitor that it is down. The OSDs periodically send messages to the Ceph Monitor (in releases prior to Luminous, this was done by means of MPGStats, and beginning with the Luminous release, this has been done with MOSDBeacon). If the Ceph Monitors receive no such message after a configurable period of time, then they mark the OSD down. This mechanism is a failsafe, however. Normally, Ceph OSD Daemons determine if a neighboring OSD is down and report it to the Ceph Monitors. This contributes to making Ceph Monitors lightweight processes. See Monitoring OSDs and Heartbeats for additional details.
3. Data Scrubbing: To maintain data consistency, Ceph OSD Daemons scrub RADOS objects. Ceph OSD Daemons compare the metadata of their own local objects against the metadata of the replicas of those objects, which are stored on other OSDs. Scrubbing occurs on a per-Placement-Group basis, finds mismatches in object size and finds metadata mismatches, and is usually performed daily. Ceph OSD Daemons perform deeper scrubbing by comparing the data in objects, bit-for-bit, against their checksums. Deep scrubbing finds bad sectors on drives that are not detectable with light scrubs. See **[Data Scrubbing](https://docs.ceph.com/en/reef/rados/configuration/osd-config-ref#scrubbing)** for details on configuring scrubbing.

RADOS (Reliable Autonomic Distributed Object Store) is a foundational component of the Ceph distributed storage system, providing a scalable and reliable object storage service where data is stored as objects within pools, forming the basis for Ceph's various services.
4. Replication: Data replication involves collaboration between Ceph Clients and Ceph OSD Daemons. Ceph OSD Daemons use the CRUSH algorithm to determine the storage location of object replicas. Ceph clients use the CRUSH algorithm to determine the storage location of an object, then the object is mapped to a pool and to a placement group, and then the client consults the CRUSH map to identify the placement group’s primary OSD.

After identifying the target placement group, the client writes the object to the identified placement group’s primary OSD. The primary OSD then consults its own copy of the CRUSH map to identify secondary OSDS, replicates the object to the placement groups in those secondary OSDs, confirms that the object was stored successfully in the secondary OSDs, and reports to the client that the object was stored successfully. We call these replication operations subops.

![r](https://docs.ceph.com/en/reef/_images/ditaa-db39e087bb6fb671969d38bd44c9e71ff716334d.png)

By performing this data replication, Ceph OSD Daemons relieve Ceph clients and their network interfaces of the burden of replicating data.

## **[Dynamic Cluster Management](https://docs.ceph.com/en/reef/architecture/#dynamic-cluster-management)**
