# **[](https://docs.ceph.com/en/latest/rados/configuration/storage-devices/#bluestore)**

BlueStore
BlueStore is a special-purpose storage back end designed specifically for managing data on disk for Ceph OSD workloads. BlueStore’s design is based on a decade of experience of supporting and managing Filestore OSDs.

Key BlueStore features include:

Direct management of storage devices. BlueStore consumes raw block devices or partitions. This avoids intervening layers of abstraction (such as local file systems like XFS) that can limit performance or add complexity.

Metadata management with RocksDB. RocksDB’s key/value database is embedded in order to manage internal metadata, including the mapping of object names to block locations on disk.

Full data and metadata checksumming. By default, all data and metadata written to BlueStore is protected by one or more checksums. No data or metadata is read from disk or returned to the user without being verified.

Inline compression. Data can be optionally compressed before being written to disk.

Multi-device metadata tiering. BlueStore allows its internal journal (write-ahead log) to be written to a separate, high-speed device (like an SSD, NVMe, or NVDIMM) for increased performance. If a significant amount of faster storage is available, internal metadata can be stored on the faster device.

Efficient copy-on-write. RBD and CephFS snapshots rely on a copy-on-write clone mechanism that is implemented efficiently in BlueStore. This results in efficient I/O both for regular snapshots and for erasure-coded pools (which rely on cloning to implement efficient two-phase commits).

For more information, see BlueStore Configuration Reference and BlueStore Migration.
