# **[The Definitive KVM (Kernel-based Virtual Machine) API Documentation](https://docs.kernel.org/virt/kvm/api.html)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

## 1. General description¶

The kvm API is centered around different kinds of file descriptors and ioctls that can be issued to these file descriptors. An initial open(“/dev/kvm”) obtains a handle to the kvm subsystem; this handle can be used to issue system ioctls. A KVM_CREATE_VM ioctl on this handle will create a VM file descriptor which can be used to issue VM ioctls. A KVM_CREATE_VCPU or KVM_CREATE_DEVICE ioctl on a VM fd will create a virtual cpu or device and return a file descriptor pointing to the new resource.

In other words, the kvm API is a set of ioctls that are issued to different kinds of file descriptor in order to control various aspects of a virtual machine. Depending on the file descriptor that accepts them, ioctls belong to the following classes:

System ioctls: These query and set global attributes which affect the whole kvm subsystem. In addition a system ioctl is used to create virtual machines.

VM ioctls: These query and set attributes that affect an entire virtual machine, for example memory layout. In addition a VM ioctl is used to create virtual cpus (vcpus) and devices.

VM ioctls must be issued from the same process (address space) that was used to create the VM.

vcpu ioctls: These query and set attributes that control the operation of a single virtual cpu.

vcpu ioctls should be issued from the same thread that was used to create the vcpu, except for asynchronous vcpu ioctl that are marked as such in the documentation. Otherwise, the first ioctl after switching threads could see a performance impact.

device ioctls: These query and set attributes that control the operation of a single device.

device ioctls must be issued from the same process (address space) that was used to create the VM.

While most ioctls are specific to one kind of file descriptor, in some cases the same ioctl can belong to more than one class.

The KVM API grew over time. For this reason, KVM defines many constants of the form KVM_CAP_*, each corresponding to a set of functionality provided by one or more ioctls. Availability of these “capabilities” can be checked with KVM_CHECK_EXTENSION. Some capabilities also need to be enabled for VMs or VCPUs where their functionality is desired (see 6. Capabilities that can be enabled on vCPUs and 7. Capabilities that can be enabled on VMs).
