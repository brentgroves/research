# **[Introduction to virtio-networking and vhost-net](https://www.redhat.com/en/blog/deep-dive-virtio-networking-and-vhost-net)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

In this post we will explain the vhost-net architecture described in the introduction, to make it clear how everything works together from a technical point of view. This is part of the series of blogs that introduces you to the realm of virtio-networking which brings together the world of virtualization and the world of networking.

This post is intended for architects and developers who are interested in understanding what happens under the hood of the vhost-net/virtio-net architecture described in the previous blog.

We'll start by describing how the different virtio spec standard components and shared memory regions are arranged in the hypervisor, how QEMU emulates a virtio network device and how the guest uses the open virtio specification to implement the virtualized driver for managing and communicating with that device.

After showing you the QEMU virtio architecture we will analyze the I/O bottlenecks and limitations and we will use the host’s kernel to overcome them, reaching the vhost-net architecture presented in the overview post (link).

Last, but not least, we will show how to connect the virtual machine to the external word, beyond the host it’s running on, using Open Virtual Switch (OVS), an open source virtual, SDN-capable, distributed switch.

By the end of this post, you’ll be able to understand how the vhost-net/virtio-net architecture works, the purpose of each of its components and how packets are sent and received.

## Previous Concepts

In this section we will briefly explain a few concepts that you need to know in order to fully understand this post. It might seem basic for the well-versed in the matter, but it will provide a common foundation to build on.

## Networking

Let’s start with the basics. A physical NIC (Network Interface Card) is the hardware (real) component that allows the host to connect to the external world. It can perform some offloading, like performing a checksum calculation in the NIC instead of the CPU, Segmentation Offload (fragment a larger piece of data into small chunks, like ethernet MTU size) or Large Receive Offload (join many received packets’ data into only one for the CPU point of view).

On the other side we have tun/tap devices, virtual point-to-point network devices that the userspace applications can use to exchange packets. The device is called a tap device when the data exchanged is layer 2 (ethernet frames), and a tun device if the data exchanged is layer 3 (IP packets).

When the tun kernel module is loaded it creates a special device /dev/net/tun. A process can create a tap device opening it and sending special ioctl commands to it. The new tap device has a name in the /dev filesystem and another process can open it, send and receive Ethernet frames.

## IPC, System programming

Unix sockets are a way to do Inter-Process Communication (IPC) on the same machine in an efficient way. In this post scope, the server of the communication binds a Unix socket to a path in the file system, so a client can connect to it using that path. From that moment, the processes can exchange messages. Note that unix sockets can also be used to exchange file descriptors between processes.

An eventfd is a lighter way of performing IPC. While Unix sockets allows to send and receive any kind of data, eventfd is only an integer that a producer can change and a consumer can poll and read. This makes them more suitable as a wait/notify mechanism, rather than information passing.

Both of these IPC systems expose a file descriptor for each process in the communication. The fcntl call performs different operations on that file descriptors, as making them non-blocking (so a read operation returns immediately if there is nothing to read). The ioctl call follows the same pattern, but implementing device-specific operations, like sending commands.

Shared memory is the last method of IPC we will cover here. Instead of providing a channel to communicate two process, it makes some of the processes’ memory regions point to the same memory page, so the change that one process writes over it affects the subsequent reads the other make.

## QEMU and device emulation

QEMU is a hosted virtual machine emulator that provides a set of different hardware and device models for the guest machine. For the host, qemu appears as a regular process scheduled by the standard Linux scheduler, with its own process memory. In the process, QEMU allocates a memory region that the guest see as physical, and executes the virtual machine’s CPU instructions.

To perform I/O on bare metal hardware, like storage or networking, the CPU has to interact with physical devices performing special instructions and accessing particular memory regions, such as the ones that the device is mapped to.

When the guests access these memory regions, control is returned to QEMU, which performs the device’s emulation in a transparent manner for the guest.

## KVM

Kernel-based Virtual Machine (KVM) is an open source virtualization technology built into Linux. It provides hardware assist to the virtualization software, using built-in CPU virtualization technology to reduce virtualization overheads (cache, I/O, memory) and improving security.

With KVM, QEMU can just create a virtual machine with virtual CPUs (vCPUs) that the processor is aware of, that runs native-speed instructions. When a special instruction is reached by KVM, like the ones that interacts with the devices or to special memory regions, vCPU pauses and informs QEMU of the cause of pause, allowing hypervisor to react to that event.

In the regular KVM operation, the hypervisor opens the device /dev/kvm, and communicates with it using ioctl calls to create the VM, add CPUs, add memory (allocated by qemu, but physical from the virtual machine’s point of view), send CPU interrupts (as an external device would send), etc. For example, one of these ioctl runs the actual KVM vCPU,, blocking QEMU and making the vCPU run until it found an instruction that needs hardware assistance. In that moment, the ioctl returns (this is called vmexit) and QEMU knows the cause of that exit (for example, the offending instruction).

For special memory regions, KVM follows a similar approach, marking memory regions as Read Only or not mapping them at all, causing a vmexit with the KVM_EXIT_MMIO reason.

## **[The virtio specification(START HERE)](https://www.redhat.com/en/blog/deep-dive-virtio-networking-and-vhost-net)
