# **[unshare]()**

The unshare command in Linux is used to execute a program in new, isolated namespaces. Namespaces are a fundamental concept in Linux that provide resource isolation, allowing a process or group of processes to have their own view of certain system resources, separate from other processes on the system.

How unshare works:
When you run a command with unshare, it creates a new instance of one or more specified namespaces for the executed program. This means that the changes made within these new namespaces (e.g., changing the hostname in a new UTS namespace) will only affect processes within that specific namespace and will not impact the rest of the system.
