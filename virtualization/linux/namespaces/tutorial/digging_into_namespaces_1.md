# **[](https://blog.quarkslab.com/digging-into-linux-namespaces-part-1.html)**

Digging into Linux namespaces - part 1
Posted Tue 16 November 2021
Author Mihail Kirov
Category Containers
Tags Linux, container, kernel, Docker, 2021
Process isolation is a key component for containers. One of the key underlying mechanisms are namespaces. We will explore what they are, and how they work, to build our own isolated container and better understand each piece.

What are namespaces?
Namespaces are a Linux kernel feature released in kernel version 2.6.24 in 2008. They provide processes with their own system view, thus isolating independent processes from each other. In other words, namespaces define the set of resources that a process can use (You cannot interact with something that you cannot see). At a high level, they allow fine-grain partitioning of global operating system resources such as mounting points, network stack and inter-process communication utilities. A powerful side of namespaces is that they limit access to system resources without the running process being aware of the limitations. In typical Linux fashion they are represented as files under the /proc/<pid>/ns directory.

```bash
cryptonite@cryptonite:~ $ echo $$
4622
cryptonite@cryptonite:~ $ ls /proc/$$/ns -al
total 0
dr-x--x--x 2 cryptonite cryptonite 0 Jun 29 15:00 .
dr-xr-xr-x 9 cryptonite cryptonite 0 Jun 29 13:13 ..
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 cgroup -> 'cgroup:[4026531835]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 ipc -> 'ipc:[4026531839]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 mnt -> 'mnt:[4026531840]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 net -> 'net:[4026532008]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 pid -> 'pid:[4026531836]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 pid_for_children -> 'pid:[4026531836]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 time -> 'time:[4026531834]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 time_for_children -> 'time:[4026531834]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 user -> 'user:[4026531837]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:00 uts -> 'uts:[4026531838]'

When we spawn a new process all the namespaces are inherited from its parent.

```bash
# inception
cryptonite@cryptonite:~ $ /bin/zsh
# father PID verification
╭─cryptonite@cryptonite ~
╰─$ ps -efj  | grep $$
crypton+   13560    4622   13560    4622  1 15:07 pts/1    00:00:02 /bin/zsh
╭─cryptonite@cryptonite ~
╰─$ ls /proc/$$/ns -al
total 0
dr-x--x--x 2 cryptonite cryptonite 0 Jun 29 15:10 .
dr-xr-xr-x 9 cryptonite cryptonite 0 Jun 29 15:07 ..
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 cgroup -> 'cgroup:[4026531835]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 ipc -> 'ipc:[4026531839]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 mnt -> 'mnt:[4026531840]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 net -> 'net:[4026532008]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 pid -> 'pid:[4026531836]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 pid_for_children -> 'pid:[4026531836]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 time -> 'time:[4026531834]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 time_for_children -> 'time:[4026531834]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 user -> 'user:[4026531837]'
lrwxrwxrwx 1 cryptonite cryptonite 0 Jun 29 15:10 uts -> 'uts:[4026531838]'
```

The ps command in Linux is used to report a snapshot of the current processes. The parameters e, f, and j are commonly used options that modify the output format and content.
-e (Every process):
.
This option selects all processes. Without it, ps typically only shows processes associated with the current terminal.
-f (Full format listing):
.
This option provides a full-format listing, which includes more columns of information such as UID, PID, PPID, C (CPU utilization), STIME (start time), TTY (controlling terminal), TIME (CPU time used), and CMD (command being executed).
-j (Jobs format):
.
This option displays output in a jobs format, which includes columns like PID (process ID), PGID (process group ID), SID (session ID), TTY (controlling terminal), TIME (CPU time used), and CMD (command being executed). This format is particularly useful for understanding process relationships within job control.

echo $$ returns a different PID after run zsh, but `ls /proc/$$/ns -al` list the same namespaces for the parent and child process.

Namespaces are created with the clone syscall with one of the following arguments:

- CLONE_NEWNS - create new mount namespace;
- CLONE_NEWUTS - create new UTS namespace;
- CLONE_NEWIPC - create new IPC namespace;
- CLONE_NEWPID - create new PID namespace;
- CLONE_NEWNET - create new NET namespace;
- CLONE_NEWUSER - create new USR namespace;
- CLONE_NEWCGROUP - create a new cgroup namespace.

Linux control groups, or cgroups, are a kernel feature that allows you to manage and limit the resources used by a group of processes. They enable fine-grained control over resource allocation, prioritization, and isolation, enhancing system stability and performance. Cgroups are essential for containerization technologies like Docker and Kubernetes, which rely on them to manage resources for individual containers and pods.

A major change in the history of cgroups is cgroup v2, which removes the ability to use multiple process hierarchies and to discriminate between threads as found in the original cgroup (now called "v1").[1]: § Issues with v1 and Rationales for v2  Work on the single, unified hierarchy started with the repurposing of v1's dummy hierarchy as a place for holding all controllers not yet used by others in 2014.[7] cgroup v2 was merged in Linux kernel 4.5 (2016).[8]

Namespaces can also be created using the unshare syscall. The difference between clone and unshare is that clone spawns a new process inside a new set of namespaces, and unshare moves the current process inside a new set of namespaces (unshares the current ones).

## Why use namespaces?

If we imagine namespaces as boxes for processes containing some abstracted global system resources, one good thing with these boxes is that you can add and remove stuff from one box and it will not affect the content of the other boxes. Or, if a process A in a box (set of namespaces) goes crazy and decides to delete the whole filesystem or the network stack in that box, it will not affect the abstraction of these resources provided for another process B placed in a different box. Moreover, namespaces can provide even fine-grained isolation, allowing process A and B to share some system resources (e.g. sharing a mount point or a network stack). Namespaces are often used when untrusted code has to be executed on a given machine without compromising the host OS. Programming contest platforms like Hackerrank, Codeforces, Rootme use namespaced environments in order to safely execute and verify contestants' code without putting their servers at risk. PaaS (platform as a service) providers like Google Cloud Engine use namespaced environments to run multiple user services (e.g. web servers, databases) on the same hardware without the possibility of interference of these services. So namespaces can also be seen as useful for efficient resource sharing. Other cloud technologies like Docker or LXC also use namespaces as means for process isolation. These technologies put operating system processes in isolated environments called containers. Running processes in Docker containers, for example, is like running them in virtual machines. The difference between containers and VMs is that containers share and use directly the host OS kernel, thus making them significantly lighter than virtual machines as there is no hardware emulation. This increase of overall performance is mainly due to the usage of namespaces which are directly integrated in the Linux kernel. However, there are some implementations of VMs which are extremely light.

## Types of namespaces

In the current stable Linux Kernel version 5.7 there are seven different namespaces:

PID namespace: isolation of the system process tree;

NET namespace: isolation of the host network stack;

MNT namespace: isolation of host filesystem mount points;

UTS namespace: isolation of hostname;

IPC namespace: isolation for interprocess communication utilities (shared segments, semaphores);

USER namespace: isolation of system users IDs;

CGROUP namespace: isolation of the virtual cgroup filesystem of the host.

The namespaces are per-process attributes. Each process can perceive at most one namespace. In other words, at any given moment, any process P belongs to exactly one instance of each namespace. For example when a given process wants to update the route table on the system, the Kernel shows it the copy of the route table of the namespace to which it belongs at that moment. If a process asks for its ID in the system, the Kernel will respond with the ID of the process in its current namespace (in case of nested namespace). We are going to look in detail at each namespace in order to understand what are the operating system mechanisms behind them. Understanding that will help us find what is under the hood of today’s containerized technologies.

## PID namespace

Historically, the Linux kernel has maintained a single process tree. The tree data structure contains a reference to every process currently running in a parent-child hierarchy. It also enumerates all running processes in the OS. This structure is maintained in the so called procfs filesystem which is a property of the live system (i.e. it’s present only when the OS is running). This structure allows processes with sufficient privileges to attach to other processes, inspect, communicate and/or kill them. It also contains information about the root directory of a process, its current working directory, the open file descriptors, virtual memory addresses, the available mounting points, etc.

```bash
# an example of the procfs structure
cryptonite@cryptonite:~ $ls /proc/1/
   arch_status     coredump_filter      gid_map     mounts          pagemap         setgroups   task
   attr            cpu_resctrl_groups   io          mountstats      patch_state     smaps       timens_offsets
   cgroup          environ              map_files   numa_maps       root            stat        uid_map
   clear_refs      exe                  maps        oom_adj         sched           statm
