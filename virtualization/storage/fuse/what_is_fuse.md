# **[what is fuse](https://exploiter.dev/blog/2022/FUSE-exploit.html)**

FUSE for Linux Exploitation 101
During the past few weeks, my friend @kiks and I started to develop an exploit for CVE-2022-2602: it’s an io_uring UAF.

We already completed the exploit using the userfaultfd technique to pause a kernel thread. Unfortunately, this technique is dead (thank you, vm.unprivileged_userfaultfd :/ ), so we started searching a good replacement for userfaultfd.

While reading @chompie’s blogpost about io_uring, I stumbled upon FUSE.

In this blogpost I’ll try to present to you my take on FUSE for Linux Exploitation :)

TLDR: FUSE filesystem allows users to pause a kernel thread, implementing a blocking read/write FUSE operation.

## What is FUSE?

FUSE (Filesystem in USErspace) is a feature that allows users (also unprivileged users) to create fileystems in userspace.

FUSE architecture is composed of 3 main parts:

Fuse kernel module, which forwards requests on FUSE files to the user-space callbacks.
libfuse, which is the userspace component.
fusermount, an utility used to unmount fuse filesystems.
