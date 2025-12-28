# **[Building a Linux container by hand using namespaces](https://www.redhat.com/en/blog/building-container-namespaces)**

**[Research List](../../../../../research_list.md)**\
**[Detailed Status](../../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../../README.md)**

## references

- **[ubuntu process capabilities list](https://manpages.ubuntu.com/manpages/trusty/man7/capabilities.7.html#:~:text=The%20%2Fproc%2FPID%2Ftask,of%20a%20process's%20main%20thread.)**

Not too long ago, I wrote an article covering an overview of **[the most common namespaces](https://www.redhat.com/sysadmin/7-linux-namespaces)**. The information is great to have, and to some extent, I am sure that you can extrapolate how you might put this knowledge to good use. It's not normally my style to leave things so open-ended. So for the next couple of articles, I spend some time demonstrating a few of the more important namespaces through the lens of creating a primitive Linux container. In some sense, I am writing down my experiences with the techniques I use while troubleshooting a Linux container on a client site. With that in mind, I start with the foundation of any container, especially when security is a concern.

## A little about Linux capabilities

Security on a Linux system can take many forms. For this article's purposes, I am mainly concerned with security when it comes to file permissions. As a reminder, everything on a Linux system is some sort of file, and therefore file permissions are the first line of defense against an application that may misbehave.

The primary way Linux handles file permissions is through the implementation of users. There are normal users, for which Linux applies privilege checking, and there is the superuser that bypasses most (if not all) checks. In short, the original Linux model was all-or-nothing.

To get around this, some program binaries have the set uid bit set on them. This setting allows the program to run as the user who owns the binary. The passwd utility is a good example of this. Any user can run this utility on the system. It needs to have elevated privileges on the system to interact with the shadow file, which stores the hashes for user passwords on a Linux system. While the passwd binary has built-in checks to ensure that one normal user cannot change another user's password, many applications do not have the same level of scrutiny, especially if the system administrator turned on the set uid bit.

Linux capabilities were created to provide a more granular application of the security model. Instead of running the binary as root, you can apply only the specific capabilities an application requires to be effective. As of Linux Kernel 5.1, there are 38 capabilities. The **[man pages](https://man7.org/linux/man-pages/man7/capabilities.7.html)** for the capabilities are actually quite well written and describe each capability.

A capability set is the manner in which capabilities can be assigned to threads. In brief, there are five total capability sets, but for this discussion, only two of them are relevant: Effective and Permitted.

**Effective:** The kernel verifies each privileged action and decides whether to allow or disallow a system call. If a thread or file has the effective capability, you are allowed to perform the action related to the effective capability.

**Permitted:** Permitted capabilities are not active yet. However, if a process has permitted capabilities, it means the process itself can choose to escalate its privilege into an effective privilege.

In order to see what capabilities a given process may have you can run the getpcaps ${PID} command. The output of this command will look different depending on the distribution of Linux. On RHEL/CentOS you will get an entire list of capabilities:

In a Linux shell, $$ represents the process ID (PID) of the current shell. Each process running on a Linux system has a unique PID

```bash
getpcaps $$
1154772: =
cat /proc/1154772/status
Name:   zsh
Umask:  0002
State:  S (sleeping)
Tgid:   1154772
Ngid:   0
Pid:    1154772
PPid:   1154168
TracerPid:      0
Uid:    1000    1000    1000    1000
Gid:    1000    1000    1000    1000
FDSize: 128
Groups: 4 20 24 27 30 46 116 126 128 997 1000 
NStgid: 1154772
NSpid:  1154772
NSpgid: 1154772
NSsid:  1154772
VmPeak:    15804 kB
VmSize:    15180 kB
VmLck:         0 kB
VmPin:         0 kB
VmHWM:     10492 kB
VmRSS:      8456 kB
RssAnon:            3840 kB
RssFile:            4616 kB
RssShmem:              0 kB
VmData:     4460 kB
VmStk:       180 kB
VmExe:       760 kB
VmLib:      3812 kB
VmPTE:        68 kB
VmSwap:      904 kB
HugetlbPages:          0 kB
CoreDumping:    0
THP_enabled:    1
Threads:        1
SigQ:   0/30988
SigPnd: 0000000000000000
ShdPnd: 0000000000000000
SigBlk: 0000000000000002
SigIgn: 0000000000384004
SigCgt: 0000000008013003
...
```

Since kernel 2.5.27, capabilities are an optional kernel component, and can be enabled/disabled  via  the
CONFIG_SECURITY_CAPABILITIES kernel configuration option.

The  /proc/PID/task/TID/status  file  can  be  used  to  view  the  capability  sets  of  a  thread.  The /proc/PID/status file shows  the  capability  sets  of  a  process's  main  thread.   Before  Linux  3.8,
nonexistent  capabilities  were  shown  as  being  enabled  (1) in these sets.  Since Linux 3.8, all non-
existent capabilities (above CAP_LAST_CAP) are shown as disabled (0).
