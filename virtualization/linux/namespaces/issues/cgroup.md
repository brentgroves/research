# **[[Solved] Launching snaps in network namespace fails with “error: cannot find tracking cgroup”](https://forum.snapcraft.io/t/solved-launching-snaps-in-network-namespace-fails-with-error-cannot-find-tracking-cgroup/31113)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../../README.md)**

I’m trying to launch firefox snap from a shell inside network namespace managed by vopono 8, and it fails.

```bash
$ snap run --debug-log --shell firefox
2022/08/02 16:31:31.619292 cmd_run.go:486: DEBUG: enabled debug logging of early snap startup
2022/08/02 16:31:31.619850 cmd_run.go:1035: DEBUG: executing snap-confine from /snap/core/13425/usr/lib/snapd/snap-confine
2022/08/02 16:31:31.620216 cmd_run.go:438: DEBUG: SELinux not enabled
2022/08/02 16:31:31.620490 tracking.go:46: DEBUG: creating transient scope snap.firefox.firefox
2022/08/02 16:31:31.621077 tracking.go:186: DEBUG: using session bus
2022/08/02 16:31:31.621981 tracking.go:319: DEBUG: create transient scope job: /org/freedesktop/systemd1/job/822
error: cannot find tracking cgroup
```

When launched directly:

```bash
$ firefox -ProfileManager
internal error, please report: running "firefox" failed: cannot find tracking cgroup
The shell (bash) was created with:

vopono exec --dns "1.1.1.1" --provider privateinternetaccess --server jp "bash"
The error seems to originate from ProcessPathInTrackingCgroup. I checked /proc/self/cgroup:

cat /proc/self/cgroup 
0::/user.slice/user-1000.slice/user@1000.service/app.slice/app-org.kde.yakuake-93dfbf7d91b44295bf8ca397d8bd220f.scope
```

The dmesg command in Linux is used to display and manage the kernel ring buffer. This buffer stores messages produced by the kernel and device drivers during system startup and throughout operation. These messages are crucial for troubleshooting and understanding system behavior.

```bash
sudo dmesg | grep DENIED 
```

does not log any lines when launching firefox snap from the network namespace.

Any ideas how I can debug this further to fix it?

## answer

Turns out it’s because /sys/fs/cgroup not being mounted.

securityfs is also required. (Got this inspiration from <https://github.com/diddlesnaps/snapcraft-container/issues/8#issuecomment-1070825050>) Mount cgroup2 and securityfs inside the netns shell: sudo mount -t cgroup2 cgroup2 /sys/fs/cgroup su…

```bash
# Mount cgroup2 and securityfs inside the netns shell:

sudo mount -t cgroup2 cgroup2 /sys/fs/cgroup
ls /sys/fs/cgroup
cgroup.controllers      cgroup.subtree_control  cpu.stat             io.cost.qos       memory.pressure         misc.peak                      system.slice
cgroup.max.depth        cgroup.threads          cpu.stat.local       io.pressure       memory.reclaim          proc-sys-fs-binfmt_misc.mount  user.slice
cgroup.max.descendants  cpu.pressure            dev-hugepages.mount  io.prio.class     memory.stat             sys-fs-fuse-connections.mount
cgroup.pressure         cpuset.cpus.effective   dev-mqueue.mount     io.stat           memory.zswap.writeback  sys-kernel-config.mount
cgroup.procs            cpuset.cpus.isolated    init.scope           machine.slice     misc.capacity           sys-kernel-debug.mount
cgroup.stat             cpuset.mems.effective   io.cost.model        memory.numa_stat  misc.current            sys-kernel-tracing.mount

sudo mount -t securityfs securityfs /sys/kernel/security/
ls /sys/kernel/security/
apparmor  evm  ima  integrity  lockdown  lsm  tpm0
```

After doing so, firefox snap could be launched in the network namespace.

Linux mount Command Syntax. The standard mount command syntax is: mount -t [type] [device] [dir] Copy. The command instructs the kernel to attach the file system found on [device] at the [dir] directory. The -t [type] option is optional, and it describes the file system type (EXT3, EXT4, BTRFS, XFS, HPFS, VFAT, etc.
