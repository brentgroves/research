# **[Creating Guests with virt-install](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/7/html/virtualization_deployment_and_administration_guide/sect-guest_virtual_machine_installation_overview-creating_guests_with_virt_install#sect-Guest_virtual_machine_installation_overview-Creating_guests_with_virt_install)**

## references

**[Ubuntu docs](https://manpages.ubuntu.com/manpages/trusty/man1/virt-install.1.html)**
**[virtual machine manager](https://ubuntu.com/server/docs/virtual-machine-manager)**
**[install kvm on headless server](https://www.cyberciti.biz/faq/how-to-install-kvm-on-ubuntu-20-04-lts-headless-server/)**

## install

```bash
sudo apt install virtinst
```

You can use the virt-install command to create virtual machines and install operating system on those virtual machines from the command line. virt-install can be used either interactively or as part of a script to automate the creation of virtual machines. If you are using an interactive graphical installation, you must have virt-viewer installed before you run virt-install. In addition, you can start an unattended installation of virtual machine operating systems using virt-install with kickstart files.

The virt-install utility uses a number of command-line options. However, most virt-install options are not required.
The main required options for virtual guest machine installations are:
--name 
The name of the virtual machine.
--memory The amount of memory (RAM) to allocate to the guest, in MiB.
Guest storage
Use one of the following guest storage options:
--disk
The storage configuration details for the virtual machine. If you use the --disk none option, the virtual machine is created with no disk space.
--filesystem
The path to the file system for the virtual machine guest.

Installation method
Use one of the following installation methods:
--location
The location of the installation media.
--cdrom
The file or device used as a virtual CD-ROM device. It can be path to an ISO image, or a URL from which to fetch or access a minimal boot ISO image. However, it can not be a physical host CD-ROM or DVD-ROM device.
--pxe
Uses the PXE boot protocol to load the initial ramdisk and kernel for starting the guest installation process.
--import
Skips the OS installation process and builds a guest around an existing disk image. The device used for booting is the first device specified by the disk or filesystem option.
--boot
The post-install VM boot configuration. This option allows specifying a boot device order, permanently booting off kernel and initrd with optional kernel arguments and enabling a BIOS boot menu.
To see a complete list of options, enter the following command:
# virt-install --help
To see a complete list of attributes for an option, enter the following command:
# virt install --option=?
The virt-install man page also documents each command option, important variables, and examples.
Prior to running virt-install, you may also need to use qemu-img to configure storage options. For instructions on using qemu-img, see Chapter 14, Using qemu-img.

## 3.2.1. Installing a virtual machine from an ISO image
The following example installs a virtual machine from an ISO image:

```bash
ls ~/images
# virt-install \ 
  --name vlan_fun \ 
  --memory 2048 \ 
  --vcpus 2 \ 
  --disk size=8 \ 
  --cdrom ~/images/ubuntu-24.04.1-live-server-amd64.iso \ 
  --os-variant ubuntu24.04
```

The --cdrom /path/to/rhel7.iso option specifies that the virtual machine will be installed from the CD or DVD image at the specified location.
