# **[What is KVM?](https://www.redhat.com/en/topics/virtualization/what-is-KVM)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

Kernel-based Virtual Machine (KVM) is an open source virtualization technology for Linux® operating systems. With KVM, Linux can function as a hypervisor that runs multiple, isolated virtual machines (VMs).

KVM was announced in 2006 and merged into the Linux kernel a year later. Many open source virtualization technologies, including Red Hat’s virtualization portfolio, depend on KVM as a component.

## What does a hypervisor do?

Virtualization, which lets you run an operating system (OS) within another OS, is possible thanks to hypervisors. A hypervisor pools computing resources—like processing, memory, and storage—and reallocates them among VMs. A hypervisor can run multiple VMs at once, manage them, and support the creation of new ones. The physical hardware, when used as a hypervisor, is called the host, while the many VMs that use its resources are guests.

Hypervisors need operating system-level components—such as a memory manager, process scheduler, input/output (I/O) stack, device drivers, security manager, a network stack, and more—to run VMs. KVM has all these components because it’s part of the Linux kernel. Every VM is implemented as a regular Linux process, scheduled by the standard Linux scheduler, with dedicated virtual hardware like a network card, graphics adapter, CPU(s), memory, and disks.

## What are the features of KVM?
With KVM, a VM is a Linux process, scheduled and managed by the kernel. VMs running with KVM benefit from the performance features of Linux, and users can take advantage of the fine-grained control provided by the Linux scheduler. KVM also brings features related to security, storage, hardware support, and live migration.

## Security boundaries with SELinux and sVirt
KVM uses a combination of Security-Enhanced Linux (SELinux) and sVirt for enhanced VM security and isolation. SELinux establishes security boundaries around VMs. sVirt extends SELinux’s capabilities, allowing Mandatory Access Control (MAC) security to be applied to guest VMs and preventing manual labeling errors.

## Storage flexibility
KVM is able to use any storage supported by Linux, including some local disks and network-attached storage (NAS). KVM also supports shared file systems so VM images may be shared by multiple hosts. 

## Support for multiple hardware architectures
KVM can run on a wide variety of hardware platforms. When used as part of Red Hat Enterprise Linux 9, KVM is supported with 64-bit AMD, Intel, and ARM architectures, as well as IBM z13 systems and later.

## Live migration
KVM supports live migration, which is the ability to move a running VM between physical hosts with no noticeable service interruption. The VM remains powered on, network connections remain active, and applications continue to run while the VM is relocated. KVM also saves a VM's current state so it can be stored and resumed later.

## How do you manage VMs with KVM?
When you’re running multiple VMs, a **[virtualization management](https://www.redhat.com/en/topics/virtualization/what-is-virtualization-management)** tool is helpful for keeping track of them. Some VM management tools run from the command line, others provide graphical user interfaces (GUIs), and others are designed to manage VMs across large enterprise environments. Here are a few common virtualization management solutions for KVM.

## libvirt and virsh

The libvirt project provides an API for managing virtualization platforms. Within libvirt, virsh is a command-line utility for creating, starting, listing, and stopping VMs, as well as entering a virtualization shell.

## Virtual Machine Manager

Virtual Machine Manager (known as VMM or virt-manager) provides a desktop interface for VMs, and is available for major Linux distributions.

## Web consoles

VM administrators can choose to manage their VMs using web-based interfaces. For example, Cockpit offers a solution that lets users manage VMs from a web interface. Red Hat Enterprise Linux offers a web console plug-in for virtualization.

## KubeVirt

**[KubeVirt](https://www.redhat.com/en/topics/virtualization/what-is-kubevirt)** is a solution for managing large numbers of VMs in a Kubernetes environment, where VMs can be managed alongside containerized applications. Kubevirt provides the foundation for Red Hat OpenShift® Virtualization.

