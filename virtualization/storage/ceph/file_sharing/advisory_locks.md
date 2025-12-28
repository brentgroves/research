# advisory locking

Ceph does not directly implement "advisory" locking in the Unix sense, but uses exclusive locks for RBD images to coordinate access, especially for virtualization, and a complex MDS lock system for CephFS to manage client capabilities and metadata operations. While exclusive locks are cooperative, a process can be blockedlist to acquire a lock if a client crashes, forcing a new client to break the old lock and take over, as seen with crashed Proxmox nodes

RBD Exclusive Locks
Purpose: These locks prevent multiple clients from writing to the same RBD image simultaneously, ensuring data consistency for tasks like virtualization and snapshotting.
Mechanism: Clients acquire an exclusive lock, and if a client crashes, a new client can break the old lock and take control after the monitor blocklists the failed client.
Commands: Management is done through the rbd lock command-line tool.

## CephFS MDS Locking

Purpose:
CephFS uses locks to manage client access and ensure metadata consistency for the entire filesystem.
Capabilities:
Clients acquire "capabilities" (e.g., Fr for read, Fw for write) that are controlled by the MDS locker.
Lock States:
The MDS transitions through various states like LOCK_SYNC and LOCK_EXCL to coordinate read and write access, eventually leading to stable states like LOCK_MIX for shared read/write.

## Advisory Locking vs. Ceph's Approach

Advisory Locks:
.
In Unix systems, advisory locks are cooperative; the kernel tracks them, but applications must obey them to avoid issues like deadlocks.
Ceph's Cooperative Locking:
.
While Ceph's locking is cooperative, it includes enforcement mechanisms like the blocklisting process for failed clients, making it more robust than pure advisory locking.