...
# an example of the process tree structure
cryptonite@cryptonite:~ $pstree | head -n 20
systemd-+-ModemManager---2*[{ModemManager}]
        |-NetworkManager---2*[{NetworkManager}]
        |-accounts-daemon---2*[{accounts-daemon}]
        |-acpid
        |-avahi-daemon---avahi-daemon
        |-bluetoothd
        |-boltd---2*[{boltd}]
        |-colord---2*[{colord}]
        |-containerd---17*[{containerd}]
```

On system boot, the first process started on most of the modern Linux OS is systemd (system daemon), which is situated on the root node of the tree. Its parent is PID=0 which is a non-existing process in the OS. This process is after that responsible for starting the other services/daemons, which are represented as its childs and are necessary for the normal functioning of the OS. These processes will have PIDs > 1 and the PIDs in the tree structure are unique.

With the introduction of the Process namespace (or PID namespace) it became possible to make nested process trees. It allows processes other than systemd (PID=1) to perceive themselves as the root process by moving on the top of a subtree, thus obtaining PID=1 in that subtree. All processes in the same subtree will also obtain IDs relative to the process namespace. This also means that some processes may end up having multiple IDs depending on the number of process namespaces that they are in. Yet, in each namespace, at most one process can have a given PID (the unique value of a node in the process tree becomes a per-namespace property). This comes from the fact that relations between the processes in the root process namespace stay intact. Or said with other words, a process in a new PID namespace is still attached to its parent, thus being part of its parent PID namespace. These relations between all processes can be seen in the root process namespace, but in a nested process namespace they are not visible. That means that a process in a nested process namespace can’t interact with its parent or any other process in an upper process namespace. That’s due to the fact that, being on the top of a new PID namespace, the process perceives its PID as 1, and there is no other process before the process with PID=1.

![i1](https://blog.quarkslab.com/resources/2021-11-18-namespaces/jcPTsBS.png)

In the Linux kernel the PID is represented as a structure. Inside we can also find the namespaces a process is part of as an array of upid struct.

```c
struct upid {
    int nr;  /* the pid value */
    struct pid_namespace *ns;       /* the namespace this value
                                    * is visible in */
    struct hlist_node pid_chain; /* hash chain for faster search of PIDS in the given namespace*/
};

