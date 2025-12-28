# **[Unlocking Network Performance with XDP and eBPF](https://medium.com/@kcl17/unlocking-network-performance-with-xdp-and-ebpf-67c712128025)**

XDP, eXpress Data Path, is a high-performance networking technology in the Linux kernel that allows for fast and efficient packet processing at the earliest stage of the networking stack. It operates within the kernel space and provides a programmable interface for handling incoming packets directly on the network interface card (NIC), bypassing much of the traditional networking stack.

Press enter or click to view image in full size

![i1](https://miro.medium.com/v2/resize:fit:720/format:webp/1*p8XM2CN9dIAcjOntgAJaQQ.jpeg)

## Why XDP?

XDP is a technology that allows developers to attach eBPF programs to low-level hooks, implemented by network device drivers in the Linux kernel, as well as generic hooks that run after the device driver.

Press enter or click to view image in full size

![i2](https://miro.medium.com/v2/resize:fit:720/format:webp/0*QRsrfoBJ0_RxJOwp)

XDP can be used to achieve high-performance packet processing in an eBPF architecture, primarily using kernel bypass. This greatly reduces the overhead needed for the kernel, because it does not need to process context switches, network layer processing, interrupts, and so on. Control of the network interface card (NIC) is transferred to an eBPF program. This is especially important while working at higher network speeds — 10 Gbps and above.

The kernel bypass method has some drawbacks:

- eBPF programs have to write their own drivers.
- XDP programs run before packets are parsed. This means that eBPF programs must directly implement functionality they need to do their job, without relying on the kernel.

XDP makes it easier to implement high-performance networking in eBPF, by allowing eBPF programs to directly read and write network packet data, and determine how to process the packets, before reaching the kernel level.

XDP programs can be directly attached to a network interface. Whenever a new packet is received on the network interface, XDP programs receive a callback, and can perform operations on the packet very quickly.

You can connect an XDP program to an interface using the following models:

Generic XDP — XDP programs are loaded into the kernel as part of the ordinary network path. This does not provide full performance benefits, but is an easy way to test XDP programs or run them on generic hardware that does not provide specific support for XDP.
Native XDP — The XDP program is loaded by the network card driver as part of its initial receive path. This also requires support from the network card driver.
Offloaded XDP — The XDP program loads directly on the NIC, and executes without using the CPU. This requires support from the network interface device.
