
The newuidmap command in Linux is a utility used to establish the UID (User ID) mapping for a user namespace. This mapping defines how UIDs within a user namespace correspond to UIDs on the host system. It is a crucial component for enabling unprivileged containerization and other forms of user namespace isolation.

Key aspects of newuidmap:

## Purpose

It sets the /proc/[pid]/uid_map file for a specified process ID (pid), which governs the UID mapping within that process's user namespace.

## Arguments

- pid: The process ID of the process whose user namespace's UID mapping is to be configured. Alternatively, fd:N can be used, where N is a file descriptor to the /proc/[pid] directory.
- uid loweruid count: One or more sets of three integers:
  - uid: The starting UID within the user namespace.
  - loweruid: The corresponding starting UID on the host system (outside the user namespace).
  - count: The length of the UID ranges to be mapped.

## Permissions and /etc/subuid

- newuidmap verifies that the caller owns the target process.
- Crucially, it checks if the UIDs being mapped from the host system (loweruid to loweruid + count) are permitted to the calling user according to the /etc/subuid file. This file lists the subordinate UID ranges that a user is allowed to utilize for user namespace mappings.
Single Use:
newuidmap can only be used once for a given process's user namespace.
Importance in Containerization:
newuidmap (along with newgidmap for GIDs) is fundamental for rootless containers, allowing users to run containers without requiring root privileges on the host system by mapping container UIDs to subordinate UIDs allocated to the user.

In Linux, subuid refers to subordinate user IDs, which are ranges of user IDs that a specific user is authorized to use within user namespaces. These subordinate UIDs are defined in the /etc/subuid file.
Purpose:
The primary purpose of subuid and the related subgid (subordinate group IDs) is to enable unprivileged users to create and manage isolated environments, such as containers (e.g., with Podman or LXD), without requiring root privileges on the host system.
How it Works:
/etc/subuid File: This file contains entries, typically one per line, specifying a username and a range of subordinate UIDs allocated to that user. Each entry has three colon-delimited fields:
Login Name or UID: The user to whom the subordinate UIDs are assigned.
Numerical Subordinate User ID: The starting UID of the allocated range.
Numerical Subordinate User ID Count: The number of UIDs in the allocated range.
Example:
Code

`myuser:100000:65536`

This example grants myuser access to a range of 65,536 UIDs starting from 100,000.
User Namespaces: When a user creates a user namespace (e.g., for a container), they can map these subordinate UIDs to UIDs within the namespace. For instance, UID 0 inside the container might map to UID 100,000 on the host system, and subsequent UIDs within the container would map sequentially to the allocated range.
