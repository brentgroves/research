# **[Overview](https://maas.io/tutorials/create-kvm-pods-with-maas#1-overview)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

Note: did not test this yet.

MAAS enables you to treat physical servers like an elastic cloud-like resource.

## Building elastic test environments with MAAS pods

MAAS version 2.2 introduced “pods” as an operational concept. A MAAS pod describes the availability of resources and enables the creation (or composition) of a machine with a set of those resources. Each pod represents a pool of various available hardware resources, such as CPU, RAM, and (local or remote) storage capacity.

A user can allocate the needed resources manually (using the MAAS UI or CLI) or dynamically (using Juju or the MAAS API). That is, machines can be allocated “just in time”, based on CPU, RAM, and storage constraints of a specific workload.

MAAS supports two types of pods, (1) Physical systems with Intel RSD and (2) Virtual Machines with KVM (using the virsh interface). Since we want to explore how to better utilise existing hardware, let’s build a test environment with KVM pods.

## Requirements

A test-bed environment would require a server running the latest Ubuntu Server LTS (How to install Ubuntu Server), with at least: - 4 CPU cores - 16GB RAM - 100GB free disk space, preferably SSD - 2 NICs, one connected to an external network (possibly a DMZ) and the second NIC will be the internal network. MAAS will act as an HTTP proxy and IP gateway between the two networks. MAAS will also provide DNS for all the VMs and servers/pods it will be managing, as well as DHCP. MAAS needs to be installed on only one server/pod and it will be managing all the other pods remotely. MAAS is very versatile. We are focusing here only on one out of many potential KVM pod scenarios.

## 2. Getting started

Start by installing the latest LTS version of Ubuntu Server, selecting only OpenSSH server from the Software selection menu. When the Ubuntu installation completed, you can connect to it through SSH.

Now, ensure the latest stable MAAS version is available, update the system and install the needed virtualization tools:

Note: doing a google search shows `ppa maas` shows the latest ppa to be 3.3.
Going to the ppa site `https://ppa.launchpadcontent.net/maas` shows many more versions upto 3.5.

```bash
# https://discourse.maas.io/t/24-04-not-in-maas-using-mass-io-despite-24-04-being-in-stable-amd64/8174/7
# 3.6-next was the only ppa for noble
sudo add-apt-repository ppa:maas/3.6-next
# sudo add-apt-repository ppa:maas/3.5
# sudo add-apt-repository -r ppa:maas/3.5
# sudo add-apt-repository ppa:maas/2.6  
# sudo add-apt-repository -r ppa:maas/2.6

sudo apt upgrade -y

sudo apt install bridge-utils qemu-kvm libvirt-bin
Note, selecting 'qemu-system-x86' instead of 'qemu-kvm'
Package libvirt-bin is not available, but is referred to by another package.
This may mean that the package is missing, has been obsoleted, or
is only available from another source

E: Package 'libvirt-bin' has no installation candidate

sudo apt install bridge-utils qemu-kvm libvirt-bin

```

You are correct: The libvirt-bin package was dropped in 18.10.
Quoting from https://lists.debian.org/debian-user/2016/11/msg00518.html
The package was split into two parts:
libvirt-daemon-system
libvirt-clients
In most cases you probably want both of them at the same time.
So instead of libvirt-bin use libvirt-daemon-system libvirt-clients:

```bash
sudo apt-get install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils
```