# **[](https://github.com/canonical/lxd/issues/12510)

Required information
Distribution: Ubuntu 22.04.3
Distribution version:
The output of "lxc info" or if that fails:
Kernel version: 6.2.0.36
LXC version: 5.19
LXD version: 5.19
Storage back-end in use: btrfs
Issue description
Trying to start an existing LXD Windows 11 vm but after 30 seconds the LXD VM Stops

Tried to create/install a New Windows 11 Pro vm and during installation it too Stops after about
10-15 seconds.

## Steps to reproduce

I just followed the Canonical Guide:
<https://ubuntu.com/tutorials/how-to-install-a-windows-11-vm-using-lxd#3-create-a-new-vm>

However, I the only change I did was to make the Windows 11 VM size = 60GiB

`$ lxc start win11 --console=vga`

Windows 11 starts and appears on the screen. Even if I do not do anything further...the LXD Windows 11 VM will just Stop after 10-15 seconds.

This was all working 2 weeks ago?

Note creating/running an Ubuntu LXD VM works just fine.

So I suspect a couple of things.

Perhaps something Distrobuilder - and whatever magic it does.
Some problem with the newer Linux 6.2.x.x kernels that get installed?
Some possible Change in Qemu
NOTE: On a separate system I installed Ubuntu 23.10 (Kernel 6.5.0.9) & LXD (5.19) and same thing happens where
Windows starts to boot gets to first install menu and then the Windows 11 LXD container goes into "stopped" state.

I'd think it should be quick & easy to replicate by someone as nothing beyond defaults were used.

Activity

bmullan
changed the title [-]lxd windows 11 pro vm starts but quickly shutdown[/-] [+]lxd windows 11 VM Starts but VM Stops within 30 seconds[/+] on Nov 7, 2023
bmullan
bmullan commented on Nov 13, 2023
bmullan
on Nov 13, 2023
Author
Incus and LXD both fail exactly the same trying to install/run Win11 despite the fact that an Ubuntu 22.04 VM installs & runs just fine.

After spending a week troubleshooting this and no solution I bit the bullet and reinstalled Ubuntu 22.04.3 and restored /home from backup and now both Incus & LXD create/run a Win11 Pro VM ok again.

```bash
# get
sysctl kernel.apparmor_restrict_unprivileged_unconfined
kernel.apparmor_restrict_unprivileged_unconfined = 0
sysctl kernel.apparmor_restrict_unprivileged_userns
kernel.apparmor_restrict_unprivileged_userns = 1

# set
sudo sysctl -w kernel.apparmor_restrict_unprivileged_unconfined=0
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
```

lxc exec NAME -- passwd arch
Sep 08 18:20:03 isdev systemd[2832]: Started snap.lxd.lxc-4ab7d3f1-d985-4259-a23f-f918aff6a04d.scope.
░░ Subject: A start job for unit UNIT has finished successfully
░░ Defined-By: systemd
░░ Support: <http://www.ubuntu.com/support>
░░
░░ A start job for unit UNIT has finished successfully.
░░
░░ The job identifier is 974.
