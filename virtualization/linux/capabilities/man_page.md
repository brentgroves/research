# **[capabilities man page](https://man7.org/linux/man-pages/man7/capabilities.7.html)**

       capabilities - overview of Linux capabilities
DESCRIPTION         top
       For the purpose of performing permission checks, traditional UNIX
       implementations distinguish two categories of processes:
       privileged processes (whose effective user ID is 0, referred to as
       superuser or root), and unprivileged processes (whose effective
       UID is nonzero).  Privileged processes bypass all kernel
       permission checks, while unprivileged processes are subject to
       full permission checking based on the process's credentials
       (usually: effective UID, effective GID, and supplementary group
       list).

       Starting with Linux 2.2, Linux divides the privileges
       traditionally associated with superuser into distinct units, known
       as capabilities, which can be independently enabled and disabled.
       Capabilities are a per-thread attribute.

   Capabilities list
       The following list shows the capabilities implemented on Linux,
       and the operations or behaviors that each capability permits:

       CAP_AUDIT_CONTROL (since Linux 2.6.11)
              Enable and disable kernel auditing; change auditing filter
              rules; retrieve auditing status and filtering rules.

       CAP_AUDIT_READ (since Linux 3.16)
              Allow reading the audit log via a multicast netlink socket.

       CAP_AUDIT_WRITE (since Linux 2.6.11)
              Write records to kernel auditing log.

       CAP_BLOCK_SUSPEND (since Linux 3.5)
              Employ features that can block system suspend (epoll(7)
              EPOLLWAKEUP, /proc/sys/wake_lock).

       CAP_BPF (since Linux 5.8)
              Employ privileged BPF operations; see bpf(2) and
              bpf-helpers(7).

              This capability was added in Linux 5.8 to separate out BPF
              functionality from the overloaded CAP_SYS_ADMIN capability.

       CAP_CHECKPOINT_RESTORE (since Linux 5.9)
              •  Update /proc/sys/kernel/ns_last_pid (see
                 pid_namespaces(7));
              •  employ the set_tid feature of clone3(2);
              •  read the contents of the symbolic links in
                 /proc/pid/map_files for other processes.

              This capability was added in Linux 5.9 to separate out
              checkpoint/restore functionality from the overloaded
              CAP_SYS_ADMIN capability.

       CAP_CHOWN
              Make arbitrary changes to file UIDs and GIDs (see
              chown(2)).

       CAP_DAC_OVERRIDE
              Bypass file read, write, and execute permission checks.
              (DAC is an abbreviation of "discretionary access control".)

       CAP_DAC_READ_SEARCH
              •  Bypass file read permission checks and directory read
                 and execute permission checks;
              •  invoke open_by_handle_at(2);
              •  use the linkat(2) AT_EMPTY_PATH flag to create a link to
                 a file referred to by a file descriptor.

       CAP_FOWNER
              •  Bypass permission checks on operations that normally
                 require the filesystem UID of the process to match the
                 UID of the file (e.g., chmod(2), utime(2)), excluding
                 those operations covered by CAP_DAC_OVERRIDE and
                 CAP_DAC_READ_SEARCH;
              •  set inode flags (see FS_IOC_SETFLAGS(2const)) on
                 arbitrary files;
              •  set Access Control Lists (ACLs) on arbitrary files;
              •  ignore directory sticky bit on file deletion;
              •  modify user extended attributes on sticky directory
                 owned by any user;
              •  specify O_NOATIME for arbitrary files in open(2) and
                 fcntl(2).

       CAP_FSETID
              •  Don't clear set-user-ID and set-group-ID mode bits when
                 a file is modified;
              •  set the set-group-ID bit for a file whose GID does not
                 match the filesystem or any of the supplementary GIDs of
                 the calling process.

       CAP_IPC_LOCK
              •  Lock memory (mlock(2), mlockall(2), mmap(2), shmctl(2));
              •  Allocate memory using huge pages (memfd_create(2),
                 mmap(2), shmctl(2)).

       CAP_IPC_OWNER
              Bypass permission checks for operations on System V IPC
              objects.

       CAP_KILL
              Bypass permission checks for sending signals (see kill(2)).
              This includes use of the ioctl(2) KDSIGACCEPT operation.

       CAP_LEASE (since Linux 2.4)
              Establish leases on arbitrary files (see fcntl(2)).

       CAP_LINUX_IMMUTABLE
              Set the FS_APPEND_FL and FS_IMMUTABLE_FL inode flags (see
              FS_IOC_SETFLAGS(2const)).

       CAP_MAC_ADMIN (since Linux 2.6.25)
              Allow MAC configuration or state changes.  Implemented for
              the Smack Linux Security Module (LSM).

       CAP_MAC_OVERRIDE (since Linux 2.6.25)
              Override Mandatory Access Control (MAC).  Implemented for
              the Smack LSM.

       CAP_MKNOD (since Linux 2.4)
              Create special files using mknod(2).

       CAP_NET_ADMIN
              Perform various network-related operations:
              •  interface configuration;
              •  administration of IP firewall, masquerading, and
                 accounting;
              •  modify routing tables;
              •  bind to any address for transparent proxying;
              •  set type-of-service (TOS);
              •  clear driver statistics;
              •  set promiscuous mode;
              •  enabling multicasting;
              •  use setsockopt(2) to set the following socket options:
                 SO_DEBUG, SO_MARK, SO_PRIORITY (for a priority outside
                 the range 0 to 6), SO_RCVBUFFORCE, and SO_SNDBUFFORCE.

       CAP_NET_BIND_SERVICE
    