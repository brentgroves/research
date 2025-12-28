# **[rbd mirroring](https://docs.ceph.com/en/reef/rbd/rbd-mirroring/)**

## AI Overview

Block storage (RBD) mirroring is the asynchronous replication of Ceph block device images between two or more Ceph clusters to provide a disaster recovery solution. It ensures point-in-time consistency of block device changes and can be configured for one-way (active-passive) or two-way (active-active) replication using either journal-based or snapshot-based methods. The process involves the rbd-mirror daemon pulling changes from a remote primary image and writing them to a local, non-primary image to maintain replicated copies.

## How it Works

1. Asynchronous Replication: Mirroring is a non-blocking process, meaning the primary cluster is not held up waiting for the replication to complete.
2. Image States: Images can be in a primary state (active for writes) or a non-primary state (a read-only replica).
3. Mirroring Modes:
**Journal-based:** Uses the journaling feature to record all writes, which are then replayed on the secondary cluster. This provides near real-time, crash-consistent replication but adds overhead and impacts performance.
**Snapshot-based:** Relies on periodic, crash-consistent mirror snapshots to identify data and metadata changes (deltas) between them. This method is better for feature implementation and faster in some scenarios but requires a fully synchronized snapshot for failover.

## Replication Types

**One-way (Active-Passive):** Data is replicated from a primary cluster (site-A) to a secondary cluster (site-B), with the rbd-mirror daemon running only on the secondary site.
**Two-way (Active-Active):** Data is mirrored in both directions between two primary images on different clusters, with the rbd-mirror daemon running on both clusters.

## Configuration Steps

1. Enable Mirroring on Pools: Use rbd mirror pool enable with the pool name and desired mode (pool for all journaled images, or image for individual images).
2. Configure Peers: Set up the connection between the peer Ceph clusters, often through a peers configuration within the pool settings.
3. Manage Mirroring: Use commands like rbd mirror pool info to check status and rbd mirror image status to inspect individual image replication.

## Benefits

**Disaster Recovery:** Provides data protection and minimizes downtime and data loss during a primary site failure.
**Reduced RTO/RPO:** Improves the Recovery Time Objective (RTO) and Recovery Point Objective (RPO) by ensuring data is available at a secondary location.

Requirements

- Two or more healthy Ceph clusters.
- A high-bandwidth, reliable network connection between the sites.
- Proper pool and image configurations on both clusters.
