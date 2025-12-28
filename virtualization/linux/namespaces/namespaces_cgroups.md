# **[What Are Namespaces and cgroups, and How Do They Work?](https://blog.nginx.org/blog/what-are-namespaces-cgroups-how-do-they-work#:~:text=A%20control%20group%20(cgroup)%20is%20a%20Linux,so%20on)**

**[Research List](../../../../research_list.md)**\
**[Detailed Status](../../../../../a_status/detailed_status.md)**\
**[Curent Tasks](../../../../../a_status/current_tasks.md)**\

**[Main](../../../../../README.md)**

## references

- **[ubuntu process capabilities list](https://manpages.ubuntu.com/manpages/trusty/man7/capabilities.7.html#:~:text=The%20%2Fproc%2FPID%2Ftask,of%20a%20process's%20main%20thread.)**

Recently, I have been investigating NGINX Unit, our open source multi-language application server. As part of my investigation, I noticed that Unit supports both namespaces and cgroups, which enables process isolation. In this blog, we’ll look at these two major Linux technologies, which also underlie containers.

Containers and associated tools like Docker and Kubernetes have been around for some time now. They have helped to change how software is developed and delivered in modern application environments. Containers make it possible to quickly deploy and run each piece of software in its own segregated environment, without the need to build individual virtual machines (VMs).

Most people probably give little thought to how containers work under the covers, but I think it’s important to understand the underlying technologies – it helps to inform our decision‑making processes. And personally, fully understanding how something works just makes me happy!

## What Are Namespaces?

Namespaces have been part of the Linux kernel since about 2002, and over time more tooling and namespace types have been added. Real container support was added to the Linux kernel only in 2013, however. This is what made namespaces really useful and brought them to the masses.

AI Overview "To manage and interact with Linux namespaces, you can use tools like lsns, ip netns, and unshare, which are part of the util-linux and iproute2 packages, respectively.:

wikipedia: “Namespaces are a feature of the Linux kernel that partitions kernel resources such that one set of processes sees one set of resources while another set of processes sees a different set of resources.”

In other words, the key feature of namespaces is that they isolate processes from each other. On a server where you are running many different services, isolating each service and its associated processes from other services means that there is a smaller blast radius for changes, as well as a smaller footprint for security‑related concerns. Mostly though, isolating services meets the architectural style of microservices as described by **[Martin Fowler](https://martinfowler.com/articles/microservices.html)**.

Using containers during the development process gives the developer an isolated environment that looks and feels like a complete VM. It’s not a VM, though – it’s a process running on a server somewhere. If the developer starts two containers, there are two processes running on a single server somewhere – but they are isolated from each other.

## Types of Namespaces

Within the Linux kernel, there are different types of namespaces. Each namespace has its own unique properties:

- A **[user namespace](https://man7.org/linux/man-pages/man7/user_namespaces.7.html)** has its own set of user IDs and group IDs for assignment to processes. In particular, this means that a process can have root privilege within its user namespace without having it in other user namespaces.

- A **[process ID (PID) namespace](https://man7.org/linux/man-pages/man7/pid_namespaces.7.html)** assigns a set of PIDs to processes that are independent from the set of PIDs in other namespaces. The first process created in a new namespace has PID 1 and child processes are assigned subsequent PIDs. If a child process is created with its own PID namespace, it has PID 1 in that namespace as well as its PID in the parent process’ namespace. See below for an example.

- A **[network namespace](https://man7.org/linux/man-pages/man7/network_namespaces.7.html)** has an independent network stack: its own private routing table, set of IP addresses, socket listing, connection tracking table, firewall, and other network‑related resources.

Connection tracking (“conntrack”) is a core feature of the Linux kernel's networking stack. It allows the kernel to keep track of all logical network connections or flows, and thereby identify all of the packets which make up each flow so they can be handled consistently together.

- A **[mount namespace](https://man7.org/linux/man-pages/man7/mount_namespaces.7.html)** has an independent list of mount points seen by the processes in the namespace. This means that you can mount and unmount filesystems in a mount namespace without affecting the host filesystem.

- An **[interprocess communication (IPC) namespace](https://man7.org/linux/man-pages/man7/ipc_namespaces.7.html)** has its own IPC resources, for example **[POSIX message queues](https://man7.org/linux/man-pages/man7/mq_overview.7.html)**.

POSIX message queues allow processes to exchange data in the form of messages.  This API is distinct from that provided by System V        message queues (msgget(2), msgsnd(2), msgrcv(2), etc.), but provides similar functionality.

- A **[UNIX Time‑Sharing (UTS) namespace](https://man7.org/linux/man-pages/man7/uts_namespaces.7.html)** allows a single system to appear to have different host and domain names to different processes.

## An Example of Parent and Child PID Namespaces

In the diagram below, there are three PID namespaces – a parent namespace and two child namespaces. Within the parent namespace, there are four processes, named PID1 through PID4. These are normal processes which can all see each other and share resources.

The child processes with PID2 and PID3 in the parent namespace also belong to their own PID namespaces in which their PID is 1. From within a child namespace, the PID1 process cannot see anything outside. For example, PID1 in both child namespaces cannot see PID4 in the parent namespace.

This provides isolation between (in this case) processes within different namespaces.

![p](https://nginxblog-8de1046ff5a84f2c-endpoint.azureedge.net/blobnginxbloga72cde487e/wp-content/uploads/2022/07/Namespaces-cgroups_PID-namespaces-1536x749.png)

## Creating a Namespace

With all that theory under our belts, let’s cement our understanding by actually creating a new namespace. The Linux unshare command is a good place to start. The **[manual page](https://man7.org/linux/man-pages/man1/unshare.1.html)** indicates that it does exactly what we want:
