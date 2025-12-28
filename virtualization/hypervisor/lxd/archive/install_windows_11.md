# **[How to install a Windows 11 VM using LXD](https://ubuntu.com/tutorials/how-to-install-a-windows-11-vm-using-lxd#1-overview)**

## **[update display drivers](https://discuss.linuxcontainers.org/t/how-to-increase-display-resolution-of-windows-vm/23508/2)**

Download virtio-win.iso from **[Index of /groups/virt/virtio-win/direct-downloads/archive-virtio/virtio-win-0.1.271-1](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/)**

That should let you refresh the drivers, especially the virtio-vga driver.
I know that in my VMs I can select other resolutions, so it’s either a driver problem or some display configuration that’s being weird.

## 1. Overview

If you are using a Linux environment but want to run a Windows 11 virtual machine, you can easily do so using LXD. Windows 11 is somewhat strict in its requirements (needs UEFI SecureBoot, having a TPM, and having a modern CPU), but LXD supports that out of the box, and there’s no need for any complex configuration in order to enable a Windows VM. In this tutorial, we will walk through the process of installing Windows in an LXD virtual machine. We will be installing Windows 11, but the same procedure also applies to Windows server machines.

A Trusted Platform Module (TPM) is a secure cryptoprocessor that implements the ISO/IEC 11889 standard. Common uses are verifying that the boot process starts from a trusted combination of hardware and software and storing disk encryption keys.

A TPM 2.0 implementation is part of the Windows 11 system requirements.[1]

## What you’ll learn

- How to repackage an ISO image with lxd-imagebuilder
- How to install a Windows VM
- What you’ll need
- Ubuntu Desktop 20.04 or above
- LXD snap (version 5.0 or above) installed and running
- Some basic command-line knowledge

## How to install a Windows 11 VM using LXD

## 2. Prepare your Windows image

To start, we need to download a Windows 11 Disk Image (ISO) from the official website.
