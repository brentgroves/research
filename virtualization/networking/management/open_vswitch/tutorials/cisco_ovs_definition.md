# **[Open vSwitch (OVS)](https://www.cisco.com/c/en/us/support/docs/routers/enterprise-nfv-infrastructure-software/221679-understand-nfvis-virtual-networks-ovs.html#:~:text=Open%20vSwitch%20(OVS)%20is%20an%20open%2Dsource%2C%20multi%2Dlayer,sFlow%2C%20IPFIX%2C%20RSPAN%2C%20CLI%2C%20LACP%2C%20and%20802.1ag.&text=It%20uses%20virtual%20network%20bridges%20and%20flows%20rules%20to%20forward%20packets%20between%20hosts.)**

## Open vSwitch (OVS)

Open vSwitch (OVS) is an open-source, multi-layer virtual switch designed to enable network automation through programmatic extensions, while providing support for standard management interfaces and protocols, such as NetFlow, sFlow, IPFIX, RSPAN, CLI, LACP, and 802.1ag. Its widely used in large virtualized environments, particularly with hypervisors to manage network traffic between virtual machines (VMs). It allows for the creation of sophisticated network topologies and policies directly managed through the NFVIS interface, providing a versatile environment for network function virtualization.

![i1](https://www.cisco.com/c/dam/en/us/support/docs/routers/enterprise-nfv-infrastructure-software/221679-understand-nfvis-virtual-networks-ovs-03.png)

Figure 4. OVS configuration within the Linux kernel

## OVS Bridges

It uses virtual network bridges and flows rules to forward packets between hosts. It behaves like a physical switch, only virtualized.

![i2](https://www.cisco.com/c/dam/en/us/support/docs/routers/enterprise-nfv-infrastructure-software/221679-understand-nfvis-virtual-networks-ovs-04.png)

Figure 5. Example implementation of 2 VMs or VNFs attached to the wan-br bridge

VNF, or Virtual Network Function, refers to the software implementation of network functions, like firewalls or load balancers, that were traditionally performed by dedicated hardware appliances. VNFs are key components of Network Function Virtualization (NFV), allowing these functions to be virtualized and run on standard servers.

## Context Switching Deficits

When a network packet arrives at a network interface card (NIC), it triggers an interrupt, a signal to the processor indicating that it needs immediate attention. The CPU pauses its current tasks to handle the interrupt, a process known as interrupt processing. During this phase, the CPU, under the control of the operating system kernel, reads the packet from the NIC into memory and decides the next steps based on the packet destination and purpose. The goal is to quickly process or route the packet to its intended application, minimizing latency and maximizing throughput.

Context switching is the process by which a CPU switches from executing tasks in one environment (context) to another. This is particularly relevant when moving between user mode and kernel mode:

- **User Mode:** This is a restricted processing mode where most applications run. Applications in user mode do not have direct access to hardware or reference memory and must communicate with the operating system kernel to perform these operations.

- **Kernel Mode:** This mode grants the operating system full access to the hardware and all memory. The kernel can execute any CPU instruction and reference any memory address. Kernel mode is required for performing tasks like managing hardware devices, memory, and executing system calls.

When an application needs to perform an operation that requires kernel-level privileges (such as reading a network packet), a context switch occurs. The CPU transitions from user mode to kernel mode to execute the operation. Once completed, another context switch returns the CPU to user mode to continue executing the application. This switching process is critical for maintaining system stability and security but introduces overhead that can affect performance.

OVS mainly runs in the operating system user space, which can become a bottleneck as data throughput increases. This is because more context switches are needed for the CPU to move to kernel mode to process packets, slowing down performance. This limitation is particularly noticeable in environments with high packet rates or when precise timing is crucial. To address these performance limitations and meet the demands of modern, high-speed networks, technologies like DPDK (Data Plane Development Kit) and SR-IOV (Single Root I/O Virtualization) were developed.

The Data Plane Development Kit (DPDK) is an open source software project managed by the Linux Foundation. It provides a set of data plane libraries and network interface controller polling-mode drivers for offloading TCP packet processing from the operating system kernel to processes running in user space. This offloading achieves higher computing efficiency and higher packet throughput than is possible using the interrupt-driven processing provided in the kernel.

## Data Plane Development Kit (DPDK)

DPDK is a set of libraries and drivers designed to accelerate packet processing workloads on a wide range of CPU architectures. By bypassing the traditional kernel networking stack (avoiding context switching), DPDK can significantly increase data plane throughput and reduce latency. This is particularly beneficial for high-throughput VNFs that require low-latency communication, making NFVIS an ideal platform for performance-sensitive network functions.

![i2](https://www.cisco.com/c/dam/en/us/support/docs/routers/enterprise-nfv-infrastructure-software/221679-understand-nfvis-virtual-networks-ovs-05.png)

Figure 6. Traditional OVS (left-hand side) and DPDK OVS (right-hand side) context switching optimizations

Support for DPDK for OVS started in NFVIS 3.10.1 for ENCS and 3.12.2 for other platforms.

Cisco Enterprise NFV Infrastructure Software (#NFVIS). NFVIS is the software platform that implements full life cycle management from the central orchestrator and controller (APIC-EM and ESA) for virtualized services. NFVIS enables the connectivity between virtual services and external interfaces as well as supporting the underlying hardware. You can think of NFVIS as a software virtual platform that has the following key capabilities:

Platform management supports not only network and platform resources such as CPU/Memory/Storage, but also to enable higher network performance functions such as SR-IOV (for those that are not familiar with Intel’s SR-IOV, here is a good **[primer](http://www.intel.com/content/www/us/en/pci-express/pci-sig-sr-iov-primer-sr-iov-technology-paper.html)**);
A virtualization layer that implements a Linux KVM hypervisor and virtual switch. This layer abstracts the service functions implemented by each VNF from the underlying hardware. NFVIS allows VNFs to be managed independently and to be provisioned dynamically.
Programmable API interface for REST and NETCONF used to control all aspects of the virtual services life cycle management.
Health monitoring system watches over the critical processes of the system that can also be accessed via the NFVIS API.

Service Chain throughput near SRIOV, better than non-DPDK OVS.
Virtio driver required for VNF.
Supported platforms:
ENCS 3.10.1 onwards.
UCSE, UCS-C, CSP5K 3.12.1 onwards.
DPDK for port-channels supported since 4.12.1.
Packet /traffic capture : Not supported in DPDK.
Span traffic on PNIC : Not supported in DPDK.
After OVS-DPDK is enabled, it cannot be disabled as an individual feature. Only way to disable DPDK would be a factory reset.

## Data Copying

Traditional networking approaches often require that data be copied multiple times before reaching its destination in the VM memory. For example, a packet must be copied from the NIC to the kernel space, then to the user space for processing by a virtual switch (like OVS), and finally to the VM memory. Each copy operation incurs a delay and increases CPU utilization despite the performance improvements DPDK offers by bypassing the kernels networking stack.

These overheads include memory copies and the processing time needed to handle packets in user space before they can be forwarded to the VM. PCIe Passthrough and SR-IOV addresses these bottlenecks by allowing a physical network device (like a NIC) to be shared directly among multiple VMs without involving the host operating system to the same extent as traditional virtualization methods.

## PCIe Passthrough

The strategy involves bypassing the hypervisor to allow Virtual Network Functions (VNFs) direct access to a Network Interface Card (NIC), achieving nearly maximum throughput. This approach is known as PCI passthrough, which lets a complete NIC be dedicated to a guest operating system without the intervention of a hypervisor. In this setup, the virtual machine operates as though its directly connected to the NIC. For instance, with two NIC cards available, each one can be exclusively assigned to different VNFs, providing them direct access.

However, this method has a drawback: if only two NICs are available and exclusively used by two separate VNFs, any additional VNFs, such as a third one, would be left without NIC access due to the lack of a dedicated NIC available for it. An alternative solution involves using Single Root I/O Virtualization (SR-IOV).

## Single Root I/O Virtualization (SR-IOV)

Is a specification that allows a single physical PCI device, like a network interface card (NIC), to appear as multiple separate virtual devices. This technology provides direct VM access to physical network devices, reducing overhead and improving I/O performance. It works by dividing a single PCIe device into multiple virtual slices, each assignable to different VMs or VNFs, effectively solving the limitation caused by a finite number of NICs. These virtual slices, known as Virtual Functions (VFs), allow for shared NIC resources among multiple VNFs. The Physical Function (PF) refers to the actual physical component that facilitates SR-IOV capabilities.

By leveraging SR-IOV, NFVIS can allocate dedicated NIC resources to specific VNFs, ensuring high performance and low latency by facilitating Direct Memory Access (DMA) of network packets directly into the respetive VM memory. This approach minimizes CPU involvement to merely processing the packets, thus lowering CPU usage. This is especially useful for applications that require guaranteed bandwidth or have stringent performance requirements.
