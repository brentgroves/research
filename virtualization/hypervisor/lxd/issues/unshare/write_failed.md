<https://tbhaxor.com/exploiting-linux-capabilities-part-1/>
<https://blog.quarkslab.com/digging-into-linux-namespaces-part-2.html>

```bash
lxc console v1 --type vga
unshare: write failed /proc/self/uid_map: Operation not permitted
echo "==> Disabling Apparmor unprivileged userns mediation"
echo 0 > /proc/sys/kernel/apparmor_restrict_unprivileged_userns

echo "==> Disabling Apparmor unprivileged unconfined mediation"
echo 0 > /proc/sys/kernel/apparmor_restrict_unprivileged_unconfined
```

Process isolation is a key component for containers. One of the key underlying mechanisms are namespaces. In this second (and last) part of the series we examine the USER, MNT, UTS, IPC and CGROUP namespaces, and finally we combine everything to build a fully isolated environment for a process.

In the previous episode, we introduced what are namespaces, and why they are so useful nowadays. Then we looked at the PID and NET namespaces. Let's explore the rest of the namespaces now, before we leverage them to build a fully isolated process.

## USER namespace

All processes in the Linux world have their owner. There are privileged and unprivileged processes depending on their effective user ID (UID) attribute. Depending on this UID processes have different privileges over the OS. The user namespace is a kernel feature allowing per-process virtualization of this attribute. In the Linux documentation, a user namespace is defined in the following manner:

User namespaces isolate security-related identifiers and attributes, in particular, user IDs and group IDs, the root directory, keys, and capabilities. A process’s user and group IDs can be different inside and outside a user namespace. In particular, a process can have a normal unprivileged user ID outside a user namespace while at the same time having a user ID of 0 inside the namespace.

<https://blog.quarkslab.com/digging-into-linux-namespaces-part-2.html>

The "lxd write fail uid_map" error in LXD (or Incus, its successor) usually indicates an issue with user namespace ID mapping, specifically when trying to write to the /proc/self/uid_map file. This file is used to map user IDs inside a container to user IDs on the host system, and the error suggests that LXD is unable to create or modify these mappings, according to the Linux Containers Forum. This can prevent containers from starting or functioning correctly, particularly when dealing with nested containers or when the host system's ID mapping configuration is insufficient.
