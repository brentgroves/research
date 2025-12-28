# **[](https://tbhaxor.com/exploiting-linux-capabilities-part-1/)

lxd unshare: write failed /proc/self/uid_map: Operation not permitted

The error "lxd unshare: write failed /proc/self/uid_map: Operation not permitted" indicates a problem with user ID mapping within a user namespace, specifically when LXD attempts to create or manage a container with unprivileged user IDs.
This error typically arises because:
Nested User Namespaces:
You might be attempting to run LXD or create a container within an environment that is already operating within a user namespace (e.g., another container, a rootless environment). This nesting can restrict the ability to further modify uid_map.
Insufficient Capabilities:
The process attempting the unshare operation lacks the necessary capabilities to write to /proc/self/uid_map. Specifically, the CAP_SETUID and CAP_SETGID capabilities are required for managing user ID mappings within a user namespace.
UID/GID Range Limitations:
In rootless environments or specific container setups, there might be limitations on the range of user IDs and group IDs that can be mapped within a user namespace. Attempting to map UIDs/GIDs outside this allowed range will result in this error.
To resolve this issue, consider the following:
Ensure Proper Capabilities:
If running within a containerized environment, ensure the container has the necessary capabilities, particularly CAP_SETUID and CAP_SETGID, or that the security context allows for unprivileged user ID mapping.
Avoid Nested User Namespaces:
If possible, avoid running LXD or creating containers within an already existing user namespace, or ensure the outer namespace is configured to allow for nested unprivileged operations.
Verify UID/GID Range:
Check the configured UID/GID ranges for your rootless or containerized environment and ensure the IDs being mapped by LXD fall within these allowed ranges.

Exploiting Linux Capabilities – Part 1
Get the practical knowledge on how to abuse cap_setuid and cap_setgid capabilities in Linux to get the root user shell
