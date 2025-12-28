# **[VMs versus Containers](https://www.mssqltips.com/sqlservertip/5907/getting-started-with-windows-containers-for-sql-server-part-1/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Multipass Menu](../virtualization_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## VMs versus Containers

Given the nature of containers, you might get confused as to how different they are from virtual machines. To illustrate, below is a diagram of the hypervisor architecture.

![](https://www.mssqltips.com/tipimages2/5907_introduction-containers-sql-server-dba.001.png)

Virtualization solves a totally different IT problem on its own: hardware overprovisioning. In the past, IT would provision hardware that is barely even using half of the available resource. This is wasted resource. So, instead of buying expensive hardware for a specific application without knowledge of present or future capacity, you can run them on virtual machines with minimal resources. You can scale the virtual machines up in the future if and when the workload increases. Even better, you can run multiple virtual machines on a single physical machine. The only time IT would buy hardware is when there really is a need for it.

However, virtualization came with its own sets of challenges. For one, each virtual machine requires its own copy of the operating system before you can even run applications inside them. Each operating system consumes a fair amount of hardware resources from the physical host – virtual CPU, memory and storage. Plus, if every virtual machine runs the same operating system, you are basically creating and running multiple copies of the operating system, each requiring the same amount of administrative overhead like securing, patching and monitoring. Wouldn't it be great if you only had one operating system that runs the different applications but in an isolated process, so they don't interfere with one another, much like how one application is isolated from another thru virtual machines?

This is where containers come in.

![](https://www.mssqltips.com/tipimages2/5907_introduction-containers-sql-server-dba.002.png)

In the diagram above, you only have one operating system. The containers share the same operating system kernel with other containers, each one running as isolated processes in user space. **Instead of abstracting the hardware like what virtualization does, containers abstract the operating system kernel.** This reduces the amount of storage space requirement for containers, eliminating the inefficiencies of having multiple copies of the operating system running on guest virtual machines. It also significantly reduces the amount of administrative overhead necessary to manage operating systems. Plus, they use far fewer resources than virtual machines.

And since containers do not have a full-blown operating system, they can be easily started and stopped in a "just-in-time" fashion, quickly spinning up containers when the need arises. This is a huge benefit when dealing with fast software development lifecycles and having the right environment that comes with it. Imagine having a developer build an application and deploying it in a container that can be moved across different computing environments, from his workstation to a production server, while eliminating the very common "but it worked in my laptop" comment.

## Linux, Containers and Docker

The idea behind containers started with virtualizing the Linux operating system kernel. This is the reason why it is very popular in the Linux community. As a SQL Server DBA who only worked with Windows in most of your career, this can be a little bit intimidating, especially if you haven't worked with Linux just yet. Don't fret. Windows Server 2016 has support for containers, so you can start working with it in a familiar environment. In fact, this tip will get you started on deploying containers on a Windows Server 2016 environment.

However, you do need to have a basic understanding of Linux to fully maximize containers.

And because containers were built to virtualize the operating system kernel, the container image needs to share the same operating system as the underlying engine. That's not to say that you cannot run both Windows and Linux containers on the same container engine, like running a Windows and Linux virtual machine on the same hypervisor. But it isn't a good idea from an operations standpoint.

In a previous tip on **[Run SQL Server vNext (CTP1) as a Docker Container on a Mac](https://www.mssqltips.com/sqlservertip/4602/run-sql-server-vnext-ctp1-as-a-docker-container-on-a-mac/)**, you've seen how to leverage Docker with a SQL Server running in a container. But what is Docker?

Docker is a container engine developed by Docker, Inc. based on the concept of virtualizing the Linux operating system kernel. Docker is to container engine much like how VMWare is to virtualization. Learning the different docker commands to work with the Docker container engine – for SQL Server on both Windows and Linux - will be the focus of this series of tips.

Let's get started with setting up Docker on a Windows Server 2016 machine.
