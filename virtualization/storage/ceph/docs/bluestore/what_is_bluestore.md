# **[](https://docs.redhat.com/en/documentation/red_hat_ceph_storage/3/html/administration_guide/osd-bluestore)**

Chapter 9. BlueStore
BlueStore is a new back-end object store for the OSD daemons. The original object store, FileStore, requires a file system on top of raw block devices. Objects are then written to the file system. BlueStore does not require an initial file system, because BlueStore puts objects directly on the block device.

Important
BlueStore provides a high-performance backend for OSD daemons in a production environment. By default, BlueStore is configured to be self-tuning. If you determine that your environment performs better with BlueStore tuned manually, please contact Red Hat support and share the details of your configuration to help us improve the auto-tuning capability. Red Hat looks forward to your feedback and appreciates your recommendations.

Direct management of storage devices
BlueStore consumes raw block devices or partitions. This avoids any intervening layers of abstraction, such as local file systems like XFS, that might limit performance or add complexity.
Metadata management with RocksDB
BlueStore uses the RocksDB’ key-value database to manage internal metadata, such as the mapping from object names to block locations on a disk.
Full data and metadata checksumming
By default all data and metadata written to BlueStore is protected by one or more checksums. No data or metadata are read from disk or returned to the user without verification.
Efficient copy-on-write
The Ceph Block Device and Ceph File System snapshots rely on a copy-on-write clone mechanism that is implemented efficiently in BlueStore. This results in efficient I/O both for regular snapshots and for erasure coded pools which rely on cloning to implement efficient two-phase commits.
No large double-writes
BlueStore first writes any new data to unallocated space on a block device, and then commits a RocksDB transaction that updates the object metadata to reference the new region of the disk. Only when the write operation is below a configurable size threshold, it falls back to a write-ahead journaling scheme, similar to what how FileStore operates.
Multi-device support
BlueStore can use multiple block devices for storing different data, for example: Hard Disk Drive (HDD) for the data, Solid-state Drive (SSD) for metadata, Non-volatile Memory (NVM) or Non-volatile random-access memory (NVRAM) or persistent memory for the RocksDB write-ahead log (WAL). See Section 9.2, “BlueStore Devices” for details.
