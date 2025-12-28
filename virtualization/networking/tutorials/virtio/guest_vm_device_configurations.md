# **[Guest Virtual Machine Device Configuration](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/chap-guest_virtual_machine_device_configuration)**

Red Hat Enterprise Linux 7 supports three classes of devices for guest virtual machines:

- Emulated devices are purely virtual devices that mimic real hardware, allowing unmodified guest operating systems to work with them using their standard in-box drivers.

- Virtio devices (also known as paravirtualized) are purely virtual devices designed to work optimally in a virtual machine. Virtio devices are similar to emulated devices, but non-Linux virtual machines do not include the drivers they require by default. Virtualization management software like the Virtual Machine Manager (virt-manager) and the Red Hat Virtualization Hypervisor install these drivers automatically for supported non-Linux guest operating systems. Red Hat Enterprise Linux 7 supports up to 216 virtio devices. For more information, see Chapter 5, KVM Paravirtualized (virtio) Drivers.

- Assigned devices are physical devices that are exposed to the virtual machine. This method is also known as passthrough. Device assignment allows virtual machines exclusive access to PCI devices for a range of tasks, and allows PCI devices to appear and behave as if they were physically attached to the guest operating system. Red Hat Enterprise Linux 7 supports up to 32 assigned devices per virtual machine.
Device assignment is supported on PCIe devices, including select graphics devices. Parallel PCI devices may be supported as assigned devices, but they have severe limitations due to security and system configuration conflicts.
