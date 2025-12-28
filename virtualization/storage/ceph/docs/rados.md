# **[What is RADOS](https://www.clyso.com/us/what-is-rados/)**

## next pdf section is 3.1

RADOS, which stands for Reliable Autonomic Distributed Object Storage, is the core storage layer that underpins Ceph’s ability to provide object, block, and file storage services. It is a robust and highly reliable storage solution that offers a low-level data object storage service, ensuring data durability, scalability, and consistency.

Key Features of RADOS

1. Reliable and Highly Available
RADOS is designed to provide reliable storage services by managing data replication and erasure coding. These mechanisms ensure data durability and high availability, even in the face of hardware failures. This reliability is a cornerstone of Ceph’s architecture, ensuring that data remains accessible and intact.
2. Scalability
One of RADOS’s standout features is its scalability. It can grow with your storage needs, whether on day one or day one thousand. This scalability is achieved through the addition of more nodes, allowing the system to expand seamlessly without downtime or performance degradation.
3. Data Management
RADOS simplifies data management by handling all aspects of data replication, erasure coding, data placement, rebalancing, and repair. This autonomic management reduces the administrative burden and ensures optimal data distribution and recovery processes.
Simplifying Higher Layers
4. Strong Consistency
RADOS prioritizes strong consistency, adhering to the CP (Consistency and Partition tolerance) principles of the CAP theorem. This means that all clients see the same view of data, even right after an update or delete operation, ensuring data correctness and reliability.

RADOS’s robust data management capabilities simplify the design and implementation of higher layers, such as Ceph’s file, block, and object storage services. By providing a reliable and consistent storage foundation, RADOS allows these higher-level services to focus on their specific functionalities without worrying about the underlying data management complexities.

## Use Cases

1. Object Storage
RADOS underpins Ceph’s object storage system, enabling scalable and reliable storage for large amounts of unstructured data. This is ideal for cloud storage solutions, backup systems, and data archives.
2. Block Storage
RADOS supports Ceph’s block storage (RBD), providing high-performance storage for virtual machines, databases, and other applications that require block-level access.
3. File Storage
RADOS powers Ceph’s file storage (CephFS), offering a scalable and POSIX-compliant file system suitable for large-scale file storage needs in enterprise environments.

Block storage is a way to store data in fixed-size blocks, each with a unique identifier, allowing for efficient data management and retrieval. To use block storage, you typically need to create a block storage volume, format it with a file system, mount it to a server, and then you can store and retrieve data through its mount point.

|                 | Object storage                                                                       | Block storage                                                                     | File storage                                                      |
|-----------------|--------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|-------------------------------------------------------------------|
| Type of storage | Objects stored in scalable buckets                                                   | Fixed-size blocks in a rigid arrangement                                          | Files organized hierarchically in folders and directories         |
| Volume of data  | Supports high data volumes                                                           | Supports high data volume                                                         | Better for lower volumes of data                                  |
| Data management | Custom metadata provides easy searchability                                          | More limited search and analytics capabilities                                    | Hierarchical structure works well for simpler, smaller datasets   |
| Cost            | Pay-as-you-go pricing, more cost-effective                                           | More costly, storage purchased as fixed blocks of storage                         | More costly, requires purchasing new storage devices to scale out |
| Performance     | Slower performance, longer processing times                                          | Super low latency and high performance                                            | Performance impacted by higher data volume                        |
| Scalability     | Highly scalable                                                                      | Limited scalability                                                               | Limited scalability                                               |
| Ideal for       | Big data storage, static unstructured data, analytics, rich media files, and backups | Transactional, structured data, storage for databases, disks for VMs, and caching | Shared file storage, unstructured data                            |

| Feature      | File Storage                                                      | Block Storage                                                 |
|--------------|-------------------------------------------------------------------|---------------------------------------------------------------|
| Organization | Hierarchical file and folder structure.                           | Data broken into fixed-size blocks with unique identifiers.   |
| Access       | Through file path and name.                                       | Directly to blocks via unique identifiers.                    |
| Performance  | Good for everyday applications; can slow down with large volumes. | High performance and low latency for transactional workloads. |
| Scalability  | Scalable but limited by hierarchical structure.                   | Highly scalable by adding storage volumes.                    |
| Metadata     | Includes file details and path.                                   | Minimal metadata, mainly block identifiers.                   |
| Cost         | Generally more cost-effective.                                    | Can be more expensive for high-performance deployments.       |
| Use Cases    | File sharing, collaboration, structured data.                     | Databases, VMs, high-performance computing.                   |
