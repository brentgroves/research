# **[vfs](https://www.starlab.io/blog/introduction-to-the-linux-virtual-filesystem-vfs-part-i-a-high-level-tour)**

Let’s begin with a simple question: How are files accessed, and what steps are involved?

We can all agree data access has become ingrained in daily life. However, we don’t give much thought to where that data lives or the process that occurs before we see it. This is an intentional abstraction meant to limit the basic knowledge necessary to perform most data-related tasks.

The Linux variant of this is called the Virtual Filesystem, or VFS for short. The VFS acts as the interface between the user and the file’s backing filesystem, masking any implementation details behind generic calls such as `open()`, `read()`, `write()`, etc. The primary benefit of the VFS is that most userspace programs are naturally written in a completely filesystem-agnostic way granting greater flexibility and portability in ways that the original author of the program likely never envisioned. An interesting byproduct of this is that it also allows any number of filesystems to coexist in a unified namespace.

The VFS is sandwiched between two layers: the upper and the lower. The upper layer is the system call layer where a userspace process traps into the kernel to request a service (which is usually accomplished via libc wrapper functions) -- thus catalyzing the VFS’s processes. The lower layer is a set of function pointers, one set per filesystem implementation, which the VFS calls when it needs an action performed that requires information specific to a particular filesystem. Taken another way, the VFS could be thought of as the glue between the userspace applications’ requests for file-related services and the filesystem-specific functions which the VFS invokes as needed. From a high-level view, this can be modeled as a standard abstract interface (see figure to the right):

