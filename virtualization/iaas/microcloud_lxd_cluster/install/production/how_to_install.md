# **[How to install MicroCloud](<https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/install/#howto-install>)**

## Pre-deployment requirements

Important

These requirements are in addition to those listed in the General tab.

Physical machines only (no VMs)

Minimum cluster size:

3 members

For critical deployments, we recommend a minimum of 4 members

Memory:

Minimum 32 GiB RAM per cluster member

Software:

For production deployments subscribed to Ubuntu Pro, each cluster member must use a LTS version of Ubuntu

Networking:

For each cluster member, we recommend dual-port network cards with a minimum 10 GiB capacity, or higher if low latency is essential

Storage:

For each cluster member, we recommend at least 3 NVMe disks:

- 1 for OS
- 1 for local storage
- 1 for distributed storage

For detailed information, see: **[Requirements](https://documentation.ubuntu.com/microcloud/latest/microcloud/reference/requirements/#reference-requirements)**.

## Installation

To install MicroCloud, install all required snaps on all machines that you want to include in your cluster. You can optionally specify a channel for each snap, but generally, you can leave out the channel to use the current recommended default.

To do so, enter the following commands on all machines:

```bash
sudo snap install lxd --cohort="+"
sudo snap install microceph --cohort="+"
sudo snap install microovn --cohort="+"
sudo snap install microcloud --cohort="+"
```

The --cohort flag ensures that versions remain **[synchronized during later updates](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/update_upgrade/#howto-update-sync)**.

Following installation, make sure to **[hold updates](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/update_upgrade/#howto-update-hold)**.

To indefinitely hold all updates to the snaps needed for MicroCloud, run:

`sudo snap refresh --hold lxd microceph microovn microcloud`

Then you can perform manual updates on a schedule that you control.

For detailed information about holds, see: Pause or stop automatic updates in the Snap documentation.

## Previously installed snaps

If a required snap is already installed on your machine, you will receive a message to that effect. In this case, check the version for the installed snap:

`snap list <snap>`

View the **[matrix of compatible versions](https://documentation.ubuntu.com/microcloud/latest/microcloud/reference/releases-snaps/#ref-releases-matrix)** to determine whether you need to upgrade the snap to a different channel. Follow either the update or upgrade instructions below.

## Update

If the installed snap is using a channel corresponding to a release that is compatible with the other snaps, update to the most recent stable version of the snap without changing the channel:

`sudo snap refresh <snap> --cohort="+"`

## Upgrade

If you need to upgrade the channel, run:

`sudo snap refresh <snap> --cohort="+" --channel=<target channel>`

Example:

`sudo snap refresh microcloud --cohort="+" --channel=2/stable`

## Optionally specify a channel

Channels correspond to different releases. When unspecified, MicroCloud and its components’ snaps use their respective recommended default channels.

To specify a different channel, add the --channel flag at installation:

`sudo snap install <snap> --cohort="+" --channel=<target channel>`

For example, to use the 3/edge channel for the MicroCloud snap, run:

`sudo snap install microcloud --cohort="+" --channel=3/edge`

For details about the MicroCloud snap channels, see: **[Channels](https://documentation.ubuntu.com/microcloud/latest/microcloud/reference/releases-snaps/#ref-snaps-microcloud-channels)**.

Hold updates
When a new release is published to a snap channel, installed snaps following that channel update automatically by default. This is undesired behavior for MicroCloud and its components, and you should override this default behavior by holding updates. See: **[Hold updates](https://documentation.ubuntu.com/microcloud/latest/microcloud/how-to/update_upgrade/#howto-update-hold)**.
