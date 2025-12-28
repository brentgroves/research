# **[Setting Up Virtual Machines with QEMU, KVM, and Virt-Manager on Debian/Ubuntu](https://linuxconfig.org/setting-up-virtual-machines-with-qemu-kvm-and-virt-manager-on-debian-ubuntu)**

**[Back to Research List](../../../../../research/research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

Virtualization technology has become an indispensable tool in software development, testing, and deployment. It allows you to run multiple virtual machines (VMs) on a single physical machine, each with its own isolated operating system and resources. This tutorial focuses on setting up a virtualization environment on Debian or Ubuntu Linux using QEMU, KVM (Kernel-based Virtual Machine), and Virt-Manager.

In this tutorial you will learn:

How to update your Debian or Ubuntu system.
The process of installing QEMU, KVM, and Virt-Manager.
How to add your user to the necessary groups to manage VMs without root privileges.
Steps to verify the installation and manage virtual machines with Virt-Manager.

| Category    | Requirements, Conventions or Software Version Used                                                                                                                                                               |
|-------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| System      | Debian or Ubuntu Linux system                                                                                                                                                                                    |
| Software    | QEMU, KVM, Virt-Manager                                                                                                                                                                                          |
| Other       | Internet connection for software installation                                                                                                                                                                    |
| Conventions | # – requires given linux commands to be executed with root privileges either directly as a root user or by use of sudo command $ – requires given linux commands to be executed as a regular non-privileged user |

## Step-by-Step Guide to Virtualization with QEMU, KVM, and Virt-Manager

Before diving into the steps, it’s important to understand the roles of QEMU, KVM, and Virt-Manager. QEMU is an open-source machine emulator and virtualizer that allows you to run operating systems and software designed for a different architecture. KVM is a virtualization module in the Linux kernel that allows the kernel to function as a hypervisor. Lastly, Virt-Manager is a graphical interface for managing virtual machines through libvirt.

## Update Your System: 

Ensure that your Debian or Ubuntu system is up-to-date to avoid any compatibility issues during the installation of virtualization tools. Run the following commands in a terminal:

```bash
$ sudo apt update
$ sudo apt upgrade
```


This step updates the list of available packages and their versions and then installs the newest versions of the packages currently installed on your system.

## Install QEMU and Virt-Manager: 

Install QEMU, KVM, and Virt-Manager to set up your virtualization environment. These tools will allow you to create and manage virtual machines with ease. Execute the following command:

```bash
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virt-manager
```

This command installs all necessary packages, including QEMU for emulation, KVM for hardware acceleration, libvirt daemon for managing VMs, libvirt clients for command-line interaction, bridge-utils for network bridging, and Virt-Manager for graphical management.

Add Your User to Necessary Groups: To manage virtual machines without root privileges, add your user to the ‘libvirt’ and ‘kvm’ groups by running:

```bash
$ sudo adduser $USER libvirt
$ sudo adduser $USER kvm
```

Verify Installation: Check that the libvirt service is running with:
`$ sudo systemctl status libvirtd`

If it’s not running, start and enable it at boot with:

```bash
$ sudo systemctl start libvirtd
$ sudo systemctl enable libvirtd
```

This step ensures that the libvirt daemon is active and set to start automatically on boot, which is necessary for managing virtual machines.


## What is libvirt

Libvirt is a virtualization API that manages virtual machines (VMs) and the resources of the host computer. It's accessible from a variety of programming languages, including C, Python, Perl, and Go. 

## Launch Virt-Manager: 

Open Virt-Manager either from your applications menu or by executing the following command in a terminal:

`$ virt-manager`

Virt-Manager provides a user-friendly graphical interface for creating, configuring, and managing virtual machines. It simplifies the process of VM management, making it accessible even to those new to virtualization.

Create a New Virtual Machine: In Virt-Manager, click on the “Create a new virtual machine” button. Follow the wizard to select the installation method (ISO image, network installation, or importing existing disk), allocate resources (CPU, memory, disk space), and complete the setup by installing the operating system.

## Using Your Virtual Machine: 

Once the operating system installation is complete, you can start, stop, pause, and configure your virtual machine settings through Virt-Manager. Additionally, you can connect to the VM’s console to interact with it directly.

![uvm](https://linuxconfig.org/wp-content/uploads/2024/02/02-setting-up-virtual-machines-with-qemu-kvm-and-virt-manager-on-debian-ubuntu.webp)

## Advanced Tips and Tricks for Virtualization with QEMU, KVM, and Virt-Manager

After setting up your virtualization environment with QEMU, KVM, and Virt-Manager, there are several advanced features and best practices you can employ to enhance your virtual machine management and performance. Here are some tips and tricks to help you get the most out of your virtualized setup.

## Utilizing QEMU Guest Agent

The QEMU Guest Agent facilitates improved communication between the host and the guest VMs, enabling functionalities such as file transfers, graceful shutdowns, and system information queries. To take advantage of these features, install the guest agent in your VMs:

`$ sudo apt install qemu-guest-agent`

Once installed, make sure the guest agent service is enabled and running within your VMs for enhanced performance and management capabilities.

## Mastering Snapshots

Snapshots are a powerful feature that allows you to save the state of a VM at any given point in time. This is incredibly useful for testing software or updates without risking your primary system state. To create a snapshot in Virt-Manager, select your VM, click on the “Snapshots” section, and then “Take Snapshot”. Always ensure you have enough disk space available before taking snapshots to avoid performance degradation.

## Attaching USB Devices

To attach USB devices directly to a VM, go to the VM’s hardware details in Virt-Manager, add a USB host device, and select the device you wish to attach. This is particularly useful for software testing on different operating systems or accessing data stored on external drives directly within your VM.