![i1](https://images.squarespace-cdn.com/content/v1/5e1f51eb1bb1681137ea90b8/6cc957f9-2b62-40c0-a621-cb8137045c9a/VFS+Interface+Graphic.gif?format=2500w)

Naturally, the lower layer is where Star Lab’s AuthFS and FortiFS filesystems hook into the VFS. Therefore, it is necessary that we understand the VFS if we want to work in the realm of filesystem implementation.  

Through the VFS’s use of callback functions such as read and write, we can operate on files without worrying about the implementation details. This way, the userspace programmer is only concerned with reading from a file or writing to it and not with how the file is physically stored in a USB flash drive, disk drive, over the network, or on any other conceivable medium.

This results in the following architecture:

![i2](https://images.squarespace-cdn.com/content/v1/5e1f51eb1bb1681137ea90b8/aa42deed-c4bd-4184-a72e-8bdb0c946a5c/VFS+Detailed+Interface+Graphic.gif?format=2500w)

We will not concern ourselves here with a thorough explanation of the buffer cache or the device drivers. The device drivers are ultimately responsible for taking requests to read and write to a particular device (or medium, such as over the network) and realizing those requests. The buffer cache is a layer of optimization that acts an intermediary between the filesystem drivers and the device drivers.

While the previous high-level overview is appropriate for understanding the 10,000 foot view of the VFS, the devil really is in the details as depicted to the right.

For the sake of brevity, we’ll focus on a tour of the primary data structures involved as we attempt to breakdown the VFS, namely:

Filesystem Types

Superblocks

Inodes

Dentries

Files

![i3](https://images.squarespace-cdn.com/content/v1/5e1f51eb1bb1681137ea90b8/fa5c3f56-7e4d-4a9a-a184-83a37c26d0d3/VFS+Delineation+Graphics.gif?format=2500w)

Filesystem Types
In order to use a filesystem, the kernel must know the filesystem type, defined in include/linux/fs.h (and shorted here for brevity):

struct file_system_type {     const char                      *name;      // friendly name of the filesystem -- like 'ext2'     int                             fs_flags;   // mostly obscure options     int                             (*init_fs_context)(struct fs_context *);     const struct fs_parameter_spec*parameters;     struct dentry                   *(*mount) (struct file_system_type *, int, const char*, void *);     void                            (*kill_sb) (struct super_block *);     struct module*owner;     struct file_system_type         *next;     struct hlist_head               fs_supers; };
Note: All data structures mentioned here are shown as they were in Linux v5.18.6.

struct file_system_type maintains data related to a filesystem but is not associated with any particular 'instance of a filesystem', a phrase which here means a mounted filesystem. Examples of filesystems include:

ext2/3/4

fat16/32

ntfs

btrfs

isofs

reiserfs

squashfs

... and the list goes on.

The VFS maintains a linked-list of known filesystem types, which can be viewed in userspace by executing cat /proc/filesystems.

A snippet of what our system prints:

nodev    sysfs nodev    tmpfs nodev    proc nodev    debugfs nodev    sockfs nodev    bpf nodev    pipefs nodev    ramfs nodev    pstore          ext3          ext2          ext4          vfat nodev    nfsd

You will notice a theme in most kernel data structures in that they are linked to and indexed in many different ways. In struct file_system_type, the member struct file_system_type *next is a pointer to the next filesystem type that the kernel knows about, i.e., every filesystem type is part of a global list of all filesystem types in the kernel. You can find this global list's definition in fs/filesystems.c:

static struct file_system_type *file_systems; static DEFINE_RWLOCK(file_systems_lock);
The member struct hlist_head fs_supers indicates that each filesystem type contains a hash table of all superblocks of the same filesystem type. We shall describe the superblock shortly, but what this means is that fs_supers provides a list of all mounts of the containing file_system_type.

Filesystem types are registered and unregistered in the kernel via these functions in include/linux/fs.h:

int register_filesystem(struct file_system_type *); int unregister_filesystem(struct file_system_type*);
Once a filesystem type is known to the kernel (i.e. registered), a filesystem of that type may be mounted to a location in the directory tree.

## Superblock

The superblock is a structure that represents an instance of a filesystem, i.e., a mounted filesystem. The superblock is defined in include/linux/fs.hs (and greatly shortened here for brevity):

struct super_block {     struct list_head                s_list;     // list of all other superblocks of this filesystem type     dev_t                           s_dev;      // device associated with this mount     unsigned long                   s_blocksize;     loff_t                          s_maxbytes;     struct file_system_type         *s_type;    // struct describing the type of filesystem this mount represents     const struct super_operations*s_op;     uuid_t                          s_uuid;     // unique ID of this mount     struct list_head                s_inodes;     unsigned long                   s_magic;    // magic number of this filesystem     struct dentry                   *s_root;     int                             s_count;     void*s_fs_info;     const struct dentry_operations  *s_d_op; };

Learn about magic numbers here.

The superblock is typically stored on the storage device itself and loaded into memory when mounted.

There are a few fields we want to pay special attention to. First, s_list is a linked list to the other superblocks of the same filesystem type. Second, s_inodes is the list of inodes within this filesystem mount (which we explain in a moment). And third, s_op, which points to a struct that defines a set of functions that provide data about the superblock. struct super_operations is a prime example of the VFS’s abstraction that we will see again. It contains a group of function pointers provided per filesystem type that describe the filesystem’s implementation. This keeps the VFS agnostic to the details of a particular filesystem’s inner workings.

## Inode

A filesystem object can be one of the following types:

socket

symbolic link

regular file

block device

directory

character device

FIFO

An inode, short for index node, exists per object in all filesystems for all of the filesystem object types. It is defined in include/linux/fs.h (and shortened here for brevity):

struct inode {     umode_t                         i_mode;     // access permissions, i.e., readable or writeable     kuid_t                          i_uid;      // user id of owner     kgid_t                          i_gid;      // group id of owner     unsigned int                    i_flags;     const struct inode_operations   *i_op;     struct super_block*i_sb;     struct address_space            *i_mapping;     unsigned long                   i_ino;      // unique number identifying this inode     const unsigned int              i_nlink;    // number of hard links     dev_t                           i_rdev;     loff_t                          i_size;     // size of inode contents in bytes     struct timespec64               i_atime;    // access time     struct timespec64               i_mtime;    // modify time     struct timespec64               i_ctime;    // creation time     unsigned short                  i_bytes;    // bytes consumed     const struct file_operations*i_fop;     struct address_space            i_data; };

Note the fields i_op and i_fop. These are again function pointers that describe the filesystem’s implementation. struct inode_operations defines the set of callback functions that operate on the inode. These functions do things like:

change permissions

create files

make symlinks

make directories

rename files

Similarly, struct file_operations defines the set of callback operations that can be called on a struct file object. We will discuss this data structure later -- but in short, a struct file is created for every instance of an open file.

Dentry and The Dentry Cache
A dentry, short for directory entry, is the glue that holds inodes and files together by relating inode numbers to file names. This can be tricky to wrap your head around at first, but take another look at the struct inode. Although we claim there is an inode for every object in the filesystem, the struct inode itself does not contain a name or any friendly identifier; this is the job of the dentry.  

We may have also fibbed a bit when we said that there is an inode for every object in the filesystem. Many names can represent the same filesystem object (see hard and symbolic links), so there isn’t a strict one-to-one relationship between objects and their name(s). This is one excellent reason for divorcing inodes from their names.

The other reason for having dentries is one of optimization. String comparison is expensive, and using it to lookup filesystem paths would create a significant performance impact. Instead, the kernel caches mappings from filesystem paths to their corresponding dentries into what is aptly named the dentry cache, also referred to as the dcache.

A dentry exists not just for filenames, but also for directories and thus for every component of a path. For instance, the path /mnt/cdrom/foo contains dentries for the components /, mnt, cdrom, and foo. Dentry objects are created on the fly as needed.

The dentry structure is defined in include/linux/dcache.h (and shortened here for brevity):

struct dentry {     struct hlist_bl_node            d_hash;                     // lookup hash list     struct dentry                   *d_parent;                 // parent directory     struct qstr                     d_name;     struct inode*d_inode;                   // where the name belongs to     unsigned char                   d_iname[DNAME_INLINE_LEN];  // small names     const struct dentry_operations  *d_op;     void*d_fsdata;                  // fs-specific data     struct list_head                d_child;                    // child of parent list, i.e., our siblings     struct list_head                d_subdirs;                  // our children };
d_name contains the name of the file and d_inode points to its associated inode.

File
A file object represents an open file and is defined in include/linux/fs.h (and shortened here for brevity):

struct file {     struct path                     f_path;         // a dentry and a mount point which locate this file     struct inode                    *f_inode;       // the inode underlying this file     const struct file_operations*f_op;          // callbacks to function which can operate on this file     spinlock_t                      f_lock;     atomic_long_t                   f_count;     unsigned int                    f_flags;     fmode_t                         f_mode;     struct mutex                    f_pos_lock;     loff_t                          f_pos           // offset in the file from which the next read or write shall commence     struct fown_struct              f_owner;     void                            *private_data     struct address_space*f_mapping;     // callbacks for memory mapping operations };
We would like to emphasize that this represents an open file and contains data such as flags used while opening the file and the offset from which a process can read or write from. When the file is closed, this data structure is removed from memory - operations such as writing data will be delegated to its respective inode.

Although the information presented thus far is not detailed enough to allow one to implement and/or modify a filesystem, it will hopefully act as a starting point from which to expand one's knowledge. In particular, topics to further research could include:

What exactly are all the callback functions and which ones must be implemented?

What are the system calls which involve the VFS and how do they end up calling our callback functions? Tracing system calls through the VFS and into the various callback functions will be instrumental in understanding the VFS's inner workings.

How to ensure filesystem integrity and solutions available to do so.

tldr:

A superblock represents a mounted filesystem.

The VFS maintains a list of superblocks.

An inode represents a filesystem object (i.e. file).

Each superblock maintains a list of inodes.

A dentry translates a file path components into inodes.

The dcache contains all dentries.

Futher Reading:

Linux's VFS documentation

Understanding the Linux Kernel, 3rd Edition (See chapter 12)

Example of writing a simple filesystem from scrach

Wrapfs -- a good example of a stacked filesystem

Securing the Linux Filesystem with dm-verity
