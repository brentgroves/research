# **[How to Install KVM on Ubuntu](https://phoenixnap.com/kb/ubuntu-install-kvm)**

**[Back to Research List](../../../../research_list.md)**\
**[Back to Current Status](../../../../../a_status/current_tasks.md)**\
**[Back to Main](../../../../../README.md)**

KVM (Kernel-based Virtual Machine) is an open-source virtualization technology built into the Lin ux kernel. It operates within the Linux kernel and uses its capabilities to manage hardware resources directly, acting like a Type 1 hypervisor.

In this tutorial, you will learn how to install and set up KVM on Ubuntu.

## Prerequisites

- A system running Ubuntu.
- An account with root privileges.
- Access to the terminal.

## Install KVM on Ubuntu

To install KVM, you need to set up the necessary virtualization packages, ensure your system supports hardware virtualization, and authorize users to run KVM. This section outlines the necessary steps for KVM installation on the latest Ubuntu version (24.04 Noble Numbat).

## Step 1: Update Ubuntu

Before installing KVM, update your system's package repository information. Refreshing the package repository ensures you install the latest available program version available for your system.

Run the command below:

```bash
sudo apt update
```

Provide the root password and wait for the apt package manager to complete the process.

## Step 2: Check Virtualization Support on Ubuntu

The next step is to make sure your system supports virtualization. Follow the steps below:

1. Use the egrep command to check if your CPU supports hardware virtualization. Run the following command:

```bash
egrep -c '(vmx|svm)' /proc/cpuinfo
8
```

## If the command returns a value of 0, your processor is not capable of running KVM. On the other hand, any other number means you can proceed with the installation

2. Next, check if your system can use KVM acceleration:

```bash
sudo kvm-ok
INFO: /dev/kvm exists
KVM acceleration can be used
```

If kvm-ok returns an error, install cpu-checker to resolve the issue.

3. To install cpu-checker, run the following command:

```bash
sudo apt install cpu-checker
```

4. When the installation completes, rerun the command to check KVM acceleration availability, and if everything is ok, you are ready to start installing KVM.

## Step 3: Install KVM Packages

Install the essential KVM packages with the following command:

```bash
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils -y
```

Wait until the system installs all the packages.

## Step 4: Authorize Users

Only members of the libvirt and kvm user groups can run virtual machines. If you want specific users to run VMs, add them to those user groups. Follow the steps below:

1. Add the user you want to run the virtual machines to the libvirt group:

```bash
sudo adduser [username] libvirt
```

Replace [username] with the actual username.

2. Next, do the same for the kvm group:

```bash
sudo adduser [username] kvm
```

For example:

![ke](https://phoenixnap.com/kb/wp-content/uploads/2024/08/add-user-to-virtualization-group.png)

Note: If you need to remove a user from the libvirt or kvm group, just replace adduser with deluser in the command above.

## Step 5: Verify the Installation

Confirm that the KVM installation was successful with the virsh command. The virsh command is a command-line tool for managing virtual machines on Linux systems. Run the command below:

```bash
sudo virsh list --all
```

The command lists all active and inactive virtual machines on the system. You can expect an output similar to the one below if you have not yet created any VMs:

![lvm](https://phoenixnap.com/kb/wp-content/uploads/2024/08/list-vms.png)

Alternatively, use the systemctl command to check the status of libvirtd, the daemon that provides the backend services for the libvirt virtualization management system:

```bash
sudo systemctl status libvirtd
● libvirtd.service - libvirt legacy monolithic daemon
     Loaded: loaded (/usr/lib/systemd/system/libvirtd.service; enabled; preset: enabled)
     Active: active (running) since Mon 2025-02-03 17:23:25 UTC; 1min 26s ago
TriggeredBy: ● libvirtd-admin.socket
             ● libvirtd-ro.socket
             ● libvirtd.socket
       Docs: man:libvirtd(8)
             https://libvirt.org/
   Main PID: 2381 (libvirtd)
      Tasks: 22 (limit: 32768)
     Memory: 21.9M (peak: 23.2M)
        CPU: 953ms
     CGroup: /system.slice/libvirtd.service
             ├─1146 /usr/sbin/dnsmasq --conf-file=/var/lib/libvirt/dnsmasq/default.conf --leasefile-ro --dhcp-script=/usr/lib/libvirt/libvirt_lea>
             ├─1147 /usr/sbin/dnsmasq --conf-file=/var/lib/libvirt/dnsmasq/default.conf --leasefile-ro --dhcp-script=/usr/lib/libvirt/libvirt_lea>
             └─2381 /usr/sbin/libvirtd --timeout 120

Feb 03 17:23:25 ump1 systemd[1]: Starting libvirtd.service - libvirt legacy monolithic daemon...
Feb 03 17:23:25 ump1 systemd[1]: Started libvirtd.service - libvirt legacy monolithic daemon.
Feb 03 17:23:26 ump1 dnsmasq[1146]: read /etc/hosts - 8 names
Feb 03 17:23:26 ump1 dnsmasq[1146]: read /var/lib/libvirt/dnsmasq/default.addnhosts - 0 names
Feb 03 17:23:26 ump1 dnsmasq-dhcp[1146]: read /var/lib/libvirt/dnsmasq/default.hostsfile
lines 15-22/22 (END)
```

If the virtualization daemon is not active, activate it with the following command:

```bash
sudo systemctl enable --now libvirtd
```

## Create Virtual Machine on Ubuntu

Before you choose one of the two methods below for creating a VM, install virt-manager, a tool for creating and managing VMs:

```bash
sudo apt install virt-manager -y
```

Wait for the installation to finish.

Download the ISO with the OS you wish to install on a VM and proceed to pick an installation method below.

### Method 1: Virt Manager GUI

Virt-manager is a graphical user interface tool for managing virtual machines, allowing users to create, configure, and control VMs using libvirt. Follow the steps below:

1. Start virt-manager by running the command below:

```bash
sudo virt-manager
```

Note: If you are using a bare metal server to run VMs and you want to connect via SSH, specify the -Y option when establishing the connection. It enables trusted X11 forwarding, which allows you to run graphical applications on a remote server and display them on your local machine securely.
The syntax is:

```bash
ssh -Y username@hostname
```

2. In the Virtual Machine Manager window, click the computer icon in the upper-left corner to create a new VM.

![vm](https://phoenixnap.com/kb/wp-content/uploads/2024/08/open-virt-manager.png)

3. Select the option to install the VM using an ISO image and click Forward.

![ii](https://phoenixnap.com/kb/wp-content/uploads/2024/08/select-image-source.png)

4. In the next dialogue, click Browse... and navigate to the path where you stored the ISO you wish to install. Select the ISO and click Forward to continue.

![nd](https://phoenixnap.com/kb/wp-content/uploads/2024/08/select-iso-image.png)

5. Enter the amount of RAM and the number of CPUs you wish to allocate to the VM and click Forward to proceed to the next step.

![er](https://phoenixnap.com/kb/wp-content/uploads/2024/08/choose-memory-and-cpu-settings.png)
