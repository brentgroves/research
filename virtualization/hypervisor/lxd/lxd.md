# **[LXD](<https://documentation.ubuntu.com/lxd#:~:text=LXD%20(%20%5Bl%C9%9Bks'di%3A%5D,inside%20containers%20or%20virtual%20machines>.)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../a_status/detailed_status.md)**\
**[Back to Main](../../../../../README.md)**

LXD ( [lɛks'di:] 🔈) is a modern, secure and powerful system container and virtual machine manager. It provides a unified experience for running and managing full Linux systems inside containers or virtual machines.

## What is application containerization (app containerization)?

Application containerization is a virtualization technology that works at the operating system (OS) level. It is used for deploying and running distributed applications in their own isolated environments, without the use of virtual machines (VMs). IT teams can host multiple containers on the same server, each running an application or service. The containers access the same OS kernel and use the same physical resources. Containers can run on bare-metal servers, virtual machines or cloud platforms. Most containers run on Linux servers, but they can also run on select Windows and macOS computers.

## What is a system container?

Another type of container is the system container. The system container performs a role similar to virtual machines but without hardware virtualization. A system container, also called an infrastructure container, runs its own guest OS. It includes its own application libraries and execution code. System containers can host application containers.

Although system containers also rely on images, the container instances are generally long-standing and not momentary like application containers. An administrator updates and changes system containers with configuration management tools rather than destroying and rebuilding images when a change occurs. Canonical Ltd., developer of the Ubuntu Linux operating system, leads the **LXD, or Linux container hypervisor**, system containers project. Another system container option is OpenVZ.

## **[LXD vs. LXC](https://documentation.ubuntu.com/lxd/en/latest/explanation/lxd_lxc/)**

LXD and LXC are two distinct implementations of Linux containers.

LXC is a low-level user space interface for the Linux kernel containment features. It consists of tools (lxc-* commands), templates, and library and language bindings.

LXD is a more intuitive and user-friendly tool aimed at making it easy to work with Linux containers. It is an alternative to LXC’s tools and distribution template system, with the added features that come from being controllable over the network. Under the hood, LXD uses LXC to create and manage the containers.

## **[LXD (Linux container hypervisor)](https://www.techtarget.com/searchitoperations/definition/LXD-Linux-container-hypervisor)**

LXD is an open source container management extension for Linux Containers (LXC). LXD both improves upon existing LXC features and provides new features and functionality to build and manage Linux containers.

LXD is a representational state transfer application programming interface (REST API) that communicates with LXC through the liblxc library. LXD also supplies a system daemon that applications can use to access LXC and has a template distribution system to enable faster container creation and operation.

Container users should understand that LXC is a Linux system container technology, which is, in some ways, similar to hypervisor-level virtualization, such as VMware ESXi, and, in other ways, similar to **[application containers](https://www.techtarget.com/searchitoperations/definition/application-containerization-app-containerization)**, such as Docker.

# **[Containers vs Virtual Machines](https://www.techtarget.com/searchitoperations/definition/application-containerization-app-containerization)**

![](https://cdn.ttgtmedia.com/rms/onlineimages/containers_vs_virtual_machines-f.png)
