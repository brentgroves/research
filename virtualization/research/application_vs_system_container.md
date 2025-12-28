# **[Containers vs Virtual Machines](https://www.techtarget.com/searchitoperations/definition/application-containerization-app-containerization)**

![](https://cdn.ttgtmedia.com/rms/onlineimages/containers_vs_virtual_machines-f.png)

## What is application containerization (app containerization)?

Application containerization is a virtualization technology that works at the operating system (OS) level. It is used for deploying and running distributed applications in their own isolated environments, without the use of virtual machines (VMs). IT teams can host multiple containers on the same server, each running an application or service. The containers access the same OS kernel and use the same physical resources. Containers can run on bare-metal servers, virtual machines or cloud platforms. Most containers run on Linux servers, but they can also run on select Windows and macOS computers.

## What is a system container?

Another type of container is the system container. The system container performs a role similar to virtual machines but without hardware virtualization. A system container, also called an infrastructure container, runs its own guest OS. It includes its own application libraries and execution code. System containers can host application containers.

Although system containers also rely on images, the container instances are generally long-standing and not momentary like application containers. An administrator updates and changes system containers with configuration management tools rather than destroying and rebuilding images when a change occurs. Canonical Ltd., developer of the Ubuntu Linux operating system, leads the LXD, or Linux container hypervisor, system containers project. Another system container option is OpenVZ.
