# Advisory Locking vs. Ceph's Approach

Byte-Range Locks:
.
When an application uses standard file I/O (read/write) APIs, Windows enforces byte-range locks on the NTFS file system. These are mandatory in that they are enforced by the file system and prevent other clients from writing to locked sections of the file, though they are not mandatory in the sense of a system-wide, unbypassable policy.

Advisory Locks:
.
In Unix systems, advisory locks are cooperative; the kernel tracks them, but applications must obey them to avoid issues like deadlocks.
Ceph's Cooperative Locking:
.
While Ceph's locking is cooperative, it includes enforcement mechanisms like the **[blocklisting process](https://docs.ceph.com/en/latest/cephfs/eviction/)** for failed clients, making it more robust than pure advisory locking.