struct pid {
    atomic_t count; /*reference counter */
    struct hlist_head tasks[PIDTYPE_MAX]; /* lists of tasks*/
    struct rcu_head rcu;
    int level;              // number of upids
    struct upid numbers[0];  // array of pid namespaces
};
```

To create a new process inside a new PID namespace, one must call the clone() system call with a special flag CLONE_NEWPID. Whereas the other namespaces discussed below can also be created using the unshare() system call, a PID namespace can only be created at the time a new process is spawned using clone() or fork() syscalls.

Let’s explore that:

```bash
# Let's start a process in a new pid namespace;
cryptonite@cryptonite:~ $sudo unshare --pid  /bin/bash
bash: fork: Cannot allocate memory     [1]
root@cryptonite:/home/cryptonite# ls
bash: fork: Cannot allocate memory     [1]
```

What happened? It seems like the shell is stuck between the two namespaces. This is due to the fact that unshare doesn’t enter the new namespace after being executed (execve() call). This is the desired Linux kernel behavior. The current “unshare” process calls the unshare system call, creating a new pid namespace, but the current “unshare” process is not in the new pid namespace. A process B creates a new namespace but the process B itself won’t be put into the new namespace, only the sub-processes of process B will be put into the new namespace. After the creation of the namespace the unshare program will execute /bin/bash. Then /bin/bash will fork several new sub-processes to do some jobs. These sub-processes will have a PIDs relative to the new namespace and when these processes are done they will exit leaving the namespace without PID=1. The Linux kernel doesn’t like to have PID namespaces without a process with PID=1 inside. So when the namespace is left empty the kernel will disable some mechanisms which are related to the PID allocation inside this namespace thus leading to this error. This error is well documented if you look around the Internet.

Instead, we must instruct the unshare program to fork a new process after it has created the namespace. Then this new process will have PID=1 and will execute our shell program. In that way when the sub-processes of /bin/bash exit the namespace will still have a process with PID=1.

```bash
cryptonite@cryptonite:~ $sudo unshare --pid --fork  /bin/bash
root@cryptonite:/home/cryptonite# echo $$
1
root@cryptonite:/home/cryptonite# ps
    PID TTY          TIME CMD
   7239 pts/0    00:00:00 sudo
   7240 pts/0    00:00:00 unshare
   7241 pts/0    00:00:00 bash
   7250 pts/0    00:00:00 ps
