# **[Google Cloud](https://cloud.google.com/learn/what-is-a-virtual-machine)**

## Types of virtual machines

Generally speaking, there are two types of virtual machines: process VMs and system VMs.

- Process VM: A process VM, also called an application virtual machine or managed runtime environment (MRE), creates a virtual environment of an OS while an app or single process is running and destroys it as soon as you exit. Process VMs enable creating a platform-independent environment that lets an app or process run the same way on any platform.
- System VM: A system VM (sometimes called hardware virtual machines) simulates a complete operating system, allowing multiple OS environments to live on the same machine. Typically, this is the type of VM people are referring to when they talk about “virtual machines.” System VMs can run their own OS and applications, and a hypervisor monitors and distributes the physical host machine’s resources between system VMs.
