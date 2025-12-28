# **[OpenZFS Documentation](https://openzfs.github.io/openzfs-docs/)

Welcome to the OpenZFS Documentation. This resource provides documentation for users and developers working with (or contributing to) the OpenZFS project. New users or system administrators should refer to the documentation for their favorite platform to get started.

Getting Started

Project and Community

Developer Resources

How to get started with OpenZFS on your favorite platform

About the project and how to contribute

Technical documentation discussing the OpenZFS implementation

## Checksums and Their Use in ZFS

End-to-end checksums are a key feature of ZFS and an important differentiator for ZFS over other RAID implementations and filesystems. Advantages of end-to-end checksums include:

detects data corruption upon reading from media

blocks that are detected as corrupt are automatically repaired if possible, by using the RAID protection in suitably configured pools, or redundant copies (see the zfs copies property)

periodic scrubs can check data to detect and repair latent media degradation (bit rot) and corruption from other sources

checksums on ZFS replication streams, zfs send and zfs receive, ensure the data received is not corrupted by intervening storage or transport mechanisms
