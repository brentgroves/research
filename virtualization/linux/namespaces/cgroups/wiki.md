# **[](https://en.wikipedia.org/wiki/Cgroups)**

## Interfaces

Both versions of cgroup act through a pseudo-filesystem (cgroup for v1 and cgroup2 for v2). Like all filesystems they can be mounted on any path, but the general convention is to mount one of the versions (generally v2) on /sys/fs/cgroup under the sysfs default location of /sys. As mentioned before the two cgroup versions can be active at the same time; this too applies to the filesystems so long as they are mounted to a different path.[21][1] For the description below we assume a setup where the v2 hierarchy lies in /sys/fs/cgroup. The v1 hierarchy, if ever required, will be mounted at a different location.

```bash
ls /sys/fs/cgroup
cgroup.controllers      cgroup.subtree_control  cpu.stat             init.scope     memory.numa_stat        misc.current                   sys-kernel-tracing.mount
cgroup.max.depth        cgroup.threads          cpu.stat.local       io.cost.model  memory.pressure         misc.peak                      system.slice
cgroup.max.descendants  cpu.pressure            dev-hugepages.mount  io.cost.qos    memory.reclaim          proc-sys-fs-binfmt_misc.mount  user.slice
cgroup.pressure         cpuset.cpus.effective   dev-mqueue.mount     io.pressure    memory.stat             sys-fs-fuse-connections.mount
cgroup.procs            cpuset.cpus.isolated    dmem.capacity        io.prio.class  memory.zswap.writeback  sys-kernel-config.mount
cgroup.stat             cpuset.mems.effective   dmem.current         io.stat        misc.capacity           sys-kernel-debug.mount
```

At initialization cgroup2 should have no defined control groups except the top-level one. In other words, /sys/fs/cgroup should have no directories, only a number of files that control the system as a whole. At this point, running ls /sys/fs/cgroup could list the following on one example system:

cgroup.controllers
cgroup.max.depth
cgroup.max.descendants
cgroup.pressure
cgroup.procs
cgroup.stat
cgroup.subtree_control
cgroup.threads
cpu.pressure
cpuset.cpus.effective
cpuset.cpus.isolated
cpuset.mems.effective
cpu.stat
cpu.stat.local
io.cost.model
io.cost.qos
io.pressure
io.prio.class
io.stat
irq.pressure
memory.numa_stat
memory.pressure
memory.reclaim
memory.stat
memory.zswap.writeback
misc.capacity
misc.current
misc.peak

These files are named according to the controllers that handle them. For example, cgroup.*deal with the cgroup system itself and memory.* deal with the memory subsystem. Example: to request the kernel to 1 gigabyte of memory from anywhere in the system, one can run echo "1G swappiness=50" > /sys/fs/cgroup/memory.reclaim.[1]

To create a subgroup, one simply creates a new directory under an existing group (including the top-level one). The files corresponding to available controls for this group are automatically created.[1] For example, running mkdir /sys/fs/cgroup/example; ls /sys/fs/cgroup/example would produce a list of files largely similar to the one above, but with noticeable changes. On one example system, these files are added:

cgroup.events
cgroup.freeze
cgroup.kill
cgroup.type
cpu.idle
cpu.max
cpu.max.burst
cpu.pressure
cpu.uclamp.max
cpu.uclamp.min
cpu.weight
cpu.weight.nice
memory.current
memory.events
memory.events.local
memory.high
memory.low
memory.max
memory.min
memory.oom.group
memory.peak
memory.swap.current
memory.swap.events
memory.swap.high
memory.swap.max
memory.swap.peak
memory.zswap.current
memory.zswap.max
pids.current
pids.events
pids.events.local
pids.max
pids.peak

These changes are not unexpected because some controls and statistics only make sense on a subset of processes (e.g. nice level being the CPU priority of processes relative to the rest of the system).[1]

Processes are assigned to subgroups by writing to /proc/<PID>/cgroup. The cgroup a process is in can be found by reading the same file.[1]

```bash
cat /proc/$$/cgroup   
0::/user.slice/user-1000.slice/user@1000.service/app.slice/app-gnome-code-726053.scope
```

On systems based on systemd, a hierarchy of subgroups is predefined to encapsulate every process directly and indirectly launched by systemd under a subgroup: the very basis of how systemd manages processes. An explanation of the nomenclature of these groups can be found in the Red Hat Enterprise Linux 7 manual.[22] Red Hat also provides a guide on creating a systemd service file that causes a process to run in a separate cgroup.[23]

systemd-cgtop[24] command can be used to show top control groups by their resource usage.

Namespace isolation
Main article: Linux namespaces
While not technically part of the cgroups work, a related feature of the Linux kernel is namespace isolation, where groups of processes are separated such that they cannot "see" resources in other groups. For example, a PID namespace provides a separate enumeration of process identifiers within each namespace. Also available are mount, user, UTS (Unix Time Sharing), network and SysV IPC namespaces.

The PID namespace provides isolation for the allocation of process identifiers (PIDs), lists of processes and their details. While the new namespace is isolated from other siblings, processes in its "parent" namespace still see all processes in child namespaces—albeit with different PID numbers.[29]
Network namespace isolates the network interface controllers (physical or virtual), iptables firewall rules, routing tables etc. Network namespaces can be connected with each other using the "veth" virtual Ethernet device.[30]
"UTS" namespace allows changing the hostname.
Mount namespace allows creating a different file system layout, or making certain mount points read-only.[31]
IPC namespace isolates the System V inter-process communication between namespaces.
User namespace isolates the user IDs between namespaces.[32]
Cgroup namespace
