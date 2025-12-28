# **[fuse](https://people.duke.edu/~tkb13/courses/ece566-2020fa/homework/program-fuse.pdf)**

First, let’s discuss what a filesystem is at a high level (to be covered much deeper later in the course).
Your hard drive or SSD is a dumb storage device: you just tell it which block to read or write and it goes
there and does that: the interface is just read_block(int blocknum) and
writeblock(int blocknum, char* data).
We could just live with that – just making a note that block 42 is my tax records and blocks 43-49 is a
picture of my dog, but that gets cumbersome.
A filesystem stores information about which blocks correspond to which pieces of information (files) on
the hard drive itself. It provides the hierarchical directory abstraction, the permissions abstraction, and
other metadata things (timestamps, etc.). The filesystem uses the block device’s
read_block/write_block interface in order to provide a richer interface that includes OS
primitives you’re used to: open, close, read, write, mkdir, delete, etc.
The usual architecture for a modern filesystem is a module within the OS kernel. When a user program
tries to do an IO call, it is passed to a handler in the OS that follows the filesystem’s algorithm to
perform that operation using a given block device. On modern systems, you may have multiple
filesystems available (“mounted”) at a time. For example, you might have your laptop’s hard drive
mounted (formatted on Windows as the NTFS standard) as well a USB stick (formatted in the FAT32
standard). The modern OS allows many different handlers to all have the same file IO interface – the
pivot that selects among them is called the Virtual Filesystem (VFS). In this example, NTFS and FAT32 are
considered the actual filesystems.

It is possible to write you own filesystem code as a kernel module, but writing kernel code can be
troublesome and tedious. The Linux kernel provides an interesting facility called FUSE (“Filesystem in
USErspace”) that can mitigate this. In this system, kernel calls to do filesystem things are redirected back
into a user program for handling -- one that you will write.

This is illustrated in the figure to the right; a call to
the usual ls command goes down to the kernel
VFS, is routed back into userspace to the example
hello filesystem shown, which decides how to
handle the call. The answer is piped back through
the kernel to the original caller. In this way, user
code written in C, Python, or any other language
with fuse bindings can act as a fully-fledged
filesystem. There’s a performance cost for this, but
for this class, that’s a cost we’re willing to play for
the simplicity of writing user code vs. kernel code.
In this assignment, you’ll go through a FUSE tutorial and write a few small example FUSE programs
