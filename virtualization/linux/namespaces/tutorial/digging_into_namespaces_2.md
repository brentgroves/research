# **[](https://blog.quarkslab.com/digging-into-linux-namespaces-part-2.html)**

Process isolation is a key component for containers. One of the key underlying mechanisms are namespaces. In this second (and last) part of the series we examine the USER, MNT, UTS, IPC and CGROUP namespaces, and finally we combine everything to build a fully isolated environment for a process.

In the **[previous episode](https://blog.quarkslab.com/digging-into-linux-namespaces-part-1.html)**, we introduced what are namespaces, and why they are so useful nowadays. Then we looked at the PID and NET namespaces. Let's explore the rest of the namespaces now, before we leverage them to build a fully isolated process.

Starting with Linux 3.8 (and unlike the flags used for creating other types of namespaces), on some Linux distributions, no privilege is required to create a user namespace. Let’s try it out!

cryptonite@cryptonite:~ $uname -a
Linux qb 5.11.0-25-generic #27~20.04.1-Ubuntu SMP Tue Jul 13 17:41:23 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux

The uname command in Linux is a command-line utility used to display system information. It provides details about the operating system and the hardware platform on which the system is running.

```bash
# root user namespace

cryptonite@cryptonite:~ $id
uid=1000(cryptonite) gid=1000(cryptonite) groups=1000(cryptonite) ...
cryptonite@cryptonite:~ $unshare -U /bin/bash
nobody@cryptonite:~$ id
uid=65534(nobody) gid=65534(nogroup) groups=65534(nogroup)
```

In the new user namespace our process belongs to user nobody with effective UID=65334, which is not present in the system. Okay, but where does it come from and how does the OS resolve it when it comes to system wide operations (modifying files, interacting with programs)? According to the Linux documentation it’s predefined in a file:

If a user ID has no mapping inside the namespace, then system calls that return user IDs return the value defined in the file /proc/sys/kernel/overflowuid, which on a standard system defaults to the value 65534. Initially, a user namespace has no user ID mapping, so all user IDs inside the namespace map to this value.

To answer the second part of the question - there is dynamic user id mapping when a process needs to perform system-wide operations.

```bash
# inside the USER namespace we create a file
nobody@cryptonite:~$ touch hello
nobody@cryptonite:~ $ls -l hello
-rw-rw-r-- 1 nobody nogroup 0 Jun 29 17:06 hello
```

We can see that the new created file belongs to user nobody which actually is not existing on the current system. Let’s check the ownership of this file from the point of view of a process in the root USER namespace.

cryptonite@cryptonite:~ $ls -al hello
-rw-rw-r-- 1 cryptonite cryptonite 0 Jun 29 17:09 hello

```bash
# under what UID runs the process who has created this file?

cryptonite@cryptonite:~ $ps l | grep /bin/bash
F S   UID     PID    PPID  C PRI  NI ADDR SZ WCHAN       TTY         TIME CMD
0  1000   18609    3135  20   0  19648  5268 poll_s S+   pts/0      0:00 /bin/bash
```

As it can be seen from the above code snippet, the shell process in the root user namespace sees that the process inside the USER namespace has the same UID. This also explains why the file which was created by nobody and seen as belonging to nobody in the new USER namespace, actually belongs to the user with ID=1000.

As mentioned, user namespaces can also be nested - a process can have a parent user namespace (except processes in the root user namespace) and zero or more child user namespaces. Let’s now see how the process sees the file system whose contents ownership is defined in the root user namespace.

```bash
cryptonite@cryptonite:~ $unshare -U /bin/bash
nobody@cryptonite:/$ ls -al
drwxr-xr-x  20 nobody nogroup  4096 Jun 12 17:25 .
drwxr-xr-x  20 nobody nogroup  4096 Jun 12 17:25 ..
lrwxrwxrwx   1 nobody nogroup     7 Jun 12 17:21 bin -> usr/bin
drwxr-xr-x   5 nobody nogroup  4096 Jun 25 10:23 boot
...

nobody@cryptonite:~$ id
uid=65534(nobody) gid=65534(nogroup) groups=65534(nogroup)
nobody@cryptonite:~$ touch /heloo.txt
touch: cannot touch '/heloo.txt': Permission denied
```

Okay, that is weird - the root directory contents seen from the new user namespace are owned by the user owning the process inside the USER namespace but the process can’t modify the directory contents? In the new user namespace the user (root) who owns these files is not being remapped, thus it doesn’t exist. That’s why the process see nobody and nogroup. But when it tries to modify the contents of the directory it does that by using it’s UID in the root user namespace which is different then the UID of the files. Okay, but how can a process interact with the filesystem in this case? We’ll have to use a mapping.

## Mapping UIDs and GIDs

Some processes need to run under effective UID 0 in order to provide their services and be able to interact with the OS file system. One of the most common things when using user namespaces is to define mappings. This is done using the /proc/<PID>/uid_map and /proc/<PID>/gid_map files. The format is the following:

ID-inside-ns (resp.ID-outside-ns) defines the starting point of UID mapping inside the user namespace (resp. outside of the user namespace) and length defines the number of subsequent UID (resp. GID) mappings. The mappings are applied when a process within a USER namespace tries to manipulate system resources belonging to another USER namespace.

Some important rules according the Linux documentation:

If the two processes are in the same namespace, then ID-outside-ns is interpreted as a user ID (group ID) in the parent user namespace of the process PID. The common case here is that a process is writing to its own mapping file (/proc/self/uid_map or /proc/self/gid_map).

If the two processes are in different namespaces, then ID-outside-ns is interpreted as a user ID (group ID) in the user namespace of the process opening /proc/PID/uid_map (/proc/PID/gid_map). The writing process is then defining the mapping relative to its own user namespace.

Okay, let’s try this out:

```bash
# adding a mapping for a shell process with PID=18609 in a user namespace

cryptonite@cryptonite:~ $echo "0 1000 65335" | sudo tee /proc/18609/uid_map
0 1000 65335
cryptonite@cryptonite:~ $echo "0 1000 65335" | sudo tee /proc/18609/gid_map
0 1000 65335

# back to the user namespaced shell
nobody@cryptonite:~$ id
uid=0(root) gid=0(root) groups=0(root)
# create a file
nobody@cryptonite:~$ touch hello

# back to the root namespace
cryptonite@cryptonite:~ $ls -l hello
-rw-rw-r-- 1 cryptonite cryptonite 0 Jun 29 17:50 hello
```

The process inside the user namespace thinks his effective UID is root but in the upper (root) namespace his UID is the same as the process that created it (zsh with UID=1000). Here is an illustration of the above snippet.

![i1](https://blog.quarkslab.com/resources/2021-11-18-namespaces/bJmaWTD.jpg)

A more general view of the remapping process can be seen on this picture:

![i2](https://blog.quarkslab.com/resources/2021-11-18-namespaces/vKKeaWt.png)

Another important thing to note is that in the defined USER namespace the process has effective UID=0 and all capabilities set in the permitted set.

Let’s see what is the view of the filesystem for the process within the remapped user namespace.

```bash
# in the root user namespace

cryptonite@cryptonite:~ $ls -l
total 0
-rw-rw-r-- 1 cryptonite cryptonite 0 Jul  2 11:07 hello

# in the sub user namespace

nobody@cryptonite:~/test$ ls -l
-rw-rw-r-- 1 root root 0 Jul  2 11:07 hello
```

The "lxd write fail uid_map" error in LXD (or Incus, its successor) usually indicates an issue with user namespace ID mapping, specifically when trying to write to the /proc/self/uid_map file. This file is used to map user IDs inside a container to user IDs on the host system, and the error suggests that LXD is unable to create or modify these mappings, according to the Linux Containers Forum. This can prevent containers from starting or functioning correctly, particularly when dealing with nested containers or when the host system's ID mapping configuration is insufficient.

## shell 1

echo "0 1000 65335" | sudo tee /proc/15320/uid_map

## shell 2

bash - 15320
echo "200 1000 65335" | sudo tee /proc/33160/uid_map
cat /proc/33160/uid_map

## shell 3

sh - 33160
