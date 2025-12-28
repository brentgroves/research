# **[dpdk](https://www.dpdk.org/)**

1. Mission of the Data Plane Development Kit
The mission of DPDK is to:

Create an open source, production quality, vendor neutral software platform for enabling fast packet processing, upon which users can build and run data plane applications.
Host the infrastructure for the DPDK community, establishing a neutral home for community assets, meetings, events and collaborative discussions.

## what is dpdk

DPDK (Data Plane Development Kit) is an open-source software framework that provides a set of libraries and drivers for fast packet processing by enabling applications to bypass the Linux kernel network stack. It achieves high-performance networking by running packet processing in user space, using Poll Mode Drivers (PMDs) to directly access network interfaces and eliminate the overhead of interrupt handling. DPDK is used in applications like network function virtualization (NFV) and advanced network switching to achieve high throughput and low latency.  

How DPDK Works

- Kernel Bypass: DPDK moves network packet processing from the kernel to user-space applications, which dramatically reduces the CPU cycles required.
- Poll Mode Drivers (PMDs): Instead of relying on the kernel's interrupt-driven model, DPDK uses PMDs that continuously poll network devices for new packets, ensuring constant and efficient data flow.
- Environment Abstraction Layer (EAL): The EAL provides a consistent programming interface, abstracting the hardware and system details so applications can be written in a hardware-agnostic way.
- User-Space Memory Management: DPDK includes memory management features like huge pages and memory pools to efficiently allocate and manage memory buffers, further improving performance.
