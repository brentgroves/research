# **[How To Use QEMU From the Linux Command-Line](https://www.baeldung.com/linux/qemu-from-terminal)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../../README.md)**

QEMU is a type-2 hypervisor that uses dynamic translation to emulate CPU instructions on a foreign architecture. It’s helpful for many tasks, such as testing and development, cloud computing, and system administration. In conjunction with other virtualization technologies like KVM or Xen, it allows the guest to run directly on the host CPU at near-native speed.

In this tutorial, we’ll see how to use QEMU to emulate an entire machine (CPU, memory, and devices) to run a popular Linux distro as a guest OS inside a Linux host.

## Why Use QEMU

There are dozens of hypervisors, as we can see in a careful comparison. However, many have proprietary licenses, are little known, or are suitable only for particular use cases. Some are old and no longer actively developed.

In contrast, QEMU is free, open-source, general-purpose, and among the most widely used type-2 hypervisors. In fact, it can emulate many kinds of peripherals and devices, and its license allows its use in any environment, including servers, without restrictions.

QEMU has a vast set of options that make it suitable even for non-common use cases. As there are methods for achieving greatly accelerated video performance, it’s even good for gaming. It’s also helpful for remote use because it can redirect the VGA display over a VNC session.

We can use it either from the terminal, which is the default mode, or with support from a graphic frontend. The only fundamental limitation of QEMU is the difficulty of use. It’s not designed to be user-friendly but targeted at advanced users.

## Using QEMU From the Command-Line

Using QEMU from the terminal has several advantages over using a graphical frontend:

- Flexibility → Terminal commands allow more customization options and fine-grained control.
- Scriptability → Automation and scripting of QEMU commands are more straightforward in the terminal.
- Remote Access → The terminal allows for remote access and management of QEMU virtual machines.
- Resource Usage → Using the terminal reduces resource usage compared to GUI frontends, especially on systems with limited resources, such as older computers or embedded systems. The terminal’s lower resource usage also makes it a good choice for running multiple virtual machines simultaneously on a single system.
- Consistency → Terminal commands ensure consistency across different platforms and environments.

