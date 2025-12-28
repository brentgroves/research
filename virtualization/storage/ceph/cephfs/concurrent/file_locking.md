# How to ensure a write fails if a file was changed

AI Overview
While CephFS clients have strong cache coherency, ensuring a write fails if a file was changed by another source is not a standard, built-in feature. This functionality is typically achieved by implementing a locking or versioning strategy in your application layer. **CephFS's native behavior is to serialize writes, not to prevent them based on external changes.**

## Why CephFS doesn't do this automatically

CephFS, like most distributed file systems, is designed for high availability and concurrent access. When multiple clients have a file open, the Ceph Metadata Server (MDS) manages client "capabilities," which are permissions to cache or write to a file.

Because CephFS prioritizes consistency over strict file-level write failure, you must implement a "compare-and-set" or "optimistic locking" approach at the application level.

**Method 1:** Use extended attributes (xattrs) for optimistic locking
This method uses a file's extended attributes as a version number, ensuring a write only succeeds if the version number is unchanged.
Read the current version: Before writing, read the file's current version number, which you'll store in a custom xattr.

```bash
CURRENT_VERSION=$(getfattr -n user.version file.txt | grep "user.version=" | cut -d '=' -f 2)
```

**Start your work:** Perform modifications to a local copy or buffer.
Attempt a conditional write: When ready to save, attempt a write only if the version hasn't changed.

For file updates, you can use a script that combines a check and a write with setfattr. However, setfattr on a non-empty file will fail, so this approach is best for whole-file replacement.

For more complex operations, your application code needs to handle this logic:
**Get lock:** Acquire an exclusive lock on the file.
**Check version again:** Read the user.version xattr one more time. If it has changed, abort the write and handle the conflict.
**Write and update version:** If the version is the same, perform the write and increment the version number in the xattr before releasing the lock.
**Release lock:** Release the exclusive lock.

## Method 2: Use file locking and metadata checks

This method uses standard POSIX file locking (flock) to ensure an exclusive lock before writing, combined with a metadata check to see if the file was modified since it was read.
**Open and lock the file:** Open the file with a specific file descriptor and acquire an exclusive lock using flock(fd, LOCK_EX | LOCK_NB). Use the LOCK_NB (non-blocking) flag to have the call fail immediately if the lock is already held by another process.
**Check modification time:** After acquiring the lock, compare the file's modification timestamp (mtime) with the timestamp you recorded when you first read the file.
**Fail on a conflict:** If the mtime has changed, another process modified the file while you were waiting for the lock. In this case, release the lock and fail the write.
**Perform the write:** If the mtime matches, it's safe to write your changes.
Release the lock: Close the file to release the exclusive lock.

## Method 3: Use RADOS striping objects

For advanced or high-performance applications, you can operate directly on the underlying RADOS object storage.
When a CephFS file is written, it is striped across one or more RADOS objects.
You can directly use RADOS's native librados API, which provides more direct control over object operations.
This approach is complex but allows you to implement atomic transactions across objects or use omap (object maps) to build your own versioning or locking mechanism.

| Method                         | Use Case                                 | Pros                                        | Cons                                                                                       |
|--------------------------------|------------------------------------------|---------------------------------------------|--------------------------------------------------------------------------------------------|
| Optimistic Locking with xattrs | Whole-file updates with low contention.  | Simple and lightweight for the application. | Not a real-time check, requires application logic. setfattr won't work on non-empty files. |
| File Locking (flock) + mtime   | Shared access with synchronous writes.   | Uses standard POSIX semantics.              | Relies on application logic to handle re-checks and retries. flock is only advisory.       |
| Native librados API            | Advanced, high-performance applications. | Most robust, offers object-level control.   | Highly complex and bypasses the CephFS layer.                                              |
