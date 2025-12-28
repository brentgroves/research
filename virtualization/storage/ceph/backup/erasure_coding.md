# **[Erasure Coding](https://docs.ceph.com/en/reef/rados/operations/erasure-code)**

## AI Overview

Erasure Coding Including Calculator | OpenMetal IaaS
In Ceph, erasure coding is a data durability method that splits data into smaller chunks (k) and creates additional parity chunks (m) to reconstruct data if some chunks are lost. Unlike data replication (storing multiple full copies of data), erasure coding offers greater storage efficiency by storing only the original data chunks and the parity chunks, using less space but requiring more CPU and RAM for encoding and decoding. This makes it ideal for large datasets or less frequently accessed data where storage efficiency is prioritized over fast read performance.
