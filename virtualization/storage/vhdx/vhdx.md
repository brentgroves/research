# vhdx file format linux

VHDX is a virtual hard disk file format primarily used by Microsoft's Hyper-V virtualization platform, but it can be mounted and used within Linux systems, particularly when working with WSL 2 (Windows Subsystem for Linux) or for accessing virtual machine images. While not natively supported, tools like libguestfs-tools and qemu-nbd enable mounting VHDX files, either read-only or read-write, on Linux systems.
This video demonstrates how to mount VHD/VHDX images in Linux for forensic investigations:

Mounting VHDX in Linux:

1. Using libguestfs-tools:
This suite of tools provides functionalities for inspecting and manipulating virtual machine images, including VHDX files.
Install it with sudo apt-get install libguestfs-tools on Debian/Ubuntu-based systems.
You can then use guestmount to mount the VHDX file, specifying options like --inspector (to detect filesystems) and --ro (for read-only access).
2. Using qemu-nbd:
qemu-nbd maps a VHDX file to a network block device, allowing it to be mounted as a regular block device.
You can then mount the block device using standard Linux commands like

Specific Use Cases:
WSL 2:
.
WSL 2 uses VHDX files to store the root filesystem of installed Linux distributions. You can manage the disk space used by these VHDX files, including expanding their size if needed.
General Virtual Machine Access:
.
If you have a VHDX file from a Hyper-V virtual machine, you can use the above methods to access its contents or mount it within a Linux environment.
Important Considerations:
**[Read-only vs. Read-write:](https://www.google.com/search?sca_esv=cd63d47fa156149d&cs=0&sxsrf=AE3TifMwxe9RDtEeRk-T3jqDeLbcPuAjyw%3A1752605329063&q=Read-only+vs.+Read-write&sa=X&ved=2ahUKEwjR6I_Qw7-OAxV5K1kFHcMdG5MQxccNegQIYBAD&mstk=AUtExfD6Ddk-sFq0HJeSwz7FCPD16VH-iy-aCGMVcmoPOig9dV0SKczwVQK0RH9fpmS4Ks1r099EwVBBUU9je_UAKaMQZHYWZ9PFr1rGNuTDa8kif-WH-imRO98m18WvbjGlEjj0JZbs-XJiuxWSLxEDsDjq9gwpDmaTFcnkBYhQ5ae-q3_Nfmt-OjI5bWru84ouioPChjxXsfrNLVaZufyFb4IuxSJpSlarV7pC7Mmvba8mnRjaeEXtuCawL3uKdgriloOqfJ7_XVj8GCgC9OtPlLCn&csui=3)**
.
While guestmount can mount VHDX files read-only, mounting them read-write can be more complex and might require specific tools and configurations depending on the filesystem within the VHDX.
File system type:
.
Ensure you know the file system type within the VHDX (e.g., ext4 for many Linux distributions) to mount it correctly.
VirtualBox:
.
VirtualBox can also handle VHDX files, but it might require conversion to other formats like VDI for full write support.
