# **[Paravirtualized Devices](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/virtualization_getting_started_guide/paravirtdevices#paravirtdevices)**

## AI Overview: who makes virtio-net

Virtio-net, a networking para-virtualization solution, is developed and maintained by the Linux Kernel community, the Data Plane Development Kit (DPDK) community, QEMU, and OASIS, among others, forming the broader virtio-networking community.

## **[virtio-net](https://projectacrn.github.io/latest/developer-guides/hld/virtio-net.html)**

## **[Linux virtio](https://docs.kernel.org/driver-api/virtio/virtio.html)**

## Paravirtualized Devices

Paravirtualization provides a fast and efficient means of communication for guests to use devices on the host machine. KVM provides paravirtualized devices to virtual machines using the virtio API as a layer between the hypervisor and guest.
Some paravirtualized devices decrease I/O latency and increase I/O throughput to near bare-metal levels, while other paravirtualized devices add functionality to virtual machines that is not otherwise available. It is recommended to use paravirtualized devices instead of emulated devices for virtual machines running I/O intensive applications.
All virtio devices have two parts: the host device and the guest driver. Paravirtualized device drivers make it possible for the guest operating system access to physical devices on the host system.
The paravirtualized device drivers must be installed on the guest operating system. By default, the paravirtualized device drivers are included in Red Hat Enterprise Linux 4.7 and later, Red Hat Enterprise Linux 5.4 and later, and Red Hat Enterprise Linux 6.0 and later. The paravirtualized device drivers must be manually installed on Windows guests.

The paravirtualized network device (virtio-net)
The paravirtualized network device is a virtual network device that provides network access to virtual machines with increased I/O performance and lower latency.
The paravirtualized block device (virtio-blk)
The paravirtualized block device is a high-performance virtual storage device with that provides storage to virtual machines with increased I/O performance and lower latency. The paravirtualized block device is supported by the hypervisor and is attached to the virtual machine (except for floppy disk drives, which must be emulated).
The paravirtualized controller device (virtio-scsi)
The paravirtualized SCSI controller device is a new feature in Red Hat Enterprise Linux 6.4 that provides a more flexible and scalable alternative to virtio-blk. A virtio-scsi guest is capable of inheriting the feature set of the target device, and can handle hundreds of devices compared to virtio-blk, which can only handle 28 devices.
In Red Hat Enterprise Linux 6.4 and above, virtio-scsi is fully supported for the following guest operating systems:
Red Hat Enterprise Linux 6.4 and above
Windows Server 2008
Windows 7
Windows Server 2012
Windows 8 (32/64 bit)
The paravirtualized clock
Guests using the Time Stamp Counter (TSC) as a clock source may suffer timing issues. KVM works around hosts that do not have a constant Time Stamp Counter by providing guests with a paravirtualized clock. Additionally, the paravirtualized clock assists with time adjustments needed after a guest runs the sleep (S3) or suspend to RAM operations.
The paravirtualized serial device (virtio-serial)
The paravirtualized serial device is a bytestream-oriented, character stream device, and provides a simple communication interface between the host's user space and the guest's user space.
The balloon device (virtio-balloon)
The balloon device can designate part of a virtual machine's RAM as not being used (a process known as inflating the balloon), so that the memory can be freed for the host (or for other virtual machines on that host) to use. When the virtual machine needs the memory again, the balloon can be deflated and the host can distribute the RAM back to the virtual machine.
The paravirtualized graphics card (QXL)
The paravirtualized graphics card works with the QXL driver to provide an efficient way to display a virtual machine's graphics from a remote host. The QXL driver is required to use SPICE.
