# **[MinIO Erasure Code Overview](https://docs.min.io/enterprise/aistor-object-store/operations/core-concepts/erasure-coding/)**

MinIO AIStor Documentation
MinIO AIStor is a high-performance S3-compatible object store licensed under the MinIO Commercial License.
This site documents the installation, administration, and operations of AIStor Server deployments running the latest stable release.

Erasure Coding
AIStor Server implements Erasure Coding as a core component in providing data redundancy and availability.

The diagrams and content in this section present a simplified view of erasure coding operations and are not intended to represent the complexities of the AIStor Server’s full erasure coding implementation.

AIStor groups drives in each server pool into one or more Erasure Sets of the same size.

![i1](https://docs.min.io/enterprise/aistor-object-store/operations/core-concepts/images/erasure-coding-erasure-set.svg)

The above example deployment consists of 4 nodes with 4 drives each. AIStor initializes with a single erasure set consisting of all 16 drives across all four nodes.

AIStor determines the optimal number and size of erasure sets when initializing a server pool. You cannot modify these settings after this initial setup.

For each write operation, AIStor partitions the object into data and parity shards.

Data shards contain a portion of a given object. Parity shards contain a mathematical representation of the object used for rebuilding Data shards.

Use mc admin object info to output a summary of a specific object’s shards (also called “parts”) on disk.
