# **[Getting Started latest](https://documentation.ubuntu.com/microcloud/latest/microcloud/tutorial/get_started/)**

Get started with MicroCloud
MicroCloud is quick to set up. Once **[installed](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/install/#howto-install)**, you can start using MicroCloud in the same way as a regular LXD cluster.

This tutorial guides you through installing and initializing MicroCloud in a confined environment, then starting some instances to see what you can do with MicroCloud. It uses LXD virtual machines (VMs) for the MicroCloud cluster members, so you don’t need any extra hardware to follow the tutorial.

Tip

While VMs are used as cluster members for this tutorial, we recommend that you use physical machines in a production environment. You can use VMs as cluster members in testing or development environments. To do so, your host machine must have nested virtualization enabled. See the **[Ubuntu Server documentation](https://documentation.ubuntu.com/server/how-to/virtualisation/enable-nested-virtualisation/#check-if-nested-virtualisation-is-enabled)** on how to check if nested virtualization is enabled.

We also limit each machine in this tutorial to 2 GiB of RAM, which is less than the recommended hardware requirements. In the context of this tutorial, this amount of RAM is sufficient. However, in a production environment, make sure to use machines that fulfill the **[Hardware requirements](https://documentation.ubuntu.com/microcloud/latest/microcloud/reference/requirements/#reference-requirements-hardware)**.

## Install and initialize LXD

Note

You can skip this step if you already have a LXD server installed and initialized on your host machine. However, you should make sure that you have a storage pool set up that is big enough to store four VMs. We recommend a minimum storage pool size of 40 GiB.

MicroCloud requires LXD version 5.21:

Install snapd:

Run snap version to find out if snap is installed on your system:

```bash
~$snap version
snap    2.59.4
snapd   2.59.4
series  16
ubuntu  24.04
kernel  5.15.0-73-generic
```

If you see a table of version numbers, snap is installed. If the version for snapd is 2.59 or later, you are all set and can continue with the next step of installing LXD.

If the version for snapd is earlier than 2.59, or if the snap version command returns an error, run the following commands to install the latest version of snapd:

```bash
sudo hostnamectl set-hostname micro11
sudo hostnamectl set-hostname micro12
sudo hostnamectl set-hostname micro13

sudo apt update
sudo apt install snapd
```

If LXD is already installed, enter the following command to update it:

`sudo snap refresh lxd --channel=5.21/stable`

Otherwise, enter the following command to install LXD:

`sudo snap install lxd`

Enter the following command to initialize LXD:

`lxd init`

Accept the default values except for the following questions:

Size in GiB of the new loop device (1GiB minimum)

Enter 40. 100

What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”)

Enter 10.1.123.1/24.

What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”)

Enter fd42:1:1234:1234::1/64.

Would you like the LXD server to be available over the network? (yes/no)

Enter yes.

Modify the default network so we can later define specific IPv6 addresses for the VMs:

`lxc network set lxdbr0 ipv6.dhcp.stateful true`

Note

In the steps above, we ask you to specify the IP addresses to be used instead of accepting the defaults. While this is not strictly required for this setup, it causes the example IPs displayed in this tutorial to match what you see on your system, which improves clarity.

## Provide storage disks

MicroCloud supports both local and remote storage. For local storage, you need one disk per cluster member. For remote storage with high availability (HA), you need at least three disks that are located across three different cluster members.

In this tutorial, we will set up each of the four cluster members with local storage. We will also set up three of the cluster members with remote storage. In total, we will set up seven disks. It’s possible to add remote storage on the fourth cluster member, if desired. However, it is not required for HA.

Complete the following steps to create the required disks in a LXD storage pool:

Create a ZFS storage pool called disks:

```bash
lxc storage create disks zfs size=100GiB

```
