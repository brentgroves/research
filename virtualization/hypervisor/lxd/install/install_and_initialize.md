# **[](https://documentation.ubuntu.com/lxd/latest/tutorial/first_steps/)**

First steps with LXD
This tutorial guides you through the first steps with LXD. It covers installing and initializing LXD, creating and configuring some instances, interacting with the instances, and creating snapshots.

After going through these steps, you will have a general idea of how to use LXD, and you can start exploring more advanced use cases!

Note

Ensure that you have 20 GiB free disk space before starting this tutorial.

## Install and initialize LXD

The easiest way to install LXD is to install the snap package. If you prefer a different installation method, or use a Linux distribution that is not supported by the snap package, see How to install LXD.

## 1. Install snapd

Run snap version to find out if snap is installed on your system:

```bash
~$snap version
snap    2.63+24.04ubuntu0.1
snapd   2.63+24.04ubuntu0.1
series  16
ubuntu  24.04
kernel  5.15.0-117-generic
```

If you see a table of version numbers, snap is installed and you can continue with the next step of installing LXD.

If the command returns an error, run the following commands to install the latest version of snapd on Ubuntu:

```bash
sudo apt update
sudo apt install snapd
```

## 2. Enter the following command to install LXD

```bash
sudo snap install lxd --channel=5.21/stable --cohort="+"
# sudo snap install microceph --channel=squid/stable --cohort="+"
# sudo snap install microovn --channel=24.03/stable --cohort="+"
# sudo snap install microcloud --channel=2/stable --cohort="+"

If this is your first time running LXD on this machine, you should also run: lxd init
To start your first container, try: lxc launch ubuntu:24.04
Or for a virtual machine: lxc launch ubuntu:24.04 --vm

# To indefinitely hold all updates to the snaps needed for MicroCloud, run:

sudo snap refresh --hold lxd
```

## 3. Check if the current user is part of the lxd group (the group was automatically created during the previous step)

`getent group lxd | grep "$USER"`

If this command returns a result, you’re set up correctly and can continue with the next step.

If there is no result, enter the following commands to add the current user to the lxd group (which is needed to grant the user permission to interact with LXD):

```bash
sudo usermod -aG lxd "$USER"
newgrp lxd
```

## 4. Enter the following command to initialize LXD

`lxd init --minimal`

This will create a minimal setup with default options. If you want to tune the initialization options, see How to initialize LXD for more information.

## 5. LXD supports both Containers and VMs. For LXD virtual machines, your host system must be capable of KVM virtualization. To check this, run the following command

```bash
lxc info | grep -FA2 'instance_types'
  instance_types:

- container
- virtual-machine
```

The following output indicates that your host system is capable of virtualization:

instance_types:

- container
- virtual-machine

If virtual-machine fails to appear in the output, this indicates that the host system is not capable of virtualization. In this case, LXD can only be used for containers. You can proceed with this tutorial to learn about using containers, but disregard the steps that refer to virtual machines.

Launch and inspect instances
LXD is image based and can load images from different image servers. In this tutorial, we will use the official ubuntu: image server.

You can list all images (long list) that are available on this image server with:

`lxc image list ubuntu:`

You can list the images used in this tutorial with:

`lxc image list ubuntu: 24.04 architecture=$(uname -m)`