Let’s now see how to install Linux Mint 21.1 Cinnamon edition on a guest QEMU machine within a host running the same operating system. Before proceeding further, let’s download the **[distro’s ISO](https://www.linuxmint.com/download.php)**.

##  Choice of Virtual Disk Type

QEMU supports several types of **[virtual hard drives](https://www.baeldung.com/linux/virtual-disk-images)**, also used by other hypervisors, for example:

- Raw disk image
- **[QCOW2 (QEMU Copy On Write)](https://www.qemu.org/docs/master/system/images.html#cmdoption-image-formats-arg-qcow2)**
- VMDK (VMware virtual disk)
- VDI (VirtualBox virtual disk)
- Physical disk (direct access to a physical disk)

These are only the most common formats, as others are supported. In addition, QEMU can access a disk image locally or remotely via ssh.

In this example, we choose QCOW2, the QEMU’s native format, because it has several advantages over the other formats related to snapshots, space efficiency, compression, near-raw performance, multi-threading, error handling, memory usage, and encryption capabilities. We can create a fixed-size (preallocated) or variable-size (non-preallocated) QCOW2 disk. In the latter case, that is the default, the space occupied on the host grows as the virtual disk is used, which comes in handy when we don’t know how much space we need in advance.

Therefore, let’s create with qemu-img a variable-size QCOW2 disk of 20GB:

```bash
qemu-img create -f qcow2 myVirtualDisk.qcow2 20G
Formatting 'myVirtualDisk.qcow2', fmt=qcow2 cluster_size=65536 extended_l2=off compression_type=zlib size=21474836480 lazy_refcounts=off refcount_bits=16
```

The virtual disk is ready with all the default options. Let’s do a verification:

```bash
file myVirtualDisk.qcow2
myVirtualDisk.qcow2: QEMU QCOW2 Image (v3), 21474836480 bytes
ls -l myVirtualDisk.qcow2 
-rw-r--r-- 1 francesco francesco 196928 Feb  3 19:31 myVirtualDisk.qcow2
```

The ‘file’ command in Linux is a vital utility for determining the type of a file. It identifies file types by examining their content rather than their file extensions, making it an indispensable tool for users who work with various file formats. The file type can be displayed in a human-readable format (e.g., ASCII text) or as a MIME type (e.g., ‘text/plain; charset=us-ascii‘). The file command tests each argument provided to categorize it accurately.

As expected, although it’s a 20GiB (21.474.836.480 bytes) virtual disk, its initially occupied space is only 192KiB (196.928 bytes). Out of curiosity, “QCOW2 Image (v3)” refers to what was initially called QCOW3 and is sometimes still incorrectly called that on outdated web pages.

## Emulation of a Complete Hardware System With KVM

```bash
lscpu
Architecture:             x86_64
  CPU op-mode(s):         32-bit, 64-bit
  Address sizes:          39 bits physical, 48 bits virtual
  Byte Order:             Little Endian
CPU(s):                   8
  On-line CPU(s) list:    0-7
...
free
free                    
               total        used        free      shared  buff/cache   available
Mem:            7848        6107         404         387        1336        1057
Swap:           2047        1358         689
Total:          9896        7466        1093
```
Let’s suppose we want to create a virtual machine with the following characteristics:

- Virtual hard disk “myVirtualDisk.qcow2“, previously created
- Boot from ISO file “linuxmint-21.1-cinnamon-64bit.iso“
- 2 CPUs
- 4 GB RAM
- Network card connected to the host via NAT
- High-resolution video card
- Sound card
- Mouse and keyboard

The following command meets these requirements:

```bash
qemu-system-x86_64 \
-enable-kvm                                                    \
-m 4G                                                          \
-smp 2                                                         \
-hda myVirtualDisk.qcow2                                       \
-boot d                                                        \
-cdrom linuxmint-22.1-cinnamon-64bit.iso                       \
-netdev user,id=net0,net=192.168.0.0/24,dhcpstart=192.168.0.9  \
-device virtio-net-pci,netdev=net0                             \
-vga qxl                                                       \
-device AC97
```

Let’s look at the meaning of each option:

-enable-kvm → KVM to boost performance
-m 4G → 4GB RAM
-smp 2 → 2CPUs
-hda myVirtualDisk.qcow2 → our 20GB variable-size disk
-boot d → boots the first virtual CD drive
-cdrom linuxmint-21.1-cinnamon-64bit.iso → Linux Mint ISO
-netdev user,id=net0,net=192.168.0.0/24,dhcpstart=192.168.0.9 → NAT with DHCP
-device virtio-net-pci,netdev=net0 → network card
-vga qxl → powerful graphics card
-device AC97 → sound card
Let’s verify that the virtual machine works as expected:

![v](https://www.baeldung.com/wp-content/uploads/sites/2/2023/02/QEMU-Linux-Mint-21-Virtual-Machine.jpg)

The guest booting is fast, and the host CPU load is negligible (8% after guest system boot, measured by top). We heard the default login sound. Using the Display module of Cinnamon Settings, we chose the same video resolution as the host, as shown in the screenshot above. After that, we pressed CTRL+ALT+F to switch the windowed guest view to full screen. GParted showed us the 20GB virtual disk, yet to be partitioned. From the terminal, we checked the NAT configuration with ifconfig, the amount of RAM with free, and the number of CPUs with nproc. Their outputs are in the screenshot and everything is as expected.

In addition to the manual that details every possible command, we can consult more concise and easy-to-access documentation on the most common QEMU options.

## Installation and Configuration of a Guest Operating System

We followed the wizard’s standard steps for installation, including automatic partitioning. The following screenshot shows that Linux sees the QEMU’s virtual hard drive as if it were SCSI:

![s](https://www.baeldung.com/wp-content/uploads/sites/2/2023/02/QEMU-Linux-Mint-Automatic-Partitioning.jpg)

After installation, “myVirtualDisk.qcow2” became 11.2 GiB. In all subsequent starts, we can remove the -boot and -cdrom parameters. Alternatively, we can use the -boot menu=on parameter to choose which device to boot with.

```bash
qemu-system-x86_64 \
-enable-kvm                                                    \
-m 4G                                                          \
-smp 2                                                         \
-hda myVirtualDisk.qcow2                                       \
-netdev user,id=net0,net=192.168.0.0/24,dhcpstart=192.168.0.9  \
-device virtio-net-pci,netdev=net0                             \
-vga qxl                                                       \
-device AC97
```

## Pass-Through Access to a Host USB Stick

Pass-through is a QEMU feature that allows a virtual machine to access physical hardware directly, bypassing the virtualization layer without any overhead or limitations. It’s helpful with devices such as graphics cards, network adapters, or storage devices. It can improve performance and provide access to device-specific features unavailable in a purely virtual environment. In the case of a USB flash drive, pass-through is a way to exchange files with the outside world.

First, we need some information about the device:

```bash
lsusb -v
[...]
Bus 001 Device 002: ID 0930:6545 Toshiba Corp. Kingston DataTraveler [...] 4GB Stick
Device Descriptor:
[...]
  idVendor           0x0930 Toshiba Corp.
  idProduct          0x6545 Kingston DataTraveler
[...]
```

The device file path is like /dev/bus/usb/XXX/YYY. According to the Linux kernel’s naming policies, XXX is the bus number (001 in our case), which usually doesn’t change. Instead, YYY is the device number (002 in our case), which changes every time the USB device gets unplugged and re-plugged. That said, let’s check the device file permissions:

```bash
ls -l /dev/bus/usb/001/002
crw-rw-rw- 1 root root 189, 1 Feb  6 08:35 /dev/bus/usb/001/002
```

The user and group are root. This isn’t good for QEMU because the group must be kvm to allow the guest to access the device. So, let’s run the following two commands with root permissions to change permanently, via an udev rule, the group associated with this particular device:

```bash
 echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="0930", ATTR{idProduct}=="6545", OWNER="root", GROUP="kvm", MODE="0666"' > /etc/udev/rules.d/99-usb-stick.rules
# udevadm control --reload-rules && udevadm trigger
```

Let’s unplug and re-plug the USB stick. Let’s recheck the device file permissions and, if the group is still root, let’s reboot the host. Finally, let’s launch QEMU with the following three more parameters, in which we use the idVendor and idProduct previously provided by lsusb:

```bash
-device usb-ehci,id=ehci \
-usb \
-device usb-host,bus=ehci.0,vendorid=0x0930,productid=0x6545
```

In this way, we added an EHCI controller named ehci, which gives us a USB 2.0 bus named ehci.0. As a result, the device icon appears on the desktop:

![u](https://www.baeldung.com/wp-content/uploads/sites/2/2023/02/Linux-Mint-21-USB-Stick-inside-QEMU-guest.jpg)

With pass-through, however, while the guest uses the flash drive, it’ll be inaccessible to the host. That’s why sharing the same directory between host and guest requires a different solution, as we’ll see later.

