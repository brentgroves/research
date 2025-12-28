# AI Overview

Windows does not use mandatory file locks in the traditional sense; instead, it relies on mechanisms like sharing modes (which are a form of mandatory access control on network shares) and byte-range locks (enforced by NTFS) to prevent concurrent writes to files. A more accurate term for when a file is unavailable to other users is a "lock" applied by a process or a user. You can lock a file for editing, identify which process is locking a file using utilities like Microsoft's PowerToys File Locksmith, or use encryption to restrict access to specific accounts.

Understanding Windows File Locks
Byte-Range Locks:
.
When an application uses standard file I/O (read/write) APIs, Windows enforces byte-range locks on the NTFS file system. These are mandatory in that they are enforced by the file system and prevent other clients from writing to locked sections of the file, though they are not mandatory in the sense of a system-wide, unbypassable policy.

Sharing Mode:
.
For network file shares (SMB), Windows implements a "sharing mode" that is a form of mandatory access control. This mode determines what concurrent access (read/write) is allowed for clients accessing the file over the network.

Advisory Locking:
.
Applications that use file mapping APIs or some other locking mechanisms implement advisory locks, where processes must cooperate and check the lock status before accessing the file.