```

But why doesn't our shell have PID 1 when we use ps? And why do we still see the process from the root namespace ? The ps program uses the procfs virtual file system to obtain information about the current processes in the system. This filesystem is mounted in the /proc directory. However, in the new namespace this mountpoint describes the processes from the root PID namespace. There are two ways to avoid that:

```bash
# creating a new mount namespace and mounting a new procfs inside
cryptonite@cryptonite:~ $sudo unshare --pid --fork --mount /bin/bash
root@cryptonite:/home/cryptonite# mount -t proc proc /proc
root@cryptonite:/home/cryptonite# ps
    PID TTY          TIME CMD
      1 pts/2    00:00:00 bash
      9 pts/2    00:00:00 ps

# Or use the unshare wrapper with the --mount-proc flag
# which does the same
cryptonite@cryptonite:~ $sudo unshare --fork --pid --mount-proc  /bin/bash
root@cryptonite:/home/cryptonite# ps
    PID TTY          TIME CMD
      1 pts/1    00:00:00 bash
      8 pts/1    00:00:00 ps
```

As we mentioned before, a process can have multiple IDs depending on the number of namespaces the process is in. Let’s now inspect the different PIDs of a shell that is nested in two namespaces.

```bash
╭cryptonite@cryptonite:~ $sudo unshare --fork --pid --mount-proc  /bin/bash
# this process has PID 4700 in the root PID namespace
root@cryptonite:/home/cryptonite# unshare --fork --pid --mount-proc /bin/bash
root@cryptonite:/home/cryptonite# ps
    PID TTY          TIME CMD
      1 pts/1    00:00:00 bash
      8 pts/1    00:00:00 ps

# Let's inspect the different PIDs
cryptonite@cryptonite:~ $sudo nsenter --target 4700 --pid --mount
cryptonite# ps -aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0  18476  4000 pts/0    S    21:11   0:00 /bin/bash
root           9  0.2  0.0  21152  5644 pts/1    S    21:15   0:00 -zsh # me
root          14  0.0  0.0  20972  4636 pts/0    S    21:15   0:00 sudo unshare
root          15  0.0  0.0  16720   520 pts/0    S    21:15   0:00 unshare -fp -
root          11  0.0  0.0  18476  3836 pts/0    S+   21:15   0:00 /bin/bash # nested shell
root          24  0.0  0.0  20324  3520 pts/1    R+   21:15   0:00 ps -aux
# the PID viewed from within the first PID namespace is 11

# Let's see its PID in the root PID namespace
cryptonite@cryptonite:~ $ps aux | grep /bin/bash
....
root       13512  0.0  0.0  18476  4036 pts/1    S+   14:44   0:00 /bin/bash
# believe me it's that process ;)

# All this info can be found in the procfs
cryptonite@cryptonite:~ $cat /proc/13152/status | grep -i NSpid
NSpid:  13512   11  1
# PID in the root namespace = 13512
# PID in the first nested namespace = 11
# pid in the second nested namespace = 1
```

Okay, after we saw the virtualization in terms of identifiers let’s see if there is real isolation in terms of interaction with other processes in the OS.

```bash
# process is run with effective UID=0 (root) and it can normally kill any other process in the OS

root@cryptonite:/home/cryptonite# kill 3

# nothing happens, because there is no process 3 in the current namespace
```

We can see that the process could not interact with a process outside of its current namespace (You cannot touch something you cannot see, remember?).

To sum up about the process namespace:

Processes within a namespace only see (interact with) the processes in the same PID namespace (isolation);

Each PID namespace has its own numbering starting at 1 (relative);

This numbering is unique per process namespace - If PID 1 goes away then the whole namespace is deleted;

Namespaces can be nested;

A process ends up having multiple PIDs (when namespaces are nested);

All ‘ps’-like commands use the virtual procfs file system mount to deliver their functionalities.

```bash
# All this info can be found in the procfs

cryptonite@cryptonite:~ $cat /proc/13152/status | grep -i NSpid
NSpid:  13512   11  1

# PID in the root namespace = 13512

# PID in the first nested namespace = 11

# pid in the second nested namespace = 1
```
