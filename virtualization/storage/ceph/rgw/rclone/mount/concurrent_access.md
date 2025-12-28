# AI Overview

## **[](https://forum.rclone.org/t/multiple-users-writing-the-same-files-on-the-same-storage/47290/4)**

Rclone mount allows multiple concurrent file accesses, particularly for read operations. When multiple clients or processes concurrently read from the same file on an rclone mount, rclone can handle this by opening multiple streams or "readers" to the file on the remote, allowing each client to read from its desired offset.
However, a key distinction exists between concurrent reads and concurrent writes or modifications:
**Concurrent Reads:** Rclone handles multiple concurrent read requests to a single file efficiently, as demonstrated by its ability to open multiple readers for different offsets within the same file.
**Concurrent Writes/Modifications:** Rclone does not inherently provide distributed locking or sophisticated conflict resolution mechanisms for concurrent writes to the same file from multiple sources. If multiple users or processes attempt to modify the same file simultaneously through an rclone mount, conflicts can arise. Rclone typically handles writes by waiting for a small duration after a file is closed before uploading the modified version to the remote. This means that the "last write wins" in many scenarios, and changes from other concurrent writes might be overwritten.

Considerations for concurrent access:
**File Locks:** Rclone itself does not implement distributed file locking. If application-level locking is required for concurrent writes, it must be handled by the applications accessing the mount or by an external system.
Conflict Resolution: For scenarios involving multiple users modifying the same files, consider using version control systems or collaborative editing tools that manage conflicts at a higher level, rather than relying solely on rclone for this.
**--vfs-cache-mode writes:** This option can be used to cache writes locally before uploading, which can improve performance and mitigate some issues with concurrent access by reducing direct remote interactions during active writing. However, it does not resolve fundamental conflict resolution for simultaneous modifications.
**--vfs-write-back:** This flag controls how quickly modified files are uploaded to the remote after being closed, which can be relevant for scenarios where multiple modifications might occur in quick succession.
