# **[Multipass Install/Upgrade/Uninstall](https://multipass.run/docs/installing-on-linux#heading--install-upgrade-uninstall)**

**[Back to Research List](../../../research_list.md)**\
**[Back to Multipass Menu](./multipass_menu.md)**\
**[Back to Current Status](../../../../development/status/weekly/current_status.md)**\
**[Back to Main](../../../../README.md)**

## references

- **[Install LXD driver](https://jon.sprig.gs/blog/post/2800)**

## Multipass Documentation

Multipass is a tool to generate cloud-style Ubuntu VMs quickly on Linux, macOS, and Windows.

It gives you a simple but powerful CLI that allows you to quickly access an Ubuntu command line or create your own local mini-cloud.

Local development and testing is a pain, but Multipass makes it easier by automating all of your setup and teardown. Multipass has a growing library of images that give you the ability to launch purpose-built VMs, or custom VMs you’ve configured yourself through its powerful cloud-init interface.

Developers can use Multipass to prototype cloud deployments and to create fresh, customized Linux dev environments on any machine. Mac and Windows users can use Multipass as the quickest way to get an Ubuntu command line on their system. New Ubuntu users can use it as a sandbox to try new things without affecting their host machine, and without the need to dual boot.

## To uninstall Multipass, simply run

```sudo snap remove multipass```

## **[Install Multipass](https://multipass.run/docs/installing-on-linux#heading--install-upgrade-uninstall)**

The Ubuntu Snap Store is located on the domain snapcraft.io.

To install Multipass, simply execute:

```bash
sudo snap install multipass
multipass 1.13.0 from Canonical✓ installed
multipass 1.15.0 from Canonical✓ installed
```

For architectures other than amd64, you’ll need the beta channel at the moment.

You can also use the edge channel to get the latest development build:

```bash
snap install multipass --edge
```

Make sure you’re part of the group that Multipass gives write access to its **[socket](../../sockets/unix_domain_sockets.md)** (sudo in this case, but it may also be adm or admin, depending on your distribution):

Make sure you’re part of the group that Multipass gives write access to its socket (sudo in this case, but it may also be adm or admin, depending on your distribution):

```bash
$ ls -l /var/snap/multipass/common/multipass_socket
srw-rw---- 1 root sudo 0 Dec 19 09:47 /var/snap/multipass/common/multipass_socket
$ groups | grep sudo
brent adm cdrom sudo dip plugdev lpadmin lxd sambashare docker

```

## **[Step 0: Change to LXD driver](https://jon.sprig.gs/blog/post/2800)**

Did not have to do this on Ubuntu 24.04 server with multipass 1.15.0 from Canonical✓ installed

Currently only the LXD driver supports the networks command on Linux.

So, let’s make multipass on Ubuntu use LXD! (Be prepared for entering your password a few times!)

```bash
multipass networks
Name        Type       Description
eno1        ethernet   Ethernet device
eno2        ethernet   Ethernet device
mpqemubr0   bridge     Network bridge

networks failed: The networks feature is not implemented on this backend.
```

Firstly, we need to install LXD. Dead simple:

LXD ( [lɛks'di:] 🔈) is a modern, secure and powerful system container and virtual machine manager. It provides a unified experience for running and managing full Linux systems inside containers or virtual machines.

```bash
sudo snap install lxd
lxd (5.21/stable) 5.21.1-d46c406 from Canonical✓ installed
```

Next, we need to tell snap that it’s allowed to connect LXD to multipass:

```bash
sudo snap connect multipass:lxd lxd
sudo snap connections multipass
Interface          Plug                         Slot                Notes
firewall-control   multipass:firewall-control   :firewall-control   -
home               multipass:all-home           :home               -
home               multipass:home               :home               -
kvm                multipass:kvm                :kvm                -
libvirt            multipass:libvirt            -                   -
lxd                multipass:lxd                lxd:lxd             -
multipass-support  multipass:multipass-support  :multipass-support  -
network            multipass:network            :network            -
network-bind       multipass:network-bind       :network-bind       -
network-control    multipass:network-control    :network-control    -
network-manager    multipass:network-manager    :network-manager    -
network-observe    multipass:network-observe    :network-observe    -
removable-media    multipass:removable-media    -                   -
system-observe     multipass:system-observe     :system-observe     -
unity7             multipass:unity7             :unity7             -
wayland            multipass:wayland            :wayland            -
x11                multipass:x11                :x11                -```

And lastly, we tell multipass to use lxd:

```bash
multipass set local.driver=lxd
multipass networks

Name        Type       Description
eno1        ethernet   Ethernet device
eno2        ethernet   Ethernet device
eno3        ethernet   Ethernet device
eno4        ethernet   Ethernet device
enp66s0f0   ethernet   Ethernet device
enp66s0f1   ethernet   Ethernet device
enp66s0f2   ethernet   Ethernet device
enp66s0f3   ethernet   Ethernet device
mpbr0       bridge     Network bridge for Multipass
```

## I don't think I need to do the rest of this

## Install **[libvirt](https://ubuntu.com/server/docs/libvirt)**

The **[libvirt library](https://libvirt.org/)** is used to interface with many different virtualisation technologies. Before getting started with libvirt it is best to make sure your hardware supports the necessary virtualisation extensions for Kernel-based Virtual Machine (KVM).

**Note:**
On many computers with processors supporting hardware-assisted virtualisation, it is necessary to first activate an option in the BIOS to enable it.

```bash
sudo apt install cpu-checker
kvm-ok                      
INFO: /dev/kvm exists
KVM acceleration can be used

```

```bash
sudo apt install net-tools
sudo apt install libvirt-clients
sudo virsh net-list --all
error: failed to connect to the hypervisor
error: Failed to connect socket to '/var/run/libvirt/libvirt-sock': No such file or directory

systemctl status libvirtd
systemctl status virtqemud.socket
systemctl start virtqemud.socket
```
