# **[](https://www.baeldung.com/linux/process-needed-capabilities#introduction-to-linux-capabilities)**

 Introduction to Linux Capabilities
Linux capabilities are a feature within the Linux kernel that allows for more precise control over the privileges of individual processes. Traditionally, the concept of privilege on a Unix-like system like Linux has been binary – a process either runs with full root (superuser) or restricted user privileges. This means that any process running as root has access to all system resources and can perform any action, making it a significant security risk.

However, with the introduction of capabilities, Linux provides a way to divide and assign privileges more granularly. This means that processes no longer need to access the all-encompassing power of the root user to perform specific tasks. Instead, capabilities can be assigned to processes, giving them only the necessary permissions to perform their designated functions. This enhances security by reducing the potential attack surface and limiting the potential damage a compromised process can do.

Furthermore, by allowing processes to have only the required capabilities, we uphold the principle of least privilege, which suggests that a process should be given the minimum privileges necessary to accomplish its task and nothing more. For example, a process might need the capability to bind to low-numbered ports, typically a privilege reserved for the root user. Instead of running the entire process as root, which would be overkill and risky, the specific capability to bind to ports is granted, and the process can run with reduced privileges.

## 3. Using getpcaps to Display Process Capabilities

getpcaps is a tool tailor-made to display the capabilities of processes. It provides a quick snapshot of the capabilities granted to a particular process, identified by its Process ID (PID).

Suppose we want to understand the capabilities of a process with PID 12345:

```bash
$ getpcaps 12345
PID 12345 = cap_chown,cap_dac_override,...,cap_audit_write,cap_setfcap+i
```

As we can see, our output narrates the capabilities assigned to the process. We can then delve deeper into each capability to understand its significance and function, with each capability represented by its name and separated by commas:

- cap_chown – allows the process to change the ownership of files
- cap_dac_override – enables the process to bypass discretionary access controls (DAC), permitting it to access files even if standard permission checks would deny access
- cap_audit_write – allows the process to write audit logs for monitoring and tracking system activity
- cap_setfcap – permits the process to set file capabilities, which are additional access controls beyond traditional permissions
- +i – signifies the inheritable capabilities that can be passed to child processes

As system administrators, with getpcaps, we can gain insights into the privileges assigned to processes, contributing to a better understanding of system security and potential vulnerabilities.

## 4. Utilizing /proc and capsh for Capability Exploration and Retrieval

Linux systems offer a treasure trove of information, and the /proc pseudo-filesystem is a golden key. Coupled with **[capsh](https://man7.org/linux/man-pages/man1/capsh.1.html)**, it becomes a powerful tool to unveil capabilities. The /proc directory houses information on all processes, and capsh is our trusted companion for exploring Linux capability support. By synergizing the two, we gain a comprehensive view of process capabilities.

First, let’s peek into the /proc/<PID>/status to extract capability information.

Suppose we want to scrutinize the capabilities of a process with PID 6789:

```bash
$ cat /proc/6789/status | grep Cap
CapInh: 00000000a80425fb
...
CapAmb: 0000000000000000
```

Here, we retrieve and display information related to the capabilities of the PID 6789 process. The CapInh field indicates the inheritable capabilities associated with the process, while the CapAmb field pertains to the ambient capabilities represented in hexadecimal notation.

To interpret and decipher these hexadecimal values into human-readable capability names, we turn to capsh:

```bash
$ capsh --decode=00000000a80425fb
cap_chown            = +ep
cap_dac_override     = +eip
cap_fowner           = +e
cap_fsetid           = +ei
...
```

Similar to our previous interaction of cap_chown and cap_dac_override in getpcaps:

- cap_fowner – grants the process the ability to set arbitrary file owners
- cap_fsetid – vests the process the ability to set arbitrary groups and user IDs on files

In addition to our decoded output, a set of one or more letters and symbols accompanies each capability name. These symbols provide insight into the specific or combined privileges granted to the process for that capability:

- – capability is permitted (the process is allowed to use this capability)
e – capability is effective (the process is currently able to use this capability)
i – capability is inheritable (passed on from the parent process to child processes when a new process is created)
p – capability has permitted and inheritable attributes combined

This method empowers us as system administrators to comprehensively assess the capabilities associated with a specific process, aiding in system analysis, security evaluation, and efficient resource management.

## 5. Process Capabilities Analysis With libcap-ng and pscap

Next in our arsenal is **[libcap-ng](https://people.redhat.com/sgrubb/libcap-ng/)**, complemented by the **[pscap](https://man7.org/linux/man-pages/man8/pscap.8.html)** utility. The libcap-ng library provides functions for manipulating and interpreting capability sets. It allows programs to work with capabilities at a low level, making it easier to manage and control privileges for various processes.

Additionally, pscap is a utility that complements libcap-ng. It provides an easy-to-read overview of the practical capabilities associated with running processes on a Linux system. The combination of libcap-ng and pscap allows us to efficiently list the effective capabilities of processes in a digestible format.

However, we should note that while pscap offers an easy-to-read overview of the capabilities associated with running processes, it has limitations. It doesn’t provide information on which capabilities a process exercises during its execution but what it has been granted. This distinction is vital, primarily to minimize our applications’ privilege footprint.

## 5.1. Installing libcap-ng and pscap

To start working with libcap-ng and pscap, we must install the libcap-ng-utils package by using a package manager like apt:

```bash
$ sudo apt install libcap-ng-utils
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
  libcap-ng0
Suggested packages:
  libcap-ng-doc
The following NEW packages will be installed:
  libcap-ng-utils libcap-ng0
0 upgraded, 2 newly installed, 0 to remove and 17 not upgraded.
```

Here, we install the libcap-ng library with apt.

## 5.2. Viewing Process Capabilities

Once the libcap-ng-utils package installation completes, we can now use the pscap utility to view the capabilities of various processes:

```bash
$ pscap
ppid  pid   name        command           capabilities
1     480   root        lvmetad           full
1     492   root        systemd-udevd     full
...
1     1209  root        NetworkManager    dac_override, kill, ...
```

As we can see, the output of the pscap command provides a tabular representation of the capabilities possessed by various processes running on the system:

- ppid (Parent Process ID) – shows the Process ID of the parent process that spawned the current process
- pid (Process ID) – displays the unique identifier assigned to each running process on our system
- name – lists the username associated with the process
- command – shows the name of the executable or command that initiated the process by indicating what the process is doing or which application it belongs to
- capabilities – displays the capabilities granted to each process

Furthermore, each entry in the table corresponds to a running process. The capabilities listed in the capabilities column indicate the various privileges assigned to each process. For example, our process with PID 1209, named NetworkManager and owned by the root user, has been granted the following capabilities – dac_override, kill, and potentially others that are truncated in the output. These capabilities allow the process to override discretionary access controls, send signals to other processes, and potentially more, depending on the complete list of capabilities.
