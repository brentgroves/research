# **[](https://www.veritas.com/support/en_US/doc/79548079-166315497-0/v63112214-166315497)**

VirtIO disk drives
VirtIO is an abstraction layer for paravirtualized hypervisors in Kernel-based Virtual Machine (KVM) technology. Unlike full virtualization, VirtIO requires special paravirtualized drivers running in each VM guest. VirtIO provides support for many devices including network devices and block (disk) devices. Using VirtIO to export block devices to a host allows files, VxVM volumes, DMP meta-nodes, SCSI devices or any other type of block device residing on the host to be presented to the VM guest. When SCSI devices are presented to a VM guest using VirtIO, in addition to simple reads and writes, SCSI commands such as SCSI inquiry commands can be performed, which allows VxVM in the guest to perform deep device discovery. Running VxVM and DMP on the host and on the VM guest provides for consistent naming of SCSI devices from the array to the host through to the VM guest.

Paravirtualization is a virtualization technique where the guest operating system is aware of the virtualization layer (hypervisor) and is modified to interact with it directly, rather than through full hardware emulation. This direct interaction, often using hypercalls, can lead to performance improvements compared to full virtualization, especially for I/O intensive operations.

Yes, Nutanix AHV utilizes paravirtualized devices, specifically virtio-scsi for storage and virtio-net for networking, to enhance VM performance. These devices are designed to minimize overhead when interacting with the hypervisor, resulting in improved I/O and network throughput.
Elaboration:
Paravirtualization:
In the context of virtualization, paravirtualization involves modifying the guest operating system to work more efficiently with the hypervisor. Instead of emulating hardware, the guest OS is aware of the virtualization layer and communicates with it directly, leading to performance gains.
VirtIO:
Nutanix AHV leverages VirtIO, a paravirtualized framework, for both storage and networking.
VirtIO-SCSI:
For storage, AHV uses virtio-scsi as the default virtual SCSI controller. This controller is designed for high-performance I/O and is integrated into the Linux kernel, meaning most Linux distributions will have the necessary drivers built-in.
VirtIO-Net:
For networking, AHV utilizes virtio-net as the default virtual network interface card (vNIC). The virtio-net driver is also part of the Linux kernel, simplifying configuration and enabling optimal network performance.
