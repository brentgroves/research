# **[Install KVM](https://www.webhi.com/how-to/install-configure-kvm-on-ubuntu-debian-linux/)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Networking Menu](../networking_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

KVM (Kernel-based Virtual Machine) is an open source virtualization technology that allows you to create and run virtual machines on Linux. KVM requires hardware virtualization support, which is available on most modern CPUs.

In this comprehensive guide, we will cover how to install and configure KVM on Ubuntu 20.04/22.04. We will go through the following steps:

## Prerequisites

Before we install KVM, let’s go over the prerequisites:

Ubuntu 20.04/22.04 operating system
Administrator (root) access to the system
Intel VT-x or AMD-V CPU virtualization support enabled in BIOS
At least 2 GB RAM (4 GB recommended)

To verify that your CPU supports hardware virtualization, run this command:

```bash
sudo apt install cpu-checker
kvm-ok                      
INFO: /dev/kvm exists
KVM acceleration can be used

```

or

```$ egrep -c '(vmx|svm)' /proc/cpuinfo```
If the output is 1 or greater, your CPU supports hardware virtualization.

You also need to ensure virtualization is enabled in BIOS. Reboot your system, enter BIOS setup, and enable Intel VT-x/AMD-V.

Now let’s move on to installing KVM.

Install KVM and Other Required Packages
We need to install a few packages to use KVM. Run these commands to install KVM and other required utilities:

```bash
sudo apt update
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
```

This installs the main packages:

qemu-kvm – KVM hypervisor and processor emulator
libvirt-daemon-system – Main daemon managing VMs and hypervisor
libvirt-clients – Client tools for interacting with libvirt
bridge-utils – Required for creating a network bridge
virt-manager – GUI for managing virtual machines (optional)
Verify the installation by checking the version of KVM:

```bash
$ kvm --version
The output should display the installed KVM version:

QEMU emulator version 4.2.1 (Debian 1:4.2-3ubuntu6.28)
Copyright (c) 2003-2019 Fabrice Bellard and the QEMU Project developers
Now KVM and related utilities are installed. Next we’ll load the required kernel modules.
```
