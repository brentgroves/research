# **[Writing a KVM hypervisor VMM in Python](https://www.devever.net/~hl/kvm)**

**[Back to Research List](../../../../../research_list.md)**\
**[Back to Current Status](../../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../../README.md)**

Linux's Kernel Virtual Machine (KVM) is a hypervisor built into the Linux kernel. Whereas in the past Xen proved a more popular hypervisor for multi-tenant clouds — being the original basis of AWS EC2, for example — over the years Linux's own hypervisor has matured and grown in popularity, and now eclipsed Xen as the hypervisor of preference for many clouds. AWS at some point switched to KVM (though it's unclear to me if they still use it or a custom hypervisor at this point), and Google Cloud has used KVM from the beginning.

AWS Virtual Servers (Instances):
EC2 provides virtual machines, or instances, that users can launch and configure with different operating systems, software, and hardware configurations.

There are probably many reasons for this, but two in particular come to mind:

The greater ease of administration offered by KVM. Since KVM virtual machines are created and maintained by ordinary processes on Linux, **a VM essentially just looks like an ordinary long-running process**, and can be launched, managed and terminated accordingly. By comparison, Xen requires the reconfiguration of the system's boot process to boot Xen before Linux, and requires its virtual machines to be managed using Xen-specific commands.

The higher flexibility of KVM. In particular, KVM features a clean separation between the hypervisor and the VMM, which is discussed below. This allows the same KVM hypervisor to power many different VMMs, which has unlocked a lot of innovation in the VMM space.
